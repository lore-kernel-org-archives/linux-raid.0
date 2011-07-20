From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH] MD: generate an event when array sync is complete
Date: Wed, 20 Jul 2011 14:16:09 -0500
Message-ID: <1311189369.4939.2.camel@f14.redhat.com>
References: <1310677165.2246.12.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1310677165.2246.12.camel@f14.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

Neil,

As you said, reap_sync_thread is a much better place for this patch...

 brassow

This patch causes MD to generate an event (for device-mapper) when the
synchronization thread is reaped.  This is expected behavior for device-mapper.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -7148,6 +7148,8 @@ static void reap_sync_thread(mddev_t *md
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
 	md_new_event(mddev);
+	if (mddev->event_work.func)
+		queue_work(md_misc_wq, &mddev->event_work);
 }
 
 /*


