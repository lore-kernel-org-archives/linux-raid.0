From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: RAID rebuild on Create
Date: Mon, 30 Apr 2007 20:00:38 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0704301958530.29151@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi list,


when a user does `mdadm -C /dev/md0 -l <any> -n <whatever fits> 
<devices>`, the array gets rebuilt for at least RAID1 and RAID5, even if 
the disk contents are most likely not of importance (otherwise we would 
not be creating a raid array right now). Could not this needless resync 
be skipped - what do you think?


Jan
-- 
