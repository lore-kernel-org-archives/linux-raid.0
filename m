Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fA0LnfDX"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3587110C1
	for <linux-raid@vger.kernel.org>; Tue, 28 Nov 2023 11:01:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701198098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2I3hbaCerYSJrfrScAIbUgdYhnkOYSj3ADEFMEMpp9Q=;
	b=fA0LnfDXfaMNHzgVqXbsKtj8vDd3ENwUtZmACBx2gL23IXUhrZeFjuXZA3TDZaq82cG8k7
	8XAXpB/RVF83cnuCfyBlJhIr060+GB8V3KC/4PVRpWr0bdI6q4MFbBRhqyLSLeC+n0fVKs
	j1X5Hk4OeETYUcdyZmFsN0iTccI5EPc=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-57-pqxnXveuNwK9hDZmHJR9_A-1; Tue, 28 Nov 2023 14:01:36 -0500
X-MC-Unique: pqxnXveuNwK9hDZmHJR9_A-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-677fc779771so79594446d6.0
        for <linux-raid@vger.kernel.org>; Tue, 28 Nov 2023 11:01:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701198095; x=1701802895;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2I3hbaCerYSJrfrScAIbUgdYhnkOYSj3ADEFMEMpp9Q=;
        b=ASUUCvI+T+NLt1OrWaTlbnXJrk3MQu7DTVasMV6mDwOVCJSX4SqiKkGfVdLJSNovmo
         1RZ+BJLBQiFE5223qV/FG4OqQNbUgcDjgbtqQ1J8ahgMDMCiDuu8B92Nv+WEodPcbpx9
         AMxbBiYrKdRxSI7RHSOY7GlyQr183AUkNvJ4PYoNAnuI0qh7EnmZQ4k3l+j7OEXBfETw
         XI3ke3CtGJLa/lKVgQo/X/OBkNvYvbt7z+REPo5b9NlpQTxffth7y3oYzIdprXvKF/pu
         rXVpBlelroftW5iotouj0AaDUoNQfvw+S1ZVAeiPuK0G11XRrmpu5kRf4G0CHyoq/2lj
         FpQg==
X-Gm-Message-State: AOJu0Yw+fzEWSxaswYpRtxWO0jTvxVI6Ho5K1ogupssF4t2StJPdFr8r
	9hULM/mtitEmN+Grytbp/3TMAfaciNJlkrrkeVO4LLEX8g6zvCFQJ6NpBO37xV3YS8m6aFfQbUR
	VYCRwjFlCOGRSdGdG1TZKzmSA12aOQQ==
X-Received: by 2002:ad4:4147:0:b0:67a:2426:260f with SMTP id z7-20020ad44147000000b0067a2426260fmr13250889qvp.53.1701198095085;
        Tue, 28 Nov 2023 11:01:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEpg8VcQlfVX9efD4g+0Wp2l0P0/R9tJ+ED5Gb/rQl5m/v5/QiYIfqWFC7sBZxCajn1euUSWQ==
X-Received: by 2002:ad4:4147:0:b0:67a:2426:260f with SMTP id z7-20020ad44147000000b0067a2426260fmr13250856qvp.53.1701198094763;
        Tue, 28 Nov 2023 11:01:34 -0800 (PST)
Received: from ?IPv6:2600:6c64:4e7f:603b:7f10:16a0:5672:9abf? ([2600:6c64:4e7f:603b:7f10:16a0:5672:9abf])
        by smtp.gmail.com with ESMTPSA id p15-20020a0cf68f000000b0067a35c1d10csm3095947qvn.114.2023.11.28.11.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 11:01:34 -0800 (PST)
Message-ID: <3704907f5dfef98a3dc9d5675b05c731e86e2cd5.camel@redhat.com>
Subject: Re: [PATCH] md/raid6: use valid sector values to determine if an
 I/O should wait on the reshape
From: Laurence Oberman <loberman@redhat.com>
To: Song Liu <song@kernel.org>, David Jeffery <djeffery@redhat.com>
Cc: linux-raid@vger.kernel.org
Date: Tue, 28 Nov 2023 14:01:33 -0500
In-Reply-To: <CAPhsuW7V1H9xJ+ihC21B8S+cp4QZDz32a0YJPfELt=va3xpBZQ@mail.gmail.com>
References: <20231128181233.6187-1-djeffery@redhat.com>
	 <CAPhsuW7V1H9xJ+ihC21B8S+cp4QZDz32a0YJPfELt=va3xpBZQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2023-11-28 at 10:44 -0800, Song Liu wrote:
> Hi David and Laurence,
>=20
> On Tue, Nov 28, 2023 at 10:13=E2=80=AFAM David Jeffery <djeffery@redhat.c=
om>
> wrote:
> >=20
> > During a reshape or a RAID6 array such as expanding by adding an
> > additional
> > disk, I/Os to the region of the array which have not yet been
> > reshaped can
> > stall indefinitely. This is from errors in the
> > stripe_ahead_of_reshape
> > function causing md to think the I/O is to a region in the actively
> > undergoing the reshape.
> >=20
> > stripe_ahead_of_reshape fails to account for the q disk having a
> > sector
> > value of 0. By not excluding the q disk from the for loop, raid6
> > will always
> > generate a min_sector value of 0, causing a return value which
> > stalls.
> >=20
> > The function's max_sector calculation also uses min() when it
> > should use
> > max(), causing the max_sector value to always be 0. During a
> > backwards
> > rebuild this can cause the opposite problem where it allows I/O to
> > advance
> > when it should wait.
> >=20
> > Fixing these errors will allow safe I/O to advance in a timely
> > manner and
> > delay only I/O which is unsafe due to stripes in the middle of
> > undergoing
> > the reshape.
> >=20
> > Fixes: 486f60558607 ("md/raid5: Check all disks in a stripe_head
> > for reshape progress")
> > Signed-off-by: David Jeffery <djeffery@redhat.com>
> > Tested-by: Laurence Oberman <loberman@redhat.com>
>=20
> Thanks for the fix!
>=20
> Can we add a test to mdadm/tests to cover this case? (Not sure how
> reliable
> the test will be).
>=20
> Song
>=20
> > ---
> > =C2=A0drivers/md/raid5.c | 4 ++--
> > =C2=A01 file changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index dc031d42f53b..26e1e8a5e941 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -5892,11 +5892,11 @@ static bool stripe_ahead_of_reshape(struct
> > mddev *mddev, struct r5conf *conf,
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int dd_idx;
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (dd_idx =3D 0; dd_idx < =
sh->disks; dd_idx++) {
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (dd_idx =3D=3D sh->pd_idx)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (dd_idx =3D=3D sh->pd_idx || dd_idx =3D=3D sh->qd_idx)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 conti=
nue;
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 min_sector =3D min(min_sector, sh-
> > >dev[dd_idx].sector);
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 max_sector =3D min(max_sector, sh-
> > >dev[dd_idx].sector);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 max_sector =3D max(max_sector, sh-
> > >dev[dd_idx].sector);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock_irq(&conf->device_=
lock);
> > --
> > 2.43.0
> >=20
> >=20
>=20
Hello Song

The way this was discovered is the customer forced a reshape of a raid6
device by adding an additional device.=C2=A0
The reshape then sess the hang.

# mdadm /dev/md0 -a /dev/nvme18n1
mdadm: added /dev/nvme18n1

# mdadm --grow --raid-devices=3D6 /dev/md0

The problem was we needed a test kernel just for the customer to
recover, because on reboot the reshape starts again and hangs the
device access.

Such steps could be added for a test but David will know maybe an
easier way for a test.

Regards
Laurence



