From: Ninti Systems <office@ninti.com.au>
Subject: fd filesystem and RAID1
Date: 03 Apr 2004 09:02:37 +0930
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1080948756.999.10.camel@localhost>
Reply-To: office@ninti.com.au
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've been able to do everything involved in setting up a simple RAID1
with 2 IDE disks on Slackware 9.1 except get it to actually keep working
on reboot. 

I installed on one disk, built 'degraded' RAID1 devices on the second
disk, copied data, etc. I can hot add devices from the original disk to
the RAID arrays. RAID devices in /etc/fstab come up (in degraded mode)
on boot.

The problem is that hot-added devices never stick, the RAID arrays are
always degraded again on reboot. 

mdadm complains of missing superblocks. I have read the man page but
can't see how to manage superblocks (create/delete) if this is even
possible.

I'm wondering if have to make the original install partitions type 'fd'
as well as those on the second disk? 



