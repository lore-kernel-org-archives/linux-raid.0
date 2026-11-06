Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793948895;
	b=0n6Xank7POrE7SOJD+L1zk8xLwPUsvDrtof8iEVjvhBedJ9h3N4mPjVNoCYTO00MGUNh
	 H2cTXOZh7qzgwh3eky7fSOX1rwUYTjucejdhNxwxyH4DQhTARMs3rv1dWAHLHmXcLYyKL
	 URD1xkgDLll8WnqBO8F0TiGZcvcFidGj8FK/YU6IRyAfuy9KoiUYuJTu/SlIWCtPei/MX
	 jmkjLTgGUqgPgfqbUv2iIW6zOuj3CSLI2nZ2pJrCOEMmblnHzUqqKlqg5rpHOwWt1o/pj
	 XVD725OUpWikbsG3O5RhsEGS6j/vQnPSpkoltG8DcDbEmaMx9B9Ll/x7BcS18+j1c7w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793948895;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=S80Aki1MZIKsaLrEPPSq4R+7BMxNgCPLgicxZ7e4X9Q=;
	b=lODV6gmO/VnGvMe9srPK+90En39BhcPDvywWPsCPCekWDRenel0uo0u+HpuFNsAIXABZ
	 PSSgX49tXdzEpL6LmD05ap19EchYB74qD8gUc8j+8FliF2n4DOzn0qey0E9vskMKQmgCU
	 NBg3DPDSWovjm9zYBQ5kJ2mJyQssHRSy/iVDjRzVrIXx3XSwcim80wkF185mzzBmbJo4n
	 5VrcwnPJmja6RAEvespioeIkUH96CGcLKuQtRYMUrx1xyERgoHTiN//4+ebDlCOfJrr1U
	 407F7k7MKfSioJBdgSTVmrM4EmyLUFy4I0RH0jDmOzL6WeTtLww3WLTicjIY2QBhrEA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cloud.ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=NN1PAoGR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.42
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4497F606A328
	for <linux-raid@vger.kernel.org>; Fri,  6 Nov 2026 07:08:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4497F606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=NN1PAoGR
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c3fae9338f0so1345766b.2
        for <linux-raid@vger.kernel.org>; Thu, 05 Nov 2026 23:08:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793948892; cv=none;
        d=google.com; s=arc-20260327;
        b=aXWWiBmeCDz4n/WfCTz0o5J71uQcP0vgMLqkgAr3VVinEyAni9vHjkB/HxZsFoHDi1
         PI+nS6UrOZU7OliFx6ZFTVHsJIHo1je0Js9tmIK/IxKtMAr8e3ZG6aXlHTQY2pUtrhL2
         A+fYmQEBXWgC0X+HRykXj6of+RNOK375e0pDm8yij+gvySPNfjp4ejYfJ6K8PlCGDZ2o
         CUCui69KyMgkcRRMhRlws0xmqdyIC2kkiqHTarfz0ammBnUbMOfPNs5yzmCFNJGCZw65
         wWg0a7Tdxy4E6Ly9qyVEGRpq5bqp9q6SmjZtPbnv57IAo82ZjXfz8ly/C7B2f2KGFTDy
         m4rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=S80Aki1MZIKsaLrEPPSq4R+7BMxNgCPLgicxZ7e4X9Q=;
        fh=0HMaK7lzZ/9g/1/KHVw8l56JsNwVMJOnx+PSvJ+Ohvk=;
        b=fy29hTQ9/x/c6glB/bkt5isP5p1mHOVPh4gEqjIuDDXwrIrbEuEBYQl42m2aa1b15L
         zVIzTVj/rzH8uE5zJOX3izHjDeecc3Yf7uCp/Tj3CHAkoVntpkZ5K7aJ+B4Kdlq1nuIN
         1+cLb0nhsYrrgUYkGyc+JAlKZT/fYVJA/stK5qw4HOjjJNhJsNjgbaw+kb6KbeXDjyQm
         QVFmoXDwE776+n3XRgmG6QHFDJ7DKMs38q2W24FMVm6u4VSfnX7Mh+nvlrod0a4ICPzu
         LuF4uoda8e8l1Rkq2S+EVGphzwH/06RGZZ8TZk4SPbkfZCOvtcJ8MZZAQppM8+n6T7xl
         o33A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1793948892; x=1794553692; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=S80Aki1MZIKsaLrEPPSq4R+7BMxNgCPLgicxZ7e4X9Q=;
        b=NN1PAoGRaVMXQJMrBCGqbtbalWa4Bap1MNHTxghdMw3pSLOmbk8Qo8aFn0VltyhVBe
         BiCqJ1Zk/SRo+fmKhMHCOOBgx2huZmw1ZVtlqzbTTxx8UKlwEoPpgC0LjIZJA3pBevca
         SnhySWcInUafYU/Q00RBmbtl/Yyus859ZTj5VXIlwqR15zuL90L9wzDWzkwvGVIhq5LY
         /qCFKA4y1RkauzDDbUxmnYJjLmXRx105x1rcHIm6z8sTmH/ohFIvdLSlRvw8k7hkNxEC
         m577hzKqc+XPVF4mWMqsWQ0EtokRPKPJjQVHNnA/Z0otDOHGYpVkQ4IfVLWGG5HuCjwc
         ANOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793948892; x=1794553692;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S80Aki1MZIKsaLrEPPSq4R+7BMxNgCPLgicxZ7e4X9Q=;
        b=vwoaau6Pc/UFighsDKladhlnmjUByPmRwnpW/Es24hgiq7VZXbRAIMHLq8Pug3VwvS
         v2AjBGxKDDqeCYJt5IEm/hU54IvnaB05FDtrMpJZw9os6IfX07RR7JKngyGvIpsBT531
         4b1Z52xDOIv1LIM+Ho50rj/6eluIzXsbxF34HQEX7lGKIrtyy2gnFOrcpkzqhXY4Hwak
         E2VhejEcrAeWlrcnuOpTUEzSLOxTtF+0VyggTxaIAx/eO3fG58WMCi0YeVt9Y+PyuMPS
         zqJyiTtcmvQ6WLU6ezqMtHA75jaOcMJltO5rgRddfYJttHkOVAPK982x4Bpv4F/U/Uyt
         qZOg==
