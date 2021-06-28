Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEEBFC49EAB
	for <linux-raid@archiver.kernel.org>; Mon, 28 Jun 2021 12:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1BD261279
	for <linux-raid@archiver.kernel.org>; Mon, 28 Jun 2021 12:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbhF1M2C (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 28 Jun 2021 08:28:02 -0400
Received: from mga07.intel.com ([134.134.136.100]:23569 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232802AbhF1M2C (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 28 Jun 2021 08:28:02 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10028"; a="271798946"
X-IronPort-AV: E=Sophos;i="5.83,306,1616482800"; 
   d="scan'208";a="271798946"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2021 05:25:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,306,1616482800"; 
   d="scan'208";a="640885663"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.102.57])
  by fmsmga006.fm.intel.com with ESMTP; 28 Jun 2021 05:25:14 -0700
From:   Mateusz Grzonka <mateusz.grzonka@intel.com>
To:     linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org
Subject: [PATCH] imsm: Fix possible memory leaks and refactor freeing struct dl
Date:   Mon, 28 Jun 2021 14:15:04 +0200
Message-Id: <20210628121504.2334-1-mateusz.grzonka@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Free memory allocated by structs dl and intel_super.
Allow __free_imsm_disk to decide if fd has to be closed and propagate it
across code instead of direct struct dl freeing.

Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
---
 super-intel.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index fe45d933..09e784d6 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4535,9 +4535,9 @@ load_and_parse_mpb(int fd, struct intel_super *super, char *devname, int keep_fd
 	return err;
 }
 
-static void __free_imsm_disk(struct dl *d)
+static void __free_imsm_disk(struct dl *d, int close_fd)
 {
-	if (d->fd >= 0)
+	if (close_fd && d->fd > -1)
 		close(d->fd);
 	if (d->devname)
 		free(d->devname);
@@ -4554,17 +4554,17 @@ static void free_imsm_disks(struct intel_super *super)
 	while (super->disks) {
 		d = super->disks;
 		super->disks = d->next;
-		__free_imsm_disk(d);
+		__free_imsm_disk(d, 1);
 	}
 	while (super->disk_mgmt_list) {
 		d = super->disk_mgmt_list;
 		super->disk_mgmt_list = d->next;
-		__free_imsm_disk(d);
+		__free_imsm_disk(d, 1);
 	}
 	while (super->missing) {
 		d = super->missing;
 		super->missing = d->next;
-		__free_imsm_disk(d);
+		__free_imsm_disk(d, 1);
 	}
 
 }
@@ -5279,10 +5279,13 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
 	free_super_imsm(st);
 
 	super = alloc_super();
-	if (!get_dev_sector_size(fd, NULL, &super->sector_size))
-		return 1;
 	if (!super)
 		return 1;
+
+	if (!get_dev_sector_size(fd, NULL, &super->sector_size)) {
+		free_imsm(super);
+		return 1;
+	}
 	/* Load hba and capabilities if they exist.
 	 * But do not preclude loading metadata in case capabilities or hba are
 	 * non-compliant and ignore_hw_compat is set.
@@ -5920,9 +5923,7 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 	rv = imsm_read_serial(fd, devname, dd->serial, MAX_RAID_SERIAL_LEN);
 	if (rv) {
 		pr_err("failed to retrieve scsi serial, aborting\n");
-		if (dd->devname)
-			free(dd->devname);
-		free(dd);
+		__free_imsm_disk(dd, 0);
 		abort();
 	}
 
@@ -5936,10 +5937,7 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 		if (!diskfd_to_devpath(fd, 2, pci_dev_path) ||
 		    !diskfd_to_devpath(fd, 1, cntrl_path)) {
 			pr_err("failed to get dev paths, aborting\n");
-
-			if (dd->devname)
-				free(dd->devname);
-			free(dd);
+			__free_imsm_disk(dd, 0);
 			return 1;
 		}
 
@@ -5975,15 +5973,16 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 		    !imsm_orom_has_tpv_support(super->orom)) {
 			pr_err("\tPlatform configuration does not support non-Intel NVMe drives.\n"
 			       "\tPlease refer to Intel(R) RSTe/VROC user guide.\n");
-			free(dd->devname);
-			free(dd);
+			__free_imsm_disk(dd, 0);
 			return 1;
 		}
 	}
 
 	get_dev_size(fd, NULL, &size);
-	if (!get_dev_sector_size(fd, NULL, &member_sector_size))
+	if (!get_dev_sector_size(fd, NULL, &member_sector_size)) {
+		__free_imsm_disk(dd, 0);
 		return 1;
+	}
 
 	if (super->sector_size == 0) {
 		/* this a first device, so sector_size is not set yet */
@@ -9296,7 +9295,7 @@ static int remove_disk_super(struct intel_super *super, int major, int minor)
 			else
 				super->disks = dl->next;
 			dl->next = NULL;
-			__free_imsm_disk(dl);
+			__free_imsm_disk(dl, 1);
 			dprintf("removed %x:%x\n", major, minor);
 			break;
 		}
@@ -9346,7 +9345,7 @@ static int add_remove_disk_update(struct intel_super *super)
 				}
 			}
 			/* release allocate disk structure */
-			__free_imsm_disk(disk_cfg);
+			__free_imsm_disk(disk_cfg, 1);
 		}
 	}
 	return check_degraded;
@@ -10547,7 +10546,7 @@ static void imsm_delete(struct intel_super *super, struct dl **dlp, unsigned ind
 		struct dl *dl = *dlp;
 
 		*dlp = (*dlp)->next;
-		__free_imsm_disk(dl);
+		__free_imsm_disk(dl, 1);
 	}
 }
 
-- 
2.26.2

Intel Technology Poland sp. z o.o.
ul. Sowackiego 173 | 80-298 Gdask | Sd Rejonowy Gdask Pnoc | VII Wydzia Gospodarczy Krajowego Rejestru Sdowego - KRS 101882 | NIP 957-07-52-316 | Kapita zakadowy 200.000 PLN.
Ta wiadomo wraz z zacznikami jest przeznaczona dla okrelonego adresata i moe zawiera informacje poufne. W razie przypadkowego otrzymania tej wiadomoci, prosimy o powiadomienie nadawcy oraz trwae jej usunicie; jakiekolwiek przegldanie lub rozpowszechnianie jest zabronione.
This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). If you are not the intended recipient, please contact the sender and delete all copies; any review or distribution by others is strictly prohibited.

