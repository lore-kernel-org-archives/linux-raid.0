From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Creating RAID1 with bitmap fails
Date: Wed, 30 May 2007 12:37:22 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0705301229370.11140@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,


the following command strangely gives -EIO ...
12:27 sun:~ # mdadm -C /dev/md4 -l 1 -n 2 -e 1.0 -b internal /dev/ram0 
missing

md: md4: raid array is not clean -- starting background reconstruction
md4: failed to create bitmap (-5)
md: pers->run() failed ...
mdadm: RUN_ARRAY failed: Input/output error
mdadm: stopped /dev/md4

Leaving out -b internal creates the array. /dev/ram0 or /dev/sda5 - EIO 
happens on both. (But the disk is fine, like ram0)
Where could I start looking?

Linux sun 2.6.21-1.3149.al3.8smp #3 SMP Wed May 30 09:43:00 CEST 2007 
sparc64 sparc64 sparc64 GNU/Linux
mdadm 2.5.4


Thanks,
	Jan
-- 
