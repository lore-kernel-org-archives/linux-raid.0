From: Jes.Sorensen@redhat.com
Subject: [PATCH 03/11] init_super1() memset full buffer allocated for superblock
Date: Tue, 20 Mar 2012 17:54:08 +0100
Message-ID: <1332262456-5109-4-git-send-email-Jes.Sorensen@redhat.com>
References: <1332262456-5109-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1332262456-5109-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Avoid possibly using stale data in bitmap and misc area of superblock.
In addition, remove superfluous memsets already covered by memset of
full superblock.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 super1.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/super1.c b/super1.c
index 4c75f21..1f0c8bc 100644
--- a/super1.c
+++ b/super1.c
@@ -842,7 +842,7 @@ static int init_super1(struct supertype *st, mdu_array_info_t *info,
 			": %s could not allocate superblock\n", __func__);
 		return 0;
 	}
-	memset(sb, 0, 1024);
+	memset(sb, 0, SUPER1_SIZE);
 
 	st->sb = sb;
 	if (info == NULL) {
@@ -877,7 +877,6 @@ static int init_super1(struct supertype *st, mdu_array_info_t *info,
 		sprintf(defname, "%d", info->md_minor);
 		name = defname;
 	}
-	memset(sb->set_name, 0, 32);
 	if (homehost &&
 	    strchr(name, ':')== NULL &&
 	    strlen(homehost)+1+strlen(name) < 32) {
@@ -907,7 +906,6 @@ static int init_super1(struct supertype *st, mdu_array_info_t *info,
 		sb->resync_offset = 0;
 	sb->max_dev = __cpu_to_le32((1024- sizeof(struct mdp_superblock_1))/
 				    sizeof(sb->dev_roles[0]));
-	memset(sb->pad3, 0, sizeof(sb->pad3));
 
 	memset(sb->dev_roles, 0xff, 1024 - sizeof(struct mdp_superblock_1));
 
-- 
1.7.7.6

