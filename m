Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 772E1C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 30 Sep 2022 05:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiI3F0Z (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 30 Sep 2022 01:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiI3F0X (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 30 Sep 2022 01:26:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806D0DC103
        for <linux-raid@vger.kernel.org>; Thu, 29 Sep 2022 22:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664515581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9e+LOi64UkVzyDizf2dab8KYcuCgm53BgFxnvsvhh0c=;
        b=T7QQp75jGq6xkcbnkJRl3fJWTlHWFfqSslPmJ3dPdbEozCvP2VETZUyhEiP+DIREs7NPo7
        MCrvu2wf/y01zm2EWGzNYwVSgzREqkwaAeBiAPdrNWGnq8zIMNu3bUcHCNZqFpbzE7aiAE
        UcgkR5RovG5+Gm4jqwqfEuuJ0zwlmjc=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-516-RJNPeEMmMvmLQ1JcJPvW0g-1; Fri, 30 Sep 2022 01:26:20 -0400
X-MC-Unique: RJNPeEMmMvmLQ1JcJPvW0g-1
Received: by mail-pl1-f198.google.com with SMTP id h11-20020a170902f54b00b001780f0f7ea7so2491194plf.9
        for <linux-raid@vger.kernel.org>; Thu, 29 Sep 2022 22:26:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=9e+LOi64UkVzyDizf2dab8KYcuCgm53BgFxnvsvhh0c=;
        b=5AquMXZrDnx3iEyWAjwqfTvSTEErQZApfRKlamsYYYOeNaCiQWHubfS7RBd/QuTNpa
         xdGcTyHI6dj0VXjfSlmYS8YfDSbZHG9EduiEVm1zP/9vKKOXiawY469JZ2J5qNwe61Ru
         wZ2gPjRH9a8jFNOZjjXVjclDoqowueyv0y/UNhmj817eDTYcztO1i9xMtoYbE2U3FRjf
         BzZiKD21+XI6Lhh7GJSb7mg58x1RRX79kYJPKtV/nvPu05AZ9DGd06OBxo59HYHQ/gJt
         jG2u5HGC0uiTjHiWbWSnqfuMxub1LuqZ9ElfS5z892IOGZ8HKZRCx8+EKroHaYNV9EAe
         gLtA==
X-Gm-Message-State: ACrzQf35vStoctSS88DoH3VY4cBZlkZovsJwPNuE+xqMC9kgMRw6ptgp
        V9X8Zhj0STVV2roWxqlM0VjCG7hicL/pCPNxnGjT/PmdqhCPnBDYla1s+Vye14lJarTgEP+A4FZ
        PfesAnh6045JGRgYw6Q7qn5pH9FJVPeJj09wRXA==
X-Received: by 2002:a17:903:2341:b0:178:1991:1759 with SMTP id c1-20020a170903234100b0017819911759mr6968570plh.47.1664515579262;
        Thu, 29 Sep 2022 22:26:19 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4LW7Cw/5/iConZvkwVJhZK6gEiI8ZmIV4fK9wxPCUVqWeeyK7Zo/jkKg5Jby6tTRmVc1peaa3/SW3aBxlSIlk=
X-Received: by 2002:a17:903:2341:b0:178:1991:1759 with SMTP id
 c1-20020a170903234100b0017819911759mr6968549plh.47.1664515579006; Thu, 29 Sep
 2022 22:26:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220921204356.4336-1-logang@deltatee.com>
In-Reply-To: <20220921204356.4336-1-logang@deltatee.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Fri, 30 Sep 2022 13:26:07 +0800
Message-ID: <CALTww29fH+pa=-Pzd3anEKh49fmvc9EGmL52QGo1GrQEUGsf5g@mail.gmail.com>
Subject: Re: [PATCH mdadm v3 0/7] Write Zeroes option for Creating Arrays
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

Hi Logan

I like this idea, but I have a question. If we do discard against the
member disks
and then creating raid device with --assume-clean, it should work with the same
result. The reason that you add --write-zero is for automatic doing this?

Regards
Xiao

On Thu, Sep 22, 2022 at 4:44 AM Logan Gunthorpe <logang@deltatee.com> wrote:
>
> Hi,
>
> This is the next iteration of the patchset that added the discard
> option to mdadm. Per feedback from Martin, it's more desirable
> to use the write-zeroes functionality than rely on devices to zero
> the data on a discard request. This is because standards typically
> only require the device to do the best effort to discard data and
> may not actually discard (and thus zero) it all in some circumstances.
>
> This version of the patch set adds the --write-zeroes option which
> will imply --assume-clean and write zeros to the data region in
> each disk before starting the array. This can take some time so
> each disk is done in parallel in its own fork. To make the forking
> code easier to understand this patch set also starts with some
> cleanup of the existing Create code.
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
>  Create.c           | 476 ++++++++++++++++++++++++++++-----------------
>  ReadMe.c           |   2 +
>  mdadm.8.in         |  16 ++
>  mdadm.c            |   9 +
>  mdadm.h            |   9 +
>  tests/00raid5-zero |  12 ++
>  6 files changed, 349 insertions(+), 175 deletions(-)
>  create mode 100644 tests/00raid5-zero
>
>
> base-commit: 171e9743881edf2dfb163ddff483566fbf913ccd
> --
> 2.30.2
>

