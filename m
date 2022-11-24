Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 026BAC4332F
	for <linux-raid@archiver.kernel.org>; Thu, 24 Nov 2022 05:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiKXFkK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 24 Nov 2022 00:40:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiKXFkI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 24 Nov 2022 00:40:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DD2C0536
        for <linux-raid@vger.kernel.org>; Wed, 23 Nov 2022 21:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669268352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y99B2ttuaRQDZ1Zo0yBLMzrgu9CWN1qClWtgVYlvRuQ=;
        b=IbaekpYQ8Yt10TcNuPz6h0131+5kczYhhVPkkmHpwsSeW/f2s5NfzOksbLWufHui1o0s3u
        NGHGgMXCPFkL2TZrzpQrO3DnkHjYlftZfPQO3J1DiVc4SduCgcftQkD3CnIs0Sf2SVg9oV
        UpPPNxv0GBvKaLJizWC/sIbJcbotCRE=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-532-iXD2jvtsPeGW9EGQM7hHTw-1; Thu, 24 Nov 2022 00:39:09 -0500
X-MC-Unique: iXD2jvtsPeGW9EGQM7hHTw-1
Received: by mail-pl1-f198.google.com with SMTP id e11-20020a17090301cb00b001890e0c759aso600341plh.5
        for <linux-raid@vger.kernel.org>; Wed, 23 Nov 2022 21:39:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y99B2ttuaRQDZ1Zo0yBLMzrgu9CWN1qClWtgVYlvRuQ=;
        b=2Gqn2ImYY15aXicQc3fvNAXhgfYWBKklAaLaBPoRPGZXqGFtAS90TNhV6SRhrRapG7
         WGq92PxIkq5qvVke2BNDKGs/lhPPAGQ5AD+25+0dL8PTiyZ5m4e7WmRCQoHgouoRPmvS
         G8Y8V3oXDoZ7xx9ESLUtI63zE37jSIMc94NxqG/MALtNwDtRZca8oFG9i3BEfQrfUHqk
         wPRH0/xjGl4M4Nb3Fsykv41+UJ7pNcZlYRJ194ZBHVqXJd28dDL21hZs1F3rZ/lQ52hy
         nC1lH5Ki6KXSESN0XvPKhFb4EGCyL4oQw8H7j1EFFC1SNYGDGMp0F9DH/sftoVvqSlsu
         7tQQ==
X-Gm-Message-State: ANoB5pkbLTA1aGrLjRvT/wcRuSGfAsx21tl0lm9pEHfvvPaxx93mSC4J
        dSa6Cbmufdhwj/LELu0oJoxeaWCFdPjM33BkUlSkiczULj+sSs2Yqn9jd4JoSQHv35aY0nMqXY9
        qi7G4zdW3rc7I+o5fuJXAq8CUKJUCR3M2B6tllw==
X-Received: by 2002:a17:902:d705:b0:17c:7338:2ba5 with SMTP id w5-20020a170902d70500b0017c73382ba5mr15056007ply.82.1669268348641;
        Wed, 23 Nov 2022 21:39:08 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5IPf7iRfBIUhwu9MeAhN1Sp9g1rX90y4iQfbobckgTQ41DkrOqQPYpgKMAB9XCpaK7imBQGPv3O/cUQYvj05M=
X-Received: by 2002:a17:902:d705:b0:17c:7338:2ba5 with SMTP id
 w5-20020a170902d70500b0017c73382ba5mr15055987ply.82.1669268348338; Wed, 23
 Nov 2022 21:39:08 -0800 (PST)
