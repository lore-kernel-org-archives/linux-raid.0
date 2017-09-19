From: Xiao Ni <xni@redhat.com>
Subject: [MDADM PATCH 1/2] Close mdfd before returning main function
Date: Tue, 19 Sep 2017 14:06:46 +0800
Message-ID: <1505801207-10096-2-git-send-email-xni@redhat.com>
References: <1505801207-10096-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1505801207-10096-1-git-send-email-xni@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, jes.sorensen@gmail.com
List-Id: linux-raid.ids

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 mdadm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mdadm.c b/mdadm.c
index d80aab3..7cdcdba 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1734,6 +1734,8 @@ int main(int argc, char *argv[])
 		autodetect();
 		break;
 	}
+	if (mdfd > 0)
+		close(mdfd);
 	exit(rv);
 }
 
-- 
2.7.4

