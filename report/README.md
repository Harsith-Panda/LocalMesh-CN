# LocalMesh reports (commitable)

| File | Use |
| --- | --- |
| `phase1-report.pdf` / `.tex` | Main Phase 1 report (present and submit) |
| `architecture-phase1.pdf` / `.tex` | Short architecture handout for Review 1 |
| `phase2-report.pdf` / `.tex` | Phase 2 implementation and verification status report |
| `diagrams.tex` | Shared TikZ figures |

Rebuild (needs [Tectonic](https://tectonic-typesetting.github.io/)):

```bash
cd report && make
```

Setup runbooks stay in `docs/` and are gitignored. Do not put `~/cn-team.env` or private keys here.
