From: Steven Dake <sdake@mvista.com>
Subject: Patch to fix defect in raid 1 spinlocks
Date: Fri, 12 Dec 2003 16:04:53 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1071270293.31245.47.camel@persist.az.mvista.com>
Reply-To: sdake@mvista.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-C77/X8WV+uF5ir/QHAzw"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-C77/X8WV+uF5ir/QHAzw
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Folks,

I've audited the RAID 1 locking code in 2.4.23, and found a few
problems.

The first problem is that in one instance of locking,
spin_lock_irq/spin_unlock_irq are called, without knowing the prior
state of the irq flags.  The result is that irqs could be reenabled when
they were disabled before the spin lock was taken.

The spinlock is located in the function raid1_alloc_bh.  This function
is called by raid1_make_request (spin_lock_irq is safe in this call
path).  It is also called by raid1d (spin_lock_irq is unsafe in this
call path, and spin_lock_irqsave should be used instead).

Thanks
-steve

--=-C77/X8WV+uF5ir/QHAzw
Content-Disposition: attachment; filename=raid-spinlock-fix1.patch
Content-Type: text/plain; name=raid-spinlock-fix1.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- linux-2.4.23/drivers/md/raid1.c	2003-06-13 07:51:34.000000000 -0700
+++ linux-2.4.23.raidfix/drivers/md/raid1.c	2003-12-12 15:53:13.000000000 -0700
@@ -62,10 +62,11 @@
 	 * get all we need, otherwise we could deadlock
 	 */
 	struct buffer_head *bh=NULL;
+	unsigned long flags;
 
 	while(cnt) {
 		struct buffer_head *t;
-		md_spin_lock_irq(&conf->device_lock);
+		md_spin_lock_irqsave(&conf->device_lock, flags);
 		if (!conf->freebh_blocked && conf->freebh_cnt >= cnt)
 			while (cnt) {
 				t = conf->freebh;
@@ -76,7 +77,7 @@
 				conf->freebh_cnt--;
 				cnt--;
 			}
-		md_spin_unlock_irq(&conf->device_lock);
+		md_spin_unlock_irqrestore(&conf->device_lock, flags);
 		if (cnt == 0)
 			break;
 		t = kmem_cache_alloc(bh_cachep, SLAB_NOIO);

--=-C77/X8WV+uF5ir/QHAzw--

