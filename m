From: Jes.Sorensen@redhat.com
Subject: [PATCH 06/11] Fix memory leak
Date: Mon, 31 Oct 2011 15:02:34 +0100
Message-ID: <1320069759-13361-7-git-send-email-Jes.Sorensen@redhat.com>
References: <1320069759-13361-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320069759-13361-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 super-gpt.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/super-gpt.c b/super-gpt.c
index 6f852aa..b8c9aae 100644
--- a/super-gpt.c
+++ b/super-gpt.c
@@ -179,8 +179,10 @@ static struct supertype *match_metadata_desc(char *arg)
 
 	if (!st)
 		return st;
-	if (strcmp(arg, "gpt") != 0)
+	if (strcmp(arg, "gpt") != 0) {
+		free(st);
 		return NULL;
+	}
 
 	st->ss = &gpt;
 	st->info = NULL;
-- 
1.7.6.4

