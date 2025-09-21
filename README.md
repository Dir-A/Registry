## Usage

## vcpkg

`vcpkg.json`

```json
{
  "name": "zxpkg-test",
  "version": "1.0",
  "dependencies": [
    "zqf-zut-zxjson"
  ],
  "vcpkg-configuration": {
    "default-registry": {
      "kind": "git",
      "repository": "https://github.com/Microsoft/vcpkg",
      "baseline": "29ff5b8131d0c6c8fcb8fbaef35992f0d507cd7c"
    },
    "registries": [
      {
        "kind": "git",
        "repository": "https://github.com/Dir-A/Registry.git",
        "baseline": "0a2858823b43f7945763faa5f1f39e7b859b5de5",
        "packages": [
          "zqf-*"
        ]
      }
    ]
  }
}
```

## xrepo

[WIP]

# vcpkg

### Get vcpkg

```shell
git clone https://github.com/microsoft/vcpkg.git --depth=1 .vcpkg
cd .vcpkg
bootstrap-vcpkg.bat
```

### Update versions database

```shell
.\.vcpkg\vcpkg.exe --x-builtin-ports-root=./ports --x-builtin-registry-versions-dir=./versions x-add-version --all --verbose
```

### Test Port

```shell
.\.vcpkg\vcpkg.exe install zqf-cmake-modules --overlay-ports=ports
```



