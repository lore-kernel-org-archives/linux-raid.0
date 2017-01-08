From: Xiao Ni <xni@redhat.com>
Subject: [MDADM PATCH 1/1] Add detail information when can not connect monitor
Date: Sun,  8 Jan 2017 10:59:54 +0800
Message-ID: <1483844394-7647-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: osamarin68@gmail.com, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

If it can't connect monitor, now the error message is just
Error waiting for xxx to be clean. Add detail error message
in connect_monitor.

Suggested-by: Oleg Samarin <osamarin68@gmail.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 msg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/msg.c b/msg.c
index 45cd450..c66b0a1 100644
--- a/msg.c
+++ b/msg.c
@@ -171,6 +171,8 @@ int connect_monitor(char *devname)
 	addr.sun_family = PF_LOCAL;
 	strcpy(addr.sun_path, path);
 	if (connect(sfd, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
+		pr_err("Error connecting monitor with %s: %s\n",
+			addr.sun_path, strerror(errno));
 		close(sfd);
 		return -1;
 	}
-- 
2.7.4

