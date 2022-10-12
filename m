Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F23FCC4332F
	for <linux-raid@archiver.kernel.org>; Wed, 12 Oct 2022 01:10:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiJLBKC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 Oct 2022 21:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiJLBKB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 11 Oct 2022 21:10:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2937213D49
        for <linux-raid@vger.kernel.org>; Tue, 11 Oct 2022 18:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665536996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EHys6+kmn7J/jd9cCrwS7krwmfr0OeLIGgtQ7BYbUuQ=;
        b=bAtAqBsjNij0scuqQUcWdIBlu0F11nAkhWIOIE6TMymU4BOJx+My+9imHCpafwcs7hcZMK
        kLsx295f69kiFr6yYwSrHg/7ZvKDPoQZJQLD+lI+BpEO9ukeYMCT/HBh5sExhqn07dQZPH
        MwCup+avJqJpQX6L7lCiaeGpF6/caAk=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-384-xJLsGuQYN2eD-dmMWheWJA-1; Tue, 11 Oct 2022 21:09:55 -0400
X-MC-Unique: xJLsGuQYN2eD-dmMWheWJA-1
Received: by mail-pg1-f199.google.com with SMTP id l185-20020a6388c2000000b004610d11faddso4300862pgd.1
        for <linux-raid@vger.kernel.org>; Tue, 11 Oct 2022 18:09:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EHys6+kmn7J/jd9cCrwS7krwmfr0OeLIGgtQ7BYbUuQ=;
        b=kolAWSkZS2F1RAAHYlNVKqmRjYlm6wO22Vdc4kjXwTtui3+SUHzZgfmLOnMOBASbzC
         myy43Cq1Z0bvhOl7sif4MWAq0qRmq+tOSkVdMj+JA0yfia61FJ2536G5PSP5HE8Nfd9/
         wm2it0zNl9GC3Q/vQvH89+ww2JN7cxSgfTOqzQQdIaHkvJ3ehiBdcJmHDSUw9S2YF+JF
         RrSjopOp4GdMQA2VmXevdgRlxfmLM5nkiFZ5OmM9VQk/wXp9hxfMYGizVSaNXcsgg29A
         WB1PfkinBl+nXiUtBBC+HY2w8vHMGy0cNspM4GBmG3YX3K4qSQr2kg+fsc7ftJIdPFNJ
         N01w==
X-Gm-Message-State: ACrzQf12dOMj8EGdrdCs7K1kCAQ77C1MwwM6Fkm49rAHIJQPsPDq8hmP
        gazW0HNi1pJSy14/5R4NpBub3rOl3xG2r0rCAdkPbErpNEYFo0Q927G7OWJOEBcFf6k5jQkpeZk
        dxxgfRRFj0Z3crDLb257IeN4nRx1LmSLaO/s9zA==
X-Received: by 2002:a63:d349:0:b0:460:b5ee:60ef with SMTP id u9-20020a63d349000000b00460b5ee60efmr15520293pgi.288.1665536993486;
        Tue, 11 Oct 2022 18:09:53 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5xuXLZMGNQONK2TxItS3XmgaHVyS/7c1lyVI3I28ife5qe2vD92Z4T8/1EhPQUXFjV4Y9TcvW5wdkdhQ89DRk=
X-Received: by 2002:a63:d349:0:b0:460:b5ee:60ef with SMTP id
 u9-20020a63d349000000b00460b5ee60efmr15520266pgi.288.1665536993136; Tue, 11
 Oct 2022 18:09:53 -0700 (PDT)
MIME-Version: 1.0
References: <20221007201037.20263-1-logang@deltatee.com>
In-Reply-To: <20221007201037.20263-1-logang@deltatee.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 12 Oct 2022 09:09:41 +0800
Message-ID: <CALTww28HQUPbB647oP9WKvkLX=9PqZv+9am-884zZVM923H-KA@mail.gmail.com>
Subject: Re: [PATCH mdadm v4 0/7] Write Zeroes option for Creating Arrays
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

I did a test with the patchset. There is a problem like this:

mdadm -CR /dev/md0 -l5 -n3 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme0n1 --write-zero
mdadm: zeroing data from 135266304 to 960061505536 on: /dev/nvme1n1
mdadm: zeroing data from 135266304 to 960061505536 on: /dev/nvme2n1
mdadm: zeroing data from 135266304 to 960061505536 on: /dev/nvme0n1

I ran ctrl+c when waiting, then the raid can't be created anymore. Because the
processes that write zero to nvmes are stuck.

ps auxf | grep mdadm
root       68764  0.0  0.0   9216  1104 pts/0    S+   21:09   0:00
         \_ grep --color=auto mdadm
root       68633  0.1  0.0  27808   336 pts/0    D    21:04   0:00
mdadm -CR /dev/md0 -l5 -n3 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme0n1
--write-zero
root       68634  0.2  0.0  27808   336 pts/0    D    21:04   0:00
mdadm -CR /dev/md0 -l5 -n3 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme0n1
--write-zero
root       68635  0.0  0.0  27808   336 pts/0    D    21:04   0:00
mdadm -CR /dev/md0 -l5 -n3 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme0n1
--write-zero

Regards
Xiao

On Sat, Oct 8, 2022 at 4:10 AM Logan Gunthorpe <logang@deltatee.com> wrote:
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
>
> *** BLURB HERE ***
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
>  Create.c           | 479 ++++++++++++++++++++++++++++-----------------
>  ReadMe.c           |   2 +
>  mdadm.8.in         |  16 ++
>  mdadm.c            |   9 +
>  mdadm.h            |   7 +
>  tests/00raid5-zero |  12 ++
>  6 files changed, 350 insertions(+), 175 deletions(-)
>  create mode 100644 tests/00raid5-zero
>
>
> base-commit: 8b668d4aa3305af5963162b7499b128bd71f8f29
> --
> 2.30.2
>

