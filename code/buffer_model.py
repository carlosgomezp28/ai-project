"""V5.1-course direct-support buffer benchmark (not advisor-approved).

Joint architecture: Carlos Gomez Puican and Fabian Mendez Suarez, supervised
by Marco Ortiz. Optimization/verification/simulation closure: Carlos's
individual AI & Economic Modeling contribution. Parameters are illustrative.

OTC/search/matching/Nash are a deferred, separate extension. No October public
coverage phi or R_D mechanism is used here: phi means reserve usability.
All liquidity quantities and private costs below are per unit of deposits.
"""

from dataclasses import dataclass, replace
from math import isfinite


@dataclass(frozen=True)
class AggregateState:
    A: float
    probability: float
    eps_half_width: float

    def __post_init__(self):
        if not all(isfinite(x) for x in (self.A, self.probability, self.eps_half_width)):
            raise ValueError("State inputs must be finite")
        if self.probability < 0 or self.eps_half_width <= 0:
            raise ValueError("Nonnegative probability and positive uniform width required")


def reserve_requirement(d, B, tauB, rho_m):
    """Stylized reserve amount; not a complete regulatory implementation."""
    if not all(isfinite(x) for x in (d, B, tauB, rho_m)):
        raise ValueError("Reserve inputs must be finite")
    if d <= 0 or B < 0 or not (0 <= tauB <= 1 and 0 <= rho_m <= 1):
        raise ValueError("Require d>0, B>=0 and reserve rates in [0,1]")
    return tauB * min(d, B) + rho_m * max(d - B, 0.0)


