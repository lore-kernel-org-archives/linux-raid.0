Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D90CCE7A88
	for <linux-raid@archiver.kernel.org>; Sun, 24 Sep 2023 02:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjIXC5R (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 23 Sep 2023 22:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjIXC5Q (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 23 Sep 2023 22:57:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA00C127
        for <linux-raid@vger.kernel.org>; Sat, 23 Sep 2023 19:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695524184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=drnMR4f81eF1iT4Qc7JdBdiCj9DRJ/L18uClMjiBEG0=;
        b=FfrLB63pCie662iwFCWr8FKHCb/oop5fkUJA2l5nnnJgaSzNm1JdkitQu7TPa92wJVeKu9
        qDcnVBFfyKhKm/FZMdYhK5uPwILS7lVHl0Y1Mbmc96kuv2i2yxA+WK48Ug5sAU4ALSqkC/
        AtG3IR0bwKn0W4HE0vaYI5joPQObB3w=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-zDmN3V5lNm-UQIhEnUOMpQ-1; Sat, 23 Sep 2023 22:56:22 -0400
X-MC-Unique: zDmN3V5lNm-UQIhEnUOMpQ-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-274bc2cb2dbso3139842a91.0
        for <linux-raid@vger.kernel.org>; Sat, 23 Sep 2023 19:56:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695524181; x=1696128981;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=drnMR4f81eF1iT4Qc7JdBdiCj9DRJ/L18uClMjiBEG0=;
        b=QzCvGGFk9m48VDP4+4npeOAz6tPq9GzkxDjTm48ZazsyTpsaKhAMCbmfzBnJFBkxYw
         p1ciEWnuztXawG6HuvO/xjJCnhkt74GXgzpopFlQmkvkmvGGBtFKn/YfRWtpP1jwrSWH
         zJB7hhCcyH9w37IOCuErefktKyQr34PPLW6e88V2CytGcMkJ8jDoTDh3F5MJse6jRtJ6
         GpztKwIx4jqg3u7tN+K1rF4Ki4VEZRRo8fRtnJyOgIaDFjAlLfnVdok952F9h/LIYCm8
         t4Ht5TlTR//FzcYHA8Y1JTx5MqiJ5dLArQo/+MRrUOk9y3hMRtD8d34goWwmTu0j94g9
         Xx6A==
X-Gm-Message-State: AOJu0YyFl6FJIiQBDSxUJYvKf/ie232XrjJZ4Z7I+lm1VurWWSsKMnd6
        FTkRdkFrkORYAwQHJZGrJMn3ognW+QHTCiVsqzx+D6xXY8fkntICum2kn92xh4559c2x7pFkzcU
        zaisrgd60WI/aQqQj6hRZ6HAn0/asOH4ETzdKC1v8W/FGlDc4vWZz2g==
X-Received: by 2002:a17:902:d894:b0:1c0:a5c9:e072 with SMTP id b20-20020a170902d89400b001c0a5c9e072mr2243099plz.11.1695524181098;
        Sat, 23 Sep 2023 19:56:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGojcT7eZRm3obLtfNge0+7aNUfOu9ZBozEx4G38mY+EQK6sqWSh+lYhd+HidrLHfLNFdTTTvwWlNL3KmCgqCI=
X-Received: by 2002:a17:902:d894:b0:1c0:a5c9:e072 with SMTP id
 b20-20020a170902d89400b001c0a5c9e072mr2243089plz.11.1695524180693; Sat, 23
 Sep 2023 19:56:20 -0700 (PDT)
MIME-Version: 1.0
References: <9b21efef0bc1457c89250761b2b6cf2c@TW-EX2013-MBX1.supermicro.com>
 <CALTww29MWS9GY+kc+0nTJywBZVk=aNnzujbNXkPHAjKoO5ZJDw@mail.gmail.com> <1d1fafd557ef4e82a27a3192ffd5dfda@TW-EX2013-MBX1.supermicro.com>
In-Reply-To: <1d1fafd557ef4e82a27a3192ffd5dfda@TW-EX2013-MBX1.supermicro.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Sun, 24 Sep 2023 10:56:08 +0800
Message-ID: <CALTww2_Bwkhf0XT6hAy2VzFYf5h+Ai9NRPhCBu3n5R7Yc4LAAg@mail.gmail.com>
Subject: Re: bblog overlap internal bitmap?
To:     Stan Liao <StanL@supermicro.com>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Sep 22, 2023 at 10:36=E2=80=AFAM Stan Liao <StanL@supermicro.com> w=
rote:
>
> Xiao Ni wrote:
> > On Thu, Sep 21, 2023 at 11:22=E2=80=AFAM Stan Liao <StanL@supermicro.co=
m> wrote:
> > >
> > > Hi,
> > > A md-raid (level 1) is created with 5 nvme drives and the metadata ve=
rsion
> > is specified as 1.2. The following command is used.
> > > sudo mdadm --create /dev/md0 --level=3D1 --raid-devices=3D5
> > > /dev/nvme{1,2,3,4}n1 /dev/nvme4n2 --metadata=3D1.2 The capacities of
> > nvme{1,2,3,4}n1 and nvme4n2 are 3.2TB, 1.92TB, 3.2TB, 512GB, and 512GB.
> > > OS: 20.04.1-Ubuntu
> > > mdadm version: v4.1 - 2018-10-01
> > > After creation, we found that the size of the bitmap_super_t and inte=
rnal
> > bitmap is 16KB (this is concluded by observing FF value is filled from =
around
> > byte offset 0x100 of LBA 0x10 to byte offset 0x1FF of LBA 0x1F), but th=
e
> > mdp_superblock_1.bblog_offset value is 0x10. As a result, the
> > mdp_superblock_1 occupies LBA 0x08 ~ 0x0F; bitmap_super_t and internal
> > bitmap occupy LBA 0x10 ~ 0x20; bblog occupies LBA 0x18 ~ 0x20.
> > > If bblog and bitmap do overlap, I would like to know the size value u=
sed to
> > calculate bitmap size and bblog_offset. The size value used to calculat=
e
> > bitmap size and bblog_offset is mdp_superblock_1.size or
> > mdp_superblock_1.data_size? Thanks a lot.
> > >
> >
> > Hi
> >
> > For super1.2 the layout should be:
> > |    4KB    |    4KB    |    bitmap space    |    head room    |
> > data |
> >
> > The first 4KB is empty from the beginning of the disk. The second 4KB i=
s for
> > md superblock. Then is bitmap suerblock. So if you want to see the cont=
ent
> > of bitmap_super_t, the offset should be 0x2000?
> >
> > Regards
> > Xiao
>
> Right. The bitmap_super_t is at offset 0x2000 (absolute LBA address 0x10)=
.
> And mdadm write bitmap_super_t and bitmap from LBA 0x10 to LBA 0x1F.
> Including bblog, super1.2 layout would be:
> |  4KB  |  4KB  |  bitmap space  |  bblog  |  head room  | data |
> We observe the bblog_offset value, which resides in mdp_superblock_1, is =
0x10.
> So we think there is an overlap between bitmap and bblog.
>

Because the bblog_offset is based on the start of superblock. So if
you want to calculate the offset based on the start of the disk, it
needs to add 4KB on bblog_offset. Now your bblog_offset is 0x10. It
means from the start of the superblock, it's 4K(superblock) +
4K(bitmap space). So your raid only has one page, right?

You can also you mdadm -E $member to check the "Bad Block Log"

Regards
Xiao

