From: Christian Balzer <chibi@gol.com>
Subject: RAID5 TRIM/DISCARD user land support (fstriim and mkfs)
Date: Mon, 10 Aug 2015 16:46:57 +0900
Message-ID: <20150810164657.75bae079@batzmaru.gol.ad.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello,

Debian system, tested both Wheezy and Jessie, thus 3.16 kernel with
backports.

8 SSD RAID5, of course with raid456.devices_handle_discard_safely set to 1.
I can re-mount it with discard w/o a problem:
---
EXT4-fs (md4): re-mounted. Opts: stripe=112,data=ordered,discard
---

However fstrim whines about "FITRIM ioctl failed: Operation not supported"
and mkfs.ext4 unsurprisingly doesn't discard things when invoked.

The same HW/OS combo works fine with RAID10.

When looking at the sysfs entries for that MD device the fact
that /sys/class/block/md4/queue/discard_zeroes_data is 0 doesn't instill
me with hope or confidence 

Now while the SSDs in question (Intel DC S3610s) don't really need TRIM
really would have liked them to be able to start with a clean slate so to
speak.

Any insights?

Christian
-- 
Christian Balzer        Network/Systems Engineer                
chibi@gol.com   	Global OnLine Japan/Fusion Communications
http://www.gol.com/
