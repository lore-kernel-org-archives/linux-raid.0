From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Some RAID levels do not support bitmap
Date: Mon, 11 Jun 2007 14:50:55 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706111448500.19578@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

Hi,


RAID levels 0 and 4 do not seem to like the -b internal. Is this 
intentional? Runs 2.6.20.2 on i586.
(BTW, do you already have a PAGE_SIZE=8K fix?)

14:47 ichi:/dev # mdadm -C /dev/md0 -l 4 -e 1.0 -b internal -n 2 /dev/ram[01]
mdadm: RUN_ARRAY failed: Input/output error
mdadm: stopped /dev/md0
14:47 ichi:/dev # mdadm -C /dev/md0 -l 0 -e 1.0 -b internal -n 2 /dev/ram[01]
mdadm: RUN_ARRAY failed: Cannot allocate memory
mdadm: stopped /dev/md0

Right... md: bitmaps not supported for this level.



Thanks,
	Jan
-- 
