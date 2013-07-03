From: mwilck@arcor.de
Subject: [PATCH 03/27] DDF: load_ddf_headers: use secondary header as fallback
Date: Wed,  3 Jul 2013 22:27:43 +0200
Message-ID: <1372883287-8859-4-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

When the primary header can't be read, use the secondary header
as fallback.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index c445df2..45522f2 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -601,15 +601,15 @@ static int load_ddf_headers(int fd, struct ddf_super *super, char *devname)
 				DDF_REVISION_2, super->anchor.revision,devname);
 		return 2;
 	}
+	super->active = NULL;
 	if (load_ddf_header(fd, __be64_to_cpu(super->anchor.primary_lba),
 			    dsize >> 9,  1,
 			    &super->primary, &super->anchor) == 0) {
 		if (devname)
 			pr_err("Failed to load primary DDF header "
 			       "on %s\n", devname);
-		return 2;
-	}
-	super->active = &super->primary;
+	} else
+		super->active = &super->primary;
 	if (load_ddf_header(fd, __be64_to_cpu(super->anchor.secondary_lba),
 			    dsize >> 9,  2,
 			    &super->secondary, &super->anchor)) {
@@ -619,9 +619,14 @@ static int load_ddf_headers(int fd, struct ddf_super *super, char *devname)
 		    || (__be32_to_cpu(super->primary.seq)
 			== __be32_to_cpu(super->secondary.seq) &&
 			super->primary.openflag && !super->secondary.openflag)
+		    || super->active == NULL
 			)
 			super->active = &super->secondary;
-	}
+	} else if (devname)
+		pr_err("Failed to load secondary DDF header on %s\n",
+		       devname);
+	if (super->active == NULL)
+		return 2;
 	return 0;
 }
 
-- 
1.7.1
