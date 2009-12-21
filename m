From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: mdadm 3.1.1: level change won't start
Date: Mon, 21 Dec 2009 03:41:33 +0000
Message-ID: <73e903670912201941q44dae7b0t455d1a94f13f5c31@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: Neil Brown <nfbrown@novell.com>
List-Id: linux-raid.ids

Hi all,

I wish to convert my 3-drive RAID-5 array to a 6-drive RAID-6. I'm on
Linux 2.6.32.2 and have mdadm version 3.1.1 with the 32-bit-array-size
patch from here: http://osdir.com/ml/linux-raid/2009-11/msg00534.html

I have three live drives and three spares added to the array. When I
initialize the command, mdadm does the initial checks and aborts with
a "cannot set device shape" without doing anything to the array.

=46ollowing are some md stats and growth command output:

___

$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md_d1 : active raid5 sdd1[6](S) sdc1[5](S) sdb1[4](S) sdf1[1] sde1[0] s=
dl1[3]
=A0=A0=A0=A0=A0 2930078720 blocks super 1.1 level 5, 256k chunk, algori=
thm 2 [3/3] [UUU]
=A0=A0=A0=A0=A0 bitmap: 1/350 pages [4KB], 2048KB chunk

$ mdadm --detail --scan
ARRAY /dev/md/d1 metadata=3D1.01 spares=3D3 name=3Dmamma:d1
UUID=3Dda547022:042a6f68:d5fe251e:5e89f263

$ mdadm --grow /dev/md_d1 --level=3D6 --raid-devices=3D6
--backup-file=3D/root/backup.md1_to_r6
mdadm: metadata format 1.10 unknown, ignored.
mdadm: metadata format 1.10 unknown, ignored.
mdadm level of /dev/md_d1 changed to raid6
mdadm: Need to backup 1024K of critical section..
mdadm: Cannot set device shape for /dev/md_d1
mdadm: aborting level change
___


Three questions -

1. What does the stuff about "metadata format 1.10 unknown" mean?
Notice the "super 1.1" vs. "metadata 1.01" vs. "metadata format 1.10"
disrepancy between mdsat, --detail and --grow output.

2. Am I doing something wrong? :)

3. How can I get more info about what is causing the failure to
initialize the growth?

Thanks!

-- Kristleifur


(P.s., I'm cc-ing this directly to Neil Brown as the maintainer of
mdadm. I hope that isn't rude of me.)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
