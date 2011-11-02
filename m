From: Jes.Sorensen@redhat.com
Subject: [PATCH 09/12] unblock_monitor(): Check sra is valid before dereferencing
Date: Wed,  2 Nov 2011 15:42:14 +0100
Message-ID: <1320244937-9739-10-git-send-email-Jes.Sorensen@redhat.com>
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
 msg.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/msg.c b/msg.c
index 87d3b8d..dc780b3 100644
--- a/msg.c
+++ b/msg.c
@@ -448,6 +448,8 @@ void unblock_monitor(char *container, const int unfreeze)
 			continue;
 		sysfs_free(sra);
 		sra = sysfs_read(-1, e->devnum, GET_VERSION|GET_LEVEL);
+		if (!sra)
+			continue;
 		if (sra->array.level > 0)
 			to_ping++;
 		if (unblock_subarray(sra, unfreeze))
-- 
1.7.6.4

