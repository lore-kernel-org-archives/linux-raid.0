Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E40C433C1
	for <linux-raid@archiver.kernel.org>; Fri, 26 Mar 2021 12:00:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3D41619C2
	for <linux-raid@archiver.kernel.org>; Fri, 26 Mar 2021 12:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbhCZL7i (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 26 Mar 2021 07:59:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29086 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229738AbhCZL71 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 26 Mar 2021 07:59:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616759966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UmQWEQBreoFUlDa+zWQhW0IAjXbh2xuiOPsBrcHXiPM=;
        b=JWZmVtaD9zIEr4GGKVdpuaStsk3EBkCmowmD7pYiifimHWUIA7YC9FU9dHgPBEYUMlnN56
        d4GarCO1ICVOvPf71e0xV8dJn3z1A+JnuMP8ftwdQhBo97OomIOpghZdrfFFVkj00G24xC
        5hZSZFxpm00U38CNgokwE/HSmX+K+F8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-xg6d_QJ3N4CWF6sVhQ4P2A-1; Fri, 26 Mar 2021 07:59:24 -0400
X-MC-Unique: xg6d_QJ3N4CWF6sVhQ4P2A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 155031018F70;
        Fri, 26 Mar 2021 11:59:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E3222608BA;
        Fri, 26 Mar 2021 11:59:22 +0000 (UTC)
Received: from zmail24.collab.prod.int.phx2.redhat.com (zmail24.collab.prod.int.phx2.redhat.com [10.5.83.30])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 97BD04BB7B;
        Fri, 26 Mar 2021 11:59:22 +0000 (UTC)
Date:   Fri, 26 Mar 2021 07:59:22 -0400 (EDT)
From:   Nigel Croxon <ncroxon@redhat.com>
To:     Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
Cc:     linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Jes Sorensen <jes@trained-monkey.org>
Message-ID: <1876594627.1682680.1616759962103.JavaMail.zimbra@redhat.com>
In-Reply-To: <b77b55d3-d9b2-fac9-c756-fabced0546a0@linux.intel.com>
References: <764426808.38181143.1615910368475.JavaMail.zimbraredhat!com> <08b71ea7-bdd3-722d-d18f-aa065b8756c0@linux.intel.com> <207580597.39647667.1616433400775.JavaMail.zimbra@redhat.com> <5339fdf7-0d8a-e099-1fc4-be42a08c8ad3@linux.intel.com> <1361244809.39731072.1616517370775.JavaMail.zimbra@redhat.com> <b77b55d3-d9b2-fac9-c756-fabced0546a0@linux.intel.com>
Subject: Re: [PATCH] mdadm: fix reshape from RAID5 to RAID6 with backup file
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.113.141, 10.4.195.27]
Thread-Topic: mdadm: fix reshape from RAID5 to RAID6 with backup file
Thread-Index: WA1w+jswwFzB7LPNLopPODGH/uTkag==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



----- Original Message -----
From: "Oleksandr Shchirskyi" <oleksandr.shchirskyi@linux.intel.com>
To: "Nigel Croxon" <ncroxon@redhat.com>
Cc: linux-raid@vger.kernel.org, "Mariusz Tkaczyk" <mariusz.tkaczyk@linux.intel.com>, "Jes Sorensen" <jes@trained-monkey.org>
Sent: Tuesday, March 23, 2021 4:58:27 PM
Subject: Re: [PATCH] mdadm: fix reshape from RAID5 to RAID6 with backup file

On 3/23/2021 5:36 PM, Nigel Croxon wrote:
> Oleksandr,
> Can you post your dmesg output when running the commands?
> 
> I've back down from 5.11 to 5.8 and I still see:
> [  +0.042694] md/raid0:md126: raid5 must have missing parity disk!
> [  +0.000001] md: md126: raid0 would not accept array
> 
> Thanks, Nigel

Hello Nigel,

I've switched to 4.18.0-240.el8.x86_64 kernel (I have RHEL8.3) and I still 
have the same results, issue is still easily reproducible when patch 
4ae96c8 is applied.

Cropped test logs with and w/o your patch:

# git log -n1 --oneline
f94df5c (HEAD -> master, origin/master, origin/HEAD) imsm: support for 
third Sata controller
# make clean; make; make install-systemd; make install
# mdadm -CR imsm0 -e imsm -n4 /dev/nvme[0-3]n1 && mdadm -CR volume -l0 
--chunk 64 --size=10G --raid-devices=1 /dev/nvme0n1 --force
# mdadm -G /dev/md/imsm0 -n2
# dmesg -c
[  393.530389] md126: detected capacity change from 0 to 10737418240
[  407.139318] md/raid:md126: device nvme0n1 operational as raid disk 0
[  407.153920] md/raid:md126: raid level 4 active with 1 out of 2 devices, 
algorithm 5
[  407.246037] md: reshape of RAID array md126
[  407.357940] md: md126: reshape interrupted.
[  407.388144] md: reshape of RAID array md126
[  407.398737] md: md126: reshape interrupted.
[  407.403486] md: reshape of RAID array md126
[  459.414250] md: md126: reshape done.
# cat /proc/mdstat
Personalities : [raid0] [raid6] [raid5] [raid4]
md126 : active raid4 nvme3n1[2] nvme0n1[0]
       10485760 blocks super external:/md127/0 level 4, 64k chunk, 
