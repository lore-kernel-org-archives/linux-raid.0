From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH 0/5] Fixes for RAID1 resync
Date: Tue, 16 Sep 2014 11:31:26 -0500
Message-ID: <2C41CCF8-8B5C-486F-AE43-42D10EBAA0A5@redhat.com>
References: <20140910062039.26400.36745.stgit@notabene.brown> <D96E0116-919C-4F4B-B4B6-2564B99449FB@redhat.com> <8697EC47-F648-4E66-B37C-4A2DC3030696@redhat.com> <20140915133006.14e57085@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140915133006.14e57085@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Eivind Sarto <eivindsarto@gmail.com>, linux-raid@vger.kernel.org, majianpeng <majianpeng@gmail.com>
List-Id: linux-raid.ids


On Sep 14, 2014, at 10:30 PM, NeilBrown wrote:

> On Thu, 11 Sep 2014 12:12:01 -0500 Brassow Jonathan <jbrassow@redhat.com>
> wrote:
> 
>> 
>> On Sep 10, 2014, at 10:45 PM, Brassow Jonathan wrote:
>> 
>>> 
>>> On Sep 10, 2014, at 1:20 AM, NeilBrown wrote:
>>> 
>>>> 
>>>> Jon: could you test with these patches on top of what you
>>>> have just in case something happens to fix the problem without
>>>> me realising it?
>>> 
>>> I'm on it.  The test is running.  I'll know later tomorrow.
>>> 
>>> brassow
>> 
>> The test is still failing from here.  I grabbed 3.17.0-rc4, added the 5 patches, and got the attached backtraces when testing.  As I said, the hangs are not exactly the same.  This set shows the mdX_raid1 thread in the middle of handling a read failure.
> 
> Thanks.
> mdX_raid1 is blocked in freeze_array.
> That could be caused by conf->nr_pending nor aligning properly with
> conf->nr_queued.
> 
> Both normal IO and resync IO can be retried with reschedule_retry()
> and so be counted into ->nr_queued, but only normal IO gets counted in
> ->nr_pending.
> 
> Previously could could only possibly have on or the other and when handling
> a read failure it could only be normal IO.  But now that they two types can
> interleave, we can have both normal and resync IO requests queued, so we need
> to count them both in nr_pending.
> 
> So the following patch might help.
> 
> How complicated are your test scripts?  Could you send them to me so I can
> try too?
> 
> Thanks,
> NeilBrown
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 888dbdfb6986..6a9c73435eb8 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -856,6 +856,7 @@ static void raise_barrier(struct r1conf *conf, sector_t sector_nr)
> 			     conf->next_resync + RESYNC_SECTORS),
> 			    conf->resync_lock);
> 
> +	conf->nr_pending++;
> 	spin_unlock_irq(&conf->resync_lock);
> }
> 
> @@ -865,6 +866,7 @@ static void lower_barrier(struct r1conf *conf)
> 	BUG_ON(conf->barrier <= 0);
> 	spin_lock_irqsave(&conf->resync_lock, flags);
> 	conf->barrier--;
> +	conf->nr_pending--;
> 	spin_unlock_irqrestore(&conf->resync_lock, flags);
> 	wake_up(&conf->wait_barrier);
> }

No luck, it is failing faster than before.

I haven't looked into this myself, but the dm-raid1.c code makes use of dm-region-hash.c which coordinates recovery and nominal I/O in a way that allows them to both occur in a simple, non-overlapping way.  I'm not sure it would make sense to use that instead of this new approach.  I have no idea how much effort that would be, but I could have someone look into it at some point if you think it might be interesting.

 brassow

