From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/2] super-intel.c: Don't try to close negative fd
Date: Fri,  4 May 2012 15:41:21 +0200
Message-ID: <1336138882-31869-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This should be harmless, but lets be consistent and not try to close a
negative file descripter.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 super-intel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 2e85b6b..ca15703 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4353,7 +4353,7 @@ static int get_super_block(struct intel_super **super_list, int devnum, char *de
 	} else {
 		if (s)
 			free(s);
-		if (dfd)
+		if (dfd >= 0)
 			close(dfd);
 	}
 	if ((dfd >= 0) && (!keep_fd))
-- 
1.7.7.6

