Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6375EC433F5
	for <linux-raid@archiver.kernel.org>; Fri,  4 Mar 2022 14:22:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236423AbiCDOXF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 4 Mar 2022 09:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiCDOXF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 4 Mar 2022 09:23:05 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DC41BA934
        for <linux-raid@vger.kernel.org>; Fri,  4 Mar 2022 06:22:17 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id m14so14443397lfu.4
        for <linux-raid@vger.kernel.org>; Fri, 04 Mar 2022 06:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y+8BFWeTDZl/2d1AXPvO9pWr6QPJwoBijPhYIiffYXE=;
        b=GeiyEV8qvOHEKH6Rg6fVSG+MZOqDZLzWdKEGPCJ7fprNIDQUUVHr4qcAwu/RDBiHJB
         dgvchNnENq4DuTE39vOehBacq6FRSzfPcno50qYj4PO6A7n9cL13eI3U2r3sCWKqUoPn
         M9NcxZyOU7l8ksirF1i4MzwzRMJ/I/IgRMdrZAxXT08eGlIbIEYR793E2+/5i5Z/ME8q
         2ps5JTf0nZVZMMlUM3dthH+/YYBJ+BDGMPBCGCpYTUiFrRrX4xfmbzzk9kvKLdOK53sy
         xwMS3YzStBvUn7MwztJ0IZmf2D/NelQfzB/kwF0L5lQoWD9AN5xcA5Axv6uA0ioxtIUG
         HCdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y+8BFWeTDZl/2d1AXPvO9pWr6QPJwoBijPhYIiffYXE=;
        b=NdVNErJ3vNXE7N30jGE/KHgbFkGx5sl5xGGnA/mPXL2lY/Y2oIsZmyDe09EA5NI1D0
         cc5CnHw1ISk+2gbRtJy/CWuXllcQKpucA1Sh99iNee2012gmGXib49bU+HYYCggppchT
         /cmi29HIM+UBvmBmhcghxDUGmolyN5lB5h5IBloDTz2LIQ4j1MxpOMhKqZnNPtcUfQRU
         CKIQwkYpCorCAeZIwMj9Eld2+7Sbvyg8fL1Ks0zjsK65atn+FDUZe9VgbOIedxL6zqhg
         C+nWxcU/AdjQ5k105CjYeFzSTDUiYIP/+V2jBuaPjx1pm9NkTS+n60rVdTskTzihqm0l
         N5zQ==
X-Gm-Message-State: AOAM531Al/IH3x2wXTOg/TxL8ia/KNNgRuT1111Pv0EUu+cXkyO4+tB3
        PS0rer8L17ZtFdqB6iKEI9FuP/hneyepLW2xV1U=
X-Google-Smtp-Source: ABdhPJy8auYtlQBjuBec9ebqz2S6rwhlsow0qPnNeFOv3aBOjzb+8dmz0L8Y+uAqwaoiHzNqznt+G1m9h6bAQKw+hvA=
X-Received: by 2002:a05:6512:2290:b0:445:bd9e:6501 with SMTP id
 f16-20020a056512229000b00445bd9e6501mr7769754lfu.282.1646403733938; Fri, 04
 Mar 2022 06:22:13 -0800 (PST)
MIME-Version: 1.0
References: <11cfe3aa-b778-b3e5-a152-50abc6c054ac@deltatee.com>
 <34a8b64a-37d3-9966-1fe8-d57c432600d7@deltatee.com> <806cdd27-8633-09dd-6942-12437c8b9818@linux.dev>
 <ff15d173-277a-499e-d019-07f4d4ed9f19@deltatee.com>
In-Reply-To: <ff15d173-277a-499e-d019-07f4d4ed9f19@deltatee.com>
From:   o1bigtenor <o1bigtenor@gmail.com>
Date:   Fri, 4 Mar 2022 08:21:37 -0600
Message-ID: <CAPpdf58n6NoNBGsoRDWSAn-wVL=voSD5YXiUHm_a-_N616y6HQ@mail.gmail.com>
Subject: Re: Raid5 Batching Question
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Linux-RAID <linux-raid@vger.kernel.org>,
        Shaohua Li <shli@kernel.org>, Shaohua Li <shli@fb.com>,
        Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Mar 3, 2022 at 6:27 PM Logan Gunthorpe <logang@deltatee.com> wrote:
>
>
>
> On 2022-03-02 6:40 p.m., Guoqing Jiang wrote:
> >
> >
> > On 3/3/22 7:24 AM, Logan Gunthorpe wrote:
> >> So I'm back to square one trying to find some performance improvements
> >> on the write path.
> >
> > Did you try with group_thread_cnt?
> >
> > /sys/block/md0/md/group_thread_cnt
>
> Yes, I've tried group_thread_cnt and raised stripe_cache_size and a few
> other parameters. Still get limited write performance.
>

Ermmmmmm - - - not speaking as any kind of expert - - - but - - - is this
not where your Raid 10 shines - - - fastest write with the striping and
and and. This may NOT be the case - - - tossing the idea into the ring
(hoping the real 'experts' will chime in!).

HTH
