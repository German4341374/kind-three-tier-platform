# ADR 0002: Calico for network policy enforcement

**Status:** Accepted

The default kind networking does not provide the policy behavior this demonstration needs. The cluster disables the default CNI and installs pinned Calico so default-deny and allow-list policies are actually enforced. This increases cluster startup time and adds another component to troubleshoot, but makes the security demonstration meaningful.
