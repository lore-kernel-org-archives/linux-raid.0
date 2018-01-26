From: Xiao Ni <xni@redhat.com>
Subject: [PATCH mdadm] Subdevs can't be all missing when create raid device
Date: Fri, 26 Jan 2018 16:42:16 +0800
Message-ID: <1516956136-4803-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com
List-Id: linux-raid.ids

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Create.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Create.c b/Create.c
index 239545f..50142d8 100644
--- a/Create.c
+++ b/Create.c
@@ -475,6 +475,10 @@ int Create(struct supertype *st, char *mddev,
 			close(fd);
 		}
 	}
+	if (missing_disks == dnum) {
+		pr_err("Subdevs can't be all missing\n");
+		return 1;
+	}
 	if (s->raiddisks + s->sparedisks > st->max_devs) {
 		pr_err("Too many devices: %s metadata only supports %d\n",
 			st->ss->name, st->max_devs);
-- 
2.7.4

