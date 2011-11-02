From: Jes.Sorensen@redhat.com
Subject: [PATCH 02/12] ping_monitor(): check file descriptor is valid before using and closing it
Date: Wed,  2 Nov 2011 15:42:07 +0100
Message-ID: <1320244937-9739-3-git-send-email-Jes.Sorensen@redhat.com>
References: <1320244937-9739-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320244937-9739-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 msg.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/msg.c b/msg.c
index 98d6d13..87d3b8d 100644
--- a/msg.c
+++ b/msg.c
@@ -207,9 +207,14 @@ int fping_monitor(int sfd)
 int ping_monitor(char *devname)
 {
 	int sfd = connect_monitor(devname);
-	int err = fping_monitor(sfd);
+	int err;
+
+	if (sfd >= 0) {
+		err = fping_monitor(sfd);
+		close(sfd);
+	} else
+		err = -1;
 
-	close(sfd);
 	return err;
 }
 
-- 
1.7.6.4

