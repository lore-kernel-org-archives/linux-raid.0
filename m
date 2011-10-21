From: Jes.Sorensen@redhat.com
Subject: [PATCH] array_try_spare(): missing map_unlock()
Date: Fri, 21 Oct 2011 16:07:30 +0200
Message-ID: <1319206050-7732-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Incremental.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index cff7663..5c5f34f 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1056,6 +1056,7 @@ static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 		}
 		sysfs_free(chosen);
 	}
+	map_unlock(&map);
 	return rv;
 }
 
-- 
1.7.4.4

