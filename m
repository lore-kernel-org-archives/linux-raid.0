From: Jes.Sorensen@redhat.com
Subject: [PATCH 07/13] Fix malloc() failure handling in Monitor.c
Date: Wed, 26 Oct 2011 17:30:20 +0200
Message-ID: <1319643026-11501-8-git-send-email-Jes.Sorensen@redhat.com>
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
 Monitor.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 101bca4..675ec00 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -177,6 +177,13 @@ int Monitor(struct mddev_dev *devlist,
 				st->devname = strdup(mdlist->devname);
 			else {
 				st->devname = malloc(8+strlen(mdlist->devname)+1);
+				/*
+				 * Treat malloc() failure the same as above
+				 */
+				if (!st->devname) {
+					free(st);
+					continue;
+				}
 				strcpy(strcpy(st->devname, "/dev/md/"),
 				       mdlist->devname);
 			}
-- 
1.7.6.4