[-rc5 kernel with previous 5 patches, plus the one above]
Sep 15 16:52:35 bp-01 kernel: INFO: task kworker/u129:2:21621 blocked for more than 120 seconds.
Sep 15 16:52:35 bp-01 kernel:      Tainted: G            E  3.17.0-rc5 #1
Sep 15 16:52:35 bp-01 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep 15 16:52:35 bp-01 kernel: kworker/u129:2  D 0000000000000001     0 21621      2 0x00000080
Sep 15 16:52:35 bp-01 kernel: Workqueue: writeback bdi_writeback_workfn (flush-253:11)
Sep 15 16:52:35 bp-01 kernel: ffff8802040538c8 0000000000000046 0000000000000000 ffff880217254150
Sep 15 16:52:35 bp-01 kernel: ffff880204050010 0000000000012bc0 0000000000012bc0 ffff8802173c2490
Sep 15 16:52:35 bp-01 kernel: ffff880204053898 ffff88021fa32bc0 ffff8802173c2490 ffffffff81580a60
Sep 15 16:52:35 bp-01 kernel: Call Trace:
Sep 15 16:52:35 bp-01 kernel: [<ffffffff81580a60>] ? yield_to+0x180/0x180
Sep 15 16:52:36 bp-01 kernel: [<ffffffff81580779>] schedule+0x29/0x70
Sep 15 16:52:36 bp-01 kernel: [<ffffffff8158084c>] io_schedule+0x8c/0xd0
Sep 15 16:52:36 bp-01 kernel: [<ffffffff81580a8c>] bit_wait_io+0x2c/0x50
Sep 15 16:52:36 bp-01 kernel: [<ffffffff81580d75>] __wait_on_bit+0x65/0x90
Sep 15 16:52:36 bp-01 kernel: [<ffffffff811350a4>] wait_on_page_bit+0xc4/0xd0
Sep 15 16:52:36 bp-01 kernel: [<ffffffff8108eb00>] ? wake_atomic_t_function+0x40/0x40
Sep 15 16:52:36 bp-01 kernel: [<ffffffff8114126a>] write_cache_pages+0x33a/0x510
Sep 15 16:52:36 bp-01 kernel: [<ffffffff8113fda0>] ? set_page_dirty+0x60/0x60
Sep 15 16:52:36 bp-01 kernel: [<ffffffff81141491>] generic_writepages+0x51/0x80
Sep 15 16:52:36 bp-01 kernel: [<ffffffff811414f5>] do_writepages+0x35/0x40
Sep 15 16:52:36 bp-01 kernel: [<ffffffff811bfbe9>] __writeback_single_inode+0x49/0x230
Sep 15 16:52:36 bp-01 kernel: [<ffffffff811c3029>] writeback_sb_inodes+0x249/0x360
Sep 15 16:52:36 bp-01 kernel: [<ffffffff811c3309>] wb_writeback+0xf9/0x2c0
Sep 15 16:52:36 bp-01 kernel: [<ffffffff811c3552>] wb_do_writeback+0x82/0x1f0
Sep 15 16:52:36 bp-01 kernel: [<ffffffff810790c6>] ? ttwu_queue+0x136/0x150
Sep 15 16:52:36 bp-01 kernel: [<ffffffff811c3730>] bdi_writeback_workfn+0x70/0x210
Sep 15 16:52:36 bp-01 kernel: [<ffffffff8106b5fe>] process_one_work+0x14e/0x430
Sep 15 16:52:36 bp-01 kernel: [<ffffffff8106b9ff>] worker_thread+0x11f/0x3c0
Sep 15 16:52:36 bp-01 kernel: [<ffffffff8106b8e0>] ? process_one_work+0x430/0x430
Sep 15 16:52:36 bp-01 kernel: [<ffffffff810707de>] kthread+0xce/0xf0
Sep 15 16:52:36 bp-01 kernel: [<ffffffff81070710>] ? kthread_freezable_should_stop+0x70/0x70
Sep 15 16:52:36 bp-01 kernel: [<ffffffff8158432c>] ret_from_fork+0x7c/0xb0
Sep 15 16:52:36 bp-01 kernel: [<ffffffff81070710>] ? kthread_freezable_should_stop+0x70/0x70
Sep 15 16:52:36 bp-01 kernel: INFO: task kjournald:26375 blocked for more than 120 seconds.
Sep 15 16:52:36 bp-01 kernel:      Tainted: G            E  3.17.0-rc5 #1
Sep 15 16:52:36 bp-01 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep 15 16:52:36 bp-01 kernel: kjournald       D 0000000000000004     0 26375      2 0x00000080
Sep 15 16:52:36 bp-01 kernel: ffff8804019dfb98 0000000000000046 000000000000003c ffff88021726cf40
Sep 15 16:52:36 bp-01 kernel: ffff8804019dc010 0000000000012bc0 0000000000012bc0 ffff880415632f00
Sep 15 16:52:36 bp-01 kernel: ffff8804019dfb68 ffff88021fa92bc0 ffff880415632f00 ffff8804019dfc50
Sep 15 16:52:36 bp-01 kernel: Call Trace:
Sep 15 16:52:36 bp-01 kernel: [<ffffffff81580a60>] ? yield_to+0x180/0x180
Sep 15 16:52:36 bp-01 kernel: [<ffffffff81580779>] schedule+0x29/0x70
Sep 15 16:52:36 bp-01 kernel: [<ffffffff8158084c>] io_schedule+0x8c/0xd0
Sep 15 16:52:36 bp-01 kernel: [<ffffffff81580a8c>] bit_wait_io+0x2c/0x50
Sep 15 16:52:36 bp-01 kernel: [<ffffffff81580b76>] __wait_on_bit_lock+0x76/0xb0
Sep 15 16:52:36 bp-01 kernel: [<ffffffff81580a60>] ? yield_to+0x180/0x180
Sep 15 16:52:36 bp-01 kernel: [<ffffffff81580c28>] out_of_line_wait_on_bit_lock+0x78/0x90
Sep 15 16:52:36 bp-01 kernel: [<ffffffff8108eb00>] ? wake_atomic_t_function+0x40/0x40
Sep 15 16:52:36 bp-01 kernel: [<ffffffff811ca27e>] __lock_buffer+0x2e/0x30
Sep 15 16:52:36 bp-01 kernel: [<ffffffffa042eac0>] journal_submit_data_buffers+0x2b0/0x2f0 [jbd]
Sep 15 16:52:36 bp-01 kernel: [<ffffffffa042eda6>] journal_commit_transaction+0x2a6/0xf80 [jbd]
Sep 15 16:52:36 bp-01 kernel: [<ffffffff8108841f>] ? put_prev_entity+0x2f/0x400
Sep 15 16:52:36 bp-01 kernel: [<ffffffff810b211b>] ? try_to_del_timer_sync+0x5b/0x70
Sep 15 16:52:36 bp-01 kernel: [<ffffffffa0432ae1>] kjournald+0xf1/0x270 [jbd]
Sep 15 16:52:36 bp-01 kernel: [<ffffffff8108ea70>] ? bit_waitqueue+0xb0/0xb0
Sep 15 16:52:36 bp-01 kernel: [<ffffffffa04329f0>] ? commit_timeout+0x10/0x10 [jbd]
Sep 15 16:52:36 bp-01 kernel: [<ffffffff810707de>] kthread+0xce/0xf0
Sep 15 16:52:36 bp-01 kernel: [<ffffffff81070710>] ? kthread_freezable_should_stop+0x70/0x70
Sep 15 16:52:36 bp-01 kernel: [<ffffffff8158432c>] ret_from_fork+0x7c/0xb0
Sep 15 16:52:36 bp-01 kernel: [<ffffffff81070710>] ? kthread_freezable_should_stop+0x70/0x70