X-Forwarded-Encrypted: i=1; AKwUvBynErij8vW2/XgkLlbxB+d2RixBc3EyJEVbTAHovCX/8CSTtiKKtJft8XuUf8kCRgdLkObFogbYL1Cg@vger.kernel.org
X-Gm-Message-State: APuU4Z+hnBOvnJRiwTuoZOIvT6JfyXCxwl+ZRbrqGeuIZpI3jWxuGkLv
	ID9OCeP7uGfhqx2CjYQyjUgqAM92kU97qzYdxoqnpXDvd1nzz5B+ppxCrJXHgoZa4hbN+terAHW
	4ohwQK1aEJhELt/AV+XO1EgewnQUzXnK1RgGz+fepgw==
X-Gm-Gg: AYBFou2OJ7Nx+kBTVdr5/Ls6wVz1V+I4ChS2/8kbpDzthCrvsfPgEaxDgJo5em5xwnb
	DKtdm8uQDjZVrT9HD3Qca9HWh85NXZ4PZzPRpl4tg3N3rJ5EFLRyqtFYFckf6rpD8LhooVVw7Bz
	gaHb0C15NBmX+dRe7Q8ekItTLVh1q4vxKW57YLYnjhRaewX23D5KZSLkjn1eLcAnDGbypTfjE/X
	tGf6elfwCaWweiClJRvNA06Litch6urU6sWMMAm0NnJK/pIz+JMjs2AtYTRbd/vB6KXxx38Lopp
	QXSfO2astHFDvm/+t8ddHp79GyQQ/ibh1FdVmQV63HD5WrAE1FN/dhjMzbwHq6Uz3joDQmrCZwg
	Rviwc+qrdWrJmOk+R5TMEa5yKQqol6gzd1V4bdhEOs37lSGkcDC7BCxB1XSp8Qpjr+4p3hbl7AA
	jfPIWH+UrnFN948B8=
X-Received: by 2002:a17:907:1258:b0:c4d:1501:ac3a with SMTP id
 a640c23a62f3a-c4d352df5a2mr135981666b.2.1793948892542; Thu, 05 Nov 2026
 23:08:12 -0800 (PST)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <eded31de-2e92-4a3b-9384-03dbebc5e9e7@fygo.io> <20261102073555.53941-1-jinpu.wang@ionos.com>
 <54d9c6e7-7467-4c68-b34f-4a984f7fb318@fygo.io>
