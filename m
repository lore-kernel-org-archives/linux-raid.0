Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793600607;
	b=kCWFXMzSdCoqaQU/njDrnJAlkw2NsFMYN6XLlFrn68xHs0gj/IaabAOwKkvfgIkjgIsD
	 pY/HenJbyoPY14e8uANCCawOnZlYItnU0TduPOOyFvpr4Ha5HKrhP6d11wrwg6S8QDb7D
	 LAaqYN8KVIulavQxXs3od7iCZUVE0E+xohZejcK/t/ZQh+r7DTrK55XegrHOovCBs2HtJ
	 fmQLXg4k0Un3uBuA/Kf5P8AFXGm7yX5IrethCmFyCoTHzy/gyIOqdIONNz/ggRRRftkAi
	 12rSLm2p+TFuddGfPSClx4XZ62lJ3EoUl63zmPDww5jZnS76Yx1E6H2NvfXFDoSwenQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793600607;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=6fYxcqcPwGlmikFHqlLY/dtWLcl2/0gbbWwZhloeNB0=;
	b=cHYemPS/3BSm2AO1eRD+UWjbNtgZpzRfsgUKETdKYWMnf0vjLyXkuVwuNbIIEq7BRx/d
	 lLe2Qq4SrgMnfEdR+kyiEPU7Zf35UlPDhDcAHbZ7W/q5LmaxXCWH24780W0gyGdVSDrqc
	 H73J0DToKhNwdvn36LwPhXLGj9WwUhVBRDlUg/peKGZURT/jPRgCoVlYgmDhEgOxuLzQC
	 IX5rPjFvuGQMPPY7EpnA0o5hKXFeVKN3dROhICGnWSJIYV/uVHtr/celAchLkomqjk/vc
	 XhZgkiNQgup6kzBD4AZNLy8LXXRXtGK4KFPp/RaDj81nbKlYnCuS79cpMltzPcGM+sA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cloud.ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=M9tCZG9z;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.54
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E94D606A324
	for <linux-raid@vger.kernel.org>; Mon,  2 Nov 2026 06:23:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E94D606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=M9tCZG9z
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c407213696aso46983266b.0
        for <linux-raid@vger.kernel.org>; Sun, 01 Nov 2026 22:23:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793600605; cv=none;
        d=google.com; s=arc-20260327;
        b=fFrrFS12CJ0V8YctFLcuAalvIXmVYVaz5oYP42ya48GkG4t3aE+MGxrRP1ahhgVcGj
         Vm0XMmA2mSBDSH+gc1MF/rre5qWV4ghlQFcW9CiO6UYrs9Z/hHCN6aWI+2r4+OFe6i5p
         bBkWpm2p9Ogg+L4Mbk4T3/fjRhyomHd20rnzriDAIgC788FHq89UfS2ql2zcF3AAS+Fr
         5iwlnDU7NGcO27p0apEPbhQtd2tYxxil1RZv9n7lGHxukPxJQ4/HRp5HgmbVvJ4F/zNv
         XZGHlHq/L6YCl6tKJZSqhBX2s4T72q/hsT0qdTw1Z9JNss+xg81yh4oV3bgC0EeGcTFa
         ovYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6fYxcqcPwGlmikFHqlLY/dtWLcl2/0gbbWwZhloeNB0=;
        fh=plZUWGaifkdtkG7FyYkf0xIsNqXYaqugh6iFEkCjwNs=;
        b=QrIeRWxFEY9wEw3+nPX/Ln+r78iQu4Q70ADBq1EZKqDvcfjf4nZrez2Tf67gJ8TBO4
         3JFCL2CexCimhtflsPTgn4Em4KEMvd9/nxHkDlwjBPr3DX6vpklmzfuwaVSMneYTsXgy
         JCLHDQznwSniXbtt9TBTNqS7Hnee4ALmSfriG2NYPOw1MX+x1Cu+HkceTJipEFqN6hrr
         O5VtO9a/i1/b53br+tuSdvYObQLUjUFUW+KOJtdzWyzxMyFNUNMEFY7oCtiVwq7OHOQu
         3Ia1bW88lyWXrhvegshq3MjFOEDAg1T/fmrciT2o3ekICsMw2XRkWKSlFW77CKuqLsBU
         qJiQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1793600605; x=1794205405; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6fYxcqcPwGlmikFHqlLY/dtWLcl2/0gbbWwZhloeNB0=;
        b=M9tCZG9zxqLIvOsbYxcnvRWz7uoWU2o5qs9aRH0chaBHRH2TPnCx56GS+mA6WBupN/
         Bch3h/pb/UyNQI/Tc1opjllX+2qU1DmxjJ49ifIEG7egAQG8BbbYvDnmkLYghlpqCUFT
         fAPXbBJ1Zb2xHH1Sgj7NxhmxcVx/HuKO6umX4sfgHw2oX30cpPrp1wE4UQQQUuD77jzl
         RxQxWjKAkAXdK90O4dYCQHOWrdEM+r9ryX3Q9+QXevf3tYfHdf6BlOOB1jlxAvQ7sCgj
         X3Kk3dKjzFsQRg6Xt3Uq1MO6+TjZdJD+7DW1CU0kdTiLNFXXERHyqwBGYbj0g3pjouax
         KztQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793600605; x=1794205405;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6fYxcqcPwGlmikFHqlLY/dtWLcl2/0gbbWwZhloeNB0=;
        b=jROXB8r4bLONTneME5cMwCpGuE4OTrfyWkLnV4a7OQ33/5TLbalUz3ASvJr6yTXETu
         jnIR+DsV0b6FPc1+S+hsyS8bHJ2vHsusx8j2dHCnDKIJDLCETyZjgWkR6LhNk5GINYl6
         0fQROpn4sKP8OMXZxLn/FYgu3eUWHaPlJ57VALSavpKxEbNeMflQ+Tn8cN1TjeWWFvCt
         awzJJwz1j0dhwX3uU8zC9B9biV2VCkcRl53atgkLPZPawp27D+ZyfwLSMRpr02cIXvta
         NWQaKtH6ToxB9aVOazLzJ66RwoO/5EelDJyTeOf+YH6YHX65465nda6hfaex96BLGc6L
         2prg==
