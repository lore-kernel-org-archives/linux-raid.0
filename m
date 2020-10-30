Return-Path: <SRS0=hsaE=EF=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3192FC4363A
	for <linux-raid@archiver.kernel.org>; Fri, 30 Oct 2020 12:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B13802071A
	for <linux-raid@archiver.kernel.org>; Fri, 30 Oct 2020 12:38:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ST5QfiGn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgJ3Mia (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 30 Oct 2020 08:38:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20215 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725863AbgJ3Mi3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 30 Oct 2020 08:38:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604061508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=+f/QP4CQnBh6pt6eSEIvYodWw2EULr/hAnCTVNGrUSc=;
        b=ST5QfiGn5eoAqwfwrLYoVVK1c8M4dAdaeFiZ0Gt1t8pGXRlcoHP5uABPI7hzytUDhbC6Rp
        DUTxbFZ7DrDo47PW46cUtvMONExv2+VW6oCyd9RHTYF0fHK4MocIfIQz7zYSmueD/MbZwp
        R701rNgU+lvpnnlEk2GOIunw2J7UC+k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-jZof45cMNHKXtCyD509XkQ-1; Fri, 30 Oct 2020 08:38:24 -0400
X-MC-Unique: jZof45cMNHKXtCyD509XkQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EAF14922A80
        for <linux-raid@vger.kernel.org>; Fri, 30 Oct 2020 12:38:23 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-36.pek2.redhat.com [10.72.8.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CACD5C1C4;
        Fri, 30 Oct 2020 12:38:18 +0000 (UTC)
To:     linux-raid <linux-raid@vger.kernel.org>
Cc:     Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>
From:   Xiao Ni <xni@redhat.com>
Subject: The raid device can't be unmount when it can't work
Message-ID: <9b6db7d5-4a34-a1f9-2314-5e3522555052@redhat.com>
Date:   Fri, 30 Oct 2020 20:38:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------3D45F46B3C8CC3A18B6E15EC"
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This is a multi-part message in MIME format.
--------------3D45F46B3C8CC3A18B6E15EC
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi all

When one raid loses disks that are bigger than the max degraded number, 
the udev rule[1] tries to stop
the raid device. If the raid device is mount, it tries to unmount it 
first[2]. It uses udisks command to do this.
It's a little old. Now the package version is udisks2 which uses 
udisksctl to do this. I write a patch[3] and do
test. It's failed because of "udisksctl error Permission denied".

The first test:
[root@localhost ~]# mdadm -CR /dev/md0 -l5 -n3 /dev/sdg /dev/sdi 
/dev/sdj --assume-clean
[root@localhost ~]# mkfs.xfs /dev/md0
[root@localhost ~]# mount /dev/md0 /mnt/test/
[root@localhost ~]# mdadm -If sdg
mdadm: set sdg faulty in md0
mdadm: hot removed sdg from md0
[root@localhost ~]# mdadm -If sdi
mdadm: set device faulty failed for sdi:  Device or resource busy
Unmounted /dev/md0.

The patch works as expected.

The second test:
[root@localhost ~]# mdadm -CR /dev/md0 -l5 -n3 /dev/sdg /dev/sdi 
/dev/sdj --assume-clean
[root@localhost ~]# mkfs.xfs /dev/md0
[root@localhost ~]# mount /dev/md0 /mnt/test/
[root@localhost ~]# echo "scsi remove-single-device 6 0 0 0" > 
/proc/scsi/scsi
[root@localhost ~]# echo "scsi remove-single-device 7 0 0 0" > 
/proc/scsi/scsi
The /dev/md0 is still mount. The patch doesn't work as expected. Logs 
are added during the test. It reports
error "udisksctl error Permission denied"

I searched in google to find the reason. It says it needs to config 
polkit[4]. I did but it didn't work.

The patch is in the attachment
[1]: udev-md-raid-assembly.rules
[2]: IncrementalRemove->force_remove
[3]: The patch is in the attachment
[4]: https://github.com/coldfix/udiskie/wiki/Permissions

Best Regards
Xiao

--------------3D45F46B3C8CC3A18B6E15EC
Content-Type: text/x-patch;
 name="0001-change-udisks-to-udisksctl.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-change-udisks-to-udisksctl.patch"

From 0e5b3833da9ba3b663224daf91eb67e8b55a31c4 Mon Sep 17 00:00:00 2001
From: Xiao Ni <xni@redhat.com>
Date: Mon, 26 Oct 2020 23:21:10 +0800
Subject: [PATCH 1/1] mdadm/Incremental: change udisks to udisksctl

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Incremental.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 98dbcd9..64c9b48 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1679,8 +1679,8 @@ static void run_udisks(char *arg1, char *arg2)
 	int pid = fork();
 	int status;
 	if (pid == 0) {
-		execl("/usr/bin/udisks", "udisks", arg1, arg2, NULL);
-		execl("/bin/udisks", "udisks", arg1, arg2, NULL);
+		execl("/usr/bin/udisksctl", "udisksctl", arg1, "-b", arg2, NULL);
+		execl("/bin/udisksctl", "udisksctl", arg1, "-b", arg2, NULL);
 		exit(1);
 	}
 	while (pid > 0 && wait(&status) != pid)
@@ -1692,7 +1692,7 @@ static int force_remove(char *devnm, int fd, struct mdinfo *mdi, int verbose)
 	int rv;
 	int devid = devnm2devid(devnm);
 
-	run_udisks("--unmount", map_dev(major(devid), minor(devid), 0));
+	run_udisks("unmount", map_dev(major(devid), minor(devid), 0));
 	rv = Manage_stop(devnm, fd, verbose, 1);
 	if (rv) {
 		/* At least we can try to trigger a 'remove' */
-- 
2.7.5


--------------3D45F46B3C8CC3A18B6E15EC--

