From: Roberto Nunnari <roberto.nunnari@supsi.ch>
Subject: failed drive in raid 1 array
Date: Wed, 23 Feb 2011 17:52:39 +0100
Message-ID: <4D653B57.1030203@supsi.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello.

I have a linux box, with two 2TB sata HD in raid 1.

Now, one disk is in failed state and it has no spares:
# cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 sdb4[2](F) sda4[0]
       1910200704 blocks [2/1] [U_]

md0 : active raid1 sdb1[1] sda2[0]
       40957568 blocks [2/2] [UU]

unused devices: <none>


The drives are not hot-plug, so I need to shutdown the box.

My plan is to:
# sfdisk -d /dev/sdb > sdb.sfdisk
# mdadm /dev/md1 -r /dev/sdb4
# mdadm /dev/md0 -r /dev/sdb1
# shutdown -h now

replace the disk and boot (it should come back up, even without one 
drive, right?)

# sfdisk /dev/sdb < sdb.sfdisk
# mdadm /dev/md1 -a /dev/sdb4
# mdadm /dev/md0 -a /dev/sdb1

and the drives should start to resync, right?

This is my first time I do such a thing, so please, correct me
if the above is not correct, or is not a best practice for
my configuration.

My last backup of md1 is of mid november, so I need to be
pretty sure I will not lose my data (over 1TB).

A bit abount my environment:
# mdadm --version
mdadm - v1.12.0 - 14 June 2005
# cat /etc/redhat-release
CentOS release 4.8 (Final)
# uname -rms
Linux 2.6.9-89.31.1.ELsmp i686

Thank you very much and best regards.
Robi
