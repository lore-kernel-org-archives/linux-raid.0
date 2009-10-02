From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 3/3] Allow sysfs_notify_dirent to be called from interrupt
	context.
Date: Thu, 01 Oct 2009 18:18:36 -0700
Message-ID: <20091002011836.24095.94139.stgit@dwillia2-linux.ch.intel.com>
References: <20091002011747.24095.70355.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091002011747.24095.70355.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Joel Andres Granados <jgranado@redhat.com>, stable@kernel.org
List-Id: linux-raid.ids

From: NeilBrown <neilb@suse.de>

sysfs_notify_dirent is a simple atomic operation that can be used to
alert user-space that new data can be read from a sysfs attribute.

Unfortunately is cannot currently be called from non-process context
because of it's use of spin_lock which is sometimes taken with
interrupt enabled.

So change all lockers of sysfs_open_dirent_lock to disable interrupts,
thus making sysfs_notify_dirent safe to be called from non-process
context (as drivers/md does in md_safemode_timeout).

sysfs_get_open_dirent is (documented as being) only called from
process context, so it uses spin_lock_irq.  Other places
use spin_lock_irqsave.

The usage for sysfs_notify_dirent in md_safemode_timeout was
introduced in 2.6.28, so this patch is suitable for that and more
recent kernels.

Cc: <stable@kernel.org>
Reported-by: Joel Andres Granados <jgranado@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/sysfs/file.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 561a9c0..f5ea468 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -268,7 +268,7 @@ static int sysfs_get_open_dirent(struct sysfs_dirent *sd,
 	struct sysfs_open_dirent *od, *new_od = NULL;
 
  retry:
-	spin_lock(&sysfs_open_dirent_lock);
+	spin_lock_irq(&sysfs_open_dirent_lock);
 
 	if (!sd->s_attr.open && new_od) {
 		sd->s_attr.open = new_od;
@@ -281,7 +281,7 @@ static int sysfs_get_open_dirent(struct sysfs_dirent *sd,
 		list_add_tail(&buffer->list, &od->buffers);
 	}
 
-	spin_unlock(&sysfs_open_dirent_lock);
+	spin_unlock_irq(&sysfs_open_dirent_lock);
 
 	if (od) {
 		kfree(new_od);
@@ -315,8 +315,9 @@ static void sysfs_put_open_dirent(struct sysfs_dirent *sd,
 				  struct sysfs_buffer *buffer)
 {
 	struct sysfs_open_dirent *od = sd->s_attr.open;
+	unsigned long flags;
 
-	spin_lock(&sysfs_open_dirent_lock);
+	spin_lock_irqsave(&sysfs_open_dirent_lock, flags);
 
 	list_del(&buffer->list);
 	if (atomic_dec_and_test(&od->refcnt))
@@ -324,7 +325,7 @@ static void sysfs_put_open_dirent(struct sysfs_dirent *sd,
 	else
 		od = NULL;
 
-	spin_unlock(&sysfs_open_dirent_lock);
+	spin_unlock_irqrestore(&sysfs_open_dirent_lock, flags);
 
 	kfree(od);
 }
@@ -456,8 +457,9 @@ static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
 void sysfs_notify_dirent(struct sysfs_dirent *sd)
 {
 	struct sysfs_open_dirent *od;
+	unsigned long flags;
 
-	spin_lock(&sysfs_open_dirent_lock);
+	spin_lock_irqsave(&sysfs_open_dirent_lock, flags);
 
 	od = sd->s_attr.open;
 	if (od) {
@@ -465,7 +467,7 @@ void sysfs_notify_dirent(struct sysfs_dirent *sd)
 		wake_up_interruptible(&od->poll);
 	}
 
-	spin_unlock(&sysfs_open_dirent_lock);
+	spin_unlock_irqrestore(&sysfs_open_dirent_lock, flags);
 }
 EXPORT_SYMBOL_GPL(sysfs_notify_dirent);
 

