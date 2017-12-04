From: Shaohua Li <shli@kernel.org>
Subject: Re: Calling block ops when !TASK_RUNNING warning in raid1
Date: Mon, 4 Dec 2017 14:31:36 -0800
Message-ID: <20171204223136.zezzu27ilgmu4log@kernel.org>
References: <CAKTMprOTWf04=433GAhpUYs_UXsw1qgiqpRCRs9zEU0K-GP8Hw@mail.gmail.com>
 <20171128175222.zntgvtxaa4kzbtlw@kernel.org>
 <87y3movcqp.fsf@notabene.neil.brown.name>
 <840098d9-8e39-22b3-f903-bf046ab92b86@suse.com>
 <87vahsv1cx.fsf@notabene.neil.brown.name>
 <20171201201009.4lqx3ktwyxgxyaos@kernel.org>
 <87vahntsn3.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87vahntsn3.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Guoqing Jiang <gqjiang@suse.com>, Dennis Yang <shinrairis@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Dec 04, 2017 at 08:21:04AM +1100, Neil Brown wrote:
> On Fri, Dec 01 2017, Shaohua Li wrote:
> 
> > On Thu, Nov 30, 2017 at 03:26:06PM +1100, Neil Brown wrote:
> >> On Thu, Nov 30 2017, Guoqing Jiang wrote:
> >> 
> >> > On 11/30/2017 08:20 AM, NeilBrown wrote:
> >> >> On Tue, Nov 28 2017, Shaohua Li wrote:
> >> >>
> >> >>> On Tue, Nov 28, 2017 at 04:51:25PM +0800, Dennis Yang wrote:
> >> >>>> Hi,
> >> >>>>
> >> >>>> We recently see the following kernel dump on raid1 with some kernel
> >> >>>> debug option on.
> >> >>>>
> >> >>>> <4>[   40.501369] ------------[ cut here ]------------
> >> >>>> <4>[   40.501375] WARNING: CPU: 7 PID: 7477 at
> >> >>>> kernel/sched/core.c:7404 __might_sleep+0xa2/0xb0()
> >> >>>> <4>[   40.501378] do not call blocking ops when !TASK_RUNNING; state=2
> >> >>>> set at [<ffffffff810c28d8>] prepare_to_wait_event+0x58/0x100
> >> >>>> <4>[   40.501379] Modules linked in: dm_c2f(O) pl2303 usbserial
> >> >>>> qm2_i2c(O) intel_ips drbd(O) flashcache(O) dm_tier_hro_algo
> >> >>>> dm_thin_pool dm_bio_prison dm_persistent_data hal_netlink(O) k10temp
> >> >>>> coretemp mlx4_en(O) mlx4_core(O) mlx_compat(O) igb e1000e(O)
> >> >>>> mpt3sas(O) mpt2sas scsi_transport_sas raid_class usb_storage xhci_pci
> >> >>>> xhci_hcd usblp uhci_hcd ehci_pci ehci_hcd
> >> >>>> <4>[   40.501395] CPU: 7 PID: 7477 Comm: md321_resync Tainted: G
> >> >>>>      O    4.2.8 #1
> >> >>>> <4>[   40.501396] Hardware name: INSYDE QV96/Type2 - Board Product
> >> >>>> Name1, BIOS QV96IR23 10/21/2015
> >> >>>> <4>[   40.501397]  ffffffff8219aff7 ffff880092f7b868 ffffffff81c86c4b
> >> >>>> ffffffff810dfb59
> >> >>>> <4>[   40.501399]  ffff880092f7b8b8 ffff880092f7b8a8 ffffffff81079fa5
> >> >>>> ffff880092f7b8e8
> >> >>>> <4>[   40.501401]  ffffffff821a4f6d 0000000000000140 0000000000000000
> >> >>>> 0000000000000001
> >> >>>> <4>[   40.501403] Call Trace:
> >> >>>> <4>[   40.501407]  [<ffffffff81c86c4b>] dump_stack+0x4c/0x65
> >> >>>> <4>[   40.501409]  [<ffffffff810dfb59>] ? console_unlock+0x279/0x4f0
> >> >>>> <4>[   40.501411]  [<ffffffff81079fa5>] warn_slowpath_common+0x85/0xc0
> >> >>>> <4>[   40.501412]  [<ffffffff8107a021>] warn_slowpath_fmt+0x41/0x50
> >> >>>> <4>[   40.501414]  [<ffffffff810c28d8>] ? prepare_to_wait_event+0x58/0x100
> >> >>>> <4>[   40.501415]  [<ffffffff810c28d8>] ? prepare_to_wait_event+0x58/0x100
> >> >>>> <4>[   40.501416]  [<ffffffff810a4f72>] __might_sleep+0xa2/0xb0
> >> >>>> <4>[   40.501419]  [<ffffffff8117bb7c>] mempool_alloc+0x7c/0x150
> >> >>>> <4>[   40.501422]  [<ffffffff8101442a>] ? save_stack_trace+0x2a/0x50
> >> >>>> <4>[   40.501425]  [<ffffffff8145b589>] bio_alloc_bioset+0xb9/0x260
> >> >>>> <4>[   40.501428]  [<ffffffff816cb6da>] bio_alloc_mddev+0x1a/0x30
> >> >>>> <4>[   40.501429]  [<ffffffff816d22a2>] md_super_write+0x32/0x90
> >> >>>> <4>[   40.501431]  [<ffffffff816db9b2>] write_page+0x2d2/0x480
> >> >>>> <4>[   40.501432]  [<ffffffff816db808>] ? write_page+0x128/0x480
> >> >>>> <4>[   40.501434]  [<ffffffff816a45cc>] ? flush_pending_writes+0x1c/0xe0
> >> >>>> <4>[   40.501435]  [<ffffffff816dc2a6>] bitmap_unplug+0x156/0x170
> >> >>>> <4>[   40.501437]  [<ffffffff810caa2d>] ? trace_hardirqs_on+0xd/0x10
> >> >>>> <4>[   40.501439]  [<ffffffff81c94b4b>] ? _raw_spin_unlock_irq+0x2b/0x40
> >> >>>> <4>[   40.501440]  [<ffffffff816a4613>] flush_pending_writes+0x63/0xe0
> >> >>>> <4>[   40.501442]  [<ffffffff816a4aff>] freeze_array+0x6f/0xc0
> >> >>>> <4>[   40.501443]  [<ffffffff810c27e0>] ? wait_woken+0xb0/0xb0
> >> >>>> <4>[   40.501444]  [<ffffffff816a4b8f>] raid1_quiesce+0x3f/0x50
> >> >>>> <4>[   40.501446]  [<ffffffff816d2254>] md_do_sync+0x1394/0x13b0
> >> >>>> <4>[   40.501447]  [<ffffffff816d1531>] ? md_do_sync+0x671/0x13b0
> >> >>>> <4>[   40.501449]  [<ffffffff810cb680>] ? __lock_acquire+0x990/0x23a0
> >> >>>> <4>[   40.501451]  [<ffffffff810bade7>] ? pick_next_task_fair+0x707/0xc30
> >> >>>> <4>[   40.501453]  [<ffffffff8108783c>] ? kernel_sigaction+0x2c/0xc0
> >> >>>> <4>[   40.501455]  [<ffffffff81c94b4b>] ? _raw_spin_unlock_irq+0x2b/0x40
> >> >>>> <4>[   40.501456]  [<ffffffff816cac80>] ? find_pers+0x80/0x80
> >> >>>> <4>[   40.501457]  [<ffffffff816cadbe>] md_thread+0x13e/0x150
> >> >>>> <4>[   40.501458]  [<ffffffff816cac80>] ? find_pers+0x80/0x80
> >> >>>> <4>[   40.501460]  [<ffffffff816cac80>] ? find_pers+0x80/0x80
> >> >>>> <4>[   40.501462]  [<ffffffff8109ded5>] kthread+0x105/0x120
> >> >>>> <4>[   40.501463]  [<ffffffff81c94b4b>] ? _raw_spin_unlock_irq+0x2b/0x40
> >> >>>> <4>[   40.501465]  [<ffffffff8109ddd0>] ? kthread_create_on_node+0x220/0x220
> >> >>>> <4>[   40.501467]  [<ffffffff81c956cf>] ret_from_fork+0x3f/0x70
> >> >>>> <4>[   40.501468]  [<ffffffff8109ddd0>] ? kthread_create_on_node+0x220/0x220
> >> >>>> <4>[   40.501469] ---[ end trace bd085fb137be2a87 ]---
> >> >>>>
> >> >>>> It looks like raid1_quiesce() creates a nested sleeping primitives by
> >> >>>> calling wait_event_lock_irq_cmd()
> >> >>>> first to change the state to TASK_UNINTERRUPTIBLE and
> >> >>>> flush_pending_writes() could eventually try
> >> >>>> to allocate bio for bitmap update with GFP_NOIO which might sleep and
> >> >>>> triggers this warning.
> >> >>>> I am not sure if this warning is just a false-positive or should we
> >> >>>> change the bio allocation
> >> >>>> gfp flag to GFP_NOWAIT to prevent it from blocking?
> >> >>> This is a legit warnning. Changing gfp to GFP_NOWAIT doesn't completely fix the
> >> >>> issue, because generic_make_request could sleep too. I think we should move the
> >> >>> work to a workqueue. Could you please try below patch (untested yet)?
> >> >> I think it would be simpler to call __set_current_state(TASK_RUNNING)
> >> >> in the 'then' branch of flush_pending_writes().
> >> >
> >> > There is no 'then' branch in this function, maybe you mean set 
> >> > TASK_RUNNING in the 'if' branch,
> >> > since the calltrace is triggered by flush_pending_writes -> 
> >> > flush_bio_list -> bitmap_unplug.
> >> 
> >> I grew up with BASIC and Pascal.
> >> Every "if" statement has a "then" branch and an "else" branch.
> >> The fact that C doesn't have a "then" keyword doesn't mean there isn't a
> >> 'then' branch.
> >> 
> >> But yes, state should be set to TASK_RUNNING when the condition in the
> >> 'if' statement evaluates as 'true' (or maybe I should say "doesn't
> >> evaluate to 0").
> >
> > Completely agree this fixes the issue, but I'm a little hesitant to apply it.
> > It looks a little weird, I mean, at least I must add comments to explain why we
> > do that way. Do you have strong preference to do this way?
> 
> My preference is quite strong.  I believe the current code is simple and
> correct and doesn't need to change.
> The warning is a false positive.  It is a good warning to have, but in
> this case it doesn't indicate a problem.
> 
> I agree that comments are a good thing here.  So I propose this patch,
> replete with comments.


Ok, with the comment, I feel better. Applied, thanks!