X-Forwarded-Encrypted: i=1; AKwUvBxHYOvTwT8wylvy14ST1LFiCyK8Y/FuJTxEEkw7+Q6/LOIokNkkMkfT2P9qk3Ajj3eJQkbVCpbduyjN@vger.kernel.org
X-Gm-Message-State: APuU4Z9I31g3qJmgq+WT7mUV8eObn2p/CD/jO7p2ld76ZFnQaKTgsFfb
	9JRWXsDMXycWNkY23DU8rLjy14vZ5c2Kyd2k7nbWB/D8DGPlkuN4rDocvv1usXsTJxbuBwL9h7k
	pQ/WEoaIH7vTEd9D40MtQwsv2p7VavGROb+Vczh+hBQ==
X-Gm-Gg: AYBFou0TZwy2kHWPT7l6PqIm52IZx4Pgz8HSsQVlievbyaTvkjqjN1shd43GfdPj2TZ
	LMXIBiWFxlgeGCcdAYsNPI5oL/t2k66lMN/ic+uCMr07Tfa+a3rM6HLgfx5oRYIrD2M+dOjCGap
	wzgfn+AeO/MeMJ/kQ+p/Wm/as1aX2bx97XSO5NAFM7ZwEoFZJniso/kioReJNs11FW2eCajOF6e
	2fHTQ1EAK6R54Fi24PL2nLSkNpOkvQJoWHBmLMO4GvxwJGrt36pBSmbI0fLkAm9kcbnp+PpuKhp
	xAuRVKXW66LTxk3YRhOUV6NeQ4+QOFaYV+3hOd2VS6AYGaipYLKHrSnHQtUw9SYaAH4AK56YcJH
	1Ac88xQ45e7vZ9XnAoiqXTkn40dOFjB31hEgtNUt6dsEVJsf7XHpZwMcj4VBqyMcAsBkWUA==
X-Received: by 2002:a17:906:4bc4:b0:c32:8cbb:fac with SMTP id
 a640c23a62f3a-c4ca7a863bdmr715980066b.3.1793600604549; Sun, 01 Nov 2026
 22:23:24 -0800 (PST)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261014115334.619923-1-jinpu.wang@ionos.com> <ee303663-1b09-4e88-a129-d91e046b296b@fygo.io>
In-Reply-To: <ee303663-1b09-4e88-a129-d91e046b296b@fygo.io>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Mon, 2 Nov 2026 07:23:12 +0100
X-Gm-Features: AclHuK8gecrKacsuAOr16f-RrSjEHjs4X5XnqFVJWXTyldT4N7RppB1tMVveq30
Message-ID: <CAMGffEknMSifz-sf_cpa6dNR6S=8czZLjYaNd5mf+VYXRzoJmg@mail.gmail.com>
Subject: Re: [PATCH v2] md: clear MD_CLOSING when array_state_store() bails on
 interrupted lock
To: yukuai@fygo.io
Cc: Song Liu <song@kernel.org>, Li Nan <magiclinan@didiglobal.com>, 
	Xiao Ni <xiao@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kuai,

My apologies, missed that. I'll follow up on your previous comments.

Thx!

