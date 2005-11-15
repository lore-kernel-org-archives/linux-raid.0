From: Neil Brown <neilb@suse.de>
Subject: Re: High system load on 2.6.15-r1 & software raid
Date: Wed, 16 Nov 2005 10:09:31 +1100
Message-ID: <17274.27307.363634.27494@cse.unsw.edu.au>
References: <20051115183848.GE30507@borneo.zolder.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Frido Ferdinand on Tuesday November 15
Sender: linux-raid-owner@vger.kernel.org
To: Frido Ferdinand <frido@zolder.org>
Cc: linux-raid@VGER.KERNEL.ORG
List-Id: linux-raid.ids

On Tuesday November 15, frido@zolder.org wrote:
> Hi,
> 
> Yesterday i installed the new 2.6.15-rc1 kernel to test ata passthrough to
> get smartctl working on my sata disks. After boot I noticed a rather
> high load of ~5. I checked with top, ps, but no processes where running
> taking up CPU, and the system was 100% idle:
> 
> Cpu0  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
> Cpu1  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
> 
> After thinking about it, i realised i had 5 different software raid 1
> partitions running, md0 to md4. After disabling each of them with 
> with about 10 minutes in between, i saw the load drop by exactly
> 1 each time. This problem didn't happen on 2.6.14.2. Has anyone seen
> this problem before, maybe on another kernel ? As for smartctl, it
> works,but I didn't enable smartd nor mdadm when testing.

Thanks for testing -rc1 and for reporting the problem.

Yes, this is known and the fix just recently went into Linus' GIT
repository, so it will be in -rc2.

For reference, the fix is below.

NeilBrown


[PATCH] md: make md threads interruptible again

Despite the fact that md threads don't need to be signalled, and won't
respond to signals anyway, we need to have an 'interruptible' wait, else
they stay in 'D' state and add to the load average.

(akpm: the signal_pending() test is unneeded - we'll fix that up in the next
round.  For now, leave it there because that's how the code used to be).

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Linus Torvalds <torvalds@osdl.org>

 drivers/md/md.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a9f032e..f3fed66 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3437,10 +3437,19 @@ static int md_thread(void * arg)
 	allow_signal(SIGKILL);
 	while (!kthread_should_stop()) {
 
-		wait_event_timeout(thread->wqueue,
-				   test_bit(THREAD_WAKEUP, &thread->flags)
-				   || kthread_should_stop(),
-				   thread->timeout);
+		/* We need to wait INTERRUPTIBLE so that
+		 * we don't add to the load-average.
+		 * That means we need to be sure no signals are
+		 * pending
+		 */
+		if (signal_pending(current))
+			flush_signals(current);
+
+		wait_event_interruptible_timeout
+			(thread->wqueue,
+			 test_bit(THREAD_WAKEUP, &thread->flags)
+			 || kthread_should_stop(),
+			 thread->timeout);
 		try_to_freeze();
 
 		clear_bit(THREAD_WAKEUP, &thread->flags);
