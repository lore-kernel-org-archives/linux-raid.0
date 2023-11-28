Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RBe2o3Qd"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8E6131
	for <linux-raid@vger.kernel.org>; Tue, 28 Nov 2023 10:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701197425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=38R9LORzNUR0oms4ExAytuVNMb8ujiGUAnF1nTT7VV4=;
	b=RBe2o3QdDpQ9quzVI0OOISS3rCnOxefvibx55DW0XYa5g9/R5iMKO4heac88JUd7P8f7bn
	nRF8Z7RXKmaHzAwa5opqnVg0Zuo8oj3/7FKHh49ZcrOfNITXZeYTWzUTUGq/4h/jHz4ZWs
	igJAyKCqYakampJiiRBXGw6AD4h9Whw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-284-BvmzQmscM3KlBPayC-Yd9A-1; Tue, 28 Nov 2023 13:50:24 -0500
X-MC-Unique: BvmzQmscM3KlBPayC-Yd9A-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-77dc7cf66cdso82896785a.0
        for <linux-raid@vger.kernel.org>; Tue, 28 Nov 2023 10:50:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701197424; x=1701802224;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=38R9LORzNUR0oms4ExAytuVNMb8ujiGUAnF1nTT7VV4=;
        b=IySeZJSNwZ5k1ue4HRAtQedh3i1njply+1Mc8yzJ05Duwgg3r7CgP8/cFSJEw2PtpW
         yns+hRIWMEp88s4jhQbV3/kEjhjJvzDabNJPQQ9iq3bON+LjcBNxVPNnvuCG4VmxSDsl
         Pr7UhSJcjwun6KSsHdn4HGp3b1221Hy7oSswou/z0BIOBgGQJ0VFX8MbCWXmRBx/3FkE
         FyTvRyu1nkDsatGYsZFPn/xTTnXr8ikIq5t9TL6Dysk/oCAR4VZeEDRrRJcTkjSmaATP
         SIp/X24CRL2Vtydbi0tfh5NTfdGg6WjQ9I3rFSPPZL/bi4gZu3c76NxN0UjlKciAmoz1
         prOA==
X-Gm-Message-State: AOJu0YwWj6gsb4a7IEpMA1q4h84a1Djs9pviFvcw7Jbk64PiNM/1VM2v
	n7YgOXs0BhQ60KWNIplf6LTqrnD1zLvG8pPRLfYBR3uOFwDQbN1+A6JPnS4a/6dHzaeYonx7QyK
	lR1GnjoaUsjwAxHq8vMcZlA==
X-Received: by 2002:a05:620a:278c:b0:76e:601d:a724 with SMTP id g12-20020a05620a278c00b0076e601da724mr20778877qkp.34.1701197423806;
        Tue, 28 Nov 2023 10:50:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGnPncklJF+pbUrpPPRCU9ShwkdMFgtdTPCGLdSwqq376P1uKJEnfKtjFjx0oh7damyG3VQSQ==
X-Received: by 2002:a05:620a:278c:b0:76e:601d:a724 with SMTP id g12-20020a05620a278c00b0076e601da724mr20778863qkp.34.1701197423511;
        Tue, 28 Nov 2023 10:50:23 -0800 (PST)
Received: from ?IPv6:2600:6c64:4e7f:603b:7f10:16a0:5672:9abf? ([2600:6c64:4e7f:603b:7f10:16a0:5672:9abf])
        by smtp.gmail.com with ESMTPSA id v17-20020a05620a091100b0077263636a95sm4714490qkv.93.2023.11.28.10.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 10:50:23 -0800 (PST)
Message-ID: <87788bb04b1e0d43aa77241a1c4ea4d108079096.camel@redhat.com>
Subject: Re: [PATCH] md/raid6: use valid sector values to determine if an
 I/O should wait on the reshape
From: Laurence Oberman <loberman@redhat.com>
To: David Jeffery <djeffery@redhat.com>, Song Liu <song@kernel.org>, 
	linux-raid@vger.kernel.org, jpittman@redhat.com
Date: Tue, 28 Nov 2023 13:50:22 -0500
In-Reply-To: <20231128181233.6187-1-djeffery@redhat.com>
References: <20231128181233.6187-1-djeffery@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2023-11-28 at 13:11 -0500, David Jeffery wrote:
> During a reshape or a RAID6 array such as expanding by adding an
> additional
> disk, I/Os to the region of the array which have not yet been
> reshaped can
> stall indefinitely. This is from errors in the
> stripe_ahead_of_reshape
> function causing md to think the I/O is to a region in the actively
> undergoing the reshape.
>=20
> stripe_ahead_of_reshape fails to account for the q disk having a
> sector
> value of 0. By not excluding the q disk from the for loop, raid6 will
> always
> generate a min_sector value of 0, causing a return value which
> stalls.
>=20
> The function's max_sector calculation also uses min() when it should
> use
> max(), causing the max_sector value to always be 0. During a
> backwards
> rebuild this can cause the opposite problem where it allows I/O to
> advance
> when it should wait.
>=20
> Fixing these errors will allow safe I/O to advance in a timely manner
> and
> delay only I/O which is unsafe due to stripes in the middle of
> undergoing
> the reshape.
>=20
> Fixes: 486f60558607 ("md/raid5: Check all disks in a stripe_head for
> reshape progress")
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Tested-by: Laurence Oberman <loberman@redhat.com>
> ---
> =C2=A0drivers/md/raid5.c | 4 ++--
> =C2=A01 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index dc031d42f53b..26e1e8a5e941 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5892,11 +5892,11 @@ static bool stripe_ahead_of_reshape(struct
> mddev *mddev, struct r5conf *conf,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int dd_idx;
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0for (dd_idx =3D 0; dd_idx=
 < sh->disks; dd_idx++) {
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0if (dd_idx =3D=3D sh->pd_idx)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0if (dd_idx =3D=3D sh->pd_idx || dd_idx =3D=3D sh->qd_idx)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0con=
tinue;
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0min_sector =3D min(min_sector, sh->dev[dd_idx].sect=
or);
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0max_sector =3D min(max_sector, sh->dev[dd_idx].sector);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0max_sector =3D max(max_sector, sh->dev[dd_idx].sector);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0spin_lock_irq(&conf->devi=
ce_lock);

Nice work David as usual, this issue has lurked for a while it seems.
Thanks for all you do for Red Hat and upstream.

Regards
Laurence

