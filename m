From: Florian Dazinger <florian.dazinger@umit.at>
Subject: problems with raid=noautodetect
Date: Mon, 22 May 2006 14:41:44 +0200
Message-ID: <4471B188.3060400@umit.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi list,
I read somewhere that it would be better not to rely on the=20
autodetect-mechanism in the kernel at boot time, but rather to set up=20
/etc/mdadm.conf accordingly and boot with raid=3Dnoautodetect. Well, I=20
tried that :)

I set up /etc/mdadm.conf for my 2 raid5 arrays:

---- snip ----
# mountpoint: /home/media
ARRAY  /dev/md0
    level=3Draid5
    UUID=3D86ed1434:43380717:4abf124e:970d843a
    devices=3D/dev/sda1,/dev/sdb1,/dev/sdd3

# mountpoint: /mnt/raid
ARRAY  /dev/md1
    level=3Draid5
    UUID=3Dbaf59fb5:f4805e7a:91a77644:af3dde17
#   devices=3D/dev/sda2,/dev/sdb2,/dev/sdd2
---- snap ----

and rebooted with raid=3Dnoautodetect. It booted fine, but the 3rd disk=
s=20
from each array (/dev/sdd2 and /dev/sdd3) were removed, so I had 2=20
degraded raid5 arrays. It was possible to readd them with sth. like:

mdadm /dev/md0 -a /dev/sdd3
(synced and /proc/mdstat showed [UUU])

but after the next reboot, the two partitions were again removed=20
([UU_])?! This was a reproducible error, I tried it several times with=20
different /etc/mdadm.conf settings (ARRAY-statement with UUID=3D,=20
devices=3D, UUID+devices, etc.).

I=B4m now running autodetect again, all raid arrays are working fine, b=
ut=20
can anyone explain this strange behaviour?
(kernel-2.6.16.14, amd64)

thanks,
florian

PS: please cc me, as I=B4m not subscribed to the list
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
