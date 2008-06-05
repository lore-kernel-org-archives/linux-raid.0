From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: RAID1 over aoe devices freezes cp-procs on failure of one aoe
 device
Date: Thu, 5 Jun 2008 16:25:02 +0200
Message-ID: <20080605162502.09856f38.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, sah@coraid.com, ecashin@coraid.com
List-Id: linux-raid.ids

Hi there.

please let me explain a problem i struggle with here with a self build =
SAN.

If of one of two AoE-devices of a RAID1 fails any process copying to th=
e mounted RAID freezes.

This happens on a testing system. So I could make some more tests if yo=
u need some more information. But it's time consuming.

The aoe targets use qaoed as server.
To simulate a failure i shut down the network interface the qaoed servi=
ng requests from on one aoe-target.

  Linux        Linux
+-------+    +-------+
| qaoed |    | qaoed |
+--+----+    +---+---+
    \           / <- network device shut down
     \         /=20
   +--+-------+--+
   |  |  aoe  |  |
   | e2.0  e11.1 | Linux 2.6.22.17-0.1-default
   |    \   /    | SuSE-10.3
   |    RAID1    | sekundus
   |     md9     |
   +-------------+

sekundus:~ # cat /proc/partitions=20
major minor  #blocks  name
[...]
 152  2832 1074790400 etherd/e11.1
 152   512 1074790400 etherd/e2.0
   9     9 1074790336 md9

sekundus:~ # cat /proc/mdstat=20
Personalities : [raid1] [raid0] [raid6] [raid5] [raid4]=20
md9 : active raid1 etherd/e2.0[0] etherd/e11.1[1]
      1074790336 blocks [2/2] [UU]


The lost aoe-device is correctly marked as faulty but the the raid is n=
ot usable for a copying processes any more although the remaining devic=
e should be enough for a RAID1. There was no change after removing the =
faulty device from md9.

Is it possible that one faulty aoe-device blocks the aoe-module anyhow =
so that all other aoe devices aren't accessible anymore? Or is the RAID=
 subsystem responsible for this?

How can I debug this? There are no entries in the logs regarding this b=
esides:

/var/log/messages:
Jun  5 11:16:01 sekundus kernel: raid1: etherd/e11.1: rescheduling sect=
or 293594096
Jun  5 11:16:01 sekundus kernel: raid1: etherd/e11.1: rescheduling sect=
or 293594224
Jun  5 11:16:01 sekundus kernel: raid1: etherd/e11.1: rescheduling sect=
or 293594472
Jun  5 11:16:01 sekundus kernel: md: super_written gets error=3D-5, upt=
odate=3D0
Jun  5 11:16:01 sekundus kernel: raid1: Disk failure on etherd/e11.1, d=
isabling device.=20
Jun  5 11:16:01 sekundus kernel:        Operation continuing on 1 devic=
es
Jun  5 11:16:01 sekundus kernel: RAID1 conf printout:
Jun  5 11:16:01 sekundus kernel:  --- wd:1 rd:2
Jun  5 11:16:01 sekundus kernel:  disk 0, wo:0, o:1, dev:etherd/e2.0
Jun  5 11:16:01 sekundus kernel:  disk 1, wo:1, o:0, dev:etherd/e11.1
Jun  5 11:16:01 sekundus kernel: RAID1 conf printout:
Jun  5 11:16:01 sekundus kernel:  --- wd:1 rd:2
Jun  5 11:16:01 sekundus kernel:  disk 0, wo:0, o:1, dev:etherd/e2.0

The whole system doesn't react on a shutdown after this. I could login =
for minutes over network till i hard rebooted through sys-rq.

Thanks for any help.
Lars

PS: I gave up using raid on _multipath_ on LSI-SCSI (non-RAID SAS) conn=
ected to an external storage (with expander) because I couldn't find ou=
t which subsystem (scsi, driver, firmware-controller, firmware-expander=
, multipathing, raid) to blame for the reproducable raid sync failures.=
 Who to contact in cases with problems with such a complex system? Or i=
s there a step-by-step debugging guidance for what and how to test in w=
hat order?
This was a really time wasting try. I just skipped multipathd now - it =
seems to work.

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
