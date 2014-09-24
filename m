From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH 0/5] Fixes for RAID1 resync
Date: Tue, 23 Sep 2014 23:25:12 -0500
Message-ID: <398DA7BB-7BED-49E0-8178-0CA4384E8A84@redhat.com>
References: <20140910062039.26400.36745.stgit@notabene.brown> <D96E0116-919C-4F4B-B4B6-2564B99449FB@redhat.com> <8697EC47-F648-4E66-B37C-4A2DC3030696@redhat.com> <20140915133006.14e57085@notabene.brown> <2C41CCF8-8B5C-486F-AE43-42D10EBAA0A5@redhat.com> <20140918174846.6a445eaf@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140918174846.6a445eaf@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Eivind Sarto <eivindsarto@gmail.com>, linux-raid@vger.kernel.org, majianpeng <majianpeng@gmail.com>
List-Id: linux-raid.ids


On Sep 18, 2014, at 2:48 AM, NeilBrown wrote:

> On Tue, 16 Sep 2014 11:31:26 -0500 Brassow Jonathan <jbrassow@redhat.com>
> wrote:
> 
>> 
>> On Sep 14, 2014, at 10:30 PM, NeilBrown wrote:
>> 
>>> On Thu, 11 Sep 2014 12:12:01 -0500 Brassow Jonathan <jbrassow@redhat.com>
>>> wrote:
>>> 
>>>> 
>>>> On Sep 10, 2014, at 10:45 PM, Brassow Jonathan wrote:
>>>> 
>>>>> 
>>>>> On Sep 10, 2014, at 1:20 AM, NeilBrown wrote:
>>>>> 
>>>>>> 
>>>>>> Jon: could you test with these patches on top of what you
>>>>>> have just in case something happens to fix the problem without
>>>>>> me realising it?
>>>>> 
>>>>> I'm on it.  The test is running.  I'll know later tomorrow.
>>>>> 
>>>>> brassow
>>>> 
>>>> The test is still failing from here.  I grabbed 3.17.0-rc4, added the 5 patches, and got the attached backtraces when testing.  As I said, the hangs are not exactly the same.  This set shows the mdX_raid1 thread in the middle of handling a read failure.
>>> 
>>> Thanks.
>>> mdX_raid1 is blocked in freeze_array.
>>> That could be caused by conf->nr_pending nor aligning properly with
>>> conf->nr_queued.
>>> 
>>> Both normal IO and resync IO can be retried with reschedule_retry()
>>> and so be counted into ->nr_queued, but only normal IO gets counted in
>>> ->nr_pending.
>>> 
>>> Previously could could only possibly have on or the other and when handling
>>> a read failure it could only be normal IO.  But now that they two types can
>>> interleave, we can have both normal and resync IO requests queued, so we need
>>> to count them both in nr_pending.
>>> 
>>> So the following patch might help.
>>> 
>>> How complicated are your test scripts?  Could you send them to me so I can
>>> try too?
>>> 
>>> Thanks,
>>> NeilBrown
>>> 
>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>> index 888dbdfb6986..6a9c73435eb8 100644
>>> --- a/drivers/md/raid1.c
>>> +++ b/drivers/md/raid1.c
>>> @@ -856,6 +856,7 @@ static void raise_barrier(struct r1conf *conf, sector_t sector_nr)
>>> 			     conf->next_resync + RESYNC_SECTORS),
>>> 			    conf->resync_lock);
>>> 
>>> +	conf->nr_pending++;
>>> 	spin_unlock_irq(&conf->resync_lock);
>>> }
>>> 
>>> @@ -865,6 +866,7 @@ static void lower_barrier(struct r1conf *conf)
>>> 	BUG_ON(conf->barrier <= 0);
>>> 	spin_lock_irqsave(&conf->resync_lock, flags);
>>> 	conf->barrier--;
>>> +	conf->nr_pending--;
>>> 	spin_unlock_irqrestore(&conf->resync_lock, flags);
>>> 	wake_up(&conf->wait_barrier);
>>> }
>> 
>> No luck, it is failing faster than before.
>> 
>> I haven't looked into this myself, but the dm-raid1.c code makes use of dm-region-hash.c which coordinates recovery and nominal I/O in a way that allows them to both occur in a simple, non-overlapping way.  I'm not sure it would make sense to use that instead of this new approach.  I have no idea how much effort that would be, but I could have someone look into it at some point if you think it might be interesting.
>> 
> 
> Hi Jon,
> I can see the appeal of using known-working code, but there is every chance
> that we would break it when plugging it into md ;-)
> 
> I've found another bug.... it is a very subtle one and it has been around
> since before the patch you bisected to so it probably isn't your bug.
> It also only affects array with bad-blocks listed.  The patch is below
> but I very much doubt testing will show any change...
> 
> I'll keep looking..... oh, found one.  This one looks more convincing.
> If memory is short, make_request() will allocate an r1bio from the mempool
> rather than from the slab.  That r1bio won't have just been zeroed.
> This is mostly OK as we initialise all the fields that aren't left in
> a clean state ... except ->start_next_window.
> We initialise that for write requests, but not for read.
> So when we use a mempool-allocated r1bio that was previously used for
> write and had ->start_next_window set, and is now used for read,
> then things will go wrong.
> So this patch definitely is worth testing.
> Thanks for your continued patience in testing!!!
> 
> 
> Thanks,
> NeilBrown
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index a95f9e179e6f..7187d9b8431f 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1185,6 +1185,7 @@ read_again:
> 				   atomic_read(&bitmap->behind_writes) == 0);
> 		}
> 		r1_bio->read_disk = rdisk;
> +		r1_bio->start_next_window = 0;
> 
> 		read_bio = bio_clone_mddev(bio, GFP_NOIO, mddev);
> 		bio_trim(read_bio, r1_bio->sector - bio->bi_iter.bi_sector,
> @@ -1444,6 +1445,7 @@ read_again:
> 		r1_bio->state = 0;
> 		r1_bio->mddev = mddev;
> 		r1_bio->sector = bio->bi_iter.bi_sector + sectors_handled;
> +		start_next_window = wait_barrier(conf, bio);
> 		goto retry_write;
> 	}


