From: mwilck@arcor.de
Subject: [PATCH 04/27] DDF: handle "open flag" according to spec
Date: Wed,  3 Jul 2013 22:27:44 +0200
Message-ID: <1372883287-8859-5-git-send-email-mwilck@arcor.de>
References: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372883287-8859-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

The DDF spec mandates that the "open flag" be set to non-0 before
writing a configuration, and reset to 0 when finished to indicate
success.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 45522f2..b806949 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -2518,6 +2518,7 @@ static int __write_ddf_structure(struct dl *d, struct ddf_super *ddf, __u8 type,
 	unsigned long long sector;
 	struct ddf_header *header;
 	int fd, i, n_config, conf_size;
+	int ret = 0;
 
 	fd = d->fd;
 
@@ -2535,23 +2536,23 @@ static int __write_ddf_structure(struct dl *d, struct ddf_super *ddf, __u8 type,
 	}
 
 	header->type = type;
-	header->openflag = 0;
+	header->openflag = 1;
 	header->crc = calc_crc(header, 512);
 
 	lseek64(fd, sector<<9, 0);
 	if (write(fd, header, 512) < 0)
-		return 0;
+		goto out;
 
 	ddf->controller.crc = calc_crc(&ddf->controller, 512);
 	if (write(fd, &ddf->controller, 512) < 0)
-		return 0;
+		goto out;
 
 	ddf->phys->crc = calc_crc(ddf->phys, ddf->pdsize);
 	if (write(fd, ddf->phys, ddf->pdsize) < 0)
-		return 0;
+		goto out;
 	ddf->virt->crc = calc_crc(ddf->virt, ddf->vdsize);
 	if (write(fd, ddf->virt, ddf->vdsize) < 0)
-		return 0;
+		goto out;
 
 	/* Now write lots of config records. */
 	n_config = ddf->max_part;
@@ -2590,13 +2591,22 @@ static int __write_ddf_structure(struct dl *d, struct ddf_super *ddf, __u8 type,
 		}
 	}
 	if (i <= n_config)
-		return 0;
+		goto out;
 
 	d->disk.crc = calc_crc(&d->disk, 512);
 	if (write(fd, &d->disk, 512) < 0)
-		return 0;
+		goto out;
 
-	return 1;
+	ret = 1;
+out:
+	header->openflag = 0;
+	header->crc = calc_crc(header, 512);
+
+	lseek64(fd, sector<<9, 0);
+	if (write(fd, header, 512) < 0)
+		ret = 0;
+
+	return ret;
 }
 
 static int __write_init_super_ddf(struct supertype *st)
-- 
1.7.1
