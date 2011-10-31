From: Jes.Sorensen@redhat.com
Subject: [PATCH 02/11] Fix memory leak
Date: Mon, 31 Oct 2011 15:02:30 +0100
Message-ID: <1320069759-13361-3-git-send-email-Jes.Sorensen@redhat.com>
References: <1320069759-13361-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320069759-13361-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Assemble.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index ac1115d..4ded58c 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1375,6 +1375,7 @@ int Assemble(struct supertype *st, char *mddev,
 							sysfs_set_num(sra, NULL,
 								      "stripe_cache_size",
 								      (4 * content->array.chunk_size / 4096) + 1);
+						sysfs_free(sra);
 					}
 				}
 				if (okcnt < (unsigned)content->array.raid_disks) {
-- 
1.7.6.4

