From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: aoe disk not recognized as part of raid
Date: Fri, 23 May 2008 14:25:25 +0200
Message-ID: <20080523142525.31d6e06b.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hallo!

It seems mdadm doesn't recognises aoe block devices automatically as pa=
rt of raid:

monosan:~ # fgrep md9 /etc/mdadm.conf=20
ARRAY /dev/md9 level=3Draid1 num-devices=3D2 UUID=3D23882ab5:8346ffa3:0=
e2e4f1e:419f2ac9

monosan:~ # cat /proc/partitions=20
major minor  #blocks  name
[...]
 253    16 1074790400 dm-16
 253    17 8589934592 dm-17
 152  2832 1074790400 etherd/e11.1

monosan:~ # mdadm -As
mdadm: /dev/md9 has been started with 1 drive (out of 2).

monosan:~ # cat /proc/mdstat=20
Personalities : [raid1] [raid0] [raid6] [raid5] [raid4]=20
md9 : active (auto-read-only) raid1 dm-16[0]
      1074790336 blocks [2/1] [U_]

monosan:~ # mdadm /dev/md9 -a /dev/etherd/e11.1=20
mdadm: re-added /dev/etherd/e11.1

monosan:~ # cat /proc/mdstat=20
Personalities : [raid1] [raid0] [raid6] [raid5] [raid4]=20
md9 : active raid1 etherd/e11.1[1] dm-16[0]
      1074790336 blocks [2/2] [UU]


mdadm version 2.6.6 although it is reported as:
monosan:~ # mdadm -V
mdadm - v2.6 - 21 December 2006
monosan:~ # uname -r
2.6.25-default

Why isn't it scanned automatically?
Is this a bug to be filed?

Thanks
Lars
--=20
                            Informationstechnologie
Berlin-Brandenburgische Akademie der Wissenschaften
J=C3=A4gerstrasse 22-23                     10117 Berlin
Tel.: +49 30 20370-352           http://www.bbaw.de
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
