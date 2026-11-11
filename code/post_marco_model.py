"""Post-Marco prescribed-allocation benchmark; individual best responses only.

Joint thesis architecture: Carlos Gomez Puican and Fabian Mendez Suarez under
Marco Ortiz, building on his benchmark note. Course optimization/computational
closure: Carlos. Prescribed participation remains pending acceptance; no
voluntary-market equilibrium, advisor-approved shock law or Peru calibration.
Finite states, uniform shocks and [0,u_max] are COURSE assumptions only.
October/November-4 modules are historical and are not imported here.
"""

from dataclasses import dataclass, replace
from math import isfinite


@dataclass(frozen=True)
class ShockState:
    A: float
    probability: float
    sigma: float

    def __post_init__(self):
        if not all(isfinite(v) for v in (self.A, self.probability, self.sigma)):
            raise ValueError("Finite state primitives required")
        if self.probability < 0 or self.sigma <= 0:
            raise ValueError("Require probability>=0 and sigma>0")


@dataclass(frozen=True)
class BankType:
    name: str
    mu: float
    d: float
    beta: float
    tau: float
    u_max: float

    def __post_init__(self):
        if not all(isfinite(v) for v in (self.mu, self.d, self.beta, self.tau, self.u_max)):
            raise ValueError("Finite bank primitives required")
        if self.mu <= 0 or self.d <= 0 or not 0 <= self.tau <= 1 or self.u_max <= 0:
            raise ValueError("Require mu,d,u_max>0 and tau in [0,1]")


def check_states(states):
    if not states or abs(sum(s.probability for s in states)-1) > 1e-12:
        raise ValueError("Finite aggregate-state probabilities must sum to one")


def positive_uniform(mean, sigma):
    """E[(mean+eps)+] for eps uniform[-sigma,sigma]."""
    if mean <= -sigma:
        return 0.0
    if mean >= sigma:
        return mean
    return (sigma+mean)**2/(4*sigma)


def moments(bank, state, u):
    """Normalized D/d, X/d, pi-, pi+, and f_omega(-u); signed flow."""
    mean = bank.beta*state.A+u
    minus = max(0.0, min(1.0, (state.sigma-mean)/(2*state.sigma)))
    return dict(L=positive_uniform(-mean, state.sigma),
                X_over_d=positive_uniform(mean, state.sigma),
                pi_minus=minus, pi_plus=1-minus,
                density=1/(2*state.sigma) if abs(mean) < state.sigma else 0.0)


def allocate(banks, states, buffers, F):
    """Prescribed matching and fund accounting for a supplied population profile.

    This accounts for a profile; it does NOT solve best-response consistency.
    D_k,X_k and F are AMOUNTS; u is a per-deposit ratio. Zero-sided trade and
    Delta=0 follow the explicit conventions in the current thesis candidate.
    """
    check_states(states)
    if not banks or len(banks) != len(buffers) or not isfinite(F) or F < 0:
        raise ValueError("Require banks/buffers of equal length and F>=0")
    if any(not isfinite(u) or not 0 <= u <= b.u_max for b, u in zip(banks, buffers)):
        raise ValueError("Infeasible population buffer")
    results = []
    for state in states:
        ms = [moments(b, state, u) for b, u in zip(banks, buffers)]
        Ds = [b.d*m['L'] for b, m in zip(banks, ms)]
        Xs = [b.d*m['X_over_d'] for b, m in zip(banks, ms)]
        P = sum(b.mu*b.tau*x for b, x in zip(banks, Xs))
        Q = sum(b.mu*b.tau*d for b, d in zip(banks, Ds))
        psis = [b.tau*min(1.0, P/Q) if P > 0 and Q > 0 else 0.0 for b in banks]
        ells = [b.tau*min(1.0, Q/P) if P > 0 and Q > 0 else 0.0 for b in banks]
        delta = sum(b.mu*(1-psi)*d for b, psi, d in zip(banks, psis, Ds))
        phi = min(1.0, F/delta) if delta > 0 else 0.0
        for b, u, d, x, psi, ell in zip(banks, buffers, Ds, Xs, psis, ells):
            residual = (1-psi)*d
            results.append(dict(bank_type=b.name, A=state.A, probability=state.probability,
                                sigma=state.sigma, mu=b.mu, d=b.d, beta=b.beta,
                                tau=b.tau, reference_u=u, D_k=d, X_k=x, P=P, Q=Q,
                                psi=psi, ell=ell, Delta=delta, F=F, phi=phi,
                                borrowed=psi*d, lent=ell*x, residual=residual,
                                coverage=phi*residual, uncovered=(1-phi)*residual))
    return results


