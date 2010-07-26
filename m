From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Increase request size for levels other than raid0?
Date: Mon, 26 Jul 2010 14:30:57 +0200
Message-ID: <slrni4r002.lr8.Mario.Holbe@darkside.dyn.samba-tng.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

according to kernel code md raid0 adjusts its bdev queue max_hw_sectors
by its chunk size:
	raid0.c:	blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
Would it be possible to do that for other raid levels as well?
I'm specifically interested in raid1 :)

I have a raid0 over 4x dm-crypt over 4x raid1 (degraded) over 4 disks
here, and although I couldn't find the code that does that, the raid0
tuning seems to be limited to the max_hw_sectors of the underlying
queues (which makes sense, of course):
	/sys/block/sdc/queue/max_hw_sectors_kb: 32767
	/sys/block/sdd/queue/max_hw_sectors_kb: 32767
	/sys/block/sde/queue/max_hw_sectors_kb: 32767
	/sys/block/sdf/queue/max_hw_sectors_kb: 32767
	/sys/block/md71/queue/max_hw_sectors_kb: 127
	/sys/block/md72/queue/max_hw_sectors_kb: 127
	/sys/block/md73/queue/max_hw_sectors_kb: 127
	/sys/block/md74/queue/max_hw_sectors_kb: 127
	/sys/block/dm-6/queue/max_hw_sectors_kb: 127
	/sys/block/dm-7/queue/max_hw_sectors_kb: 127
	/sys/block/dm-8/queue/max_hw_sectors_kb: 127
	/sys/block/dm-9/queue/max_hw_sectors_kb: 127
	/sys/block/md7/queue/max_hw_sectors_kb: 127
raid1 doesn't tune its max_hw_sectors, thus I'm stuck at 127k request
size.

As far as I can see, the tuning works well if the underling queue
supports bigger max_hw_sectors, here is a raid0 over 2x dm-crypt over
2 disks (i.e. without raid1):
	/sys/block/sdg/queue/max_hw_sectors_kb: 32767
	/sys/block/sdh/queue/max_hw_sectors_kb: 32767
	/sys/block/dm-11/queue/max_hw_sectors_kb: 32767
	/sys/block/dm-12/queue/max_hw_sectors_kb: 32767
	/sys/block/md9/queue/max_hw_sectors_kb: 512
device-mapper adopts the underlying queue max_hw_sectors and raid0 tunes
itself.

Since request size is a limiting factor for dm-crypt performance, it
would be great if at least raid1 could also tune itself to the
underlying queue max_hw_sectors (or at least max_sectors).


regards
   Mario
-- 
There is nothing more deceptive than an obvious fact.
             -- Sherlock Holmes by Arthur Conan Doyle

