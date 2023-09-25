Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0EFECE7A89
	for <linux-raid@archiver.kernel.org>; Mon, 25 Sep 2023 07:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbjIYH7F (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Sep 2023 03:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbjIYH7C (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Sep 2023 03:59:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E576B3
        for <linux-raid@vger.kernel.org>; Mon, 25 Sep 2023 00:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695628696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L87wzYgBgGwZuiVFHiZUcLCo+dUlchfJ95HVn2+U9YU=;
        b=G+2ZeFxw7lqPxTqt3f+bCJr6yxMUk9KFJeYZCRAGUaLD7xwoFchP/BtRQvF9mIj7+H/0Km
        +XcfTyZrWyS7JuiMsaKtd1Qdt7lZZLJ0KZKz9qrk2p4VKy6F6UCqqR4ffpcDLtPZlkyULe
        FK4km3hAlJiZMTKkQYp8BktcvuqGHJw=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-307-IbfQL-2JPrKOh_eWmAe_8w-1; Mon, 25 Sep 2023 03:58:14 -0400
X-MC-Unique: IbfQL-2JPrKOh_eWmAe_8w-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-277576268e9so1446316a91.2
        for <linux-raid@vger.kernel.org>; Mon, 25 Sep 2023 00:58:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695628693; x=1696233493;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L87wzYgBgGwZuiVFHiZUcLCo+dUlchfJ95HVn2+U9YU=;
        b=GG43XaVorGAmZqTbw7kBSydY2+rHQ8i58zHrozp0+UvZdx4x0MgLLYolrZ/zFATSq7
         gLroUgOHCxguVumZc+VyIPLZwPyWJKtHYuHpgCNG07aZL5k/qMY48gfMalFMfVKKNncY
         6ktIhrnisOToBGnik7g8L4WW7MQGltSKeMrsrbDghe1/OSAbzr+WvQ26rcN1eUdPV0sT
         p01aakgrGwWlrLR8jAQMfvBC+LpssXmVyYoSmX3/KXZ0LZ1Yp4C0dSZU056gq3a/HtLW
         VnDgSJtRww5ykf3BwpIjVzTyDePtTbv/UCVMOY5lYLmOMyj2B1rU+HQhV/tSTR2tcsvS
         G2iw==
X-Gm-Message-State: AOJu0YwAtNlyVqCpPlqp5U+HSVkvOx+AoIvP4RdBcZUufwQ594n7w5LY
        XHpn/NU+2OX8zl+u0ySNa4h5A/3OK/tBd5p/WNzaInOMaz7QteG4TEd1jU3NKn/W+MFBs6xBebY
        FuGzcviDOROUU8YWJQCdrUEGH+MP33loubZeNtQ==
X-Received: by 2002:a17:90a:f298:b0:269:6c5:11a7 with SMTP id fs24-20020a17090af29800b0026906c511a7mr3761444pjb.17.1695628693660;
        Mon, 25 Sep 2023 00:58:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEUHlCR4v/MWcEU3R+aDOAkhHVQ8j4RqKF2cT2K2UDK1UaBW28SvLxDtzYC6qYK1vvOo4NEDTrotl718upwZN4=
X-Received: by 2002:a17:90a:f298:b0:269:6c5:11a7 with SMTP id
 fs24-20020a17090af29800b0026906c511a7mr3761439pjb.17.1695628693390; Mon, 25
 Sep 2023 00:58:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230830092902.1236950-1-yukuai1@huaweicloud.com> <CAPhsuW4QNwL3+AXk8_ZNwgSAZj9k6Ce=tPmz9xPHwC+BjT=Dcg@mail.gmail.com>
In-Reply-To: <CAPhsuW4QNwL3+AXk8_ZNwgSAZj9k6Ce=tPmz9xPHwC+BjT=Dcg@mail.gmail.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 25 Sep 2023 15:58:02 +0800
Message-ID: <CALTww28+gk4upte4wo=VBJxYCJxr2i1hdcwy+OwNHY1PqaCqVg@mail.gmail.com>
Subject: Re: [PATCH -next 0/2] md: fix potential hang for mddev_suspend()
To:     Song Liu <song@kernel.org>
Cc:     Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, yukuai3@huawei.com,
        yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Sep 23, 2023 at 5:33=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> On Wed, Aug 30, 2023 at 2:33=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com>=
 wrote:
> >
> > From: Yu Kuai <yukuai3@huawei.com>
> >
> > Yu Kuai (2):
> >   md: factor out helpers to grab and put 'active_io'
> >   md: fix potential hang for mddev_suspend()
>
> Applied to md-next. Thanks!
>
> Song
>
> >
> >  drivers/md/md.c | 36 ++++++++++++++++++++++++++++++------
> >  1 file changed, 30 insertions(+), 6 deletions(-)
> >
> > --
> > 2.39.2
> >
>

Hi all

For the second patch, active_io_release does this job. So it doesn't
need to do this in md_array_exit again.

Best Regards
Xiao

