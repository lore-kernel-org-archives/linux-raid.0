Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC9C9C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 15 Oct 2021 09:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B144B6101D
	for <linux-raid@archiver.kernel.org>; Fri, 15 Oct 2021 09:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236767AbhJOJ14 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 15 Oct 2021 05:27:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28488 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236567AbhJOJ1z (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 15 Oct 2021 05:27:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634289948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+poaq75Kqhe+1vKp7PVa9mJQacrHCGg/eM3rcOJ8IQc=;
        b=UTgwcyVVKD8Ug1WHKyP0rJdEm8loJBPlI1zdc7tpcTvUQohe1W6PpOBuGnrNZu6F9ZfnnC
        /LpUDECN8kt20RClgZpFjsOH3lTdRApgFGeczXbzkk6+zMPLi+As9QvpYLrqXnuaGLS7NS
        jeJvn0gnzasHHHpBWmqNFBFvZYPtITM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-t5Wwzv19O_CAgsU39korqw-1; Fri, 15 Oct 2021 05:25:47 -0400
X-MC-Unique: t5Wwzv19O_CAgsU39korqw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89925803F44;
        Fri, 15 Oct 2021 09:25:46 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-33.pek2.redhat.com [10.72.8.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CEF0AB854B;
        Fri, 15 Oct 2021 09:25:22 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org
Cc:     ncroxon@redhat.com, ffan@redhat.com, linux-raid@vger.kernel.org
Subject: [PATCH 1/1] mdadm/Detail: Can't show container name correctly when unpluging disks
Date:   Fri, 15 Oct 2021 17:25:20 +0800
Message-Id: <1634289920-5037-1-git-send-email-xni@redhat.com>
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

This patch replaces map_dev_preferred with devid2kname. If
the name is NULL, it means the disk is unplug.

Fixes: db5377883fef (It should be FAILED when raid has)
Signed-off-by: Xiao Ni <xni@redhat.com>
Reported-by: Fine Fan <ffan@redhat.com>
---
 Detail.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/Detail.c b/Detail.c
index d3af0ab..2164de3 100644
--- a/Detail.c
+++ b/Detail.c
@@ -351,11 +351,13 @@ int Detail(char *dev, struct context *c)
 	avail = xcalloc(array.raid_disks, 1);
 
 	for (d = 0; d < array.raid_disks; d++) {
-		char *dv, *dv_rep;
-		dv = map_dev_preferred(disks[d*2].major,
-				disks[d*2].minor, 0, c->prefer);
-		dv_rep = map_dev_preferred(disks[d*2+1].major,
-				disks[d*2+1].minor, 0, c->prefer);
+		char *dv, *dv_rep = NULL;
+
+		if (!disks[d*2].major && !disks[d*2].minor)
+			continue;
+
+		dv = devid2kname(makedev(disks[d*2].major, disks[d*2].minor));
+		dv_rep = devid2kname(makedev(disks[d*2+1].major, disks[d*2+1].minor));
 
 		if ((dv && (disks[d*2].state & (1<<MD_DISK_SYNC))) ||
 		    (dv_rep && (disks[d*2+1].state & (1<<MD_DISK_SYNC)))) {
-- 
2.7.5

