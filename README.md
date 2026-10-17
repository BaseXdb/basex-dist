# BaseX Distribution

This repository contains the scripts and resources for building and publishing the [BaseX](https://basex.org) release artifacts: the ZIP archive, the Windows installer, the WAR file and the web application archives. The BaseX sources are maintained in the [basex](https://github.com/BaseXdb/basex) repository.

## Requirements

* A checkout of [basex](https://github.com/BaseXdb/basex) next to this repository (`../basex`)
* JDK 21 and Maven
* Windows, for creating the installer with the bundled NSIS compiler

## Building the Release Files

```
basex build.xq
```

Builds BaseX and writes the artifacts to `release/`. With `-bbuild=war`, only the WAR file is built by Maven, and with `-bbuild=none`, the existing Maven artifacts are reused.

The [release workflow](.github/workflows/release.yml) runs the same script on GitHub Actions and signs the Windows installer.

## Deploying a Snapshot or Release

```
basex [-brelease=true] [-bdry=true] [-bclean=true] deploy.xq
```

Deploys the Maven modules that changed since the last run, creates the release files from the built artifacts and uploads them as snapshot or, with `-brelease=true`, as release. The server login and target directory are read from the environment variables `BASEX_DEPLOY_SERVER` and `BASEX_DEPLOY_TARGET`; `-bdry=true` prints the commands without executing them. With `-bclean=true`, the archives and copied libraries of the deployed modules are removed before building; this is always done for releases.

## Contents

| Path            | Contents |
|-----------------|----------|
| `dist/basex/`   | files copied unchanged into the distribution: readme, sample documents, catalog files, library licenses, XQuery modules |
| `images/`       | icons |
| `linux/`        | desktop entry, systemd service, Debian packaging |
| `mac/`          | Homebrew update scripts |
| `modules/`      | release and deployment modules |
| `win/`          | NSIS installer script and compiler |
| `build.xq`      | build script |
| `deploy.xq`     | deployment script |

## License

BaseX is released under the [BSD License](https://github.com/BaseXdb/basex/blob/main/LICENSE).
