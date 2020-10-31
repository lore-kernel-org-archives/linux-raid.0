Return-Path: <SRS0=7Xrs=EG=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B5AC00A89
	for <linux-raid@archiver.kernel.org>; Sat, 31 Oct 2020 00:49:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DBAE2087E
	for <linux-raid@archiver.kernel.org>; Sat, 31 Oct 2020 00:49:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F3PosETC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725616AbgJaAtX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 30 Oct 2020 20:49:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55916 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725536AbgJaAtW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 30 Oct 2020 20:49:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604105361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N03x8iuhKonf8WAAXwmSPomGjWl/OxJIYkM4iwb8pGo=;
        b=F3PosETCuesfZt7Goa1i1FNkgwh1l5vKJRpzyERYMubgc/Nr0Kjnenz9dx8YZb3wc2z0g1
        U/AmgDm/O79B4ECApBMxa5lD1oG2BMjMB/n0EZ58L5Z0GtQ+18/lkbjcRVEvN2G68mIYyJ
        QsGEIaaEvt9nQaf7d6VUBZdznK0d0x0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-HfkICe5ZNoeFzQrshiAMjw-1; Fri, 30 Oct 2020 20:49:18 -0400
X-MC-Unique: HfkICe5ZNoeFzQrshiAMjw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A4928015DB
        for <linux-raid@vger.kernel.org>; Sat, 31 Oct 2020 00:49:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 63E1B6EF6F
        for <linux-raid@vger.kernel.org>; Sat, 31 Oct 2020 00:49:17 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 57687180954D;
        Sat, 31 Oct 2020 00:49:17 +0000 (UTC)
Date:   Fri, 30 Oct 2020 20:49:16 -0400 (EDT)
From:   Xiao Ni <xni@redhat.com>
To:     linux-raid <linux-raid@vger.kernel.org>
Cc:     Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>
Message-ID: <505084787.23972105.1604105356558.JavaMail.zimbra@redhat.com>
In-Reply-To: <9b6db7d5-4a34-a1f9-2314-5e3522555052@redhat.com>
References: <9b6db7d5-4a34-a1f9-2314-5e3522555052@redhat.com>
Subject: Re: The raid device can't be unmount when it can't work
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.68.5.41, 10.4.195.4]
Thread-Topic: The raid device can't be unmount when it can't work
Thread-Index: xXHVDFYjT4qlsy4teszgcN+2GzzF7A==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

For convenient, paste the patch here:

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


----- Original Message -----
> From: "Xiao Ni" <xni@redhat.com>
> To: "linux-raid" <linux-raid@vger.kernel.org>
> Cc: "Heinz Mauelshagen" <heinzm@redhat.com>, "Nigel Croxon" <ncroxon@redhat.com>
> Sent: Friday, October 30, 2020 8:38:16 PM
> Subject: The raid device can't be unmount when it can't work
> 
> Hi all
> 
> When one raid loses disks that are bigger than the max degraded number,
> the udev rule[1] tries to stop
> the raid device. If the raid device is mount, it tries to unmount it
> first[2]. It uses udisks command to do this.
> It's a little old. Now the package version is udisks2 which uses
> udisksctl to do this. I write a patch[3] and do
> test. It's failed because of "udisksctl error Permission denied".
> 
> The first test:
> [root@localhost ~]# mdadm -CR /dev/md0 -l5 -n3 /dev/sdg /dev/sdi
> /dev/sdj --assume-clean
> [root@localhost ~]# mkfs.xfs /dev/md0
> [root@localhost ~]# mount /dev/md0 /mnt/test/
> [root@localhost ~]# mdadm -If sdg
> mdadm: set sdg faulty in md0
> mdadm: hot removed sdg from md0
> [root@localhost ~]# mdadm -If sdi
> mdadm: set device faulty failed for sdi:  Device or resource busy
> Unmounted /dev/md0.
> 
> The patch works as expected.
> 
> The second test:
> [root@localhost ~]# mdadm -CR /dev/md0 -l5 -n3 /dev/sdg /dev/sdi
> /dev/sdj --assume-clean
> [root@localhost ~]# mkfs.xfs /dev/md0
> [root@localhost ~]# mount /dev/md0 /mnt/test/
> [root@localhost ~]# echo "scsi remove-single-device 6 0 0 0" >
> /proc/scsi/scsi
> [root@localhost ~]# echo "scsi remove-single-device 7 0 0 0" >
> /proc/scsi/scsi
> The /dev/md0 is still mount. The patch doesn't work as expected. Logs
> are added during the test. It reports
> error "udisksctl error Permission denied"
> 
> I searched in google to find the reason. It says it needs to config
> polkit[4]. I did but it didn't work.
> 
> The patch is in the attachment
> [1]: udev-md-raid-assembly.rules
> [2]: IncrementalRemove->force_remove
> [3]: The patch is in the attachment
> [4]: https://github.com/coldfix/udiskie/wiki/Permissions
> 
> Best Regards
> Xiao
> 

