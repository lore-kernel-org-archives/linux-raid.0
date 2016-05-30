From: Joey Liao <joeyliao@qnap.com>
Subject: Why does raid0 set max_hw_sectors as chunk size but the other raid
 types doesn't?
Date: Mon, 30 May 2016 19:55:43 +0800
Message-ID: <CAHvN=in80JrXO=tDyxNhq9d_wW1ZCCioENyTLu9tYuYYDof20w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have no idea why does raid0_run() in raid0.c use
blk_queue_max_hw_sectors() to set max_hw_sectors as the chunk size,
but the other raid types doesn't?

What's the purpose to limit the max_hw_sectors in raid0?

Is it related to the source code logic issue or the performance issue?

Besides, I have an interesting observation. If I remove all the
following queue limitation codes in raid0_run() of raid0.c, the block
size in iostat is still the same as chunk size even the input block
size is much larger than the chunk size. Why???

-  blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
-  blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
+  //blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
+  //blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);

-  blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
-  blk_queue_io_opt(mddev->queue,
-                 (mddev->chunk_sectors << 9) * mddev->raid_disks);
+  //blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
+  /*blk_queue_io_opt(mddev->queue,
+              (mddev->chunk_sectors << 9) * mddev->raid_disks);*/
