From: Xiao Ni <xni@redhat.com>
Subject: Fwd: [PATCH] add sysfs reshape_progress for raid5
Date: Tue, 19 May 2015 22:35:50 -0400 (EDT)
Message-ID: <744536312.1396489.1432089350377.JavaMail.zimbra@redhat.com>
References: <1431673707-10895-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1431673707-10895-1-git-send-email-xni@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all

   Send the patch again. Because I don't see them at http://www.spinics.net/lists/raid/

----- Forwarded Message -----
From: "Xiao Ni" <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: "Xiao Ni" <xni@redhat.com>
Sent: Friday, May 15, 2015 3:08:27 PM
Subject: [PATCH] add sysfs reshape_progress for raid5


Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/raid5.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 77dfd72..0799793 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5893,6 +5893,19 @@ raid5_store_stripe_cache_size(struct mddev *mddev, const char *page, size_t len)
 	return err ?: len;
 }
 
+static ssize_t
+reshape_progress_show(struct mddev *mddev, char *page)
+{
+	struct r5conf *conf = mddev->private;
+	if (conf->reshape_progress == MaxSector)
+		return sprintf(page, "max\n");
+	else
+		return sprintf(page, "%llu\n",
+					(unsigned long long)conf->reshape_progress);
+}
+
+static struct md_sysfs_entry raid5_reshape_progress = __ATTR_RO(reshape_progress);
+
 static struct md_sysfs_entry
 raid5_stripecache_size = __ATTR(stripe_cache_size, S_IRUGO | S_IWUSR,
 				raid5_show_stripe_cache_size,
@@ -6122,6 +6135,7 @@ raid5_group_thread_cnt = __ATTR(group_thread_cnt, S_IRUGO | S_IWUSR,
 				raid5_store_group_thread_cnt);
 
 static struct attribute *raid5_attrs[] =  {
+	&raid5_reshape_progress.attr,
 	&raid5_stripecache_size.attr,
 	&raid5_stripecache_active.attr,
 	&raid5_preread_bypass_threshold.attr,
-- 
1.7.1