algorithm 0 [3/2] [UU_]

md127 : inactive nvme3n1[3](S) nvme2n1[2](S) nvme1n1[1](S) nvme0n1[0](S)
       4420 blocks super external:imsm

unused devices: <none>

# mdadm -Ss; wipefs -a /dev/nvme[0-3]n1
# dmesg -C
# git revert 4ae96c802203ec3cfbb089240c56d61f7f4661b3
# make clean; make; make install-systemd; make install
# mdadm -CR imsm0 -e imsm -n4 /dev/nvme[0-3]n1 && mdadm -CR volume -l0 
--chunk 64 --size=10G --raid-devices=1 /dev/nvme0n1 --force
# mdadm -G /dev/md/imsm0 -n2
# dmesg -c
[  623.772039] md126: detected capacity change from 0 to 10737418240
[  644.823245] md/raid:md126: device nvme0n1 operational as raid disk 0
[  644.838542] md/raid:md126: raid level 4 active with 1 out of 2 devices, 
algorithm 5
[  644.928672] md: reshape of RAID array md126
[  697.405351] md: md126: reshape done.
[  697.409659] md126: detected capacity change from 10737418240 to 21474836480
# cat /proc/mdstat
Personalities : [raid0] [raid6] [raid5] [raid4]
md126 : active raid0 nvme3n1[2] nvme0n1[0]
       20971520 blocks super external:/md127/0 64k chunks

md127 : inactive nvme3n1[3](S) nvme2n1[2](S) nvme1n1[1](S) nvme0n1[0](S)
       4420 blocks super external:imsm


Do you need more detailed logs? My system/drives configuration details?

Regards,
Oleksandr Shchirskyi




From f0c80c8e90b2ce113b6e22f919659430d3d20efa Mon Sep 17 00:00:00 2001
From: Nigel Croxon <ncroxon@redhat.com>
Date: Fri, 26 Mar 2021 07:56:10 -0400
Subject: [PATCH] mdadm: fix growing containers

This fixes growing containers which was broken with
commit 4ae96c802203ec3c (mdadm: fix reshape from RAID5 to RAID6 with
backup file)

The issue being that containers use the function
wait_for_reshape_isms and expect a number value and not a
string value of "max".  The change is to test for external
before setting the correct value.

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
---
 Grow.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/Grow.c b/Grow.c
index 1120929..de28540 100644
--- a/Grow.c
+++ b/Grow.c
@@ -921,7 +921,7 @@ static int subarray_set_num(char *container, struct mdinfo *sra, char *name, int
 }
 
 int start_reshape(struct mdinfo *sra, int already_running,
-		  int before_data_disks, int data_disks)
+		  int before_data_disks, int data_disks, struct supertype *st)
 {
 	int err;
 	unsigned long long sync_max_to_set;
@@ -935,20 +935,23 @@ int start_reshape(struct mdinfo *sra, int already_running,
 	else
 		sync_max_to_set = (sra->component_size * data_disks
 				   - sra->reshape_progress) / data_disks;
+
 	if (!already_running)
 		sysfs_set_num(sra, NULL, "sync_min", sync_max_to_set);
-	err = err ?: sysfs_set_num(sra, NULL, "sync_max", sync_max_to_set);
+
+        if (st->ss->external) 
+		err = err ?: sysfs_set_num(sra, NULL, "sync_max", sync_max_to_set);
+	else
+		err = err ?: sysfs_set_str(sra, NULL, "sync_max", "max");
+
 	if (!already_running && err == 0) {
 		int cnt = 5;
-		int err2;
 		do {
 			err = sysfs_set_str(sra, NULL, "sync_action",
 					    "reshape");
-			err2 = sysfs_set_str(sra, NULL, "sync_max",
-					    "max");
-			if (err || err2)
+			if (err)
 				sleep(1);
-		} while (err && err2 && errno == EBUSY && cnt-- > 0);
+		} while (err && errno == EBUSY && cnt-- > 0);
 	}
 	return err;
 }
@@ -3470,7 +3473,7 @@ started:
 		goto release;
 
 	err = start_reshape(sra, restart, reshape.before.data_disks,
-			    reshape.after.data_disks);
+			    reshape.after.data_disks, st);
 	if (err) {
 		pr_err("Cannot %s reshape for %s\n",
 		       restart ? "continue" : "start", devname);
-- 
2.27.0



