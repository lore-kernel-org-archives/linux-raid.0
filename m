From: Jes.Sorensen@redhat.com
Subject: [PATCH 05/19] remove_devices(): readlink returns -1 on error
Date: Tue,  1 Nov 2011 16:09:21 +0100
Message-ID: <1320160175-18976-6-git-send-email-Jes.Sorensen@redhat.com>
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
 Manage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Manage.c b/Manage.c
index 2d8c916..613a549 100644
--- a/Manage.c
+++ b/Manage.c
@@ -156,7 +156,7 @@ static void remove_devices(int devnum, char *path)
 				sprintf(pe, "%d", part);
 		}
 		n = readlink(path2, link, sizeof(link));
-		if (n && (int)strlen(base) == n &&
+		if (n > 0 && (int)strlen(base) == n &&
 		    strncmp(link, base, n) == 0)
 			unlink(path2);
 	}
-- 
1.7.6.4

