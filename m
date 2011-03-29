From: Tejun Heo <tj@kernel.org>
Subject: Re: raid1 boot regression in 2.6.37 [bisected]
Date: Tue, 29 Mar 2011 10:25:03 +0200
Message-ID: <20110329082503.GI6736@htj.dyndns.org>
References: <201103251725.21180.thomas.jarosch@intra2net.com>
 <20110328075937.GB16530@htj.dyndns.org>
 <201103281302.20219.thomas.jarosch@intra2net.com>
 <201103281453.53382.thomas.jarosch@intra2net.com>
 <20110328155928.GB6736@htj.dyndns.org>
 <4D90E580.7020406@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D90E580.7020406@intra2net.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Mon, Mar 28, 2011 at 09:46:08PM +0200, Thomas Jarosch wrote:
> On 03/28/2011 05:59 PM, Tejun Heo wrote:
> >> Call Trace:
> >>  [<c12dc808>] mutex_unlock+0x8/0x10
> >>  [<c11c4451>] kobj_lookup+0xe1/0x140
> >>  [<c11323b0>] ? exact_match+0x0/0x10
> >>  [<c11331b8>] get_gendisk+0x98/0xb0
> >>  [<c10e85aa>] __blkdev_get+0xca/0x320
> >>  [<c10e8843>] blkdev_get+0x43/0x2c0
> >>  [<c12de75d>] ? _raw_spin_unlock+0x1d/0x20
> >>  [<c10e8b12>] blkdev_open+0x52/0x70
> >>  [<c10bb12d>] __dentry_open+0x9d/0x240
> >>  [<c10bb3c6>] nameidata_to_filp+0x66/0x80
> >>  [<c10e8ac0>] ? blkdev_open+0x0/0x70
> >>  [<c10c781f>] finish_open+0xaf/0x190
> >>  [<c10c8a24>] ? do_path_lookup+0x44/0xe0
> >>  [<c10c9920>] do_filp_open+0x210/0x6d0
> >>  [<c10672e9>] ? lock_release_non_nested+0x59/0x2f0
> >>  [<c12de75d>] ? _raw_spin_unlock+0x1d/0x20
> >>  [<c10d47d8>] ? alloc_fd+0xb8/0xf0
> >>  [<c10baf45>] do_sys_open+0x55/0xf0
> >>  [<c10bb049>] sys_open+0x29/0x40
> >>  [<c1002e9f>] sysenter_do_call+0x12/0x38
> > 
> > Hmmm... Weird.
> > 
> > * blkid seems to be looping in blkdev_open() repeatedly calling
> >   md_open() which keeps returning -ERESTARTSYS.
> > 
> > * It triggered softlockup.  Even with -ERESTARTSYS looping, I can't
> >   see how that would be possible.
> > 
> > Is this custom boot script?  If so, do you use RT priority in the
> > script?
> 
> It's a normal dracut installation with an additional custom script
> to trigger kernel raid auto detection via mdadm.
> The custom script was part of the initial post.
> 
> I've also noticed another odd thing: On a HP Proliant ML110 G6 box,
> which is quite fast / SMP, the box brings up the software
> RAID successfully. The box is slow as hell and I can see a constant load
> on a kernel process (could be "kworker", don't remember it exactly).
> I'll try tomorrow if that is also related to the RAID subsystem
> or something else turning it into a PDP11...

Can you please apply the following patch and see whether it resolves
the problem and report the boot log?

Thanks.

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8b66e04..e17098b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6001,6 +6001,15 @@ static int md_open(struct block_device *bdev, fmode_t mode)
 		 * bd_disk.
 		 */
 		mddev_put(mddev);
+		if (current->policy == SCHED_FIFO || current->policy == SCHED_RR) {
+			static bool once;
+			if (!once) {
+				printk("%s: md_open(): RT prio, pol=%u p=%d rt_p=%u\n",
+				       current->comm, current->policy, current->static_prio, current->rt_priority);
+				once = true;
+			}
+		}
+		msleep(10);
 		/* Wait until bdev->bd_disk is definitely gone */
 		flush_workqueue(md_misc_wq);
 		/* Then retry the open from the top */