MIME-Version: 1.0
References: <20221123190954.95391-1-logang@deltatee.com>
In-Reply-To: <20221123190954.95391-1-logang@deltatee.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Thu, 24 Nov 2022 13:38:57 +0800
Message-ID: <CALTww2_veP=bkpz5Z03VjmF=0dH-D9WqD2+K5A9cBiK5Pb-USg@mail.gmail.com>
Subject: Re: [PATCH mdadm v6 0/7] Write Zeroes option for Creating Arrays
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Nov 24, 2022 at 3:10 AM Logan Gunthorpe <logang@deltatee.com> wrote:
>
> Hi,
>
> This is the next iteration of the patchset to add a zeroing option
> which bypasses the inital sync for arrays. This version of the patch
> set fixes an unitialized variable bug in v5.
>
> This patch set adds the --write-zeroes option which will imply
> --assume-clean and write zeros to the data region in each disk before
> starting the array. This can take some time so each disk is done in
> parallel in its own fork. To make the forking code easier to
> understand this patch set also starts with some cleanup of the
> existing Create code.
>
> We tested write-zeroes requests on a number of modern nvme drives of
> various manufacturers and found most are not as optimized as the
> discard path. A couple drives that were tested did not support
> write-zeroes at all but still performed similarly with the kernel
> falling back to writing zero pages. Typically we see it take on the
> order of one minute per 100GB of data zeroed.
>
> One reason write-zeroes is slower than discard is that today's NVMe
> devices only allow about 2MB to be zeroed in one command where as
> the entire drive can typically be discarded in one command. Partly,
> this is a limitation of the spec as there are only 16 bits avalaible
> in the write-zeros command size but drives still don't max this out.
> Hopefully, in the future this will all be optimized a bit more
> and this work will be able to take advantage of that.
>
> Logan
>
> --
>
> Changes since v5:
>    * Ensure 'interrupted' is initialized in wait_for_zero_forks().
>      (as noticed by Xiao)
>    * Print a message indicating that the zeroing was interrupted.
>
> Changes since v4:
>    * Handle SIGINT better. Previous versions would leave the zeroing
>      processes behind after the main thread exitted which would
>      continue zeroing in the background (possibly for some time).
>      This version splits the zero fallocate commands up so they can be
>      interrupted quicker, and intercepts SIGINT in the main thread
>      to print an appropriate message and wait for the threads
>      to finish up. (as noticed by Xiao)
>
> Changes since v3:
>    * Store the pid in a local variable instead of the mdinfo struct
>     (per Mariusz and Xiao)
>
> Changes since v2:
>
>    * Use write-zeroes instead of discard to zero the disks (per
>      Martin)
>    * Due to the time required to zero the disks, each disk is
>      now done in parallel with separate forks of the process.
>    * In order to add the forking some refactoring was done on the
>      Create() function to make it easier to understand
>    * Added a pr_info() call so that some prints can be done
>      to stdout instead of stdour (per Mariusz)
>    * Added KIB_TO_BYTES and SEC_TO_BYTES helpers (per Mariusz)
>    * Added a test to the mdadm test suite to test the option
>      works.
>    * Fixed up how the size and offset are calculated with some
>      great information from Xiao.
>
> Changes since v1:
>
>    * Discard the data in the devices later in the create process
>      while they are already open. This requires treating the
>      s.discard option the same as the s.assume_clean option.
>      Per Mariusz.
>    * A couple other minor cleanup changes from Mariusz.
>
> --
>
> Logan Gunthorpe (7):
>   Create: goto abort_locked instead of return 1 in error path
>   Create: remove safe_mode_delay local variable
>   Create: Factor out add_disks() helpers
>   mdadm: Introduce pr_info()
>   mdadm: Add --write-zeros option for Create
>   tests/00raid5-zero: Introduce test to exercise --write-zeros.
>   manpage: Add --write-zeroes option to manpage
>
>  Create.c           | 564 +++++++++++++++++++++++++++++++--------------
>  ReadMe.c           |   2 +
>  mdadm.8.in         |  16 ++
>  mdadm.c            |   9 +
>  mdadm.h            |   7 +
>  tests/00raid5-zero |  12 +
>  6 files changed, 435 insertions(+), 175 deletions(-)
>  create mode 100644 tests/00raid5-zero
>
>
> base-commit: 8b668d4aa3305af5963162b7499b128bd71f8f29
> --
> 2.30.2
>

For the series, reviewed-by Xiao Ni <xni@redhat.com>

