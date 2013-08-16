From: mwilck@arcor.de
Subject: [PATCH 2/6] DDF: export_examine_super_ddf: print MD_DEVICES
Date: Fri, 16 Aug 2013 20:21:56 +0200
Message-ID: <1376677320-12816-3-git-send-email-mwilck@arcor.de>
References: <1376677320-12816-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1376677320-12816-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Have mdadm -E --export print the number of RAID devices,
like other meta data formats do. Anaconda (RHEL/CentOS installer)
depends on it.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 95972ad..013bb9d 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1593,6 +1593,8 @@ static void export_examine_super_ddf(struct supertype *st)
 	printf("MD_METADATA=ddf\n");
 	printf("MD_LEVEL=container\n");
 	printf("MD_UUID=%s\n", nbuf+5);
+	printf("MD_DEVICES=%u\n",
+		be16_to_cpu(((struct ddf_super *)st->sb)->phys->used_pdes));
 }
 
 static int copy_metadata_ddf(struct supertype *st, int from, int to)
-- 
1.7.3.4
