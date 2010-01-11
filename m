From: Doug Ledford <dledford@redhat.com>
Subject: [[Patch mdadm] 4/5] When using -D --export the UUID is helpful, so print it out
Date: Mon, 11 Jan 2010 15:38:13 -0500
Message-ID: <1263242294-5353-5-git-send-email-dledford@redhat.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1263242294-5353-1-git-send-email-dledford@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

Signed-off-by: Doug Ledford <dledford@redhat.com>
---
 Detail.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/Detail.c b/Detail.c
index ba07c83..e05ba10 100644
--- a/Detail.c
+++ b/Detail.c
@@ -203,6 +203,11 @@ int Detail(char *dev, int brief, int export, int test, char *homehost)
 			if (mp && mp->path &&
 			    strncmp(mp->path, "/dev/md/", 8) == 0)
 				printf("MD_DEVNAME=%s\n", mp->path+8);
+                        if (mp && (mp->uuid[0] || mp->uuid[1] || mp->uuid[2] ||
+                                   mp->uuid[3]))
+                                printf("MD_UUID=%08x:%08x:%08x:%08x\n",
+                                        mp->uuid[0], mp->uuid[1], mp->uuid[2],
+                                        mp->uuid[3]);
 		}
 		goto out;
 	}
-- 
1.6.5.2

