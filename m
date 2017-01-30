From: Luke Pyzowski <Luke@sunrisefutures.com>
Subject: RE: [systemd-devel] Errorneous detection of degraded array
Date: Mon, 30 Jan 2017 22:41:10 +0000
Message-ID: <96A26C8C6786C341B83BC4F2BC5419E4795E0075@SRF-EXCH1.corp.sunrisefutures.com>
References: <96A26C8C6786C341B83BC4F2BC5419E4795DE9A6@SRF-EXCH1.corp.sunrisefutures.com>
 <b842c2ce-7d32-a392-e9d9-9f330fa6a7cf@gmail.com>
 <96A26C8C6786C341B83BC4F2BC5419E4795DF1D8@SRF-EXCH1.corp.sunrisefutures.com>
 <4504399b-4d6f-a18a-d64a-e46ecd8efa46@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4504399b-4d6f-a18a-d64a-e46ecd8efa46@gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: 'Andrei Borzenkov' <arvidjaar@gmail.com>, "'systemd-devel@lists.freedesktop.org'" <systemd-devel@lists.freedesktop.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Does
>   systemctl  list-dependencies  sys-devices-virtual-block-md0.device
> report anything interesting?  I get
>
> sys-devices-virtual-block-md0.device
> ● └─mdmonitor.service

Nothing interesting, the same output as you have above.



> Could you try run with systemd.log_level=debug on kernel command line and upload journal again. We can only hope that it will not skew timings enough but it may prove my hypothesis.

I've uploaded the full debug logs to: https://gist.github.com/Kryai/8273322c8a61347e2300e476c70b4d05
In around 20 reboots, the error appeared only twice, certainly with debug enabled it is more rare, but it does still occur, but to your correct guess, debug logging does affect the exhibition of the race condition.

Reminder of key things in the log:
# cat /etc/systemd/system/mdadm-last-resort@.timer 
[Unit]
Description=Timer to wait for more drives before activating degraded array.
DefaultDependencies=no
Conflicts=sys-devices-virtual-block-%i.device

[Timer]
OnActiveSec=30



# cat /etc/systemd/system/share.mount 
[Unit]
Description=Mount /share RAID partition explicitly
Before=nfs-server.service

[Mount]
What=/dev/disk/by-uuid/2b9114be-3d5a-41d7-8d4b-e5047d223129
Where=/share
Type=ext4
Options=defaults
TimeoutSec=120

[Install]
WantedBy=multi-user.target


Again, if any more information is needed please let me know I'll provide it.


Many thanks,
Luke Pyzowski
