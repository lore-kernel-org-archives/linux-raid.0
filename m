From: Ric Wheeler <ric@emc.com>
Subject: 4-way RAID-1 group never finishes md_do_sync()?
Date: Mon, 31 Jan 2005 16:21:14 -0500
Message-ID: <41FEA14A.2080306@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


We have a setup where the system partitions (/, /usr, /var) are all 
mirrored across a 4 volume RAID-1 devices.

On some set of our nodes running both a SLES based kernel and 2.6.10, we 
have a condition where the a device gets stuck in the md_do_sync() code 
and never makes progress, never advances and spews into /var/log/messages.

I addd a bunch of printk's to md_do_sync and got the following:

    Jan 31 15:05:57 centera kernel: md: waking up MD thread md5_raid1.
    Jan 31 15:05:57 centera kernel: md: recovery thread got woken up
    (sb_dirty 0 recovery 0x13 sync_thread 0xf6312380 REC_NEEDED 0 
    REC_DONE 1 ) ...
    Jan 31 15:05:57 centera kernel: interrupting MD-thread pid 16530
    Jan 31 15:05:57 centera kernel: raid1_spare_active start loop -
    working disks 4 degraded 0
    Jan 31 15:05:57 centera kernel: raid1_spare_active end loop -
    working disks 4 degraded 0
    Jan 31 15:05:57 centera kernel: raid1_spare_active - no spares made
    active
    Jan 31 15:05:57 centera kernel: md: updating md5 RAID superblock on
    device (in sync 1)
    Jan 31 15:05:57 centera kernel: md: sdd5 <6>(write) sdd5's sb
    offset: 305152
    Jan 31 15:05:57 centera kernel: md: sdc5 <6>(write) sdc5's sb
    offset: 305152
    Jan 31 15:05:57 centera kernel: md: sdb5 <6>(write) sdb5's sb
    offset: 305152
    Jan 31 15:05:57 centera kernel: md: sda5 <6>(write) sda5's sb
    offset: 305152
    Jan 31 15:05:57 centera kernel: md: waking up MD thread md5_raid1.
    Jan 31 15:05:57 centera kernel: md: recovery thread got woken up
    (sb_dirty 0 recovery 0x20 sync_thread 0x0 REC_NEEDED 1 REC_DONE 0 ) ...
    Jan 31 15:05:57 centera kernel: md: recovery (2) raid_disk 0 faulty
    0 nr_pending 0 degraded 0...
    Jan 31 15:05:57 centera kernel: md: recovery (2) raid_disk 2 faulty
    0 nr_pending 0 degraded 0...
    Jan 31 15:05:57 centera kernel: md: recovery (2) raid_disk 1 faulty
    0 nr_pending 0 degraded 0...
    Jan 31 15:05:57 centera kernel: md: recovery (2) raid_disk 3 faulty
    0 nr_pending 0 degraded 0...
    Jan 31 15:05:57 centera kernel: md: waking up MD thread md5_resync.
    Jan 31 15:05:57 centera kernel: md: waking up MD thread md5_raid1.
    Jan 31 15:05:57 centera kernel: md: recovery thread got woken up
    (sb_dirty 0 recovery 0x3 sync_thread 0xf6312380 REC_NEEDED 0
    REC_DONE 0 ) ...
    Jan 31 15:05:57 centera kernel: md_do_sync ITERATE_MDDEV: mddev md5
    mddev->curr_resync 2 mddev2 md3 mddev2->curr_resync 0
    Jan 31 15:05:58 centera kernel: md_do_sync ITERATE_MDDEV: mddev md5
    mddev->curr_resync 2 mddev2 md6 mddev2->curr_resync 0
    Jan 31 15:05:58 centera kernel: md_do_sync ITERATE_MDDEV: mddev md5
    mddev->curr_resync 2 mddev2 md7 mddev2->curr_resync 0
    Jan 31 15:05:58 centera kernel: md_do_sync ITERATE_MDDEV: mddev md5
    mddev->curr_resync 2 mddev2 md8 mddev2->curr_resync 0
    Jan 31 15:05:58 centera kernel: md_do_sync ITERATE_MDDEV: mddev md5
    mddev->curr_resync 2 mddev2 md0 mddev2->curr_resync 0
    Jan 31 15:05:58 centera kernel: md: syncing RAID array md5 recovery
    0x3 resync_mark 26725 resync_mark_cnt 610304
    Jan 31 15:05:58 centera kernel: md: minimum _guaranteed_
    reconstruction speed: 1000 KB/sec/disc.
    Jan 31 15:05:58 centera kernel: md: using maximum available idle IO
    bandwith (but not more than 200000 KB/sec) for reconstruction.
    Jan 31 15:05:58 centera kernel: md_do_sync: md5 j 610304
    Jan 31 15:05:58 centera kernel: md_do_sync: md5 step 0 mark 26726
    mark_cnt 610304
    Jan 31 15:05:58 centera kernel: md_do_sync: md5 step 1 mark 26726
    mark_cnt 610304
    Jan 31 15:05:58 centera kernel: md_do_sync: md5 step 2 mark 26726
    mark_cnt 610304
    Jan 31 15:05:58 centera kernel: md_do_sync: md5 step 3 mark 26726
    mark_cnt 610304
    Jan 31 15:05:58 centera kernel: md_do_sync: md5 step 4 mark 26726
    mark_cnt 610304
    Jan 31 15:05:58 centera kernel: md_do_sync: md5 step 5 mark 26726
    mark_cnt 610304
    Jan 31 15:05:58 centera kernel: md_do_sync: md5 step 6 mark 26726
    mark_cnt 610304
    Jan 31 15:05:58 centera kernel: md_do_sync: md5 step 7 mark 26726
    mark_cnt 610304
    Jan 31 15:05:58 centera kernel: md_do_sync: md5 step 8 mark 26726
    mark_cnt 610304
    Jan 31 15:05:58 centera kernel: md_do_sync: md5 step 9 mark 26726
    mark_cnt 610304
    Jan 31 15:05:58 centera kernel: md: using 128k window, over a total
    of 305152 blocks.
    Jan 31 15:05:58 centera kernel: md: resuming recovery of md5 from
    checkpoint.
    Jan 31 15:05:58 centera kernel: md: md5: sync done.

If you look at the sync part of md_do_sync, it is comparing the 
max_sectors (610304) to the value of  recovery_cp (stored in j) and they 
are equal.

In the "out" of md_do_sync, there is code that is setting recovery_cp:

 out:
    mddev->queue->unplug_fn(mddev->queue);

    wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));

    /* tell personality that we are finished */
    mddev->pers->sync_request(mddev, max_sectors, 1);

    if (!test_bit(MD_RECOVERY_ERR, &mddev->recovery) &&
        mddev->curr_resync > 2 &&
        mddev->curr_resync > mddev->recovery_cp) {
        if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
            printk(KERN_INFO
                "md: checkpointing recovery of %s.\n",
                mdname(mddev));
            mddev->recovery_cp = mddev->curr_resync;
        } else
            mddev->recovery_cp = MaxSector;
    }

Do we need to divide "curr_resync" by 2 before storing in recovery_cp, 
or I am still confused? Is this just a bit of confusion between 1k and 
512 byte units?

Regards,

Ric


