Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82291C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 13 Jan 2022 00:46:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiAMAqS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 Jan 2022 19:46:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiAMAqI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 12 Jan 2022 19:46:08 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F1FC06173F
        for <linux-raid@vger.kernel.org>; Wed, 12 Jan 2022 16:46:07 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id r6so4881017qvr.13
        for <linux-raid@vger.kernel.org>; Wed, 12 Jan 2022 16:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zaZ6awMHgZ1s5740LXoDB7YTUFLxoFMfh7JzLceDxEs=;
        b=RaKgjlvi6dMSvweKSBBCwWBNdCr/X4MCCD53DzLvZ4HTSSeoLvShw1sY8D0dwaJGoe
         sSLQGfxXi0RNAhnO1TuDlPEa04a+5x23+z3x3ueWFRvSHrXqRrmxscs7Dp9XKDg16miO
         FuaBtxWKnoPOvrv+3G+12Lo5Fd/z9ZakYUx5KVegkT4kM8XSmIKrzKrRIzJ3dNA0m7KI
         0T7MWtRMqZz/ii4yxMYC0te8gMTjO7nbLvVxvGmbxXluIHnGCzkFfAGwuS+EG7RYtyw4
         9bqJNGRbH53YMNUOMJp2Z8Gom8U2GViQZ8Ed2p6OFm85Zm0mZsWg26DawCzyTtq0+xsF
         iMdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zaZ6awMHgZ1s5740LXoDB7YTUFLxoFMfh7JzLceDxEs=;
        b=k0gwyJiBDnC5drbGAW9kYy//oB+2lR71v539HIUpsC89pmxqkNaW8OtwoNZXSnImbS
         rpAIUx2XiIa/yNCTHsJuZus0Kfe/VUXU7vkFe/Xy7sx0RKAbB6zWyQF6rYfDCw+PjB4P
         5VWeZ54BQOl6rA2ulFVuBDSNdRbrgmBYZSnKat2mnZEmslLNq9bm/uCDzhOb03goXmue
         HVA+IHB7N49W3+hUoCILm/UCxHMpK0qC0vNhbv0dUgKj+QAuLv7A5Co8nI5tECCC6wim
         2PYs00au3sAoRdCudRgvNHziwnAGQHTKIv24lYJyibm/VYhodjkG19by8z+MZYxOuU1c
         eLkg==
X-Gm-Message-State: AOAM5337IaBO4ryPQfklwMKmfJqQVBrQc+moWj2atu6eV6+L6HEMQTXf
        v0L8UevrtiiDOWfDBDR0isUPJHJcVBVpY9+/RbuoeYhd3Q4=
X-Google-Smtp-Source: ABdhPJxwYMBmtOVatNm2cP95QGStyy5KwTt6Y4ZplJcYMz2is3OKAVvsJlNXgl9OBPsSbcepZHhCmA9ch1u9segNW3U=
X-Received: by 2002:a05:6214:dc3:: with SMTP id 3mr2092196qvt.101.1642034766747;
 Wed, 12 Jan 2022 16:46:06 -0800 (PST)
MIME-Version: 1.0
References: <CAPx-8MP0+C9M9ysigF-gfaUBE8nv7nzbm4HO06yC_z5i3U3D=Q@mail.gmail.com>
 <20220110104733.00001048@linux.intel.com> <CAPx-8MNa97Aokgz8RzfiGEPXFLpzbGduNV9hUOYdGXRmfxSg3g@mail.gmail.com>
 <CAAMCDecViLw=V_nFgJicLa=nDoADScpwg_pfWF2ubF5D=aCsaA@mail.gmail.com>
 <CAPx-8MNgtVuUgdOBsZiQyXmS=nCoj255D+oNrkGOcsNVhixC3g@mail.gmail.com> <c94d975f-78d0-259f-bca2-a7b74c55f2a6@sotapeli.fi>
In-Reply-To: <c94d975f-78d0-259f-bca2-a7b74c55f2a6@sotapeli.fi>
From:   Aidan Walton <aidan.walton@gmail.com>
Date:   Thu, 13 Jan 2022 01:45:30 +0100
Message-ID: <CAPx-8MNO0WaT8j4seOdfoDKoiP=zjo-qkSmFf+ENbxiAAuFrDQ@mail.gmail.com>
Subject: Re: md device remains active even when all supporting disks have
 failed and been disabled by the kernel.
To:     Jani Partanen <jiipee@sotapeli.fi>
Cc:     Roger Heflin <rogerheflin@gmail.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thanks Jani,
Gold info. I have been looking at 2 cheap Mini-PCIe adapters. One uses
the JMicron and would you believe it the other is using ASMedia.
Now I have a solid reason to choose the second rather than the first.

In this case it will NOT be,  "Better the devil you know than the
devil you don't"
and anyway I don't work hard enough to need 6Gb/s :)
ATB
Aidan

On Thu, 13 Jan 2022 at 01:24, Jani Partanen <jiipee@sotapeli.fi> wrote:
>
> Aidan Walton kirjoitti 13/01/2022 klo 2.03:
> > Hi Roger,
> > As I mentioned, it is a:
> > JMicron Technology Corp. JMB363
>
> If my memory is correct. This chip is trash. If I am right, I have same
> chip on cheap controller what I bought to get IDE controller mainly, it
> also has 2xSATA ports and I had only troubles with that controller in linux.
> If I had no drives on SATA ports, dmesg got spammed port errors. If I
> had drives installed, they was randomly dropping in and out. Chip itself
> was running hot as hell, I mean so hot that you could not keep finger on
> chip. I did put some small finns to it and I think it did help little
> for drives dropping in and out, but didn't solve it.
> If you want a cheap controller, get this chip:
> 02:00.0 SATA controller: ASMedia Technology Inc. Device 1166 (rev 02)
>
> It's been quite stable for me and didn't cost much. Only issue I have
> that I cannot force it's ports transfer speed to example 3.0G. Spinnin
> rust do not need 6.0G speed what in my experience increase chance for
> dropouts if you cables aren't 6.0G ready and how do you tell if they are
> when cable doesn't have any mention about it?
> I think it's something to do that it's PMP card and I don't understand
> how you have to format kernel parameter when you have PMP situation. I
> can tune internal controller all ports just fine, but not this expansion
> card. Kernel tell you it's forcing them to 3.0G, but when you check
> later what transfer speed is, it's still 6.0G
>
>
