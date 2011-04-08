From: Yann Ormanns <yann-ormanns@web.de>
Subject: RAID6 simply does not start as /dev/md8
Date: Fri, 08 Apr 2011 10:00:23 +0200
Message-ID: <4D9EC097.7010600@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everybody,
I've now been trying for over a week to get my RAID6 working.
I have set up the array by partitioning all six disks (partition type:
Linux (83)) and executing "mdadm -C /dev/md8 --level=6 --raid-devices=6
/dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1".

When the array had finished syncing, I rebooted. /proc/mdstat contained
	md126 : inactive sde1[4](S) sdd1[3](S)
	      3907025072 blocks super 1.2

	md127 : inactive sdb1[1](S) sda1[0](S) sdc1[2](S) sdf1[5](S)
	      7814050144 blocks super 1.2

So I put the following lines into /etc/mdadm.conf (I had forgot this
before):
"DEVICE /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1
ARRAY /dev/md8
devices=/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1,/dev/sde1,/dev/sdf1"
So I rebooted again, now the array was started as follows:

	Personalities : [raid1] [raid6] [raid5] [raid4]
	md8 : inactive sda1[0](S)
	      1953512536 blocks super 1.2

I found out, that the assembly was aborted due to the error, that
/dev/sda1 has no superblock. It seems, as if the kernel would start the
array while booting the system, so mdadm is unable to assemble it
afterwards. If I stop and re-assemble the array, it works fine.

Unfortunately, I have to keep "CONFIG_MD_AUTODETECT" enabled, because /
and the whole system runs on a RAID1. But why does the kernel start the
array, although the used partition type of the disks in my RAID6 is NOT
"linux raid autodetect"?
I simply want to start my RAID6 as /dev/md8.

I use mdadm-3.1.4 and linux-2.6.36-gentoo-r8. The superblocks seem to be
correct - "mdadm -E /dev/sd[a,b,c,d,e,f]1 | grep Name" returns
           Name : Atlas:8  (local to host Atlas)
           Name : Atlas:8  (local to host Atlas)
           Name : Atlas:8  (local to host Atlas)
           Name : Atlas:8  (local to host Atlas)
           Name : Atlas:8  (local to host Atlas)
           Name : Atlas:8  (local to host Atlas)
If I get this right, this array should be started as /dev/md8. However,
it does not. I have tried several combinations of configurations ("linux
raid autodetect" without using mdadm for assembly, "linux" together with
mdadm, and so on), but without any success.
Any help would be really apprectiated.

Best regards,
Yann
