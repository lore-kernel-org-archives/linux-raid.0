Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03216C001E0
	for <linux-raid@archiver.kernel.org>; Wed,  9 Aug 2023 17:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbjHIRXh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Aug 2023 13:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbjHIRX2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Aug 2023 13:23:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9ECF26B9
        for <linux-raid@vger.kernel.org>; Wed,  9 Aug 2023 10:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691601755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PFqZjZ0/jglNAl1ZqeUOj8V5yjPrF91VpUDlVm4o9ZA=;
        b=PBrSt0GoPs1eGp6BOTc1xy5zd+yva7hlTz/VS36TkPQvwmRC8W1Y0AZCH+Ezzrqv4X16dI
        skpYDCPYy4WmyBxKsX0P/O4+i8vHQgPw8XCljwXK5eyOaEcIVlcMVtQtK8mEYMcoeFdklP
        x/i/6f1gzl38RQ40i0IFixwFBmE5rQ0=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412-VuP_R6trNPaKvEXBDmg8YA-1; Wed, 09 Aug 2023 13:22:34 -0400
X-MC-Unique: VuP_R6trNPaKvEXBDmg8YA-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-586aca4586aso1416077b3.2
        for <linux-raid@vger.kernel.org>; Wed, 09 Aug 2023 10:22:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691601754; x=1692206554;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PFqZjZ0/jglNAl1ZqeUOj8V5yjPrF91VpUDlVm4o9ZA=;
        b=A2k4oWSc1BYlbccMFBhvfrkf0SYXUHiP1Xf1WepuNu3rZlhdSz5ms39jw65O9pASHb
         UyD7/R//c6LePLQXdodgyVtpgzjPbfkFSBMSiaF71JHLkxBSzhijRnx7o8OUTHQAMtXf
         fb8CSzh6UPZCnR4KG44UxusVcwHAlRMEjODxVxAwdplZwYiTSQpKLhzstGQ8nSMAqiCJ
         PSbwJHbzr1gBRmIST4za3aZ9nxTHrmJnd6cWyoi3Og4noyluliGS21CFbA/KvyK8TED+
         YBrJYPOfBthxm0jYhsyKhFblda4gnsTtGS9d+rL4E4nlmznp/ahP7v7PTWzN4Jz9DduR
         V8OA==
X-Gm-Message-State: AOJu0Ywukjqcm4LT/l3P7ihBMN3PaIjXTaAncx77UvjrUk+QpbXy1bTc
        gfVw6V9gKfwh2Px+Ge7l+2iz2NW2HHiD6x3nzb5k+SViH0yzvcn5Pl/ShWAMSjsVlW5QtjUnSmC
        e7yjVfnfSkwxRC4ofvZVfGA==
X-Received: by 2002:a0d:e281:0:b0:583:fa2b:26d2 with SMTP id l123-20020a0de281000000b00583fa2b26d2mr3189618ywe.7.1691601752655;
        Wed, 09 Aug 2023 10:22:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEUrv/JFEF5k8ejT4KpoGWN0uZKajJwKsBt0W1Jb0qGGIjB4kUbCuCOeKQIp+FGJLN3rKJ3kg==
X-Received: by 2002:a0d:e281:0:b0:583:fa2b:26d2 with SMTP id l123-20020a0de281000000b00583fa2b26d2mr3189607ywe.7.1691601752359;
        Wed, 09 Aug 2023 10:22:32 -0700 (PDT)
Received: from ?IPv6:2600:6c64:4e7f:603b:fc4d:8b7c:e90c:601a? ([2600:6c64:4e7f:603b:fc4d:8b7c:e90c:601a])
        by smtp.gmail.com with ESMTPSA id d201-20020a814fd2000000b00586b5b6347csm3424138ywb.109.2023.08.09.10.22.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 10:22:31 -0700 (PDT)
Message-ID: <2fc52d45efaf42796202d934d523ad5083ae0a9f.camel@redhat.com>
Subject: Re: [PATCH] md: raid0: account for split bio in iostat accounting
From:   Laurence Oberman <loberman@redhat.com>
To:     David Jeffery <djeffery@redhat.com>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org
Date:   Wed, 09 Aug 2023 13:22:30 -0400
In-Reply-To: <20230809171722.11089-1-djeffery@redhat.com>
References: <20230809171722.11089-1-djeffery@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 2023-08-09 at 13:16 -0400, David Jeffery wrote:
> When a bio is split by md raid0, the newly created bio will not be
> tracked
> by md for I/O accounting. Only the portion of I/O still assigned to
> the
> original bio which was reduced by the split will be accounted for.
> This
> results in md iostat data sometimes showing I/O values far below the
> actual
> amount of data being sent through md.
>=20
> md_account_bio() needs to be called for all bio generated by the bio
> split.
>=20
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Tested-by: Laurence Oberman <loberman@redhat.com>
> ---
> =C2=A0drivers/md/raid0.c | 3 +--
> =C2=A01 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index d1ac73fcd852..1fd559ac8c68 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -597,8 +597,7 @@ static bool raid0_make_request(struct mddev
> *mddev, struct bio *bio)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0bio =3D split;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> =C2=A0
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (bio->bi_pool !=3D &mddev->=
bio_set)
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0md_account_bio(mddev, &bio);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0md_account_bio(mddev, &bio);
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0orig_sector =3D sector;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0zone =3D find_zone(mddev-=
>private, &sector);

Works well, looks good.
Reviewed-by: Laurence Oberman <loberman@redhat.com>

