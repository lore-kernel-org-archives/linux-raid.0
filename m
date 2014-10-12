From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: "bitmap file is out of date, doing full recovery"
Date: Sun, 12 Oct 2014 21:03:57 +0300
Message-ID: <CAGRgLy5zhV49xF=ZwULaF46Xx=8rnWcypTWxxgf0HmEPpCP+yQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Hi Neil,
after a 2-drive raid1 unclean shutdown (crash actually), after reboot, we had:

md/raid1:md24: not clean -- starting background reconstruction
md/raid1:md24: active with 2 out of 2 mirrors
md24: bitmap file is out of date (41 < 42) -- forcing full recovery
created bitmap (22 pages) for device md24
md24: bitmap file is out of date, doing full recovery
md24: bitmap initialized from disk: read 2 pages, set 44667 of 44667 bits

The superblock of both drives had event count = 42:
(this is a custom mdadm with some added prints):
mdadm: looking for devices for /dev/md24
mdadm: [/dev/md24] /dev/dm-205: slot=0, events=42,
recovery_offset=N/A, resync_offset=0, comp_size=5854539776
mdadm: [/dev/md24] /dev/dm-206: slot=1, events=42,
recovery_offset=N/A, resync_offset=0, comp_size=5854539776

But the bitmap superblock had lower event count, which resulted in a
full resync. Is this an expected scenario in case of a crash?

For example in md_update_sb, first we call
bitmap_update_sb(mddev->bitmap), which synchronously updates the
bitmap, and only afterwards we go ahead and update our superblocks. So
in this case, the bitmap should not have a lower event count. Is there
some other valid scenario, in which the bitmap can remain with a lower
event count?

Thanks,
Alex.
