From: Ninti Systems <office@ninti.com.au>
Subject: Software RAID 1 problems
Date: 15 Jul 2004 16:42:02 +0930
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1089875522.1070.18.camel@localhost>
Reply-To: office@ninti.com.au
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have just got a server (Slackware 9.1) up and running after an unknown
incident brought it down overnight (extended power failure most likely,
but not necessarily).

At first, when powering on the system would not recognise any IDE device
at all. It would not boot off a CD, and after booting of a boot floppy,
it would not mount any partitions on any IDE device.

After a ride a car, bingo, suddenly it would boot again. Then freeze,
then reboot etc etc. Eventually, I have it at the point where it will
reboot again everytime. But the problem isn't over yet ...

It appears that two out of five md devices have disappeared. md0 was the
/boot partition, and md2 was the swap partition, they are no longer
present it seems. md1, md3 and md4 are all present but degraded I think
(see output of mdadm below).

Basically, I'm wondering where to go from here:

- Does this look like a sudden-power-off issue or a broken HDD issue?

- Any advice on how to resolve this issue (get back the missing md
devices and restore full arrays?

Thanks
Mick



Raid Devices:
Personalities : [linear] [raid0] [raid1] [raid5] read_ahead 1024 sectors
md1 : active raid1 hdc2[1] 9767424 blocks [2/1] [_U] md3 : active raid1
hdc5[1] 58596992 blocks [2/1] [_U] md4 : active raid1 hdc6[1] 8297472
blocks [2/1] [_U] unused devices: <none>

Raid Array Status:

[dev 9, 1] /dev/md1 0403E3A6.F7F2F6AD.76F1F7FF.76CF2410 online [dev ?,
?] (unknown) 00000000.00000000.00000000.00000000 missing [dev 22, 2]
/dev/hdc2 0403E3A6.F7F2F6AD.76F1F7FF.76CF2410 good

[dev 9, 3] /dev/md3 0FD423CD.D4C229D1.9321323A.273CDDEB online [dev ?,
?] (unknown) 00000000.00000000.00000000.00000000 missing [dev 22, 5]
/dev/hdc5 0FD423CD.D4C229D1.9321323A.273CDDEB good
[dev 9, 4] /dev/md4 EC8BAB76.40CC4FA6.C9FB44E3.1A8DE26A online [dev ?,
?] (unknown) 00000000.00000000.00000000.00000000 missing [dev 22, 6]
/dev/hdc6 EC8BAB76.40CC4FA6.C9FB44E3.1A8DE26A good


