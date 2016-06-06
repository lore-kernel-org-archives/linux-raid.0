From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: mdadm 3.4-1, error msg. on boot - no
 /usr/lib/systemd/scripts/mdadm_env.sh
Date: Sun, 5 Jun 2016 20:03:46 -0500
Message-ID: <5754CBF2.8000309@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil, All,

  I'm chasing down the reason there is no /usr/lib/systemd/scripts/mdad=
m_env.sh
provided with mdadm. This is more a curiosity really as mdmonitor conti=
nues to
run, but it always throws an error at boot:

Jun 05 17:12:47 valhalla systemd[454]: mdmonitor.service: Failed at ste=
p EXEC
spawning /usr/lib/systemd/scripts/mdadm_env.sh: No such file or directo=
ry

  I have several Arch servers, all on mdadm 3.4-1. I ran into an issue =
a year or
so ago with a boot error with mdmonitor due to my failure to provide MA=
ILADDR in
/etc/mdadm.com, but that has long since been corrected:

# cat /etc/mdadm.conf
DEVICE partitions
ARRAY /dev/md0 metadata=3D1.2 name=3Darchiso:0 UUID=3D1b67f2d4:4911f2c5=
:469f9dcf:315814ce
ARRAY /dev/md1 metadata=3D1.2 name=3Darchiso:1 UUID=3D0542c5c9:3802b256=
:32e97884:a2e49f53
ARRAY /dev/md2 metadata=3D1.2 name=3Darchiso:2 UUID=3D812e8f85:0c4efbef=
:a0c02f49:215df35e
ARRAY /dev/md3 metadata=3D1.2 name=3Darchiso:3 UUID=3D80a3bf76:e6421b06=
:6edb2a88:741e8b6f
MAILADDR david@mydomain.com
PROGRAM /usr/sbin/handle-mdadm-events

  So following the rabbit trail further, I check and there is no
/usr/lib/systemd/scripts/mdadm_env.sh on my system and it is not provid=
ed as
part of the mdadm package:

# pacman -Ql mdadm
mdadm /etc/mdadm.conf
mdadm /usr/bin/mdadm
mdadm /usr/bin/mdassemble
mdadm /usr/bin/mdmon
mdadm /usr/lib/initcpio/hooks/mdadm
mdadm /usr/lib/initcpio/install/mdadm
mdadm /usr/lib/initcpio/install/mdadm_udev
mdadm /usr/lib/systemd/system-shutdown/mdadm.shutdown
mdadm /usr/lib/systemd/system/mdadm-grow-continue@.service
mdadm /usr/lib/systemd/system/mdadm-last-resort@.service
mdadm /usr/lib/systemd/system/mdadm-last-resort@.timer
mdadm /usr/lib/systemd/system/mdmon@.service
mdadm /usr/lib/systemd/system/mdmonitor.service
mdadm /usr/lib/udev/rules.d/63-md-raid-arrays.rules
mdadm /usr/lib/udev/rules.d/64-md-raid-assembly.rules
<snip man pages>

  However, the mdmonitor.service file is certainly looking for one:

# cat /usr/lib/systemd/system/mdmonitor.service

#  This file is part of mdadm.
#
#  mdadm is free software; you can redistribute it and/or modify it
#  under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.

[Unit]
Description=3DMD array monitor
DefaultDependencies=3Dno

[Service]
Environment=3D  MDADM_MONITOR_ARGS=3D--scan
EnvironmentFile=3D-/run/sysconfig/mdadm
ExecStartPre=3D-/usr/lib/systemd/scripts/mdadm_env.sh
ExecStart=3D/sbin/mdadm --monitor $MDADM_MONITOR_ARGS

  Further, there isn't even a /run/sysconfig directory on Arch (which l=
ooks more
SuSE'esque). Checking the status, mdmonitor is happily running and doin=
g it's job:

# sc status mdmonitor
=E2=97=8F mdmonitor.service - MD array monitor
   Loaded: loaded (/usr/lib/systemd/system/mdmonitor.service; static; v=
endor
preset: disabled)
   Active: active (running) since Fri 2016-05-27 08:32:26 CDT; 1 weeks =
2 days ago
  Process: 353 ExecStartPre=3D/usr/lib/systemd/scripts/mdadm_env.sh (co=
de=3Dexited,
status=3D203/EXEC)
 Main PID: 378 (mdadm)
    Tasks: 1 (limit: 512)
   CGroup: /system.slice/mdmonitor.service
           =E2=94=94=E2=94=80378 /sbin/mdadm --monitor --scan

May 27 08:32:26 valkyrie systemd[1]: Starting MD array monitor...
May 27 08:32:26 valkyrie systemd[1]: Started MD array monitor.

  So the issue here is "is this a missing file from the Arch packaging =
of
mdadm?", "or is there just an oversight in the service file?" I apoligi=
ze if
this has been asked before, searching, I don't find anything directly. =
So is
this an Arch issue or a mdadm issue?

  I know it's not a big issue, but I'd like to clean up the boot messag=
e
properly. What say the devs?


--=20
David C. Rankin, J.D.,P.E.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
