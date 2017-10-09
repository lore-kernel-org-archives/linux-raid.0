From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 3/3] mdadm/mdstat: correct the strncmp number 4 as 6
Date: Mon,  9 Oct 2017 16:21:14 +0800
Message-ID: <1507537274-29350-4-git-send-email-zlliu@suse.com>
References: <1507537274-29350-1-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1507537274-29350-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

mdstat: it should be corrected as 6 when strncmp 'resync'.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 mdstat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mdstat.c b/mdstat.c
index 6c906a7..7e600d0 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -244,7 +244,7 @@ struct mdstat_ent *mdstat_read(int hold, int start)
 					ent->resync = 0;
 			} else if (ent->percent == RESYNC_NONE &&
 				   (w[0] == 'r' || w[0] == 'c')) {
-				if (strncmp(w, "resync", 4) == 0)
+				if (strncmp(w, "resync", 6) == 0)
 					ent->resync = 1;
 				if (strncmp(w, "reshape", 7) == 0)
 					ent->resync = 2;
-- 
2.6.6

