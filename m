Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BED3C433DB
	for <linux-raid@archiver.kernel.org>; Tue, 12 Jan 2021 08:44:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 165A322E00
	for <linux-raid@archiver.kernel.org>; Tue, 12 Jan 2021 08:44:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405628AbhALIny (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Jan 2021 03:43:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55692 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732457AbhALIny (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 12 Jan 2021 03:43:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610440947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=uGj+m3Z1k11/i4Ov9HRHcXTU1qBA8uU+ZsRda/UITZo=;
        b=HyBespqAVj5Rqu3P11HurkoYZxnpJHta6CZyiOvgypUpmO6ThCRogX1OwQmmUtYLW1wJYY
        +uD6hzX9XOs75M854o4lL/c+Tg8vaYBbjaCkZil9acyznRhPmT9uGY7wdPDRnbygP3zaM4
        xkv22ljD7LfAQ//O+ZUM574ZXEeLQcc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-YzBDVwMeOZaz7zKg-YuKSA-1; Tue, 12 Jan 2021 03:42:23 -0500
X-MC-Unique: YzBDVwMeOZaz7zKg-YuKSA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2BA315721
        for <linux-raid@vger.kernel.org>; Tue, 12 Jan 2021 08:42:22 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-30.pek2.redhat.com [10.72.8.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B97EE1972B
        for <linux-raid@vger.kernel.org>; Tue, 12 Jan 2021 08:42:21 +0000 (UTC)
To:     linux-raid <linux-raid@vger.kernel.org>
From:   Xiao Ni <xni@redhat.com>
Subject: One failed raid device can't umount automatically
Message-ID: <1b0aaa70-a7bf-c35f-12c0-425e76200f0c@redhat.com>
Date:   Tue, 12 Jan 2021 16:42:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all

We support to umount one failed raid device automatically. But it can't 
work now.
For example, one 3 disks raid5 device /dev/md0. I unplug two disks one 
by one.
The udev rule udev-md-raid-assembly.rules is triggered when unplug disk.

In this udev rule, it calls `mdadm -If $disk` when unplug one disk. 
Function IncrementalRemove
is called. When the raid doesn't have enough disks to be active, it 
tries to stop the array.
Before stopping the array, it tries to umount the raid device first.

Now it uses udisks to umount raid device. I printed logs during test. It 
gives error message
"Permission denied". Then I tried with umount directly, it failed with 
the same error message.

diff --git a/Incremental.c b/Incremental.c
index e849bdd..96ba234 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1620,6 +1620,7 @@ static void run_udisks(char *arg1, char *arg2)
                 manage_fork_fds(1);
                 execl("/usr/bin/udisks", "udisks", arg1, arg2, NULL);
                 execl("/bin/udisks", "udisks", arg1, arg2, NULL);
+               execl("/usr/bin/umount", "umount", arg2, NULL);
                 exit(1);
         }
         while (pid > 0 && wait(&status) != pid)

Does anyone know how to fix this problem?

Regards
Xiao

