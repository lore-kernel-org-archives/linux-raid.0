Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0BF0C433EF
	for <linux-raid@archiver.kernel.org>; Thu,  6 Jan 2022 01:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344455AbiAFBxa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 5 Jan 2022 20:53:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41012 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344450AbiAFBx0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 5 Jan 2022 20:53:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641434004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1Ee1p4G6J2sTk360ohjIYz8xlGjZ1bAejMNeaSvxDPA=;
        b=T21/X/ldHMis25FQc734Wh7z9faFIJ4mAAcku4kr4evmfxLpI8bJirSUaUFpnOGQ0Odnat
        FHZtG9s9fF8ibP+QteBvfPEklrIE5XlZPUaGrLFY75tsD1Vcr3A+UoElLhf2D9SvzQbXS6
        OoU45d/SqY/Aofp7GsbEqUP7I5Gxkis=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-298-cRrJwFydM5G7kVo5KQkZTg-1; Wed, 05 Jan 2022 20:53:23 -0500
X-MC-Unique: cRrJwFydM5G7kVo5KQkZTg-1
Received: by mail-ed1-f72.google.com with SMTP id i5-20020a05640242c500b003f84839a8c3so769187edc.6
        for <linux-raid@vger.kernel.org>; Wed, 05 Jan 2022 17:53:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Ee1p4G6J2sTk360ohjIYz8xlGjZ1bAejMNeaSvxDPA=;
        b=c+V4rPb9ERpCRlFPJ8wNAOtzQhUk/taBt6pzECosFJw3ekUTzWI64W2x3R8z3htkVW
         f4Nb5AjvJVQtGEAi3EUl7F2xwoKQGjrohtmJ32hAXIEe8KQ0+HDo0krmsaHVzVp6jwnb
         UglnIvusLOJJG0GSDe5vo21vxcmwafyWue2pre0uoD1XTwE7i6ZHzSCg/Y/8O+wZAV89
         YuIgwTi6bwUDWcnyMEgFxRDNQw1IElQYw5yB0PVP6HoNmiPXvjteJgUXKljM0AOXLXXE
         pyK/qxHXMLwwqDHWfcDE1raOIgmMK+IB48T03Fo9jZsN1mHbepn8xp4cE50zEbNe0IuC
         9X3A==
X-Gm-Message-State: AOAM5333qzGk5jd2ejVxGti/PhKZYZJCr1iEkNy2AgHNjHDPfvdL4P1C
        KIu1vxpnAfDdS7AhRg0S3CISfNzP0GwHHPoPGNEbJWQbr/XRdXdSRByClstqFcJI8mxBIlbWVkM
        KatNX1jS14TIXKukyt7r9HREZql55XOBJOhc9fQ==
X-Received: by 2002:aa7:cada:: with SMTP id l26mr56481687edt.376.1641434001875;
        Wed, 05 Jan 2022 17:53:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzbe7JUjmuKYSG6Dvo3WyszYfDHgH3CFpzJvDnZyC5eVxzpkV9YOLQVI4oy2VUpj7TCXZKHMgoZKBzmjkbZ0yI=
X-Received: by 2002:aa7:cada:: with SMTP id l26mr56481679edt.376.1641434001751;
 Wed, 05 Jan 2022 17:53:21 -0800 (PST)
MIME-Version: 1.0
References: <20211210093116.7847-1-xni@redhat.com> <6bb93ce0-30e0-ff3b-9457-470496f7b1bc@redhat.com>
 <CAPhsuW4wmHMyG-DjR+SO5rweU70iqm903z9X3Pkxhpb8GzHFzg@mail.gmail.com>
In-Reply-To: <CAPhsuW4wmHMyG-DjR+SO5rweU70iqm903z9X3Pkxhpb8GzHFzg@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Thu, 6 Jan 2022 09:53:11 +0800
Message-ID: <CALTww2-SF0juRYMvrkrexDOox5DzfuUM+TjsHA6dYxqzGGPUow@mail.gmail.com>
Subject: Re: [PATCH 0/2] md: it panice after reshape from raid1 to raid5
To:     Song Liu <song@kernel.org>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Nigel Croxon <ncroxon@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Jan 6, 2022 at 2:59 AM Song Liu <song@kernel.org> wrote:
>
> On Tue, Jan 4, 2022 at 3:30 PM Xiao Ni <xni@redhat.com> wrote:
> >
> > Hi Song
> >
> > Ping. Do I still change something else?
>
> I merged the two patches into one, rewrote the commit log, added
> Guoqing's Acked-by, and applied it to md-next.
>
> For future patches, please write the commit log according to the
> guidance in Documentation/process/submitting-patches.rst.
>
> Thanks,
> Song
>

Thanks. I'll read this doc and follow the instructions.

Regards
Xiao

