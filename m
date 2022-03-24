Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 018F9C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 24 Mar 2022 07:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348329AbiCXHKp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 24 Mar 2022 03:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345176AbiCXHKl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 24 Mar 2022 03:10:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F163E92858
        for <linux-raid@vger.kernel.org>; Thu, 24 Mar 2022 00:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648105747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YAwcixvco72+O2kbtJ9UZ9Z+L7LGzZb9cM/Z+jGg5LU=;
        b=SDE42wLSVRb//3XEHJ2eyPi2K3FAyMZQsllSMc8az/UdApZOz3+P1tJVj52c6OtaxeE4+c
        teEj99GkWNLZN2om8P+dwcz/WXIlW8g8MHKum9dLcf29Boq1U0ii/lXGrdJ5kQcJFpqOwe
        HARtvZakpTAXWzkBvS8NrkRZjOqN6Mk=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-IF3tsDs9MnGmXgoyedO-Qw-1; Thu, 24 Mar 2022 03:09:06 -0400
X-MC-Unique: IF3tsDs9MnGmXgoyedO-Qw-1
Received: by mail-ej1-f71.google.com with SMTP id ga31-20020a1709070c1f00b006cec400422fso1952370ejc.22
        for <linux-raid@vger.kernel.org>; Thu, 24 Mar 2022 00:09:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YAwcixvco72+O2kbtJ9UZ9Z+L7LGzZb9cM/Z+jGg5LU=;
        b=0zUZHpGpqyr85QwMo+/ThxgYgd6+5/nyeiioNZeiBrKSFNcdFaGNvkAev6oB95kqgH
         k6TmQH05aERxxb95nlufACrCD07ZuSOnRQAOb0K7fIF3m1jlYcZT0s2UuSkN2YNZRfiI
         OZ83JrP6w5yfkUrec8SE7o5R6/x5g5N9sYjEux4yQvVcVAFhNFcxaIvx5FwBgAZscY0Z
         jP5lvmKO4vBN5fjrpOpqOHtu7uWQNFoRb6t+Ziig+7XGG99lVQZofOssnNnOtV5lt6bH
         kiyNanEDLkrdAQp4/uLT+hIf3+CJcl4DMAowNJ9tCQgt0wQbelXB1a1p22DTkaNWuJfT
         IrRA==
X-Gm-Message-State: AOAM533I/EE6w9AAHUey4vEVrAWwj5WoDuh04Sl5vP5iFGlOeWykYqzm
        +e5Ne8KjuqvTI+fpa5qWMCisHBZCgzPyJ/KghHCY3yGt+adDQn51H+7ynxLkDu08V3NWoSl7uDh
        SXbwFC2HgsMAzS1UdAB+xWs4owKVqHudeaPCUgA==
X-Received: by 2002:aa7:d619:0:b0:419:af7:841f with SMTP id c25-20020aa7d619000000b004190af7841fmr4987622edr.20.1648105743754;
        Thu, 24 Mar 2022 00:09:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwUJC3pb/b2onKZttCJA9CRCOervpMw5mGOivIZ1HdZaOuKbpMDFf+Uiy5/vGomMQ+ePz8X0A8FRWQds2jPgk=
X-Received: by 2002:aa7:d619:0:b0:419:af7:841f with SMTP id
 c25-20020aa7d619000000b004190af7841fmr4987608edr.20.1648105743543; Thu, 24
 Mar 2022 00:09:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220322152339.11892-1-mariusz.tkaczyk@linux.intel.com>
In-Reply-To: <20220322152339.11892-1-mariusz.tkaczyk@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Thu, 24 Mar 2022 15:09:47 +0800
Message-ID: <CALTww29ZT2fK_rrecKOSO=ySu1VsLUYU4nGFY5ZcTyt8UPUHbw@mail.gmail.com>
Subject: Re: [PATCH 0/3] Failed array handling improvements
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Mar 22, 2022 at 11:24 PM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> Hi Song,
> In v4 following changes were made:
> - raid1_error and raid10_error description reworked, suggested by Guoqing.
> - Error messages for raid0 and linear reworked, suggested by Guoqing.
> - check for sync_request replaced by level checks, suggested by Guoqing.
>
> I did manual (mainly on IMSM) tests, here my next TODOs in mdadm:
> - broken state handling for redundant arrays in mdadm (it is exposed in sysfs).
>   Currently it is working same as before, because broken is not a case for
>   redundant arrays in mdadm. It requires to deal with already defined "FAILED"
>   state in mdadm.
> - Blocking manual removal of devices (#mdadm --set-faulty).
>
> I run following native mdadm tests with and without changes, all passed:
> #./test --disks=/dev/nullb[1-5] --tests=00raid1,00raid4,00raid5,00raid6,01r1fail,
> 01r5fail,01replace,02r1add,05r1failfast,05r1re-add,05r1re-add-nosuper
>
> Mariusz Tkaczyk (3):
>   raid0, linear, md: add error_handlers for raid0 and linear
>   md: Set MD_BROKEN for RAID1 and RAID10
>   raid5: introduce MD_BROKEN
>
>  drivers/md/md-linear.c | 14 +++++++-
>  drivers/md/md.c        | 30 +++++++++++-------
>  drivers/md/md.h        | 72 ++++++++++++++++++++++--------------------
>  drivers/md/raid0.c     | 14 +++++++-
>  drivers/md/raid1.c     | 43 +++++++++++++++----------
>  drivers/md/raid10.c    | 40 +++++++++++++----------
>  drivers/md/raid5.c     | 48 ++++++++++++++--------------
>  7 files changed, 155 insertions(+), 106 deletions(-)
>
> --
> 2.26.2
>

Reviewd-by: Xiao Ni <xni@redhat.com>

