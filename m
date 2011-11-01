From: Jes.Sorensen@redhat.com
Subject: [PATCH 16/19] Monitor(): free allocated memory on exit
Date: Tue,  1 Nov 2011 16:09:32 +0100
Message-ID: <1320160175-18976-17-git-send-email-Jes.Sorensen@redhat.com>
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
 Monitor.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 101bca4..fc0488b 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -124,6 +124,7 @@ int Monitor(struct mddev_dev *devlist,
 	 */
 
 	struct state *statelist = NULL;
+	struct state *st2;
 	int finished = 0;
 	struct mdstat_ent *mdstat = NULL;
 	char *mailfrom = NULL;
@@ -242,6 +243,11 @@ int Monitor(struct mddev_dev *devlist,
 		}
 		test = 0;
 	}
+	for (st2 = statelist; st2; st2 = statelist) {
+		statelist = st2->next;
+		free(st2);
+	}
+
 	if (pidfile)
 		unlink(pidfile);
 	return 0;
-- 
1.7.6.4

