Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8093BC001B0
	for <linux-raid@archiver.kernel.org>; Thu, 10 Aug 2023 12:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbjHJMNM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 10 Aug 2023 08:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbjHJMNL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 10 Aug 2023 08:13:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4AB3268E
        for <linux-raid@vger.kernel.org>; Thu, 10 Aug 2023 05:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691669541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ql049NZOChsdS3y6i1d+Dpvs4jWqeja2amLw8nSx5Do=;
        b=GIIIXn/AFiYRWsbOk3uxV6wlf0Vs8YnGpVocA9VtRz4icH6oBHS+eqKacbpFT6UNIuiGCt
        Ke7UJLdIwOjTb/rLq/92Jxr/r5cCtISSXhw4Smm5wyEzfitmC+MUq+G7N0o95q5Op472hT
        4i1fvllhxsiJCSexQ26qseOYFLEN3N0=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-513-SxD0estoPym-jwtWXNSMQQ-1; Thu, 10 Aug 2023 08:12:20 -0400
X-MC-Unique: SxD0estoPym-jwtWXNSMQQ-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-5868992ddd4so12253147b3.0
        for <linux-raid@vger.kernel.org>; Thu, 10 Aug 2023 05:12:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691669539; x=1692274339;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ql049NZOChsdS3y6i1d+Dpvs4jWqeja2amLw8nSx5Do=;
        b=Hn9IdGGmzbSdLWxeQ3LqrPerd+18lAi4lYs91r+f/iM6C8WeK6PmoEkBzSf537h4RQ
         ke5s8qNPKbis/xAMV/pNITZQsAY4bMLbnCXiHgcyIJtfh8mCcTEaJmnnLNXPGuvpd84b
         3DP693vNqtKXJakmpjT8Jr8P2UVBT/gyTV3nAIIDTxjoXKnK3aTnE110gV0j7pWZ2G8O
         gH5yz0DeqcVOSFQ4IH02RVlCIDirDnCjQqeaAolHj10MzaA2qg61zXfxpSuYdZe4oWdA
         k7yvEBghVpLMggtm3rEcMRkhXJF3Emu1rs+lhAqRcwuNBvnuMh8rFedbZDB0Iw9EqPSn
         5Hjw==
X-Gm-Message-State: AOJu0Yyit/3+q1kHXLlIPto+PhMcWKdKxJTeghLiT5j23Gld+8tPnvI5
        3u6N7lIXjx/2gRVLrEAIx7HufGGhAb2P1iSE/ZIkX9yOSFYKzFmMDVG3aDqPVi92gVPd1wtGg40
        GFcp7KF74k/hqR0E5oZTRTg==
X-Received: by 2002:a25:2e47:0:b0:d3b:108b:c104 with SMTP id b7-20020a252e47000000b00d3b108bc104mr2077139ybn.54.1691669539359;
        Thu, 10 Aug 2023 05:12:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHScNZ+hiLT7tQi+74VbiPycnVQCNc8IU6zksjojkX/7DokAG9J0nZL8PoxzJfMW8To73oHhA==
X-Received: by 2002:a25:2e47:0:b0:d3b:108b:c104 with SMTP id b7-20020a252e47000000b00d3b108bc104mr2077127ybn.54.1691669539027;
        Thu, 10 Aug 2023 05:12:19 -0700 (PDT)
Received: from ?IPv6:2600:6c64:4e7f:603b:fc4d:8b7c:e90c:601a? ([2600:6c64:4e7f:603b:fc4d:8b7c:e90c:601a])
        by smtp.gmail.com with ESMTPSA id g9-20020a256b09000000b00cf79d3a503fsm295086ybc.42.2023.08.10.05.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 05:12:18 -0700 (PDT)
Message-ID: <069a0758d1d2199c5231e920aed6dfff0a552d87.camel@redhat.com>
Subject: Re: [PATCH] md: raid0: account for split bio in iostat accounting
From:   Laurence Oberman <loberman@redhat.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        David Jeffery <djeffery@redhat.com>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Date:   Thu, 10 Aug 2023 08:12:17 -0400
In-Reply-To: <2c18c875-bc00-465a-9e19-c66d63c07987@molgen.mpg.de>
References: <20230809171722.11089-1-djeffery@redhat.com>
         <2c18c875-bc00-465a-9e19-c66d63c07987@molgen.mpg.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 2023-08-10 at 08:42 +0200, Paul Menzel wrote:
> Dear David,
>=20
>=20
> Thank you for your patch.
>=20
> Am 09.08.23 um 19:16 schrieb David Jeffery:
> > When a bio is split by md raid0, the newly created bio will not be
> > tracked
> > by md for I/O accounting. Only the portion of I/O still assigned to
> > the
> > original bio which was reduced by the split will be accounted for.
> > This
> > results in md iostat data sometimes showing I/O values far below
> > the actual
> > amount of data being sent through md.
> >=20
> > md_account_bio() needs to be called for all bio generated by the
> > bio split.
>=20
> Could you please add how you tested this?
>=20
> > Signed-off-by: David Jeffery <djeffery@redhat.com>
> > Tested-by: Laurence Oberman <loberman@redhat.com>
> > ---
> > =C2=A0 drivers/md/raid0.c | 3 +--
> > =C2=A0 1 file changed, 1 insertion(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> > index d1ac73fcd852..1fd559ac8c68 100644
> > --- a/drivers/md/raid0.c
> > +++ b/drivers/md/raid0.c
> > @@ -597,8 +597,7 @@ static bool raid0_make_request(struct mddev
> > *mddev, struct bio *bio)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0bio =3D split;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > =C2=A0=20
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (bio->bi_pool !=3D &mddev=
->bio_set)
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0md_account_bio(mddev, &bio);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0md_account_bio(mddev, &bio);
> > =C2=A0=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0orig_sector =3D sector;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0zone =3D find_zone(mdde=
v->private, &sector);
>=20
>=20
> Kind regards,
>=20
> Paul
>=20
Hello

This was actually reported by a customer on RHEL9.2 and the way this
played out is they were reading the md raid device directly using dd
buffered reads.
The md raid serves an LVM volume and file system.

Using dd if=3D/dev/md0 of=3D/dev/null bs=3D1024K count=3D10000 you would
sporadically see iostat report these numbers where the raid md0 shows
invalid stats.=20

     tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn Device
   221.00       111.0M         0.0k     111.0M       0.0k dm-12
   222.00       110.0M         0.0k     110.0M       0.0k dm-15
   223.00       111.0M         0.0k     111.0M       0.0k dm-16
   220.00       109.0M         0.0k     109.0M       0.0k dm-17
   221.00       111.0M         0.0k     111.0M       0.0k dm-18
   221.00       111.0M         0.0k     111.0M       0.0k dm-19
   219.00       109.0M         0.0k     109.0M       0.0k dm-20
   219.00       110.0M         0.0k     110.0M       0.0k dm-22
   880.00         6.9M         0.0k       6.9M       0.0k md0
                ******

After patching with David's patch the issue is no longer reproducible.
We tested using the same method that reproduced the issue reported by
the customer.

Thanks
Laurence