@dataclass(frozen=True)
class BufferModel:
    d: float
    B: float
    tauB: float
    rho_m: float
    epsilon_E: float
    beta: float
    phi: float
    chi: float
    p: float
    g: float
    c: float
    states: tuple[AggregateState, ...]

    def __post_init__(self):
        reserve_requirement(self.d, self.B, self.tauB, self.rho_m)
        values = (self.epsilon_E, self.beta, self.phi, self.chi, self.p, self.g, self.c)
        if not all(isfinite(x) for x in values):
            raise ValueError("Model inputs must be finite")
        if self.epsilon_E < 0 or not 0 <= self.phi <= 1 or not 0 <= self.chi < 1:
            raise ValueError("Require epsilon_E>=0, phi in [0,1], chi in [0,1)")
        if not self.g > self.p >= 0 or self.c <= 0:
            raise ValueError("Require g>p>=0 and c>0")
        if not self.states or abs(sum(s.probability for s in self.states) - 1) > 1e-12:
            raise ValueError("Finite state probabilities must sum to one")
        if self.U <= 0:
            raise ValueError("Balance sheet requires U=1+epsilon_E-r>0")

    @property
    def r(self):
        return reserve_requirement(self.d, self.B, self.tauB, self.rho_m) / self.d

    @property
    def U(self):
        return 1 + self.epsilon_E - self.r

    def at_reserve_burden(self, r):
        """Hold other primitives fixed; realize r through B=d and tauB=r.

        This is a constructed reserve-burden path, not a deposit-choice or
        statutory-policy comparative static. Pure Base experiments are separate.
        """
        return replace(self, B=self.d, tauB=r)

    def check_u(self, u):
        if not isfinite(u) or not 0 <= u <= self.U:
            raise ValueError("Buffer must be feasible: 0<=u<=U")

    def thresholds(self, u):
        self.check_u(u)
        return u + self.phi * self.r, self.phi * self.r + self.chi * self.U + (1-self.chi)*u

    def expected_positive_part(self, threshold):
        """E[(e-threshold)+], e=beta*A+eps; eps|A uniform [-sigma,sigma]."""
        total = 0.0
        for state in self.states:
            z = threshold - self.beta * state.A
            sigma = state.eps_half_width
            value = -z if z <= -sigma else (0.0 if z >= sigma else (sigma-z)**2/(4*sigma))
            total += state.probability * value
        return total

    def tail_probability(self, threshold):
        total = 0.0
        for state in self.states:
            z = threshold - self.beta * state.A
            sigma = state.eps_half_width
            tail = max(0.0, min(1.0, (sigma-z)/(2*sigma)))
            total += state.probability * tail
        return total

    def density(self, threshold):
        """Mixture density away from support endpoints; do not assign curvature there."""
        total = 0.0
        for state in self.states:
            if state.probability == 0:
                continue
            z = threshold - self.beta * state.A
            sigma = state.eps_half_width
            if min(abs(z-sigma), abs(z+sigma)) < 1e-10:
                raise ValueError("Density/second derivative at a uniform support endpoint")
            if -sigma < z < sigma:
                total += state.probability / (2*sigma)
        return total

    def objective(self, u):
        t1, t2 = self.thresholds(u)
        return (self.c*(self.r+u) + self.p*self.expected_positive_part(t1)
                + (self.g-self.p)*self.expected_positive_part(t2))

    def derivative(self, u):
        t1, t2 = self.thresholds(u)
        return (self.c - self.p*self.tail_probability(t1)
                - (self.g-self.p)*(1-self.chi)*self.tail_probability(t2))

    def curvature(self, u):
        t1, t2 = self.thresholds(u)
        first = self.p*self.density(t1) if self.p else 0.0
        return first + (self.g-self.p)*(1-self.chi)**2*self.density(t2)

    def state_outcome(self, u, A, eps_k):
        self.check_u(u)
        e = self.beta*A + eps_k
        q = max(e-u-self.phi*self.r, 0.0)
        H = self.chi*(self.U-u)
        W = min(q, H)
        v = max(q-H, 0.0)
        return dict(e=e, u_tilde=u+self.phi*self.r, q=q, H=H, W=W, v=v,
                    b_over_d=self.U-u)

    def metrics(self, u):
        t1, t2 = self.thresholds(u)
        expected_q = self.expected_positive_part(t1)
        expected_v = self.expected_positive_part(t2)
        return dict(u=u, b_over_d=self.U-u, expected_q=expected_q,
                    expected_W=expected_q-expected_v, expected_v=expected_v,
                    private_cost=self.objective(u), H=self.chi*(self.U-u))

    def breakpoints(self):
        """All objective C2-region boundaries on the feasible interval."""
        points = {0.0, self.U}
        for state in self.states:
            if state.probability == 0:
                continue
            for endpoint in (-state.eps_half_width, state.eps_half_width):
                points.add(self.beta*state.A+endpoint-self.phi*self.r)
                points.add((self.beta*state.A+endpoint-self.phi*self.r-self.chi*self.U)
                           / (1-self.chi))
        return sorted(x for x in points if 0 <= x <= self.U)

    def support_signature(self, u):
        signature = []
        for t in self.thresholds(u):
            for state in self.states:
                if state.probability:
                    z = t-self.beta*state.A
                    signature.append(-1 if z <= -state.eps_half_width else
                                     (1 if z >= state.eps_half_width else 0))
        return tuple(signature)

    def optimum(self):
        """Analytical piecewise-affine FOC, including corners and flat minima.

        The left endpoint of a nonunique minimizer interval is the reporting
        convention; the entire interval and nonuniqueness are also returned.
        """
        nodes = self.breakpoints()
        gradients = [self.derivative(u) for u in nodes]
        tolerance = 1e-12
        if gradients[0] > tolerance:
            roots = [0.0]
        elif gradients[-1] < -tolerance:
            roots = [self.U]
        else:
            roots = [u for u, derivative in zip(nodes, gradients) if abs(derivative) <= tolerance]
            for left, right, dl, dr in zip(nodes, nodes[1:], gradients, gradients[1:]):
                if dl < -tolerance and dr > tolerance:
                    roots.append(left-dl*(right-left)/(dr-dl))
        if not roots:
            raise ArithmeticError("Piecewise FOC failed to identify a minimizer")
        lower, upper = min(roots), max(roots)
        unique = upper-lower < 1e-10
        regime = ("nonunique" if not unique else "lower_corner" if lower < 1e-10
                  else "upper_corner" if self.U-lower < 1e-10 else "interior")
        try:
            curvature = self.curvature(lower)
        except ValueError:
            curvature = None
        derivative = self.derivative(lower)
        residual = (max(0.0, -derivative) if lower == 0 else
                    max(0.0, derivative) if lower == self.U else abs(derivative))
        return dict(u=lower, regime=regime, unique=unique,
                    minimizer_lower=lower, minimizer_upper=upper,
                    curvature=curvature, kkt_residual=residual)

    def reserve_response(self):
        """Proposition 2: local du*/dr, never a historical R_D derivative."""
        optimum = self.optimum()
        if optimum['regime'] != 'interior' or not optimum['unique']:
            raise ValueError("Reserve derivative requires a unique interior optimum")
        u = optimum['u']
        curvature = self.curvature(u)
        if curvature <= 1e-12:
            raise ValueError("Reserve derivative requires positive curvature")
        t1, t2 = self.thresholds(u)
        first = self.p*self.phi*self.density(t1) if self.p else 0.0
        numerator = first + (self.g-self.p)*(1-self.chi)*(self.phi-self.chi)*self.density(t2)
        return -numerator/curvature
