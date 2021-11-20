Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7441EC433F5
	for <linux-raid@archiver.kernel.org>; Sat, 20 Nov 2021 07:24:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236816AbhKTH1C (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 20 Nov 2021 02:27:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:41786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236790AbhKTH0n (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 20 Nov 2021 02:26:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B36A60E93;
        Sat, 20 Nov 2021 07:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637393020;
        bh=yjzvhNcky041CJZ1uMGGqIn7woM9nhsIlPxWsJ0q0lU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=X6G9mpaBxLI82jpYTQnHU8reA3NvMkFXnOjLYR2QzhXgjjMSRXdBVnExaKyNiZ0Ew
         GuCP/CEISRCzKKDNr5MgRWbfwpOUEEliAb0NIsU01RvxXaqIuYq8RkpiCEGRxIFKVL
         0EaN/ra2WMVtVVM6RLOsGkc6TEbjqvTXMWy8FVHuHHeIJhuYcCdeZqSU1ysl+Zp5xN
         EULeES6C5RRMaeihY6wGozUJWD3OjDceAZkrase5ljOe2rPD83H7+IX6PvZWQ2zVLw
         dOnSmcVOKzwr0EWWxjjZM6O+x0jNHSvYFMoHxH9t+y962BknJAUE6+ORYx+1AhcSef
         RDBoB94Zhu4bA==
Received: by mail-yb1-f174.google.com with SMTP id j77so13907893ybg.6;
        Fri, 19 Nov 2021 23:23:40 -0800 (PST)
X-Gm-Message-State: AOAM531YSt5Ml28plT7FFxXMFWJ/kzdqguGSFHOfF6C8V6ywYKJUFq0b
        BUinIx1a8KYBjZCjsQcRwJLOrVGgAQWLA4sa81Q=
X-Google-Smtp-Source: ABdhPJxZehMkA4qKbP5ybYfYk3uvwIeMbRvBcKpGd8XnJPkd2cMJZcFHLQfbtjXhnxj/qD5Xz8JJGSIYwGECLEEZC1E=
X-Received: by 2002:a25:660d:: with SMTP id a13mr44779897ybc.460.1637393019876;
 Fri, 19 Nov 2021 23:23:39 -0800 (PST)
MIME-Version: 1.0
References: <20211115031817.4193-1-bernard@vivo.com> <PSAPR06MB40216A2C236343B2300EFC48DF9A9@PSAPR06MB4021.apcprd06.prod.outlook.com>
In-Reply-To: <PSAPR06MB40216A2C236343B2300EFC48DF9A9@PSAPR06MB4021.apcprd06.prod.outlook.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 19 Nov 2021 21:23:28 -1000
X-Gmail-Original-Message-ID: <CAPhsuW7SCEXrU3AL8isD-3NwH+ChgwbUAR6y+6xDVRbZTFnEJg@mail.gmail.com>
Message-ID: <CAPhsuW7SCEXrU3AL8isD-3NwH+ChgwbUAR6y+6xDVRbZTFnEJg@mail.gmail.com>
Subject: Re: [PATCH] drivers/md: fix potential memleak
To:     =?UTF-8?B?6LW15Yab5aWO?= <bernard@vivo.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Nov 16, 2021 at 9:57 PM =E8=B5=B5=E5=86=9B=E5=A5=8E <bernard@vivo.c=
om> wrote:
>
>
>
> -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> =E5=8F=91=E4=BB=B6=E4=BA=BA: bernard@vivo.com <bernard@vivo.com> =E4=BB=
=A3=E8=A1=A8 Song Liu
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2021=E5=B9=B411=E6=9C=8817=E6=97=A5=
 15:06
> =E6=94=B6=E4=BB=B6=E4=BA=BA: =E8=B5=B5=E5=86=9B=E5=A5=8E <bernard@vivo.co=
m>
> =E6=8A=84=E9=80=81: linux-raid <linux-raid@vger.kernel.org>; open list <l=
inux-kernel@vger.kernel.org>
> =E4=B8=BB=E9=A2=98: Re: [PATCH] drivers/md: fix potential memleak
>
> On Sun, Nov 14, 2021 at 7:18 PM Bernard Zhao <bernard@vivo.com> wrote:
> >
> > In function get_bitmap_from_slot, when md_bitmap_create failed,
> > md_bitmap_destroy must be called to do clean up.
>
> >Could you please explain which variable(s) need clean up?
>
> Hi Song:
> The follow is the function md_bitmap_create`s annotation :
> /*
>  * initialize the bitmap structure
>  * if this returns an error, bitmap_destroy must be called to do clean up
>  * once mddev->bitmap is set
>  */
> struct bitmap *md_bitmap_create(struct mddev *mddev, int slot)
>
> It is mentioned that bitmap_destroy needs to be called to do clean up.
> Other functions which called md_bitmap_create in the same file also calle=
d md_bitmap_create to clean up(in the error branch), but this one didn`t.
> I am not sure if there is some gap?

I don't think we need to call md_bitmap_destroy in some of these cases.
Please read the code carefully can decide where these are needed based
on the logic of the code.

Thanks,
Song
