Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9173C47082
	for <linux-raid@archiver.kernel.org>; Fri,  4 Jun 2021 01:24:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5EA6613F6
	for <linux-raid@archiver.kernel.org>; Fri,  4 Jun 2021 01:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhFDBZt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Jun 2021 21:25:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFDBZs (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 3 Jun 2021 21:25:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40F7E613F6
        for <linux-raid@vger.kernel.org>; Fri,  4 Jun 2021 01:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622769843;
        bh=BiBAhDeYF0eeu44SFzOKLRgJTVXzoKAoDbqJC6YzS3U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tht6Qr6fhVBivc3A//mwXDK+faJ1uTikvhe4bmVyD2awUaMmTzhYGnQCtMVF/VL6T
         mJVbP7CewrBCLse1WKJ2OpDwZZiFhzv9C6QD8VG7IgQSDipSNXtvhSwSvfdK0FWKK7
         PcZgFFOmJJsfpSYMVIere25qIPFFQLS9DAdcERaAGVoxVtBYRk/K+66yBBKkro1eMx
         KQME+uKs2pwFFu1p+FMUQJ8AEpU9gMpRstEyjHXMGIfWKcKh5hiDQespDb0giKMySI
         HxS9O9UKqFZievbNRY1PbAhxcti64Ubd4Ojs+CQhns+0AWhXQeM/Bb20wQX0XOUHwG
         x52iqlBPJNt3g==
Received: by mail-lj1-f173.google.com with SMTP id f12so9508259ljp.2
        for <linux-raid@vger.kernel.org>; Thu, 03 Jun 2021 18:24:03 -0700 (PDT)
X-Gm-Message-State: AOAM5303KX49NxrqGmxIyTWG72rxdKmfvdeeoso02vJCtlAiqGu5Pxv+
        cBI5P9NUjqIjX9rPGhHOh8aht6SEUngQJKED9Qo=
X-Google-Smtp-Source: ABdhPJzyQ15PxjjPg+GG6EX5Td5AzO4ygjN1h3qYnn6z3yd+nNSZDLJiWbMo+GZvIGrMPbEovbo32drxEG+JvayyJgw=
X-Received: by 2002:a2e:a490:: with SMTP id h16mr1541568lji.270.1622769841576;
 Thu, 03 Jun 2021 18:24:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210428082903.14783-1-lidong.zhong@suse.com>
In-Reply-To: <20210428082903.14783-1-lidong.zhong@suse.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 3 Jun 2021 18:23:50 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7uWNg05ps1b2qmD5P5=0x=_0ChV0e=hGZ7Occxeh2t-g@mail.gmail.com>
Message-ID: <CAPhsuW7uWNg05ps1b2qmD5P5=0x=_0ChV0e=hGZ7Occxeh2t-g@mail.gmail.com>
Subject: Re: [PATCH] md: adding a new flag MD_DELETING
To:     Lidong Zhong <lidong.zhong@suse.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Apr 28, 2021 at 1:31 AM Lidong Zhong <lidong.zhong@suse.com> wrote:
>
> The mddev data structure is freed in mddev_delayed_delete(), which is
> schedualed after the array is deconfigured completely when stopping. So
> there is a race window between md_open() and do_md_stop(), which leads
> to /dev/mdX can still be opened by userspace even it's not accessible
> any more. As a result, a DeviceDisappeared event will not be able to be
> monitored by mdadm in monitor mode. This patch tries to fix it by adding
> this new flag MD_DELETING.
>
> Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>

Sorry for the delay. I missed this one.

As I try to apply the patch, I found the patch is somehow corrupted. It contains
special patterns like:

 =09if ((err =3D mutex_lock_interruptible(&mddev->open_mutex)))
 =09=09goto out;
=20
-=09if (test_bit(MD_CLOSING, &mddev->flags)) {
+=09if (test_bit(MD_CLOSING, &mddev->flags) ||
+            (test_bit(MD_DELETING, &mddev->flags) && mddev->pers =3D=3D NU=
LL)) {

Could you please try resend it?

Thanks,
Song
