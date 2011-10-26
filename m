From: Jes.Sorensen@redhat.com
Subject: [PATCH 09/13] Fix malloc handling in dlink.c
Date: Wed, 26 Oct 2011 17:30:22 +0200
Message-ID: <1319643026-11501-10-git-send-email-Jes.Sorensen@redhat.com>
References: <1319643026-11501-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1319643026-11501-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 dlink.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/dlink.c b/dlink.c
index d734281..168ca2f 100644
--- a/dlink.c
+++ b/dlink.c
@@ -15,8 +15,10 @@ void *dl_head()
 {
     void *h;
     h = dl_alloc(0);
-    dl_next(h) = h;
-    dl_prev(h) = h;
+    if (h) {
+	    dl_next(h) = h;
+	    dl_prev(h) = h;
+    }
     return h;
 }
 
-- 
1.7.6.4

