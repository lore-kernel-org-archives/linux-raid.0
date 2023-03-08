Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA39FC678D5
	for <linux-raid@archiver.kernel.org>; Wed,  8 Mar 2023 08:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjCHIlb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Mar 2023 03:41:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjCHIlT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Mar 2023 03:41:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2DE1815A
        for <linux-raid@vger.kernel.org>; Wed,  8 Mar 2023 00:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678264829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gRzyUthiIO0er7RoHF+tKWGqVY5kdXGUdm2P7FDwAsw=;
        b=WgkLXOXdgUVMHdbsnRDILodYOJ96A+4P2NluEESJeZOsB7yA9EYAcbQRtDUQ/wqufHZW0i
        5v45MTdSqGo+aqry9faC+yzVdhzsaT7iFDTh/7FhIg1SqoIzRnZSz77LhuNFXRy7oB/3iv
        y6pJGDE+BHvjxY5IC696covIegXk3Q4=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-64-vRg06fGoNAORPtZvN62ldw-1; Wed, 08 Mar 2023 03:40:27 -0500
X-MC-Unique: vRg06fGoNAORPtZvN62ldw-1
Received: by mail-pj1-f70.google.com with SMTP id m9-20020a17090a7f8900b0023769205928so727910pjl.6
        for <linux-raid@vger.kernel.org>; Wed, 08 Mar 2023 00:40:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678264826;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gRzyUthiIO0er7RoHF+tKWGqVY5kdXGUdm2P7FDwAsw=;
        b=DW175KGE+CoJ6/zKodkDmanvgO1f9VA0rOjbBZWxAZBnwppg0gQ9ZrGjEFICAS93Du
         MAF4ZfqWRAfn1Qg6qvfkkLjkI1IfIfUhhjN9lTsncCmHrL6Zk1DvqfKUZC5LKclYRBfQ
         y+82atI1+M7tCAVEPaimEeIKG2/4wncVf/Nobq3ASAGtPiWTXgN07JRDpV/pZWUK5Bxj
         I91qp3HA7K/3EUs91Ol+DW8s6huDcr7QfsJQIxuz6kaTz1Gys8lNmlN2yd0LIKnM6IhU
         RauRsVdPgxCwgnEs4TuLw1YC2i7ButsMQIo7oBuM2B7hLXiaoSkgnoh17oLEGKIVnpRP
         ki8g==
X-Gm-Message-State: AO0yUKXEx483ZMWGuonZ8t5FYavvbUL/bqJEx+qjtx6/Zd9wfVOLGcGN
        92KMjMootqgNJUovtYntX8Wd8S9ghl6mXx4kXL8+ZfbHyOQeZw285nReTi9x0hkQoCKNRUfnUGy
        53JOtQOxIrjz/ttLnanzXwHcdBLk3OX7GSXzo9ZuvuryK/HE3
X-Received: by 2002:a17:902:efc3:b0:19a:6b55:a44d with SMTP id ja3-20020a170902efc300b0019a6b55a44dmr9197895plb.1.1678264826468;
        Wed, 08 Mar 2023 00:40:26 -0800 (PST)
X-Google-Smtp-Source: AK7set9YotYbtz0nLUxdfuTMJyJ9gHNXjh45JT2Yyci/KUYlumPbCWXDuyHTZ+OyQTXCyMyZTmYzZKkYZi0L1mz5V5E=
X-Received: by 2002:a17:902:efc3:b0:19a:6b55:a44d with SMTP id
 ja3-20020a170902efc300b0019a6b55a44dmr9197888plb.1.1678264826182; Wed, 08 Mar
 2023 00:40:26 -0800 (PST)
MIME-Version: 1.0
References: <CALTww2-1B08z+BgPKqoBMnGQ-PhB9Yr=bA7YR7HyzGX0K127MQ@mail.gmail.com>
 <2b52d846-054b-6265-21dc-b091b39b0ee9@demonlair.co.uk> <CALTww2-7O2Fj3E8gmLDb_XPb0NGARqvHXp3oJaDMeWFue_=yGQ@mail.gmail.com>
 <5d1fb871-80b7-a82a-25b5-14b156eec802@youngman.org.uk>
In-Reply-To: <5d1fb871-80b7-a82a-25b5-14b156eec802@youngman.org.uk>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 8 Mar 2023 16:40:14 +0800
Message-ID: <CALTww2_OP0YnvsxYW=LFA8B13nQo35gzsxLnWjLTZkrTZVB-kA@mail.gmail.com>
Subject: Re: What's the usage of md-autodetect.c
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     Geoff Back <geoff@demonlair.co.uk>,
        linux-raid <linux-raid@vger.kernel.org>,
        Nigel Croxon <ncroxon@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Mar 8, 2023 at 4:16=E2=80=AFPM Wols Lists <antlists@youngman.org.uk=
> wrote:
>
> On 08/03/2023 02:40, Xiao Ni wrote:
> >> (IIRC) get built if CONFIG_MD is set to M.  Changing the default for
> >> CONFIG_MD should not have any impact on this so long as the ability to
> >> set CONFIG_MD=3Dy does not get disabled (which would also be a regress=
ion).
> > I'm a little confused here. If I understand right, for the os that
>
> > doesn't use initrd
> > and we still have the ability to set CONFIG_MD=3Dy, so we can set it to
> > y and rebuild
> > the kernel. So the raid1 can be assembled by md auto-detect, right?
> >
> Bear in mind that - iirc - in order for the kernel to auto-assemble a rai=
d-1
>
> (a) it has to be superblock 0.9
> (b) superblock 0.9 is deprecated
>
> So the functionality is still used, still "supported", but we make no
> promises ...
>
> If it breaks, I'm sure people will scream and fix it, but from our point
> of view it's "if it ain't broke don't touch it".
>
> Cheers,
> Wol
>

Hi Wol

Thanks for the information.

Regards
Xiao

