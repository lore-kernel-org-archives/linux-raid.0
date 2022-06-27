Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E210C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 27 Jun 2022 13:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234641AbiF0NCE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 27 Jun 2022 09:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234633AbiF0NBu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 27 Jun 2022 09:01:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C3A511831
        for <linux-raid@vger.kernel.org>; Mon, 27 Jun 2022 06:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656334848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=4HyH3a8FtjOp1ox2IMkKrOb2s2lnRFgSqxkTIf1h8yk=;
        b=TsIkFSWA+q91D9JTlO5TUE0e6D8DtCVEfVm4uRcQsS5B7e0l+SqJG3/VYrgSk9upHF+VME
        1ZHaHikhDISnWjxvyt6e2e8fFXTGM6ESFBuPIfWhFZNx8aTzm4njVHkcNK3Vxou/BpOUVA
        SFXZBQmVqJxX47Htj3gtg1t0NIIcBRo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-qXrx_jpVPHSM-l4BGd6FxQ-1; Mon, 27 Jun 2022 09:00:42 -0400
X-MC-Unique: qXrx_jpVPHSM-l4BGd6FxQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DD9F802C17;
        Mon, 27 Jun 2022 13:00:42 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4047A400F8FD;
        Mon, 27 Jun 2022 13:00:42 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 25RD0gTV014941;
        Mon, 27 Jun 2022 09:00:42 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 25RD0guI014937;
        Mon, 27 Jun 2022 09:00:42 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Mon, 27 Jun 2022 09:00:42 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Mike Snitzer <msnitzer@redhat.com>, Song Liu <song@kernel.org>
cc:     Benjamin Marzinski <bmarzins@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Marian Csontos <mcsontos@redhat.com>,
        Ming Lei <minlei@redhat.com>, dm-devel@redhat.com,
        linux-raid@vger.kernel.org
Subject: [PATCH] dm-raid: fix out of memory accesses in dm-raid
Message-ID: <alpine.LRH.2.02.2206270858520.13562@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

dm-raid allocates the array of devices with rs->raid_disks entries and
then accesses it in a loop for rs->md.raid_disks. During reshaping,
rs->md.raid_disks may be greater than rs->raid_disks, so it accesses
entries beyond the end of the array.

We fix this bug by limiting the iteration to rs->raid_disks.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-raid.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c	2022-06-27 14:45:30.000000000 +0200
+++ linux-2.6/drivers/md/dm-raid.c	2022-06-27 14:54:02.000000000 +0200
@@ -1004,7 +1004,7 @@ static int validate_raid_redundancy(stru
 	unsigned int rebuilds_per_group = 0, copies;
 	unsigned int group_size, last_group_start;
 
-	for (i = 0; i < rs->md.raid_disks; i++)
+	for (i = 0; i < rs->md.raid_disks && i < rs->raid_disks; i++)
 		if (!test_bit(In_sync, &rs->dev[i].rdev.flags) ||
 		    !rs->dev[i].rdev.sb_page)
 			rebuild_cnt++;
@@ -1047,7 +1047,7 @@ static int validate_raid_redundancy(stru
 		 *	    C	 D    D	   E	E
 		 */
 		if (__is_raid10_near(rs->md.new_layout)) {
-			for (i = 0; i < rs->md.raid_disks; i++) {
+			for (i = 0; i < rs->md.raid_disks && i < rs->raid_disks; i++) {
 				if (!(i % copies))
 					rebuilds_per_group = 0;
 				if ((!rs->dev[i].rdev.sb_page ||
@@ -1073,7 +1073,7 @@ static int validate_raid_redundancy(stru
 		group_size = (rs->md.raid_disks / copies);
 		last_group_start = (rs->md.raid_disks / group_size) - 1;
 		last_group_start *= group_size;
-		for (i = 0; i < rs->md.raid_disks; i++) {
+		for (i = 0; i < rs->md.raid_disks && i < rs->raid_disks; i++) {
 			if (!(i % copies) && !(i > last_group_start))
 				rebuilds_per_group = 0;
 			if ((!rs->dev[i].rdev.sb_page ||
@@ -1588,7 +1588,7 @@ static sector_t __rdev_sectors(struct ra
 {
 	int i;
 
-	for (i = 0; i < rs->md.raid_disks; i++) {
+	for (i = 0; i < rs->md.raid_disks && i < rs->raid_disks; i++) {
 		struct md_rdev *rdev = &rs->dev[i].rdev;
 
 		if (!test_bit(Journal, &rdev->flags) &&
@@ -3766,7 +3766,7 @@ static int raid_iterate_devices(struct d
 	unsigned int i;
 	int r = 0;
 
-	for (i = 0; !r && i < rs->md.raid_disks; i++)
+	for (i = 0; !r && i < rs->md.raid_disks && i < rs->raid_disks; i++)
 		if (rs->dev[i].data_dev)
 			r = fn(ti,
 				 rs->dev[i].data_dev,
@@ -3817,7 +3817,7 @@ static void attempt_restore_of_faulty_de
 
 	memset(cleared_failed_devices, 0, sizeof(cleared_failed_devices));
 
-	for (i = 0; i < mddev->raid_disks; i++) {
+	for (i = 0; i < mddev->raid_disks && i < rs->raid_disks; i++) {
 		r = &rs->dev[i].rdev;
 		/* HM FIXME: enhance journal device recovery processing */
 		if (test_bit(Journal, &r->flags))

