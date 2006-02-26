From: Andre Noll <maan@systemlinux.org>
Subject: mdadm-2.3.1 fails to hotadd device
Date: Sun, 26 Feb 2006 12:08:59 +0100
Message-ID: <20060226110859.GJ7030@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

# uname -r; mdadm -V; cat /proc/mdstat 
2.6.15.4-gbbde1285
mdadm - v2.3.1 - 6 February 2006
Personalities : [raid1] [raid5] [raid6] 
md1 : active raid1 hdd1[12] sdi1[8] sda1[0] hda1[13] sdl1[11] sdk1[10]
sdj1[9] sdh1[7] sdg1[6] sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1]
251776 blocks [14/14] [UUUUUUUUUUUUUU]
      
unused devices: <none>
# 
# mdadm /dev/md1 -f /dev/hdd1 
mdadm: set /dev/hdd1 faulty in /dev/md1
# 
# mdadm /dev/md1 -r /dev/hdd1
mdadm: hot removed /dev/hdd1
# 
# mdadm /dev/md1 -a /dev/hdd1
mdadm: cannot find valid superblock in this array - HELP
# 
# mdadm-1.12.0 /dev/md1 -a /dev/hdd1
mdadm: hot added /dev/hdd1

Any hints?
Andre
-- 
The only person who always got his work done by Friday was Robinson Crusoe
