# VCPKG

### Get VCPKG

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