Sorry, still not there yet.

I'm sorry I haven't had more time to spend on this.  I'll try to get some help (perhaps from Heinz) and see if we can pitch-in instead of making you do all the work.

 brassow

Sep 23 05:01:39 bp-01 kernel: INFO: task kworker/u129:2:19096 blocked for more than 120 seconds.
Sep 23 05:01:39 bp-01 kernel:      Tainted: G            E  3.17.0-rc6 #1
Sep 23 05:01:39 bp-01 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep 23 05:01:39 bp-01 kernel: kworker/u129:2  D 0000000000000002     0 19096      2 0x00000080
Sep 23 05:01:39 bp-01 kernel: Workqueue: writeback bdi_writeback_workfn (flush-253:29)
Sep 23 05:01:39 bp-01 kernel: ffff8802079138c8 0000000000000046 ffffea0006f7b738 ffff880217260f00
Sep 23 05:01:39 bp-01 kernel: ffff880207910010 0000000000012bc0 0000000000012bc0 ffff880216aca0d0
Sep 23 05:01:39 bp-01 kernel: ffff880207913898 ffff88021fa52bc0 ffff880216aca0d0 ffff880207913980
Sep 23 05:01:39 bp-01 kernel: Call Trace:
Sep 23 05:01:39 bp-01 kernel: [<ffffffff81580ac0>] ? yield_to+0x180/0x180
Sep 23 05:01:39 bp-01 kernel: [<ffffffff815807d9>] schedule+0x29/0x70
Sep 23 05:01:39 bp-01 kernel: [<ffffffff815808ac>] io_schedule+0x8c/0xd0
Sep 23 05:01:39 bp-01 kernel: [<ffffffff81580aec>] bit_wait_io+0x2c/0x50
Sep 23 05:01:39 bp-01 kernel: [<ffffffff81580bd6>] __wait_on_bit_lock+0x76/0xb0
Sep 23 05:01:39 bp-01 kernel: [<ffffffff811cd006>] ? block_write_full_page+0xc6/0x100
Sep 23 05:01:39 bp-01 kernel: [<ffffffff81134cd8>] __lock_page+0xa8/0xb0
Sep 23 05:01:39 bp-01 kernel: [<ffffffff8108eb30>] ? wake_atomic_t_function+0x40/0x40
Sep 23 05:01:39 bp-01 kernel: [<ffffffff81141258>] write_cache_pages+0x318/0x510
Sep 23 05:01:39 bp-01 kernel: [<ffffffff8113fdb0>] ? set_page_dirty+0x60/0x60
Sep 23 05:01:39 bp-01 kernel: [<ffffffff811414a1>] generic_writepages+0x51/0x80
Sep 23 05:01:39 bp-01 kernel: [<ffffffff81141505>] do_writepages+0x35/0x40
Sep 23 05:01:39 bp-01 kernel: [<ffffffff811bfbe9>] __writeback_single_inode+0x49/0x230
Sep 23 05:01:39 bp-01 kernel: [<ffffffff811c3029>] writeback_sb_inodes+0x249/0x360
Sep 23 05:01:39 bp-01 kernel: [<ffffffff811c3309>] wb_writeback+0xf9/0x2c0
Sep 23 05:01:39 bp-01 kernel: [<ffffffff811c3552>] wb_do_writeback+0x82/0x1f0
Sep 23 05:01:39 bp-01 kernel: [<ffffffff811c3730>] bdi_writeback_workfn+0x70/0x210
Sep 23 05:01:39 bp-01 kernel: [<ffffffff8106b62e>] process_one_work+0x14e/0x430
Sep 23 05:01:39 bp-01 kernel: [<ffffffff8106ba2f>] worker_thread+0x11f/0x3c0
Sep 23 05:01:39 bp-01 kernel: [<ffffffff8106b910>] ? process_one_work+0x430/0x430
Sep 23 05:01:39 bp-01 kernel: [<ffffffff8107080e>] kthread+0xce/0xf0
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81070740>] ? kthread_freezable_should_stop+0x70/0x70
Sep 23 05:01:40 bp-01 kernel: [<ffffffff815843ac>] ret_from_fork+0x7c/0xb0
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81070740>] ? kthread_freezable_should_stop+0x70/0x70
Sep 23 05:01:40 bp-01 kernel: INFO: task kjournald:21626 blocked for more than 120 seconds.
Sep 23 05:01:40 bp-01 kernel:      Tainted: G            E  3.17.0-rc6 #1
Sep 23 05:01:40 bp-01 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep 23 05:01:40 bp-01 kernel: kjournald       D 0000000000000002     0 21626      2 0x00000080
Sep 23 05:01:40 bp-01 kernel: ffff8802024bbc08 0000000000000046 ffff8802024bbbd8 ffff880217260f00
Sep 23 05:01:40 bp-01 kernel: ffff8802024b8010 0000000000012bc0 0000000000012bc0 ffff880214de9240
Sep 23 05:01:40 bp-01 kernel: ffff8802024bbc08 ffff88021fa52bc0 ffff880214de9240 ffffffff81580ac0
Sep 23 05:01:40 bp-01 kernel: Call Trace:
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81580ac0>] ? yield_to+0x180/0x180
Sep 23 05:01:40 bp-01 kernel: [<ffffffff815807d9>] schedule+0x29/0x70
Sep 23 05:01:40 bp-01 kernel: [<ffffffff815808ac>] io_schedule+0x8c/0xd0
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81580aec>] bit_wait_io+0x2c/0x50
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81580dd5>] __wait_on_bit+0x65/0x90
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81580ac0>] ? yield_to+0x180/0x180
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81580e78>] out_of_line_wait_on_bit+0x78/0x90
Sep 23 05:01:40 bp-01 kernel: [<ffffffff8108eb30>] ? wake_atomic_t_function+0x40/0x40
Sep 23 05:01:40 bp-01 kernel: [<ffffffff811ca05e>] __wait_on_buffer+0x2e/0x30
Sep 23 05:01:40 bp-01 kernel: [<ffffffffa03f9372>] journal_commit_transaction+0x872/0xf80 [jbd]
Sep 23 05:01:40 bp-01 kernel: [<ffffffff8108844f>] ? put_prev_entity+0x2f/0x400
Sep 23 05:01:40 bp-01 kernel: [<ffffffff8108eaa0>] ? bit_waitqueue+0xb0/0xb0
Sep 23 05:01:40 bp-01 kernel: [<ffffffffa03fcae1>] kjournald+0xf1/0x270 [jbd]
Sep 23 05:01:40 bp-01 kernel: [<ffffffff8108eaa0>] ? bit_waitqueue+0xb0/0xb0
Sep 23 05:01:40 bp-01 kernel: [<ffffffffa03fc9f0>] ? commit_timeout+0x10/0x10 [jbd]
Sep 23 05:01:40 bp-01 kernel: [<ffffffff8107080e>] kthread+0xce/0xf0
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81070740>] ? kthread_freezable_should_stop+0x70/0x70
Sep 23 05:01:40 bp-01 kernel: [<ffffffff815843ac>] ret_from_fork+0x7c/0xb0
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81070740>] ? kthread_freezable_should_stop+0x70/0x70
Sep 23 05:01:40 bp-01 kernel: INFO: task xdoio:21891 blocked for more than 120 seconds.
Sep 23 05:01:40 bp-01 kernel:      Tainted: G            E  3.17.0-rc6 #1
Sep 23 05:01:40 bp-01 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep 23 05:01:40 bp-01 kernel: xdoio           D 0000000000000001     0 21891  21890 0x00000080
Sep 23 05:01:40 bp-01 kernel: ffff880405d8f978 0000000000000082 ffff880414ec0c00 ffff880217254150
Sep 23 05:01:40 bp-01 kernel: ffff880405d8c010 0000000000012bc0 0000000000012bc0 ffff8803e7be9080
Sep 23 05:01:40 bp-01 kernel: ffff880405d8f958 ffff88021fa32bc0 ffff8803e7be9080 ffffffff81580ac0
Sep 23 05:01:40 bp-01 kernel: Call Trace:
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81580ac0>] ? yield_to+0x180/0x180
Sep 23 05:01:40 bp-01 kernel: [<ffffffff815807d9>] schedule+0x29/0x70
Sep 23 05:01:40 bp-01 kernel: [<ffffffff815808ac>] io_schedule+0x8c/0xd0
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81580aec>] bit_wait_io+0x2c/0x50
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81580dd5>] __wait_on_bit+0x65/0x90
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81580ac0>] ? yield_to+0x180/0x180
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81580e78>] out_of_line_wait_on_bit+0x78/0x90
Sep 23 05:01:40 bp-01 kernel: [<ffffffff8108eb30>] ? wake_atomic_t_function+0x40/0x40
Sep 23 05:01:40 bp-01 kernel: [<ffffffff811ca05e>] __wait_on_buffer+0x2e/0x30
Sep 23 05:01:40 bp-01 kernel: [<ffffffff811cb440>] __sync_dirty_buffer+0xb0/0xd0
Sep 23 05:01:40 bp-01 kernel: [<ffffffff811cb473>] sync_dirty_buffer+0x13/0x20
Sep 23 05:01:40 bp-01 kernel: [<ffffffffa03f7e12>] journal_dirty_data+0x1f2/0x260 [jbd]
Sep 23 05:01:40 bp-01 kernel: [<ffffffffa0415200>] ext3_journal_dirty_data+0x20/0x50 [ext3]
Sep 23 05:01:40 bp-01 kernel: [<ffffffffa0415255>] journal_dirty_data_fn+0x25/0x30 [ext3]
Sep 23 05:01:40 bp-01 kernel: [<ffffffffa04148d4>] walk_page_buffers+0x84/0xc0 [ext3]
Sep 23 05:01:40 bp-01 kernel: [<ffffffffa0415230>] ? ext3_journal_dirty_data+0x50/0x50 [ext3]
Sep 23 05:01:40 bp-01 kernel: [<ffffffffa041897f>] ext3_ordered_write_end+0xaf/0x1e0 [ext3]
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81134742>] generic_perform_write+0x112/0x1c0
Sep 23 05:01:40 bp-01 kernel: [<ffffffff8113789f>] __generic_file_write_iter+0x18f/0x390
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81137aee>] generic_file_write_iter+0x4e/0xd0
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81197187>] do_iter_readv_writev+0x77/0xb0
Sep 23 05:01:40 bp-01 kernel: [<ffffffff8122e343>] ? security_file_permission+0x23/0x90
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81137aa0>] ? __generic_file_write_iter+0x390/0x390
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81137aa0>] ? __generic_file_write_iter+0x390/0x390
Sep 23 05:01:40 bp-01 kernel: [<ffffffff811988a0>] do_readv_writev+0xd0/0x320
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81137aa0>] ? __generic_file_write_iter+0x390/0x390
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81197240>] ? do_sync_readv_writev+0x80/0x80
Sep 23 05:01:40 bp-01 kernel: [<ffffffff810c722f>] ? do_futex+0xaf/0x1b0
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81198b31>] vfs_writev+0x41/0x50
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81198c66>] SyS_writev+0x56/0xf0
Sep 23 05:01:40 bp-01 kernel: [<ffffffff810ec466>] ? __audit_syscall_exit+0x216/0x2c0
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81584452>] system_call_fastpath+0x16/0x1b
Sep 23 05:01:40 bp-01 kernel: INFO: task sync:21916 blocked for more than 120 seconds.
Sep 23 05:01:40 bp-01 kernel:      Tainted: G            E  3.17.0-rc6 #1
Sep 23 05:01:40 bp-01 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep 23 05:01:40 bp-01 kernel: sync            D 0000000000000001     0 21916  21915 0x00000080
Sep 23 05:01:40 bp-01 kernel: ffff88020902bd68 0000000000000086 ffff88020902bd28 ffff880217254150
Sep 23 05:01:40 bp-01 kernel: ffff880209028010 0000000000012bc0 0000000000012bc0 ffff880216c36dc0
Sep 23 05:01:40 bp-01 kernel: ffff88020902bda8 ffff88020902bec8 ffff88020902bed0 7fffffffffffffff
Sep 23 05:01:40 bp-01 kernel: Call Trace:
Sep 23 05:01:40 bp-01 kernel: [<ffffffff815807d9>] schedule+0x29/0x70
Sep 23 05:01:40 bp-01 kernel: [<ffffffff815832ed>] schedule_timeout+0x13d/0x1d0
Sep 23 05:01:40 bp-01 kernel: [<ffffffff8106af82>] ? __queue_delayed_work+0xb2/0x1a0
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81581756>] wait_for_completion+0xc6/0x100
Sep 23 05:01:40 bp-01 kernel: [<ffffffff8107e3a0>] ? try_to_wake_up+0x220/0x220
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81583c3b>] ? _raw_spin_unlock_bh+0x1b/0x20
Sep 23 05:01:40 bp-01 kernel: [<ffffffff811c74b0>] ? fdatawrite_one_bdev+0x20/0x20
Sep 23 05:01:40 bp-01 kernel: [<ffffffff811c058d>] sync_inodes_sb+0x9d/0xd0
Sep 23 05:01:40 bp-01 kernel: [<ffffffff811c74cd>] sync_inodes_one_sb+0x1d/0x30
Sep 23 05:01:40 bp-01 kernel: [<ffffffff8119aab3>] iterate_supers+0xb3/0xe0
Sep 23 05:01:40 bp-01 kernel: [<ffffffff811c7515>] sys_sync+0x35/0x90
Sep 23 05:01:40 bp-01 kernel: [<ffffffff81584452>] system_call_fastpath+0x16/0x1b