From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 4/8] md-cluster: introduce dlm_lock_sync_interruptible to
 fix tasks hang
Date: Fri, 5 Aug 2016 20:59:41 -0700
Message-ID: <20160806035941.GA9281@kernel.org>
References: <1469686612-16126-1-git-send-email-gqjiang@suse.com>
 <1469686612-16126-4-git-send-email-gqjiang@suse.com>
 <20160801222042.GB18810@kernel.org>
 <57A01272.4010209@suse.com>
 <20160802223631.GC98613@kernel.org>
 <57A15977.205@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57A15977.205@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Aug 03, 2016 at 10:39:51AM +0800, Guoqing Jiang wrote:
> 
> 
> On 08/03/2016 06:36 AM, Shaohua Li wrote:
> >On Mon, Aug 01, 2016 at 11:24:34PM -0400, Guoqing Jiang wrote:
> >>
> >>On 08/01/2016 06:20 PM, Shaohua Li wrote:
> >>>On Thu, Jul 28, 2016 at 02:16:48AM -0400, Guoqing Jiang wrote:
> >>>>When some node leaves cluster, then it's bitmap need to be
> >>>>synced by another node, so "md*_recover" thread is triggered
> >>>>for the purpose. However, with below steps. we can find tasks
> >>>>hang happened either in B or C.
> >>>>
> >>>>1. Node A create a resyncing cluster raid1, assemble it in
> >>>>    other two nodes (B and C).
> >>>>2. stop array in B and C.
> >>>>3. stop array in A.
> >>>>
> >>>>linux44:~ # ps aux|grep md|grep D
> >>>>root	5938	0.0  0.1  19852  1964 pts/0    D+   14:52   0:00 mdadm -S md0
> >>>>root	5939	0.0  0.0      0     0 ?        D    14:52   0:00 [md0_recover]
> >>>>
> >>>>linux44:~ # cat /proc/5939/stack
> >>>>[<ffffffffa04cf321>] dlm_lock_sync+0x71/0x90 [md_cluster]
> >>>>[<ffffffffa04d0705>] recover_bitmaps+0x125/0x220 [md_cluster]
> >>>>[<ffffffffa052105d>] md_thread+0x16d/0x180 [md_mod]
> >>>>[<ffffffff8107ad94>] kthread+0xb4/0xc0
> >>>>[<ffffffff8152a518>] ret_from_fork+0x58/0x90
> >>>>
> >>>>linux44:~ # cat /proc/5938/stack
> >>>>[<ffffffff8107afde>] kthread_stop+0x6e/0x120
> >>>>[<ffffffffa0519da0>] md_unregister_thread+0x40/0x80 [md_mod]
> >>>>[<ffffffffa04cfd20>] leave+0x70/0x120 [md_cluster]
> >>>>[<ffffffffa0525e24>] md_cluster_stop+0x14/0x30 [md_mod]
> >>>>[<ffffffffa05269ab>] bitmap_free+0x14b/0x150 [md_mod]
> >>>>[<ffffffffa0523f3b>] do_md_stop+0x35b/0x5a0 [md_mod]
> >>>>[<ffffffffa0524e83>] md_ioctl+0x873/0x1590 [md_mod]
> >>>>[<ffffffff81288464>] blkdev_ioctl+0x214/0x7d0
> >>>>[<ffffffff811dd3dd>] block_ioctl+0x3d/0x40
> >>>>[<ffffffff811b92d4>] do_vfs_ioctl+0x2d4/0x4b0
> >>>>[<ffffffff811b9538>] SyS_ioctl+0x88/0xa0
> >>>>[<ffffffff8152a5c9>] system_call_fastpath+0x16/0x1b
> >>>>
> >>>>The problem is caused by recover_bitmaps can't reliably abort
> >>>>when the thread is unregistered. So dlm_lock_sync_interruptible
> >>>>is introduced to detect the thread's situation to fix the problem.
> >>>>
> >>>>Reviewed-by: NeilBrown <neilb@suse.com>
> >>>>Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> >>>>---
> >>>>  drivers/md/md-cluster.c | 38 +++++++++++++++++++++++++++++++++++++-
> >>>>  1 file changed, 37 insertions(+), 1 deletion(-)
> >>>>
> >>>>diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> >>>>index ea2699e..f3d584e 100644
> >>>>--- a/drivers/md/md-cluster.c
> >>>>+++ b/drivers/md/md-cluster.c
> >>>>@@ -10,6 +10,8 @@
> >>>>  #include <linux/module.h>
> >>>>+#include <linux/completion.h>
> >>>>+#include <linux/kthread.h>
> >>>>  #include <linux/dlm.h>
> >>>>  #include <linux/sched.h>
> >>>>  #include <linux/raid/md_p.h>
> >>>>@@ -141,6 +143,40 @@ static int dlm_unlock_sync(struct dlm_lock_resource *res)
> >>>>  	return dlm_lock_sync(res, DLM_LOCK_NL);
> >>>>  }
> >>>>+/* An variation of dlm_lock_sync, which make lock request could
> >>>>+ * be interrupted */
> >>>>+static int dlm_lock_sync_interruptible(struct dlm_lock_resource *res, int mode,
> >>>>+				       struct mddev *mddev)
> >>>>+{
> >>>>+	int ret = 0;
> >>>>+
> >>>>+	ret = dlm_lock(res->ls, mode, &res->lksb,
> >>>>+			res->flags, res->name, strlen(res->name),
> >>>>+			0, sync_ast, res, res->bast);
> >>>>+	if (ret)
> >>>>+		return ret;
> >>>>+
> >>>>+	wait_event(res->completion.wait,
> >>>>+		   res->completion.done || kthread_should_stop());
> >>>can you convert it to a waitq? Directly using the .wait/.done of completion is
> >>>really intrusive.
> >>Maybe, but we still need completion for dlm_lock_resource otherwise there
> >>are different types of dlm_lock_resource, we also need to keep align with
> >>sync_ast as dlm_lock_sync did.
> >Yes, we need a waitq and variable like completion.done to indicate the event is
> >done, and convert the completion API to waitq API in other places like
> >sync_ast. The point is not using the opaque data structure of 'struct
> >completion'. Diving into implementation details of a unrelated data structure
> >(completion here) is really intrusive.
> 
> I don't want to argue about the intrusive, but we have to create something
> which could be achieved by the existed thing.
> 
> OTOH, convert completion to waitqueue should be done in a new patch,
> and it is a big change though achieveable, we need to do full test for it.

I can't see why this is a big change. Simply adding a waitq and a variable,
replace wait_for_completion with wait_event checking the condition and replace
complete with setting the variable and wake_up. That's pretty straightforward
and no risk. I'd rather see the first patch converts completion to waitq and
this patch addes the kthread_should_stop() check.

Thanks,
Shaohua
