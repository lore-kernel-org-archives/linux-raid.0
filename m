From: Mahendra <kuk_m@yahoo.com>
Subject: slow resync during mdadm --create
Date: Mon, 7 Aug 2006 13:45:56 -0700 (PDT)
Message-ID: <20060807204556.30504.qmail@web54715.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

I am running CentOS release 4.3 with mdadm-1.11.0-2 on IBMx346 server
(2xXeon 3.06GHz CPUs and 4GB RAM). I have a RAID-5 (md8) with 4x72GB
disks. I want to convert it to RAID-10 and increase the size by using
4x146GB disks. This RAID-10 (md8) is to be built by creating RAID-0 on
top of 2 RAID-1 devices (md11, md12). I am using 4x146GB disks (15K
RPM). For all my mdxx I am usinf "Persistent Superblock" and 64H chunk
size (default). My /etc/mdadm.conf contains only one line:
DEVICE /dev/sd[abcdefghijklmnop][123456789]
/dev/hd[abcdefghijklmn][123456789]
I don't have and /etc/raidtab ... files.
I took the backup of my filesystem which was there on the old RAID-5
md8 device then I shutdown the server, remove old 4x72GB disks, insert
4x146GB disks, start the box then I started 2 mdadm --create
simlutenously:
# mdadm --create --verbose /dev/md11 --level=1 --raid-devices=2
/dev/sdc1 /dev/sdd1
# mdadm --create --verbose /dev/md12 --level=1 --raid-devices=2
/dev/sde1 /dev/sdf1

Then when I cat /proc/mdstat it reported that both md11 & md12 are
created and resync is in progress , reported resync speed was around
2000K/sec and resync will complete in approximately in 18 hours.
I checked /proc/sys/dev/raid/speed_limit_{min,max} and found these to
be set at 1000 and 30000. While the resync was going on I bumped the
min/max speeds to 50000 & 100000 but that didn't improve the resync
speed. Then I did
#mdadm -s /dev/md12    and md12 disappeared from "cat /proc/mdstat" and
suddenly the resync speed for the remaining md11 increased to around
60000K/Sec and the resync was completed in around 25 minutes.
After the resync of md11 was completed I again created the md12 with
# mdadm --create --verbose /dev/md12 --level=1 --raid-devices=2
/dev/sde1 /dev/sdf1
but the resync speed was only around 2000K/sec and mdstat reported that
it will complete in 18 Hrs. I cannot put the system down for that long
period. So I have few questions:
1. Can I create RAID-0 and then subsequently ext3fs filesystem on md8,
on top of md11 & md12 (both RAID-1) while resync of md12 is going on?
2. Why is the resync so slow?
3. How can I improve the resync speed in this scenarios?

I really appreciate your time and patience very much and thank you in
advance in anticipation of a solution.

Thanks & regards,
Mahendra

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
