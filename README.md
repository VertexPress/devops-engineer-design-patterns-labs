# DevOps Engineer Design Patterns, companion labs

Runnable code for the Vertex Press title *DevOps Engineer Design Patterns* by Daniel Mercer.
Every listing in the book lives here, under the part and chapter it belongs to, and is kept
runnable. Where a printed listing and this repository differ, **this repository is correct**,
because it is the version that is tested. Corrections are posted here as errata.

## Layout

```
partN-<area>/chNN-<topic>/<listing>.<ext>
```

One folder per chapter. File names say what the listing is, not "L1".

## Running the listings

Most listings need a real platform (a Kubernetes cluster, Terraform with providers, a Vault
server, an Envoy mesh, a Prometheus, an AWS account). Each listing's folder names what it needs.
Some are excerpts from the book that depend on helpers shown in the surrounding lab; those are
marked in a header comment.

The static gate (parse and compile checks that need no platform) runs in CI on every push and on
a monthly schedule, so a listing that stops parsing because a tool changed is caught here before
a reader hits it. See `.github/workflows/listings-ci.yml`.

## Status of this tree

This repository was seeded from the phase 5 technical review, with the phase 6 corrections applied
(the three GitHub Action pins, S3-native state locking, Guaranteed-QoS resources, External Secrets
`v1`, the availability SLI fix plus the 1h and 6h recordings, the IAM trust policy with the stray
comment removed, and the Kyverno per-rule `failureAction`). A few chapters whose listings were not
part of the reviewed set carry a short README noting the listing is to be added from the final
manuscript. Reconcile every listing against the accepted manuscript before publication, so the book
and this repository match exactly.

## License

Code in this repository is MIT licensed (see `LICENSE`). You may use it in your own work.
