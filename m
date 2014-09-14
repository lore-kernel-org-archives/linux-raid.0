From: Vaughan Cao <vaughan.cao@oracle.com>
Subject: seems like a deadlock in workqueue when md do a flush
Date: Mon, 15 Sep 2014 00:15:50 +0800
Message-ID: <5415BF36.9030308@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, neilb@suse.de, vaughan.cao@oracle.com
List-Id: linux-raid.ids

Hi Tejun/Neil,

@ INFO: task kjournald:4931 blocked for more than 120 seconds.
@ "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
@ kjournald       D ffffffff815b9c40     0  4931      2 0x00000000
@  ffff8811d4b7baa8 0000000000000046 ffff8811d4b7bfd8 0000000000013fc0
@  ffff8811d4b7a010 0000000000013fc0 0000000000013fc0 0000000000013fc0
@  ffff8811d4b7bfd8 0000000000013fc0 ffffffff818b2420 ffff8811d8a20140
@ Call Trace:
@  [<ffffffff81594729>] schedule+0x29/0x70
@  [<ffffffff81460a46>] md_flush_request+0x86/0x120
@  [<ffffffff8118c27d>] ? mem_cgroup_charge_common+0x4d/0x60
@  [<ffffffff81083730>] ? wake_up_bit+0x40/0x40
@  [<ffffffff8118c3cd>] ? mem_cgroup_cache_charge+0x7d/0x90
@  [<ffffffffa004c6eb>] raid0_make_request+0x11b/0x200 [raid0]
@  [<ffffffff812666ad>] ? generic_make_request_checks+0x1ad/0x400
@  [<ffffffff814607cc>] md_make_request+0xdc/0x240
@  [<ffffffff81131e55>] ? mempool_alloc_slab+0x15/0x20
@  [<ffffffff81131fc0>] ? mempool_alloc+0x60/0x170
@  [<ffffffff812669ca>] generic_make_request+0xca/0x100
@  [<ffffffff81266a79>] submit_bio+0x79/0x160
@  [<ffffffff811c9245>] ? bio_alloc_bioset+0x65/0x120
@  [<ffffffff811c3fd3>] submit_bh+0x133/0x200
@  [<ffffffff811c6113>] __sync_dirty_buffer+0x53/0xd0
@  [<ffffffffa00a38e9>] journal_commit_transaction+0xda9/0x1080 [jbd]
@  [<ffffffff8106e7cc>] ? lock_timer_base+0x3c/0x70
@  [<ffffffff8106ed1b>] ? try_to_del_timer_sync+0x5b/0x70
@  [<ffffffffa00a7c25>] kjournald+0xf5/0x280 [jbd]
@  [<ffffffff81083730>] ? wake_up_bit+0x40/0x40
@  [<ffffffffa00a7b30>] ? commit_timeout+0x10/0x10 [jbd]
@  [<ffffffff81082e7e>] kthread+0xce/0xe0
@  [<ffffffff81082db0>] ? kthread_freezable_should_stop+0x70/0x70
@  [<ffffffff8159e1ac>] ret_from_fork+0x7c/0xb0
@  [<ffffffff81082db0>] ? kthread_freezable_should_stop+0x70/0x70


I'm facing a strang case which looks like a deadlock in workqueue. Could 
you show me any idea on how to step further?
The case is we create a md device of type raid0 using two LUNs, mount it 
as ext3 with option barrier=1,data=ordered.  The two LUNs are like below:
@  >> sd 1:2:0:0: [sdb] Write cache: enabled, read cache: disabled, 
doesn't support DPO or FUA
we use an kernel similar to v3.10.x without per-pool workqueue 
implementation and backported the commit 7b7a866.

The case where many dio_aio_complete_work are waiting for the flush_bio 
to complete, this bio queue an work item and wait, while the work item 
is pending in the worklist but no running workers in this worker_pool 
and no idle worker thread either. I'm guessing it's a bug relative to 
the missing idle workers while there is still pending works on the 
queue. maybe there is no idle worker when wake_up_worker(pool) is called.

