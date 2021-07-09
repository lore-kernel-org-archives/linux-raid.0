Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C22D7C07E99
	for <linux-raid@archiver.kernel.org>; Fri,  9 Jul 2021 06:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A22E061441
	for <linux-raid@archiver.kernel.org>; Fri,  9 Jul 2021 06:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhGIGD0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 9 Jul 2021 02:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbhGIGD0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 9 Jul 2021 02:03:26 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F88DC061574
        for <linux-raid@vger.kernel.org>; Thu,  8 Jul 2021 23:00:43 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id o22so5599012wms.0
        for <linux-raid@vger.kernel.org>; Thu, 08 Jul 2021 23:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L+yqHAgWO0hNCW6pHlsxb3Ldr1ZUG0xKDHAeO4sQVi0=;
        b=WVb+v//8jlXlEbzEdRrkfrE02S9sQn7RSkPgX+9oJx+bsjMsM+PnkdshtxH8TNoda6
         aihxdZu9lpmV2qXXLLhZn6t10U3sgNDvBlykdcIBTxrp4N1CT++7xBjI1u7POT/LoM06
         iwyec6MzdKJkkgyZQkQoS3Mi4d+j4QIUNrVtV94UcsY+j/5pLtQejmgtUqPyYa05t1x3
         H8ZHM6Lq68BS1qzC4B/SsDSIq94bQiU28eFNF0wXcmOmECulE2yAH2KYIjhm7vM52Kva
         SmEkCFQqg96H6CuPnLrzbj9cwhVU7iv6R0tHLAK5t2Jnj4vlFyjcWVUbgSn1dV5pY0Rr
         IFNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L+yqHAgWO0hNCW6pHlsxb3Ldr1ZUG0xKDHAeO4sQVi0=;
        b=nAbHF/bV0CmsjmfhXgaGXvBJb21tKk0qGpzq3bHoPcPPcmpzg7AZOGRmiIEmBnY2pB
         jlfl4nVGoBvr+Vdr7FqB15mgRvCviDocw9wia0gbYjEWg9wU6i/jZ/iCg7QC4hxEI2Gt
         9G5hqYsnohC7Y8P3Vw4tiuOHcAwfbvvspvaFF0LCsCJXeRFDf08Ypx+h7QGSRidmmixp
         NDYRIaR029X1qJ/5o0vZmnDSqZgQ6tKMXKhKJqsei+tGtnfPhy0H/rfAOvWpFaF/p7Hv
         K17B5VkXtTrtTVWTp37HwCV9rHFpbDcAx4hyh++ANOY4bvlR/2o3h1/b8YGJPUzUXKgp
         zW6w==
X-Gm-Message-State: AOAM530URrMdMk+rOq1OhDCKpYf4Rlx/L1B2qUTnPdmW+PB1R/D8OzUM
        8x4NI1ksU/pK/mzJuF64L/4wrbZtX99luTALE0Vkd+eB/pCGjg==
X-Google-Smtp-Source: ABdhPJyrWcXBpEGSIbQWcsxDM0xUGE3rTfRe6D6HmIyR/b6lLptNnryyzgclx+DO15U4ZugYoPGrlKrsMRrS9uhgpZ0=
X-Received: by 2002:a05:600c:3b0b:: with SMTP id m11mr9466882wms.25.1625810442044;
 Thu, 08 Jul 2021 23:00:42 -0700 (PDT)
MIME-Version: 1.0
References: <CADcL3SDfzw+PZHWabN0mrHFuyt1gVtD6Owf_bNpFT=xV-JrVVA@mail.gmail.com>
 <CAOaDVC6yNDOVAvMu4gBuc+sTH50UrXD3z4sODa1NtFsV9SEZ9Q@mail.gmail.com>
 <CADcL3SBwbiZJgXVOOTqV2UPqTg=eJwG=ZDCwgzTd9Ez8FH5D6w@mail.gmail.com>
 <162569672750.31036.1684525188878933981@noble.neil.brown.name>
 <CADcL3SAWbA8C5c41MeuBczatmikUu0NMPY+1jjoy54AyObJVJA@mail.gmail.com> <162578835845.31036.9861674953440872046@noble.neil.brown.name>
In-Reply-To: <162578835845.31036.9861674953440872046@noble.neil.brown.name>
From:   BW <m40636067@gmail.com>
Date:   Fri, 9 Jul 2021 08:00:29 +0200
Message-ID: <CADcL3SDik3whZoqk16r_HeK0_JU1RvUgekYPjwTpO4NN+DkBAg@mail.gmail.com>
Subject: Re: --detail --export doesn't show all properties
To:     NeilBrown <neilb@suse.de>
Cc:     Fine Fan <ffan@redhat.com>, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It was a 4-drive RAID5 array missing one drive completely.

But I expected is was an easy thing to fix as "mdadm --detail
/dev/md1xxx" will show the details fine (out of the same information
in memory). But if it's not, maybe just make a note about it and move
on with more important things. I wouldn't be surprised if I'm the only
one ever needing this feature. And I already implemented a work-around
in my storage-management-system be getting the RAID level etc. from
/proc/mdstat first. A pain to serialize of course but it works now.

On Fri, Jul 9, 2021 at 1:52 AM NeilBrown <neilb@suse.de> wrote:
>
> On Thu, 08 Jul 2021, BW wrote:
> > 1: Just because the array is inactive doesn't mean the information is
> > not valuable, actually it's even more,  as your most likely needs your
> > attention
> > 2: The information is available and is printed when not doing --export
>
> Ahh... I missed that.  My memory is that when the array is inactive, the
> md driver really don't know anything about the array.  It doesn't find
> out until it reads the metadata, and it does that as it activates the
> array.
> But looking at your sample output I see does, as you say, give a raid
> level for an inactive array.
>
> But looking at the code, it should do exactly the same thing for
> --export, and --brief, and normal.
> It determines the raid level:
>
>         if (inactive && info)
>                 str = map_num(pers, info->array.level);
>         else
>                 str = map_num(pers, array.level);
>
> and then report 'str' in all 3 cases (possibly substituting "-unknown-"
> or "container" for NULL) providing that array.raid_disks is non-zero -
> which it is in your example.
> So I cannot see how you would get the results that you report.
>
> Do you know how you got the array in this inactive state? I could then
> experiment and see if I can reproduce your result.
>
> NeilBrown
