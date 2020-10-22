Return-Path: <SRS0=HOAI=D5=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2326C4363A
	for <linux-raid@archiver.kernel.org>; Thu, 22 Oct 2020 10:24:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F3842225F
	for <linux-raid@archiver.kernel.org>; Thu, 22 Oct 2020 10:24:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=creamfinance.com header.i=@creamfinance.com header.b="F3bOklTH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896476AbgJVKYo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Oct 2020 06:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2896350AbgJVKYo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 22 Oct 2020 06:24:44 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C28AC0613CE
        for <linux-raid@vger.kernel.org>; Thu, 22 Oct 2020 03:24:44 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id n18so1583312wrs.5
        for <linux-raid@vger.kernel.org>; Thu, 22 Oct 2020 03:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=creamfinance.com; s=google;
        h=from:to:subject:date:message-id:mime-version;
        bh=dbMBRfg59CxpZSMC7Z22hKJ9RF7QByKahs+LVmUnWQs=;
        b=F3bOklTHw/RVh/geMcCpkjh4hlX/uDCgIOgDWk1ESK1V84FK8sV0GbmnrWkkuB8IOV
         hbIgSpN6ZiAY5ZxR0qTSLwhvxL56BQePBkTrTVr/pGmiXOOGX+IrxZhEdNWqnua3ZKDm
         za7X3faiwa2fFF3M0jaIuek1cLxGqXIuMMF4c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version;
        bh=dbMBRfg59CxpZSMC7Z22hKJ9RF7QByKahs+LVmUnWQs=;
        b=ggfhcMQrUIeS4yaQ7QgEGWmAx8DLXGp8bFRpJx/4l581iYpdPh87GlhZBEokc8SwpO
         6GiCpkoKrI05vAFulvHzpHCMEiYQ8816ouCY8uUP8UwUu/GgR3Im3xnjQ82kPn3p1ci/
         U7GsoQs6R3L/Zlh/qC6UgIlsSVgKiH+mT5CjTCR/o66EpIDwS290hkhZQVcRkVXvAfvV
         z4c3KU1c/flu+AM9+qiTWIWibS6dHFqFPSJChw/Dopn8Iq5vOleKzgQSqj/ihcXxPxNJ
         tDYnT4rXb2zEeY+g5gadz6+HViUyaXdBU8dHfJ/JbIshMiqkSJVDWZmECEKz0YHFu8ML
         +4qg==
X-Gm-Message-State: AOAM532Vzq5q9wOCyvuJIA+j7zcD7ipmJIEnyv15MtQ80yBafUJ8KFJO
        K6K1tzHJqFYlnYtgS6U6wKXA2fto1ha+Cjo=
X-Google-Smtp-Source: ABdhPJwQT6sDgLfy4BXN6nplXpY2Op8cMFsLNFg9X69HATNfG01+SwXkCMhVWnGv/bP8xBi5D7IJBQ==
X-Received: by 2002:a5d:678d:: with SMTP id v13mr2008259wru.148.1603362282614;
        Thu, 22 Oct 2020 03:24:42 -0700 (PDT)
Received: from [10.8.100.4] (ip-185.208.132.9.cf-it.at. [185.208.132.9])
        by smtp.gmail.com with ESMTPSA id z5sm2912369wml.14.2020.10.22.03.24.41
        for <linux-raid@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Oct 2020 03:24:42 -0700 (PDT)
From:   "Thomas Rosenstein" <thomas.rosenstein@creamfinance.com>
To:     linux-raid@vger.kernel.org
Subject: mdraid: raid1 and iscsi-multipath devices - never faults but should!
Date:   Thu, 22 Oct 2020 12:24:39 +0200
X-Mailer: MailMate (1.13.2r5673)
Message-ID: <ED0868EE-9B90-4CE6-A722-57E0486A71FF@creamfinance.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

I'm trying todo something interesting, the structure looks like this:

xfs
- mdraid
   - multipath (with no_path_queue = fail)
     - iscsi path 1
     - iscsi path 2
   - multipath (with no_path_queue = fail)
     - iscsi path 1
     - iscsi path 2

During normal operation everything looks good, once a path fails (i.e. 
iscsi target is removed), the array goes to degraded, if the path comes 
back nothing happens.

Q1) Can I enable auto recovery for failed devices?

If the device is readded manually (or by software) everything resyncs 
and it works again. As all should be.

If BOTH devices fail at the same time (worst case scenario) it gets 
wonky. I would expect a total hang (as with iscsi, and multipath 
queue_no_path)

1) XFS reports Input/Output error
2) dmesg has logs like:

[Thu Oct 22 09:25:28 2020] Buffer I/O error on dev md127, logical block 
41472, async page read
[Thu Oct 22 09:25:28 2020] Buffer I/O error on dev md127, logical block 
41473, async page read
[Thu Oct 22 09:25:28 2020] Buffer I/O error on dev md127, logical block 
41474, async page read
[Thu Oct 22 09:25:28 2020] Buffer I/O error on dev md127, logical block 
41475, async page read
[Thu Oct 22 09:25:28 2020] Buffer I/O error on dev md127, logical block 
41476, async page read
[Thu Oct 22 09:25:28 2020] Buffer I/O error on dev md127, logical block 
41477, async page read
[Thu Oct 22 09:25:28 2020] Buffer I/O error on dev md127, logical block 
41478, async page read

3) mdadm --detail /dev/md127 shows:

/dev/md127:
            Version : 1.2
      Creation Time : Wed Oct 21 17:25:22 2020
         Raid Level : raid1
         Array Size : 96640 (94.38 MiB 98.96 MB)
      Used Dev Size : 96640 (94.38 MiB 98.96 MB)
       Raid Devices : 2
      Total Devices : 2
        Persistence : Superblock is persistent

        Update Time : Thu Oct 22 09:23:35 2020
              State : clean, degraded
     Active Devices : 1
    Working Devices : 1
     Failed Devices : 1
      Spare Devices : 0

Consistency Policy : resync

               Name : v-b08c6663-7296-4c66-9faf-ac687
               UUID : cc282a5c:59a499b3:682f5e6f:36f9c490
             Events : 122

     Number   Major   Minor   RaidDevice State
        0     253        2        0      active sync   /dev/dm-2
        -       0        0        1      removed

        1     253        3        -      faulty   /dev/dm-

4) I can read from /dev/md127, but only however much is in the buffer 
(see above dmesg logs)


In my opinion this should happen, or at least should be configurable.
I expect:
1) XFS hangs indefinitly (like multipath queue_no_path)
2) mdadm shows FAULTED as State

Q2) Can this be configured in any way?

After BOTH paths are recovered, nothing works anymore, and the raid 
doesn't recover automatically.
Only a complete unmount and stop followed by an assemble and mount makes 
the raid function again.

Q3) Is that expected behavior?

Thanks
Thomas Rosenstein