This is a vmcore from our customer after the block issue is detected. I 
haven't reproduce it locally, but the customer is easy to produce it in 
their environment.  If you need more information, please let me know.

commit 7b7a8665edd8db733980389b098530f9e4f630b2
Author: Christoph Hellwig <hch@infradead.org>
Date:   Wed Sep 4 15:04:39 2013 +0200

     direct-io: Implement generic deferred AIO completions

static void dio_bio_end_aio(struct bio *bio, int error)
{
....
                 if (dio->result && dio->defer_completion) {
                         INIT_WORK(&dio->complete_work, 
dio_aio_complete_work);
queue_work(dio->inode->i_sb->s_dio_done_wq,
                                    &dio->complete_work);
....
}


Below is some debug from the vmcore.

@ .
@ void md_flush_request(struct mddev *mddev, struct bio *bio)
@ {
@ spin_lock_irq(&mddev->write_lock);
@ wait_event_lock_irq(mddev->sb_wait,
@     !mddev->flush_bio,
@     mddev->write_lock);
@ mddev->flush_bio = bio;
@ spin_unlock_irq(&mddev->write_lock);
@ .
@ INIT_WORK(&mddev->flush_work, submit_flushes);
@ queue_work(md_wq, &mddev->flush_work);
@ }
@ EXPORT_SYMBOL(md_flush_request);


@ Note md0 is a 7T size disk, with ext3 filesystem.
@ .
@ /dev/md0 /ora_data ext3 
rw,noatime,errors=continue,barrier=1,data=ordered 0 0
@ .
@ md: bind<sdc1>
@ md: bind<sdb1>
@ md: raid0 personality registered for level 0
@ md/raid0:md0: md_size is 14036237568 sectors.
@ md: RAID0 configuration for md0 - 1 zone
@ md: zone0=[sdb1/sdc1]
@       zone-offset=         0KB, device-offset=         0KB, 
size=7018118784KB
@ md0: detected capacity change from 0 to 7186553634816



@ Analyze the vmcore, md0 indeed has a flush_bio pending.
@ .
@ struct mddev = 0xffff8811d1441000,  flush_bio = 0xffff88102f6536c0,
@ struct bio {
@   bi_sector = 0x0,
@   bi_next = 0x0,
@   bi_bdev = 0xffff8811d24e5080,
@   bi_bdev_orig = 0x0,
@   bi_flags = 0xf000000000000001,
@   bi_rw = 0x1411,    <== (REQ_FLUSH|REQ_NOIDLE|REQ_WRITE|REQ_SYNC)
@   bi_vcnt = 0x0,
@   bi_idx = 0x0,
@   bi_phys_segments = 0x0,
@   bi_size = 0x0,
@   bi_seg_front_size = 0x0,
@   bi_seg_back_size = 0x0,
@   bi_end_io = 0xffffffff81269d10 <bio_end_flush>,
@   bi_private = 0xffff88115b9fdcd8,
@   bi_ioc = 0x0,
@   bi_css = 0x0,
@   bi_integrity = 0x0,
@   bi_max_vecs = 0x0,
@   bi_cnt = {
@     counter = 0x2
@   },
@   bi_io_vec = 0x0,
@   bi_pool = 0xffff8811d8696240,
@   bi_inline_vecs = 0xffff88102f653748
@ }
@ This made other bios with REQ_FLUSH set all blocked, e.g. from kjournald.


@ kworker/15:3 sent the culprit flush_bio, insert its flush_work into 
the cwq
@ of cpu15, but the work item is pending and never get run.  In the 
meanwhile,
@ all running workers on this cpu is waiting for mddev->flush_bio to be
@ cleared, that is, the pending work item(mddev->flush_work) to complete.
@ Now, the point is why this work item can't get a chance to run.
@ .
@ PID: 20757  TASK: ffff881113fea040  CPU: 15  COMMAND: "kworker/15:3"
@  #0 [ffff88115b9fdac8] __schedule at ffffffff815940a2
@  #1 [ffff88115b9fdb60] schedule at ffffffff81594729
@  #2 [ffff88115b9fdb70] schedule_timeout at ffffffff815927c5
@  #3 [ffff88115b9fdc10] wait_for_common at ffffffff815945ca
@  #4 [ffff88115b9fdcb0] wait_for_completion at ffffffff815946fd
@  #5 [ffff88115b9fdcc0] blkdev_issue_flush at ffffffff81269ce0
@  #6 [ffff88115b9fdd20] ext3_sync_file at ffffffffa00be792 [ext3]
@  #7 [ffff88115b9fdd70] vfs_fsync_range at ffffffff811c15de
@  #8 [ffff88115b9fdd80] generic_write_sync at ffffffff811c1641
@  #9 [ffff88115b9fdd90] dio_complete at ffffffff811cceeb
@ #10 [ffff88115b9fddd0] dio_aio_complete_work at ffffffff811cd064
@ #11 [ffff88115b9fdde0] process_one_work at ffffffff8107baf0
@ #12 [ffff88115b9fde40] worker_thread at ffffffff8107db2e
@ #13 [ffff88115b9fdec0] kthread at ffffffff81082e7e
@ #14 [ffff88115b9fdf50] ret_from_fork at ffffffff8159e1ac
@ .
@ mddev=0xffff8811d1441000
@ struct mddev {
@ ...
@   flush_bio = 0xffff88102f6536c0,
@   flush_pending = {
@     counter = 0x0
@   },
@   flush_work = {
@     data = {
@       counter = 
0xffff88123fdf8005  <==(WORK_STRUCT_PENDING|WORK_STRUCT_CWQ)
@     },
@     entry = {
@       next = 0xffff8810e74a2130,
@       prev = 0xffff8810221190f0
@     },
@     func = 0xffffffff81463640 <submit_flushes>
@   },
@ ...
@ }

:!cat cwq.0xffff88123fdf8000
struct cpu_workqueue_struct {
pool = 0xffff88123fdee910,
  wq = 0xffff8811d80b5480,
  work_color = 0x0,
  flush_color = 0xffffffff,
  nr_in_flight = {0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 
0x0, 0x0, 0x0, 0x0},
  nr_active = 0x1,
  max_active = 0x100,
  delayed_works = {
    next = 0xffff88123fdf8060,
    prev = 0xffff88123fdf8060
  }
}

:!cat worker_pool.x.0xffff88123fdee910
struct worker_pool {
   gcwq = 0xffff88123fdee700,
   flags = 0x0,
   worklist = {
     next = 0xffff8811324b2870,
     prev = 0xffffffff81904f08 <psinfo_cleanup+8>
   },
   nr_workers = 0x1b,
   nr_idle = 0x0,
   idle_list = {
     next = 0xffff88123fdee938,
     prev = 0xffff88123fdee938
   },
   idle_timer = {
     entry = {
       next = 0x0,
       prev = 0xdead000000200200
     },
     expires = 0x104d7dc00,
     base = 0xffff8811d8428001,
     function = 0xffffffff8107a930 <idle_worker_timeout>,
     data = 0xffff88123fdee910,
     slack = 0xffffffff,
     start_pid = 0xffffffff,
     start_site = 0x0,
     start_comm = 
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
   },
   mayday_timer = {
     entry = {
       next = 0x0,
       prev = 0xdead000000200200
     },
     expires = 0x104cfa071,
     base = 0xffff8811d8428000,
     function = 0xffffffff8107a830 <gcwq_mayday_timeout>,
     data = 0xffff88123fdee910,
     slack = 0xffffffff,
     start_pid = 0xffffffff,
     start_site = 0x0,
     start_comm = 
"\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
   },
   assoc_mutex = {
     count = {
       counter = 0x1
     },
     wait_lock = {
       {
         rlock = {
           raw_lock = {
             {
               head_tail = 0x0,
               tickets = {
                 head = 0x0,
                 tail = 0x0
               }
             }
           }
         }
       }
     },
     wait_list = {
       next = 0xffff88123fdee9f0,
       prev = 0xffff88123fdee9f0
     },
     owner = 0x0,
     spin_mlock = 0x0
   },
   worker_ida = {
     idr = {
       top = 0xffff8811d8bdf2b0,
       id_free = 0x0,
       layers = 0x1,
       id_free_cnt = 0x0,
       lock = {
         {
           rlock = {
             raw_lock = {
               {
                 head_tail = 0x1b001b,
                 tickets = {
                   head = 0x1b,
                   tail = 0x1b
                 }
               }
             }
           }
         }
       }
     },
     free_bitmap = 0x0
   }
}

@ .
@ crash> ps | awk '{if($0 ~ "kworker" && $3 == "15")print}'
@ .
@      86      2  15  ffff8811d8420240  IN   0.0       0      0
@ [kworker/15:0H]
@   10215      2  15  ffff88117e184140  IN   0.0       0      0
@ [kworker/15:1H]
@   15577      2  15  ffff881137982100  UN   0.0       0      0
@ [kworker/15:98]
@   15597      2  15  ffff8810197d0040  UN   0.0       0      0
@ [kworker/15:118]
@   16212      2  15  ffff881033216040  UN   0.0       0      0
@ [kworker/15:32]
@   16229      2  15  ffff8810224b8380  UN   0.0       0      0
@ [kworker/15:49]
@   17485      2  15  ffff88102e5a0480  UN   0.0 0      0  [kworker/15:0]
@   18774      2  15  ffff88115d9ca300  UN   0.0 0      0  [kworker/15:4]
@   18777      2  15  ffff88102d854100  UN   0.0 0      0  [kworker/15:7]
@   18779      2  15  ffff8810314d01c0  UN   0.0 0      0  [kworker/15:9]
@   18780      2  15  ffff88102238a340  UN   0.0       0      0
@ [kworker/15:10]
@   18796      2  15  ffff88102e7c8500  UN   0.0       0      0
@ [kworker/15:28]
@   19958      2  15  ffff881034636040  UN   0.0 0      0  [kworker/15:6]
@   19959      2  15  ffff88101e0f0300  UN   0.0 0      0  [kworker/15:8]
@   19960      2  15  ffff881017050180  UN   0.0       0      0
@ [kworker/15:11]
@   19961      2  15  ffff88101a28e1c0  UN   0.0       0      0
@ [kworker/15:12]
@   19962      2  15  ffff881016e24200  UN   0.0       0      0
@ [kworker/15:14]
@   20211      2  15  ffff881032210140  UN   0.0       0      0
@ [kworker/15:15]
@   20212      2  15  ffff8810229a42c0  UN   0.0       0      0
@ [kworker/15:16]
@   20755      2  15  ffff881028d38540  UN   0.0 0      0  [kworker/15:1]
@   20756      2  15  ffff88102c9e25c0  UN   0.0 0      0  [kworker/15:2]
@   20757      2  15  ffff881113fea040  UN   0.0 0      0  [kworker/15:3]
@   20758      2  15  ffff8810330fe080  UN   0.0 0      0  [kworker/15:5]
@   20759      2  15  ffff8810218220c0  UN   0.0       0      0
@ [kworker/15:13]
@   20760      2  15  ffff88101a1b2100  UN   0.0       0      0
@ [kworker/15:17]
@   20762      2  15  ffff88102cb98180  UN   0.0       0      0
@ [kworker/15:19]
@   20763      2  15  ffff881016c9e1c0  UN   0.0       0      0
@ [kworker/15:20]
@   20764      2  15  ffff8810344f8200  UN   0.0       0      0
@ [kworker/15:21]
@   20765      2  15  ffff8810322aa240  UN   0.0       0      0
@ [kworker/15:22]
@ .
@ ## kworker/15:[01]H are in idle, others running workers, except 
kworker/15:3,
@ have the same backtrace like this below:
@ .
@ PID: 20765  TASK: ffff8810322aa240  CPU: 15  COMMAND: "kworker/15:22"
@  #0 [ffff88117064ba48] __schedule at ffffffff815940a2
@  #1 [ffff88117064bae0] schedule at ffffffff81594729
@  #2 [ffff88117064baf0] md_flush_request at ffffffff81460a46
@  #3 [ffff88117064bb70] raid0_make_request at ffffffffa00836eb [raid0]
@  #4 [ffff88117064bbb0] md_make_request at ffffffff814607cc
@  #5 [ffff88117064bc20] generic_make_request at ffffffff812669ca
@  #6 [ffff88117064bc50] submit_bio at ffffffff81266a79
@  #7 [ffff88117064bcc0] blkdev_issue_flush at ffffffff81269cd8
@  #8 [ffff88117064bd20] ext3_sync_file at ffffffffa00be792 [ext3]
@  #9 [ffff88117064bd70] vfs_fsync_range at ffffffff811c15de
@ #10 [ffff88117064bd80] generic_write_sync at ffffffff811c1641
@ #11 [ffff88117064bd90] dio_complete at ffffffff811cceeb
@ #12 [ffff88117064bdd0] dio_aio_complete_work at ffffffff811cd064
@ #13 [ffff88117064bde0] process_one_work at ffffffff8107baf0
@ #14 [ffff88117064be40] worker_thread at ffffffff8107db2e
@ #15 [ffff88117064bec0] kthread at ffffffff81082e7e
@ #16 [ffff88117064bf50] ret_from_fork at ffffffff8159e1ac


crash> p pool_nr_running

PER-CPU DATA TYPE:
   atomic_t pool_nr_running[2];
PER-CPU ADDRESSES:
   [0]: ffff88123fc13f80
   [1]: ffff88123fc33f80
   [2]: ffff88123fc53f80
   [3]: ffff88123fc73f80
   [4]: ffff88123fc93f80
   [5]: ffff88123fcb3f80
   [6]: ffff88123fcd3f80
   [7]: ffff88123fcf3f80
   [8]: ffff88123fd13f80
   [9]: ffff88123fd33f80
   [10]: ffff88123fd53f80
   [11]: ffff88123fd73f80
   [12]: ffff88123fd93f80
   [13]: ffff88123fdb3f80
   [14]: ffff88123fdd3f80
   [15]: ffff88123fdf3f80
crash> atomic_t ffff88123fdf3f80
struct atomic_t {
   counter = 0
}


crash> list -o work_struct.entry -s work_struct -x -H ffff88123fdee920

ffff8811324b2868
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff881159922130,
     prev = 0xffff88123fdee920
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff881159922128
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff881135ce1b30,
     prev = 0xffff8811324b2870
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff881135ce1b28
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff881022143130,
     prev = 0xffff881159922130
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff881022143128
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff88115b8623b0,
     prev = 0xffff881135ce1b30
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff88115b8623a8
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff8810261ecdb0,
     prev = 0xffff881022143130
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff8810261ecda8
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff88104f74ed70,
     prev = 0xffff88115b8623b0
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff88104f74ed68
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff8810221190f0,
     prev = 0xffff8810261ecdb0
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff8810221190e8
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff8811d14413d0,
     prev = 0xffff88104f74ed70
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff8811d14413c8
struct work_struct {
   data = {
     counter = 0xffff88123fdf8005
   },
   entry = {
     next = 0xffff8810e74a2130,
     prev = 0xffff8810221190f0
   },
   func = 0xffffffff81463640 <submit_flushes>
}
ffff8810e74a2128
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff881022091870,
     prev = 0xffff8811d14413d0
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff881022091868
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff8810e74a2630,
     prev = 0xffff8810e74a2130
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff8810e74a2628
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff88103460e370,
     prev = 0xffff881022091870
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff88103460e368
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff88102a71cb30,
     prev = 0xffff8810e74a2630
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff88102a71cb28
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff8810e74c13b0,
     prev = 0xffff88103460e370
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff8810e74c13a8
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff881159a5a370,
     prev = 0xffff88102a71cb30
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff881159a5a368
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff88102245c3b0,
     prev = 0xffff8810e74c13b0
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff88102245c3a8
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff881113e9c8b0,
     prev = 0xffff881159a5a370
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff881113e9c8a8
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff8810222bfd70,
     prev = 0xffff88102245c3b0
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff8810222bfd68
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff88102fd31af0,
     prev = 0xffff881113e9c8b0
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff88102fd31ae8
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff88104f7dcb30,
     prev = 0xffff8810222bfd70
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff88104f7dcb28
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff88102a59bb30,
     prev = 0xffff88102fd31af0
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff88102a59bb28
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff88104f7dc3b0,
     prev = 0xffff88104f7dcb30
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff88104f7dc3a8
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff88102fd310f0,
     prev = 0xffff88102a59bb30
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff88102fd310e8
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff8810194878b0,
     prev = 0xffff88104f7dc3b0
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff8810194878a8
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff88102c5aab30,
     prev = 0xffff88102fd310f0
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff88102c5aab28
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff88102a71c630,
     prev = 0xffff8810194878b0
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff88102a71c628
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff88102245c130,
     prev = 0xffff88102c5aab30
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff88102245c128
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff8810225c7d70,
     prev = 0xffff88102a71c630
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff8810225c7d68
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff881022143db0,
     prev = 0xffff88102245c130
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff881022143da8
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff881022119370,
     prev = 0xffff8810225c7d70
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff881022119368
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff8810225c7870,
     prev = 0xffff881022143db0
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff8810225c7868
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff88101a238630,
     prev = 0xffff881022119370
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff88101a238628
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff88103307ab30,
     prev = 0xffff8810225c7870
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff88103307ab28
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff88102d9490f0,
     prev = 0xffff88101a238630
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff88102d9490e8
struct work_struct {
   data = {
     counter = 0xffffe8ffffde0905
   },
   entry = {
     next = 0xffff88123fdf4ef0,
     prev = 0xffff88103307ab30
   },
   func = 0xffffffff811cd040 <dio_aio_complete_work>
}
ffff88123fdf4ee8
struct work_struct {
   data = {
     counter = 0xffff88123fdf7305
   },
   entry = {
     next = 0xffff88123fdf0bc8,
     prev = 0xffff88102d9490f0
   },
   func = 0xffffffffa004e9a0
}
ffff88123fdf0bc0
struct work_struct {
   data = {
     counter = 0xffff88123fdf7305
   },
   entry = {
     next = 0xffff88123fdf0c68,
     prev = 0xffff88123fdf4ef0
   },
   func = 0xffffffff8114dc90 <vmstat_update>
}
ffff88123fdf0c60
struct work_struct {
   data = {
     counter = 0xffff88123fdf7305
   },
   entry = {
     next = 0xffffffff81904f08 <psinfo_cleanup+8>,
     prev = 0xffff88123fdf0bc8
   },
   func = 0xffffffff81180200 <cache_reap>
}
ffffffff81904f00
struct work_struct {
   data = {
     counter = 0xffff88123fdf7305
   },
   entry = {
     next = 0xffff88123fdee920,
     prev = 0xffff88123fdf0c68
   },
   func = 0xffffffff8112e040 <psinfo_cleaner>
}




Thanks,
Vaughan
