From: Neil Brown <neilb@suse.de>
Subject: Re: md deadlock (was Re: 2.6.18-mm2)
Date: Tue, 10 Oct 2006 13:53:19 +1000
Message-ID: <17707.6447.329255.930851@cse.unsw.edu.au>
References: <20060928014623.ccc9b885.akpm@osdl.org>
	<6bffcb0e0609280454n34d40c0la8786e1eba6dcdf3@mail.gmail.com>
	<1159531923.28131.80.camel@taijtu>
	<17693.5913.393686.223172@cse.unsw.edu.au>
	<1159538597.28131.97.camel@taijtu>
	<1159796858.28131.149.camel@taijtu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter Zijlstra on Monday October 2
Sender: linux-raid-owner@vger.kernel.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Hi,
 would this be an appropriate fix do the warning lockdep gives about
 possible deadlocks in md.

 The warning is currently easily triggered with
   mdadm -C /dev/md1 -l1 -n1 /dev/sdc missing

 (assuming /dev/sdc is a device that you are happy to be scribbled on).

 This will take ->reconfig_mutex on md1 while holding bd_mutex,
 then will take bd_mutex on sdc while holding reconfig_mutex on md1

 This superficial deadlock isn't a real problem because the bd_mutexes
 are on different devices and there is an hierarchical relationship
 which avoids the loop necessary for a deadlock.

-----------------------
Avoid lockdep warning in md.

md_open takes ->reconfig_mutex which causes lockdep to complain.
This (normally) doesn't have deadlock potential as the possible
conflict is with a reconfig_mutex in a different device.

I say "normally" because if a loop were created in the array->member
hierarchy a deadlock could happen.  However that causes bigger
problems than a deadlock and should be fixed independently.

So we flag the lock in md_open as a nested lock.  This requires
defining mutex_lock_interruptible_nested.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c       |    2 +-
 ./include/linux/mutex.h |    3 ++-
 ./kernel/mutex.c        |    8 ++++++++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2006-10-09 14:25:11.000000000 +1000
+++ ./drivers/md/md.c	2006-10-10 12:28:35.000000000 +1000
@@ -4422,7 +4422,7 @@ static int md_open(struct inode *inode, 
 	mddev_t *mddev = inode->i_bdev->bd_disk->private_data;
 	int err;
 
-	if ((err = mddev_lock(mddev)))
+	if ((err = mutex_lock_interruptible_nested(&mddev->reconfig_mutex, 1)))
 		goto out;
 
 	err = 0;

diff .prev/include/linux/mutex.h ./include/linux/mutex.h
--- .prev/include/linux/mutex.h	2006-10-10 12:37:04.000000000 +1000
+++ ./include/linux/mutex.h	2006-10-10 12:40:20.000000000 +1000
@@ -125,8 +125,9 @@ extern int fastcall mutex_lock_interrupt
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 extern void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
+extern int mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass);
 #else
-# define mutex_lock_nested(lock, subclass) mutex_lock(lock)
+# define mutex_lock_interruptible_nested(lock, subclass) mutex_interruptible_lock(lock)
 #endif
 
 /*

diff .prev/kernel/mutex.c ./kernel/mutex.c
--- .prev/kernel/mutex.c	2006-10-10 12:35:54.000000000 +1000
+++ ./kernel/mutex.c	2006-10-10 13:20:04.000000000 +1000
@@ -206,6 +206,14 @@ mutex_lock_nested(struct mutex *lock, un
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_nested);
+int __sched
+mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
+{
+	might_sleep();
+	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, subclass);
+}
+
+EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
 #endif
 
 /*
