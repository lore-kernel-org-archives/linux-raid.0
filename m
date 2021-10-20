Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF17CC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 20 Oct 2021 14:38:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE5E1613A4
	for <linux-raid@archiver.kernel.org>; Wed, 20 Oct 2021 14:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhJTOlN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Oct 2021 10:41:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41262 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229952AbhJTOlM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 20 Oct 2021 10:41:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634740737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6FC09ZllvgS7lnsqRbcyggmk930GXbur/nz7jEPWHs0=;
        b=ILqJ9Z1q0IL7qHAIDBbpxHHMNbZ4iBMVE1oGwzyg+yoEvdPNhPTWihQBis1LasSH4F7LVM
        imrLkndYgPrL+6qV+l1uuZz4m02fuc2A60D+VRu0HTKdO27cbyeeRIEbwOi3uHO8IfV9Sq
        lC0pw2nPLBlcAsWuS67BGsEDS39z9M0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-3d3wZUW_MxuR_hcH6zc_og-1; Wed, 20 Oct 2021 10:38:52 -0400
X-MC-Unique: 3d3wZUW_MxuR_hcH6zc_og-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88AF18066EF;
        Wed, 20 Oct 2021 14:38:51 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-30.pek2.redhat.com [10.72.8.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 06418708E2;
        Wed, 20 Oct 2021 14:38:48 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org
Cc:     ncroxon@redhat.com, ffan@redhat.com,
        mariusz.tkaczyk@linux.intel.com, linux-raid@vger.kernel.org
Subject: [PATCH 1/1] mdadm/Detail: Can't show container name correctly when unpluging disks
Date:   Wed, 20 Oct 2021 22:38:43 +0800
Message-Id: <1634740723-5298-1-git-send-email-xni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The test case is:
1. create one imsm container
2. create a raid5 device from the container
3. unplug two disks
4. mdadm --detail /dev/md126
[root@rhel85 ~]# mdadm -D /dev/md126
/dev/md126:
         Container : ��, member 0

The Detail function first gets container name by function
map_dev_preferred. Then it tries to find which disks are
available. In patch db5377883fef(It should be FAILED..)
uses map_dev_preferred to find which disks are under /dev.

But now, the major/minor information comes from kernel space.
map_dev_preferred malloc memory and init a device list when
first be called by Detail. It can't find the device in the
list by the major/minor. It free the memory and reinit the
list.

The container name now points to an area tha has been freed.
So the containt is a mess.

This patch replaces map_dev_preferred with access.

Fixes: db5377883fef (It should be FAILED when raid has)
Signed-off-by: Xiao Ni <xni@redhat.com>
Reported-by: Fine Fan <ffan@redhat.com>
---
v2: use access rather than devid2kname
---
 Detail.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/Detail.c b/Detail.c
index d3af0ab..df59378 100644
--- a/Detail.c
+++ b/Detail.c
@@ -351,14 +351,17 @@ int Detail(char *dev, struct context *c)
 	avail = xcalloc(array.raid_disks, 1);
 
 	for (d = 0; d < array.raid_disks; d++) {
-		char *dv, *dv_rep;
-		dv = map_dev_preferred(disks[d*2].major,
-				disks[d*2].minor, 0, c->prefer);
-		dv_rep = map_dev_preferred(disks[d*2+1].major,
-				disks[d*2+1].minor, 0, c->prefer);
-
-		if ((dv && (disks[d*2].state & (1<<MD_DISK_SYNC))) ||
-		    (dv_rep && (disks[d*2+1].state & (1<<MD_DISK_SYNC)))) {
+		char dv[32], dv_rep[32];
+
+		sprintf(dv, "/sys/dev/block/%d:%d",
+				disks[d*2].major, disks[d*2].minor);
+		sprintf(dv_rep, "/sys/dev/block/%d:%d",
+				disks[d*2+1].major, disks[d*2+1].minor);
+
+		if ((!access(dv, R_OK) &&
+		    (disks[d*2].state & (1<<MD_DISK_SYNC))) ||
+		    (!access(dv_rep, R_OK) &&
+		    (disks[d*2+1].state & (1<<MD_DISK_SYNC)))) {
 			avail_disks ++;
 			avail[d] = 1;
 		} else
-- 
2.7.5