In-Reply-To: <54d9c6e7-7467-4c68-b34f-4a984f7fb318@fygo.io>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Fri, 6 Nov 2026 08:07:59 +0100
X-Gm-Features: AclHuK9aQXEbLTrSPM8e4jm8ymLgFvT0Vnmp-FN3vyaG3ScuxQ70C6P0VANqlfA
Message-ID: <CAMGffEmw=24WVqVXwsMMAQF589+njxDXFUAKD4VmiFv3CBmVbw@mail.gmail.com>
Subject: Re: [PATCH v3] md: clear MD_CLOSING when array_state_store() bails on
 interrupted lock
To: yukuai@fygo.io
Cc: Song Liu <song@kernel.org>, Li Nan <magiclinan@didiglobal.com>, 
	Xiao Ni <xiao@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 6, 2026 at 2:42=E2=80=AFAM yu kuai <yukuai@fygo.io> wrote:
>
> Hi,
>
> =E5=9C=A8 2026/11/2 15:35, Jack Wang =E5=86=99=E9=81=93:
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
> > Clear the flag directly in the interrupted-lock exit. Guard the clear
> > with a set_closing flag that records whether this write actually set
> > MD_CLOSING: the set call is skipped when the array is not running
> > read-write (or mddev->pers is NULL), and in that case this write must
> > not clear a MD_CLOSING it never set. This also tightens the pre-existin=
g
> > tail clear, which had the same unconditional behaviour.
> >
> > Fixes: 99b902ac1725 ("md: sync blockdev before stopping raid or setting=
 readonly")
> > Assisted-by: Claude:claude-opus-4-8 [Claude Code]
>
> checkpatch reprot error with this tag.
ok, will drop it.
>
> > Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> > ---
> > v3: (Kuai) clear MD_CLOSING directly at the mddev_lock() failure and
> >      return, drop the out_clear_closing label; reword the commit messag=
e.
> >      Keep the set_closing guard: the set call is skipped when the array
> >      is not rdwr or mddev->pers is NULL, so this write may not own the
> >      flag. Rebased on v7.4-rc1.
> > v2: guard the clear with set_closing.
> >
> >   drivers/md/md.c | 13 ++++++++++---
> >   1 file changed, 10 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 03e35386a802..f14a31387990 100644
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
> > @@ -4718,8 +4720,12 @@ array_state_store(struct mddev *mddev, const cha=
r *buf, size_t len)
> >               return err ?: len;
> >       }
> >       err =3D mddev_lock(mddev);
> > -     if (err)
> > +     if (err) {
> > +             /* Interrupted before any teardown ran, don't leak MD_CLO=
SING */
> > +             if (set_closing)
> > +                     clear_bit(MD_CLOSING, &mddev->flags);
> >               return err;
> > +     }
> >
> >       switch (st) {
> >       case inactive:
> > @@ -4792,8 +4798,9 @@ array_state_store(struct mddev *mddev, const char=
 *buf, size_t len)
> >       }
> >       mddev_unlock(mddev);
> >
> > -     if (st =3D=3D readonly || st =3D=3D read_auto || st =3D=3D inacti=
ve ||
> > -         (err && st =3D=3D clear))
> > +     if (set_closing &&
> > +         (st =3D=3D readonly || st =3D=3D read_auto || st =3D=3D inact=
ive ||
> > +          (err && st =3D=3D clear)))
>
> Just keep the checking of set_closing should be enough.

A bare "if (set_closing)" at the tail would also clear MD_CLOSING after a
successful "clear". do_md_stop() -> md_clean() keeps it on purpose so the
stopped array can't be reopened (except legacy mode with hold_active).

So v4 uses:

        if (set_closing && (st !=3D clear || err))

i.e. always clear for readonly/read_auto/inactive, and for "clear" only
if it failed (array still live). Does that look OK to you?

--
Thanks,
>
> >               clear_bit(MD_CLOSING, &mddev->flags);
> >
> >       return err ?: len;
>
> --
> Thanks,
> Kuai
