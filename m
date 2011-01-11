From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 02/13] md: fix regression resulting in delays in clearing
	bits in a bitmap
Date: Wed, 12 Jan 2011 09:12:46 +1100
Message-ID: <20110111221246.12732.33418.stgit@notabene.brown>
References: <20110111221050.12732.31647.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110111221050.12732.31647.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

commit 589a594be1fb (2.6.37-rc4) fixed a problem were md_thread would
sometimes call the ->run function at a bad time.

If an error is detected during array start up after the md_thread has
been started, the md_thread is killed.  This resulted in the ->run
function being called once.  However the array may not be in a state
that it is safe to call ->run.

However the fix imposed meant that  ->run was not called on a timeout.
This means that when an array goes idle, bitmap bits do not get
cleared promptly.  While the array is busy the bits will still be
cleared when appropriate so this is not very serious.  There is no
risk to data.

Change the test so that we only avoid calling ->run when the thread
is being stopped.  This more explicitly address the problem situation.

This is suitable for any -stable kernel to which 589a594be1fb was
applied.

Cc: stable@kernel.org
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0da25da..a301912 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6042,7 +6042,8 @@ static int md_thread(void * arg)
 			 || kthread_should_stop(),
 			 thread->timeout);
 
-		if (test_and_clear_bit(THREAD_WAKEUP, &thread->flags))
+		clear_bit(THREAD_WAKEUP, &thread->flags);
+		if (!kthread_should_stop())
 			thread->run(thread->mddev);
 	}
 


