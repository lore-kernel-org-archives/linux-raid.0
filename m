From: Jes.Sorensen@redhat.com
Subject: [PATCH 06/19] assemble_container_content(): fix memory leak
Date: Tue,  1 Nov 2011 16:09:22 +0100
Message-ID: <1320160175-18976-7-git-send-email-Jes.Sorensen@redhat.com>
References: <1320160175-18976-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320160175-18976-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Assemble.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 4ded58c..05710f5 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1527,8 +1527,11 @@ int assemble_container_content(struct supertype *st, int mdfd,
 
 	sra = sysfs_read(mdfd, 0, GET_VERSION);
 	if (sra == NULL || strcmp(sra->text_version, content->text_version) != 0)
-		if (sysfs_set_array(content, md_get_version(mdfd)) != 0)
+		if (sysfs_set_array(content, md_get_version(mdfd)) != 0) {
+			if (sra)
+				sysfs_free(sra);
 			return 1;
+		}
 
 	if (st->ss->external && content->recovery_blocked)
 		block_subarray(content);
-- 
1.7.6.4

