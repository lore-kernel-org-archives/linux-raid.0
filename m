From: Shaohua Li <shli@kernel.org>
Subject: Re: raid5 using group_thread
Date: Thu, 20 Jul 2017 09:43:59 -0700
Message-ID: <20170720164359.mdzff366mk25ff6s@kernel.org>
References: <1e734cb651e844b0bd3bc76eec9f16c9@IL-EXCH01.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1e734cb651e844b0bd3bc76eec9f16c9@IL-EXCH01.marvell.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ofer Heifetz <oferh@marvell.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jul 20, 2017 at 07:21:36AM +0000, Ofer Heifetz wrote:
> > Hi Li,
> > > ----------------------------------------------------------------------
> > > On Wed, Jul 19, 2017 at 01:00:45PM +0000, Ofer Heifetz wrote:
> > > > Hi,
> > > >
> > > > I have a question regarding raid5 built using group_thread and
> > > > async_tx, from code (v4.4 and even v4.12) I see that only raid5d invokes
> > > async_tx_issue_pending_all, shouldn't the raid5_do_work also invoke this
> > > API to issue all pending requests to HW?
> > > >
> > > > I am assuming that there is no sync mechanism between the raid5d and the
> > > raid5_do_work, correct me if I am wrong.
> > > 
> > > Can't remember why we don't call async_tx_issue_pending_all in
> > > raid5_do_work, it shouldn't harm. In practice, I doubt calling it makes a
> > > change, because when workers are running, raid5d are running too. Did you
> > > benchmark it?
> >
> > I had a jbd2 hung issue on my system and started to debug it, I noticed that in the cases it was stuck, It had pending requests in the async_xor engine waiting to be
> > issued, so basically requests were sitting in the HW ring and engine was unaware of their existence, this caused the following:
> > [ 1320.280225] INFO: task jbd2/md0-8:1755 blocked for more than 120 seconds.
> > [ 1320.287056]       Not tainted 4.4.52-gdbc4936-dirty #45
> > [ 1320.294054] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [ 1320.301922] jbd2/md0-8      D ffffffc000086cc0     0  1755      2 0x00000000
> > [ 1320.309037] Call trace:
> > [ 1320.311502] [<ffffffc000086cc0>] __switch_to+0x88/0xa0
> > [ 1320.316677] [<ffffffc0008c55d0>] __schedule+0x190/0x5d8
> > [ 1320.321935] [<ffffffc0008c5a5c>] schedule+0x44/0xb8
> > [ 1320.326842] [<ffffffc00026f194>] jbd2_journal_commit_transaction+0x174/0x13e0
> > [ 1320.334018] [<ffffffc00027378c>] kjournald2+0xc4/0x248
> > [ 1320.339185] [<ffffffc0000d2bac>] kthread+0xdc/0xf0
> > [ 1320.344006] [<ffffffc000085dd0>] ret_from_fork+0x10/0x40
> > [ 1320.349349] INFO: task ext4lazyinit:1757 blocked for more than 120 seconds.
> > [ 1320.356350]       Not tainted 4.4.52-gdbc4936-dirty #45
> > [ 1320.363347] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [ 1320.371214] ext4lazyinit    D ffffffc000086cc0     0  1757      2 0x00000000
> > [ 1320.378328] Call trace:
> > [ 1320.380793] [<ffffffc000086cc0>] __switch_to+0x88/0xa0
> > [ 1320.385964] [<ffffffc0008c55d0>] __schedule+0x190/0x5d8
> > [ 1320.391218] [<ffffffc0008c5a5c>] schedule+0x44/0xb8
> > [ 1320.396126] [<ffffffc0008c86f4>] schedule_timeout+0x15c/0x1b0
> > [ 1320.401904] [<ffffffc0008c53c8>] io_schedule_timeout+0xb0/0x128
> > [ 1320.407861] [<ffffffc0008c63e0>] bit_wait_io+0x18/0x70
> > [ 1320.413033] [<ffffffc0008c6288>] __wait_on_bit_lock+0x80/0xf0
> > [ 1320.418810] [<ffffffc0008c6354>] out_of_line_wait_on_bit_lock+0x5c/0x68
> > [ 1320.425465] [<ffffffc0001da528>] __lock_buffer+0x38/0x48
> > [ 1320.430809] [<ffffffc00026d254>] do_get_write_access+0x26c/0x540
> > [ 1320.436848] [<ffffffc00026d568>] jbd2_journal_get_write_access+0x40/0x88
> > [ 1320.443593] [<ffffffc00024c0bc>] __ext4_journal_get_write_access+0x34/0x88
> > [ 1320.450511] [<ffffffc0002279d0>] ext4_init_inode_table+0x118/0x3c0
> > [ 1320.456728] [<ffffffc000239a04>] ext4_lazyinit_thread+0x1ec/0x2b8
> > [ 1320.462866] [<ffffffc0000d2bac>] kthread+0xdc/0xf0
> > [ 1320.467691] [<ffffffc000085dd0>] ret_from_fork+0x10/0x40
> > 
> >Then I went to the raid5 code and noticed that only raid5d performs the async_tx_issue_pending which seems strange, for it to work right it must be the last one calling r5l_flush_stripe_to_raid 
> >thus waiting for the workers to finish their r5l_flush_stripe_to_raid calls, based on the code there is no such sync point between the raid5d and raid5_do_work.
> >
> >I can test the performance impact but with the current code I get hung task which basically forces me to disable group_thread_cnt.

does adding async_tx_issue_pending fix the issue? if yes, could you please
submit a patch and I will merge it. I don't have a machine with async offload
hardware.

Thanks,
Shaohua
