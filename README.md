# ClamAV Docker

ClamAV® is an open source antivirus engine for detecting trojans, viruses, malware & other malicious threats.

https://www.clamav.net/

# Config Description

*0.102 時点の設定*

- OnAccessIncludePath  
スキャン対象のディレクトリ、スペース区切りで複数設定可能
- OnAccessPrevention  
スキャンした結果、ウイルスだった場合に他のプロセスからのアクセスをブロックするかを設定する  
  ```
  Some OS distributors have disabled fanotify, despite kernel support. You can check for fanotify support on your kernel by running the command:
  $ cat /boot/config-<kernel_version> | grep FANOTIFY
  You should see the following:
      CONFIG_FANOTIFY=y
      CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
  If you see:
      # CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
  Then ClamAV's On-Access Scanner will still function, scanning and alerting on files normally in real time. However, it will be unable to block access attempts on malicious files. We call this notify-only mode.
  ```
  なので、`FANOTIFY` が有効でも `CONFIG_FANOTIFY_ACCESS_PERMISSIONS` が無効だと死ぬ  
  Docker で雑に linux-headers(fanotify) と inotify-tools(inotify) を入れただけだと有効にならない  
  このサンプルでは無効のまま
- OnAccessExcludeUname  
このユーザーが作成したファイルは Scan しない  
ClamAV プロセスがスキャン時に作成する tmp ファイルなどを再帰的にスキャンしないためにある
- OnAccessExtraScanning  
  > Toggles extra scanning and notifications when a file or directory is created or moved.  
  
  inotify イベントをキャッチするかどうか  
  inotify はファイルシステムイベントの監視ができ、OnAccessExtraScanning を ON にすることで余計なスキャンを回避する
- OnAccessDisableDDD  
ディレクトリを再帰的に見るかどうか
- VirusEvent  
ウイルス発見時に実行するイベント

# clamav-event.sh

k8s で動かす前提で、Slack 通知用の環境変数を設定することでウイルス検知時に Slack へ通知が行く

# docker-compose

SYS_ADMIN を付与している理由は、clamav で利用している fanotify の初期化、fanotify_init を呼び出すために必要な権限

参考: https://linuxjm.osdn.jp/html/LDP_man-pages/man7/capabilities.7.html