@dataclass(frozen=True)
class FrozenSchedule:
    state: ShockState
    psi: float
    ell: float
    delta: float

    def __post_init__(self):
        if not all(isfinite(v) for v in (self.psi, self.ell, self.delta)):
            raise ValueError("Finite schedules required")
        if not 0 <= self.psi <= 1 or not 0 <= self.ell <= 1 or self.delta < 0:
            raise ValueError("Coverage fractions in [0,1], Delta>=0 required")


@dataclass(frozen=True)
class BufferProblem:
    bank: BankType
    schedules: tuple[FrozenSchedule, ...]
    r: float
    i: float
    kappa: float
    F: float

    def __post_init__(self):
        check_states(tuple(s.state for s in self.schedules))
        if not all(isfinite(v) for v in (self.r, self.i, self.kappa, self.F)):
            raise ValueError("Finite cost/capacity primitives required")
        if self.r < 0 or not self.kappa > self.i >= 0 or self.F < 0:
            raise ValueError("Require r>=0, kappa>i>=0 and F>=0")

    def at_capacity(self, F):
        return replace(self, F=F)

    def coefficients(self, schedule):
        phi = min(1.0, self.F/schedule.delta) if schedule.delta > 0 else 0.0
        a = self.i*schedule.psi+self.kappa*(1-phi)*(1-schedule.psi)
        b = self.i*schedule.ell
        return a, b, phi

    def check_u(self, u):
        if not isfinite(u) or not 0 <= u <= self.bank.u_max:
            raise ValueError("Require 0<=u<=course u_max")

    def metrics(self, u):
        self.check_u(u)
        values = dict(u=u, buffer_amount=self.bank.d*u, opportunity_cost=self.r*u,
                      normalized_deficit=0.0, normalized_surplus=0.0,
                      borrowing_cost=0.0, lending_income=0.0,
                      coverage_over_d=0.0, uncovered_over_d=0.0)
        for s in self.schedules:
            m = moments(self.bank, s.state, u)
            w = s.state.probability
            _, _, phi = self.coefficients(s)
            values['normalized_deficit'] += w*m['L']
            values['normalized_surplus'] += w*m['X_over_d']
            values['borrowing_cost'] += w*self.i*s.psi*m['L']
            values['lending_income'] += w*self.i*s.ell*m['X_over_d']
            values['coverage_over_d'] += w*phi*(1-s.psi)*m['L']
            values['uncovered_over_d'] += w*(1-phi)*(1-s.psi)*m['L']
        values['J'] = (values['opportunity_cost']+values['borrowing_cost']
                       -values['lending_income']+self.kappa*values['uncovered_over_d'])
        return values

    def objective(self, u):
        return self.metrics(u)['J']

    def derivative(self, u):
        self.check_u(u)
        value = self.r
        for s in self.schedules:
            m = moments(self.bank, s.state, u)
            a, b, _ = self.coefficients(s)
            value -= s.state.probability*(a*m['pi_minus']+b*m['pi_plus'])
        return value

    def curvature(self, u):
        """Off support knots only; includes NEGATIVE lending-income curvature."""
        self.check_u(u)
        return sum(s.state.probability*(self.coefficients(s)[0]-self.coefficients(s)[1])
                   *moments(self.bank, s.state, u)['density'] for s in self.schedules)

    def breakpoints(self):
        return sorted({0.0, self.bank.u_max} | {
            u for s in self.schedules for u in (-self.bank.beta*s.state.A-s.state.sigma,
                                               -self.bank.beta*s.state.A+s.state.sigma)
            if 0 < u < self.bank.u_max})

    def convexity_certificate(self):
        """Exact piecewise-quadratic interval check, NOT assumed convexity."""
        points = self.breakpoints()
        return all(self.curvature((l+r)/2) >= -1e-12 for l, r in zip(points, points[1:]))

    def optimum(self):
        """Enumerate ALL interval endpoints/stationary points, even if nonconvex.

        Uniform branch objectives are quadratic. Flat intervals and equal
        isolated minimizers are reported explicitly (numerical tolerance 2e-12).
        """
        points = self.breakpoints()
        candidates, flats = list(points), []
        for left, right in zip(points, points[1:]):
            middle = (left+right)/2
            slope, curvature = self.derivative(middle), self.curvature(middle)
            if abs(curvature) > 1e-13:
                root = middle-slope/curvature
                if left < root < right:
                    candidates.append(root)
            elif abs(slope) < 1e-12:
                flats.append((left, right))
        minimum = min(self.objective(u) for u in candidates)
        best = sorted({u for u in candidates if abs(self.objective(u)-minimum) <= 2e-12})
        flat_best = [interval for interval in flats
                     if abs(self.objective(sum(interval)/2)-minimum) <= 2e-12]
        unique = len(best) == 1 and not flat_best
        u = best[0]
        regime = ('nonunique' if not unique else 'lower_corner' if u == 0 else
                  'upper_corner' if u == self.bank.u_max else 'interior')
        derivative = self.derivative(u)
        residual = (max(0.0, -derivative) if u == 0 else
                    max(0.0, derivative) if u == self.bank.u_max else abs(derivative))
        return dict(u=u, J=minimum, regime=regime, unique=unique,
                    minimizer_points=best, minimizing_flat_intervals=flat_best,
                    convex=self.convexity_certificate(), kkt_residual=residual)

    def capacity_response(self):
        """Local F derivative of the selected regular GLOBAL interior minimum.

        psi, ell, Delta and the conditional law stay fixed. This is not a
        derivative through the reference-population market accounting.
        """
        if self.F <= 0:
            raise ValueError("F=0 requires a one-sided capacity derivative")
        opt = self.optimum()
        u = opt['u']
        if not opt['unique'] or opt['regime'] != 'interior':
            raise ValueError("Unique interior optimum required")
        if any(abs(abs(self.bank.beta*s.state.A+u)-s.state.sigma) < 1e-8
               for s in self.schedules if s.state.probability > 0):
            raise ValueError("Optimum at a support knot")
        if any(s.delta > 0 and abs(self.F-s.delta) < 1e-8
               for s in self.schedules if s.state.probability > 0):
            raise ValueError("Capacity at a coverage kink")
        curvature = self.curvature(u)
        if curvature <= 1e-10:
            raise ValueError("Positive local curvature required")
        numerator = self.kappa*sum(
            s.state.probability*(1-s.psi)*moments(self.bank, s.state, u)['pi_minus']/s.delta
            for s in self.schedules if s.delta > 0 and self.F < s.delta)
        return -numerator/curvature


def freeze_problem(bank, states, reference_rows, r, i, kappa, F):
    rows = [row for row in reference_rows if row['bank_type'] == bank.name]
    if len(rows) != len(states) or any(row['A'] != state.A for row, state in zip(rows, states)):
        raise ValueError("Reference state/bank rows do not align")
    schedules = tuple(FrozenSchedule(state, row['psi'], row['ell'], row['Delta'])
                      for state, row in zip(states, rows))
    return BufferProblem(bank, schedules, r, i, kappa, F)