On Sat, Oct 24, 2026 at 8:05=E2=80=AFAM yu kuai <yukuai@fygo.io> wrote:
>
> Hi,
>
> =E5=9C=A8 2026/10/14 19:53, Jack Wang =E5=86=99=E9=81=93:
> > From: Jack Wang <jinpu.wang@cloud.ionos.com>
> >
> > Writing "clear", "readonly", "inactive" or "read_auto" to array_state
> > calls mddev_set_closing_and_sync_blockdev(), which sets MD_CLOSING to
> > keep the array from being reopened while it is torn down. The flag is
> > only cleared again at the tail of array_state_store() (for readonly /
> > read_auto / inactive, or the failed-clear case).
> >
> > Between setting the flag and reaching that tail there is an early retur=
n:
> >
> >       err =3D mddev_lock(mddev);
> >       if (err)
> >               return err;
> >
> > mddev_lock() is mutex_lock_interruptible() on reconfig_mutex. If the
> > writing task catches a signal while blocked there, it returns -EINTR an=
d
> > MD_CLOSING is left set on a still-running array. do_md_stop() /
> > md_set_readonly() never ran, so the array keeps working internally, but
> > every subsequent md_open() now returns -ENODEV for all callers - the
> > device shows up in /proc/mdstat and sysfs is fully populated, yet canno=
t
> > be opened, and cannot be recovered without a reboot (all clear paths
> > either need the device open or re-enter test_and_set_bit(MD_CLOSING) an=
d
> > bail with -EBUSY before the clear).
> >
> > The window is easy to hit on a busy host: reconfig_mutex is held for lo=
ng
> > stretches by a running resync/recovery, widening the interruptible wait=
,
> > and a userspace helper writing to array_state and then being killed or
> > timed out is enough to leak the flag.
> >
> > Route the interrupted-lock exit through a common label so the flag is
> > released. Guard the clear with a set_closing flag that records whether
> > this write actually set MD_CLOSING: when mddev->pers is already NULL (f=
or
> > example a concurrent STOP_ARRAY is mid-teardown) this write skips the
> > mddev_set_closing_and_sync_blockdev() call above, so it must not clear =
a
> > MD_CLOSING that the other thread owns - doing so could let the array be
> > reopened while it is being destroyed. This also tightens the pre-existi=
ng
> > tail clear, which had the same unconditional behaviour.
> >
> > mddev_unlock() is correctly skipped on the goto path since the lock was
> > never acquired.
> >
> > Fixes: 99b902ac1725 ("md: sync blockdev before stopping raid or setting=
 readonly")
> > Assisted-by: Claude:claude-opus-4-8 [Claude Code]
> > Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> > ---
> > v2: resend, rebased on md-7.4-20261013 (md/md-7.4), no code changes.
> >   drivers/md/md.c | 17 ++++++++++++++---
> >   1 file changed, 14 insertions(+), 3 deletions(-)
>
> Looks like this is just a resend, while I already replied to previous v2
> patch:
>
> Re: [PATCHv2] md: clear MD_CLOSING when array_state_store() bails on
> interrupted lock - yu kuai <https://lore.kernel.org/all/eded31de-2e92-4a3=
b-9384-03dbebc5e9e7@fygo.io/>
>
>
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 03e35386a802..f6dfd5d76199 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -4671,6 +4671,7 @@ array_state_store(struct mddev *mddev, const char=
 *buf, size_t len)
> >   {
> >       int err =3D 0;
> >       enum array_state st =3D match_word(buf, array_states);
> > +     bool set_closing =3D false;
> >
> >       /* No lock dependent actions */
> >       switch (st) {
> > @@ -4691,6 +4692,7 @@ array_state_store(struct mddev *mddev, const char=
 *buf, size_t len)
> >               err =3D mddev_set_closing_and_sync_blockdev(mddev, 0);
> >               if (err)
> >                       return err;
> > +             set_closing =3D true;
> >               break;
> >       default:
> >               break;
> > @@ -4719,7 +4721,7 @@ array_state_store(struct mddev *mddev, const char=
 *buf, size_t len)
> >       }
> >       err =3D mddev_lock(mddev);
> >       if (err)
> > -             return err;
> > +             goto out_clear_closing;
> >
> >       switch (st) {
> >       case inactive:
> > @@ -4792,8 +4794,17 @@ array_state_store(struct mddev *mddev, const cha=
r *buf, size_t len)
> >       }
> >       mddev_unlock(mddev);
> >
> > -     if (st =3D=3D readonly || st =3D=3D read_auto || st =3D=3D inacti=
ve ||
> > -         (err && st =3D=3D clear))
> > +out_clear_closing:
> > +     /*
> > +      * Only clear MD_CLOSING if this write actually set it. Otherwise=
 a
> > +      * concurrent teardown (e.g. STOP_ARRAY) may own the flag - this =
write
> > +      * would have skipped setting it above when mddev->pers was alrea=
dy
> > +      * NULL - and clearing it here would let the array be reopened wh=
ile it
> > +      * is being destroyed.
> > +      */
> > +     if (set_closing &&
> > +         (st =3D=3D readonly || st =3D=3D read_auto || st =3D=3D inact=
ive ||
> > +          (err && st =3D=3D clear)))
> >               clear_bit(MD_CLOSING, &mddev->flags);
> >
> >       return err ?: len;
>
> --
> Thanks,
> Kuai
