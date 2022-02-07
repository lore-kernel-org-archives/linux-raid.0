Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6EDDC433EF
	for <linux-raid@archiver.kernel.org>; Mon,  7 Feb 2022 22:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243902AbiBGWP1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Feb 2022 17:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbiBGWP0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 7 Feb 2022 17:15:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E6B16C061355
        for <linux-raid@vger.kernel.org>; Mon,  7 Feb 2022 14:15:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644272125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+m82o+thtcm+LpZOWYXh2SYpqiYTlY0IM2ueDhDDL8c=;
        b=i6iApITCQamA0Oq1KHL1FbucTxXLIEy5uQAQ+RCtUbylCP7/ZpJqFE+NRSIBtQggT8cnGj
        4P52Pt3q2DvnDgZ/IPPRZQP8TcVcrVQQ93LhhFJ2YYn/fP+uioAT7uqk3xn/kJslqfNoEl
        AduG3uaHu9mb1RHIjVCAC9R5pmGEIGU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-wb_ijW9_Npe31Dm-kUfmOw-1; Mon, 07 Feb 2022 17:15:22 -0500
X-MC-Unique: wb_ijW9_Npe31Dm-kUfmOw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E800A10B7440;
        Mon,  7 Feb 2022 22:15:20 +0000 (UTC)
Received: from localhost (dhcp-17-75.bos.redhat.com [10.18.17.75])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 93FB65E26B;
        Mon,  7 Feb 2022 22:15:20 +0000 (UTC)
From:   Nigel Croxon <ncroxon@redhat.com>
To:     mariusz.tkaczyk@linux.intel.com, jes@trained-monkey.org,
        linux-raid@vger.kernel.org
Subject: [PATCH] mdadm: fix msg when removing a device using the short arg -r
Date:   Mon,  7 Feb 2022 17:15:19 -0500
Message-Id: <20220207221519.3169427-1-ncroxon@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The change from commit mdadm: fix coredump of mdadm
--monitor -r broke the printing of the return message when
passing -r to mdadm --manage, the removal of a device from
an array.

If the current code reverts this commit, both issues are
still fixed.

The original problem reported that the fix tried to address
was:  The --monitor -r option requires a parameter,
otherwise a null pointer will be manipulated when
converting to integer data, and a core dump will appear.

The original problem was really fixed with:
60815698c0a Refactor parse_num and use it to parse optarg.
Which added a check for NULL in 'optarg' before moving it
to the 'increments' variable.

New issue: When trying to remove a device using the short
argument -r, instead of the long argument --remove, the
output is empty. The problem started when commit 
546047688e1c was added.

Steps to Reproduce:
1. create/assemble /dev/md0 device
2. mdadm --manage /dev/md0 -r /dev/vdxx

Actual results:
Nothing, empty output, nothing happens, the device is still
connected to the array.

The output should have stated "mdadm: hot remove failed
for /dev/vdxx: Device or resource busy", if the device was
still active. Or it should remove the device and print
a message:

# mdadm --set-faulty /dev/md0 /dev/vdd
mdadm: set /dev/vdd faulty in /dev/md0
# mdadm --manage /dev/md0 -r /dev/vdd
mdadm: hot removed /dev/vdd from /dev/md0


The following commit should be reverted as it breaks
mdadm --manage -r.

commit 546047688e1c64638f462147c755b58119cabdc8
Author: Wu Guanghao <wuguanghao3@huawei.com>
Date:   Mon Aug 16 15:24:51 2021 +0800
mdadm: fix coredump of mdadm --monitor -r

-Nigel

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>


