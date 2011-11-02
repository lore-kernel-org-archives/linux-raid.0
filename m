From: Jes.Sorensen@redhat.com
Subject: [PATCH 07/12] close_aa(): Verify file descriptors are valid before trying to close them
Date: Wed,  2 Nov 2011 15:42:12 +0100
Message-ID: <1320244937-9739-8-git-send-email-Jes.Sorensen@redhat.com>
References: <1320244937-9739-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320244937-9739-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 managemon.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/managemon.c b/managemon.c
index fceaeb9..cde0d8b 100644
--- a/managemon.c
+++ b/managemon.c
@@ -117,11 +117,16 @@ static void close_aa(struct active_array *aa)
 		close(d->state_fd);
 	}
 
-	close(aa->action_fd);
-	close(aa->info.state_fd);
-	close(aa->resync_start_fd);
-	close(aa->metadata_fd);
-	close(aa->sync_completed_fd);
+	if (aa->action_fd >= 0)
+		close(aa->action_fd);
+	if (aa->info.state_fd >= 0)
+		close(aa->info.state_fd);
+	if (aa->resync_start_fd >= 0)
+		close(aa->resync_start_fd);
+	if (aa->metadata_fd >= 0)
+		close(aa->metadata_fd);
+	if (aa->sync_completed_fd >= 0)
+		close(aa->sync_completed_fd);
 }
 
 static void free_aa(struct active_array *aa)
-- 
1.7.6.4

