Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C33F9C433FE
	for <linux-raid@archiver.kernel.org>; Wed, 27 Oct 2021 12:23:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B03AD60F9B
	for <linux-raid@archiver.kernel.org>; Wed, 27 Oct 2021 12:23:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237338AbhJ0M0P (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Oct 2021 08:26:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40627 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241874AbhJ0M0O (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 27 Oct 2021 08:26:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635337428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cQEhrQrdWG2yCOcc1xtMcrZkeh5jbpCfA4zlyZsL7dw=;
        b=a+WIiV5YTNGvAXSEUTib6++y0T1GGk87+VLDNTU7+QFU3B/eNnGJnKa+RfcuVDz81V2oSI
        uuhOKZaDdyqfixAobumGUZvOkJGqgNUz6qhi7yYAhfWxOexfdIPtHaTRmjmPWwEJuIrS1C
        AQ3JVZkPzumaUihtimypYYlkcYxeh54=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-_eVbBiS3ObOc-sIes2l6SA-1; Wed, 27 Oct 2021 08:23:45 -0400
X-MC-Unique: _eVbBiS3ObOc-sIes2l6SA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B599F101D61F;
        Wed, 27 Oct 2021 12:23:44 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-12-102.pek2.redhat.com [10.72.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D4EF5C1B4;
        Wed, 27 Oct 2021 12:23:42 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org
Cc:     ncroxon@redhat.com, ffan@redhat.com,
        mariusz.tkaczyk@linux.intel.com, linux-raid@vger.kernel.org
Subject: [PATCH 2/2] mdadm/Detail: Can't show container name correctly when unpluging disks
Date:   Wed, 27 Oct 2021 20:23:14 +0800
Message-Id: <1635337394-4782-3-git-send-email-xni@redhat.com>
In-Reply-To: <1635337394-4782-1-git-send-email-xni@redhat.com>
References: <1635337394-4782-1-git-send-email-xni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 Detail.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/Detail.c b/Detail.c
index d3af0ab..95d4cc7 100644
--- a/Detail.c
+++ b/Detail.c
@@ -351,14 +351,14 @@ int Detail(char *dev, struct context *c)
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
+		char dv[PATH_MAX], dv_rep[PATH_MAX];
+		snprintf(dv, PATH_MAX, "/sys/dev/block/%d:%d",
+			disks[d*2].major, disks[d*2].minor);
+		snprintf(dv_rep, PATH_MAX, "/sys/dev/block/%d:%d",
+			disks[d*2+1].major, disks[d*2+1].minor);
+
+		if ((is_dev_alive(dv) && (disks[d*2].state & (1<<MD_DISK_SYNC))) ||
+		    (is_dev_alive(dv_rep) && (disks[d*2+1].state & (1<<MD_DISK_SYNC)))) {
 			avail_disks ++;
 			avail[d] = 1;
 		} else
-- 
2.7.5

