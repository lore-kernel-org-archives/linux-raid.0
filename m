From: Emilio Hodge <whiz@home.nl>
Subject: Problem creating raid10 f2 with 2 disks missing
Date: Mon, 04 Mar 2013 20:59:25 +0100
Message-ID: <5134FD1D.8080908@home.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

When creating a raid 10 near with 2 copies there are 4 possibilities.

mdadm -C /dev/md/tmp -n4 -c512 -l10 -pn2 -amd missing /dev/sdb9 
/dev/sdc9 missing
mdadm -C /dev/md/tmp -n4 -c512 -l10 -pn2 -amd /dev/sda9 missing 
/dev/sdc9 missing
mdadm -C /dev/md/tmp -n4 -c512 -l10 -pn2 -amd missing /dev/sdb9 missing 
/dev/sdd9
mdadm -C /dev/md/tmp -n4 -c512 -l10 -pn2 -amd /dev/sda9 missing missing 
/dev/sdd9

When creating a raid 10 far with 2 copies only 2 possibilities work, why?
I discovered this when I failed disk 2 and 3 of a raid10 f2 and got a 
spectacular kernel oops.

root@dimmel:~# mdadm -C /dev/md/tmp -n4 -c512 -l10 -pf2 -amd /dev/sda9 
missing /dev/sdc9 missing
mdadm: /dev/sda9 appears to be part of a raid array:
     level=raid10 devices=4 ctime=Mon Mar  4 18:14:29 2013
mdadm: /dev/sdc9 appears to be part of a raid array:
     level=raid10 devices=4 ctime=Sat Mar  2 23:28:12 2013
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md/tmp started.

root@dimmel:~# mdadm -C /dev/md/tmp -n4 -c512 -l10 -pf2 -amd missing 
/dev/sdb9 missing /dev/sdd9
mdadm: /dev/sdb9 appears to be part of a raid array:
     level=raid10 devices=4 ctime=Mon Mar  4 18:17:27 2013
mdadm: /dev/sdd9 appears to be part of a raid array:
     level=raid10 devices=4 ctime=Mon Mar  4 18:15:33 2013
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md/tmp started.

root@dimmel:~# mdadm -C /dev/md/tmp -n4 -c512 -l10 -pf2 -amd /dev/sda9 
missing missing /dev/sdd9
mdadm: /dev/sda9 appears to be part of a raid array:
     level=raid10 devices=4 ctime=Mon Mar  4 18:15:02 2013
mdadm: /dev/sdd9 appears to be part of a raid array:
     level=raid10 devices=4 ctime=Sat Mar  2 23:28:12 2013
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: RUN_ARRAY failed: Input/output error

root@dimmel:~# mdadm -C /dev/md/tmp -n4 -c512 -l10 -pf2 -amd missing 
/dev/sdb9 /dev/sdc9 missing
mdadm: /dev/sdb9 appears to be part of a raid array:
     level=raid10 devices=4 ctime=Mon Mar  4 18:14:29 2013
mdadm: /dev/sdc9 appears to be part of a raid array:
     level=raid10 devices=4 ctime=Mon Mar  4 18:15:02 2013
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: RUN_ARRAY failed: Input/output error

mdadm - v3.2.5 - 18th May 2012
Linux dimmel 3.7.1 #2 SMP Thu Dec 20 21:20:41 CST 2012 x86_64 AMD 
Phenom(tm) II X4 965 Processor AuthenticAMD GNU/Linux

Emilio Hodge
