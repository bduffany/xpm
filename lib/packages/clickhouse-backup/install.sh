#!/usr/bin/env bash

if [[ "$_XPM_KERNEL" != "linux" ]]; then
  echo >&2 "clickhouse-backup not yet implemented on $_XPM_KERNEL"
  exit 1
fi

# TODO: latest version
# TODO: darwin
curl -fsSL \
  https://github.com/Altinity/clickhouse-backup/releases/download/v2.6.33/clickhouse-backup-linux-${_XPM_ARCH}.tar.gz \
  -o clickhouse-backup.tar.gz
tar xvf clickhouse-backup.tar.gz
sudo mv build/linux/${_XPM_ARCH}/clickhouse-backup ${_XPM_LOCAL_BIN_PATH}/clickhouse-backup
