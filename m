Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC742C388F9
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 18:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 641FD2072C
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 18:13:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=lucidpixels.com header.i=@lucidpixels.com header.b="BOODpSb5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgKKSM5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 Nov 2020 13:12:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgKKSM4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 11 Nov 2020 13:12:56 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6541C0613D1
        for <linux-raid@vger.kernel.org>; Wed, 11 Nov 2020 10:12:55 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id d17so4404181lfq.10
        for <linux-raid@vger.kernel.org>; Wed, 11 Nov 2020 10:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lucidpixels.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=VzE8BDaL/n6JBFIiUCtyweyNiqD2rbfzZl05aVLw9Z4=;
        b=BOODpSb5zU+KwM9sx1qPBXcrfWDmhXnHjrX9u+W8LwPEsG+sBo5JjILCLJcFDzhQJr
         zFLZXOEdd9kdGDLJhtaIOR6AkD0AYFwY9+1ig88IO2xWktU3mNm0KeSfOAfHBqwCv403
         0w4wW+5sXMT9itogqMe234o8z6ocruH8lPupM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=VzE8BDaL/n6JBFIiUCtyweyNiqD2rbfzZl05aVLw9Z4=;
        b=cId2vZy8RA7as+d1kznzzYLchquE7yCwxpsDupNFQfEZYcqrg6EMxi/f+kZko4Qk2s
         mLlcw7Ai4VlSfsGJzE5FV3gwp/Rp/X46tux7vishvsTak6M3JlP5pBjsZ4RW+sY/zkBf
         7NyyKnyYd3v1XTp9PLY/OUkZ5Wax123ZUJEc7+0J5VrMyBECtwMJQZTIvr2oUP28iRN1
         KoxCyTY2jgdynmsYg89RteRg0AYxQCg1/J/GtY737BpTfRtAuxe5o5zcTjjV/5QYI490
         m1pDiCsPh06MhhZvcOAnsYZXEN9GaEKRnVnFDoggdwO6992UvM8YE15hRCTBv99o04df
         Tnvw==
X-Gm-Message-State: AOAM532oykTev7AEajFwhfKinEXn2x4Yh+OmCtLdDiQrNgCUqzKrYPNK
        KlaaWHW4BvGQGUr2uX+aHt4SQrjtuRQtKW3vL9JIoA==
X-Google-Smtp-Source: ABdhPJwMy0RQwbcNeV3E/RqNsvvERd0DhLw5UIIHAS6OGVPC3Mj6ghAHXJryoYs2uwNsQa22a3ygQ1LjSmss7aT4PeQ=
X-Received: by 2002:a19:c8ca:: with SMTP id y193mr1722705lff.150.1605118373925;
 Wed, 11 Nov 2020 10:12:53 -0800 (PST)
MIME-Version: 1.0
From:   Justin Piszcz <jpiszcz@lucidpixels.com>
Date:   Wed, 11 Nov 2020 13:12:38 -0500
Message-ID: <CAO9zADxBz5q2FrdL4zxSU5Cs6kX7qrkrc__DT4eEaJ0aZKTVtg@mail.gmail.com>
Subject: 5.9.3: "md0:" is showing in dmesg/printk but with no other
 information is provided
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Kernel: 5.9.3
Arch: x86_64

These are showing up in dmesg every so often and they are not
associated with any type of message/alert or user associated action.
What is causing this & why are there no details associated with this
message?

[Wed Nov  4 17:05:56 2020]  md0:
[Thu Nov  5 08:23:32 2020]  md0:
[Thu Nov  5 13:12:00 2020]  md0:
[Sat Nov  7 06:53:59 2020]  md0:
[Sat Nov  7 06:54:07 2020]  md0:
[Tue Nov 10 08:09:27 2020]  md0:
[Wed Nov 11 12:43:06 2020]  md0:

Regards,

Justin.
