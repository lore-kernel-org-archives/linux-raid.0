Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC83241686B
	for <linux-raid@vger.kernel.org>; Tue,  4 Aug 2026 18:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785869074; cv=pass; b=bD6GlFDd+bjoZLWCOxoSX+eOTs0dcc9gUvbQBUfnedDgKVZjJf1UAlQADsa0YHTrSSnfWaUwlq+yoskW2dzzgtXHCoSVLCqShVpgBMlv9mSQXtR2TPyacqQBXam+0DQyHTaR9ov+5ZTWABRfz2ZaNMb0Hc1WlhJ5eoScjUA/q90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785869074; c=relaxed/simple;
	bh=Bu2cU4ibqae3k58776JwLs54knMu3t9+XEkSXXc1FRg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pi5kqGzgl1qWdpXRjPppcvb2ayyeMUdd7FN8Q4x2RxnCxUS3JIxN0SIphqhkG2gG1vYs20KMk0ZPnBKfTTAJsZZRUMgNaAk4FVp+wbTmimTrnI0Re6CHyXt9uWT4A5AMvAwmHXpIpAiW8/uyR2DazcYJMfvP42s9hp1l/sTr0J4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=KgvWrk85; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="KgvWrk85"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c1676497000so2963866b.3
        for <linux-raid@vger.kernel.org>; Tue, 04 Aug 2026 11:44:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785869069; cv=none;
        d=google.com; s=arc-20260327;
        b=ErOzzvMn9gpK426IFrhS1cs7tZdJJyd+YLzsuzfkJPCAuzCaR3Jiwl04W0bATZhYXw
         jI4FprwMeurGrAP9gYeMFNlxte3bZR107Vvbf5JN90badvCMG1Wz9UMa54G91I3bphiP
         vLScPJgyBD6aeXeHfWsYuXCcRoiMHva4CucfP82gQcp9yE3FtICt7n1N2V7u5F6XndhQ
         rhl3vQE+rznwI4pNKxqU0dhQmn3g8IRH77+jZDG1FvUpXFWc6qL8ZM9WwRUP00MdrK1k
         AzePXzSOKxqh+LFR8g2bGJe3EJDQbT5wgziTmlccsw+8HfxcCz41JNVKKStHKruZ550o
         HJ1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yOcdgk1wdFj1Z6mmAZGKU5LAITNpPVAwHwOExpuoED4=;
        fh=gaW+xh+QhDfhe4HylTXcfTps3CVnuZvbtjlQ6hc3OGU=;
        b=MXZMAF4UNXJ+gqGfaXGLbDiUzxFy/0YAVIa4xX0C+iUgWPX8yEmgBDJQb4ElbyF5G8
         61g5ChUG4DaGS1kcR0d+qL3XVBd7EXWahkvSo2VKB+oAvA7gpGBLcmZJaXNdCNeOT3C/
         KaBq6EUO7cHrTFCHKNljZkFcRSi1iwbYwOWNOw4tfkVjSqlf8njmUr7HmuN8t2XrMiwz
         s9GUlKet0mNBPB6UtLa9O+iDm3nAdH+ohYuZJZ41WLVVI25LyECkBHKePCwp3U1AnhsY
         nBz7WwxyM8UxW9B0C5901bS5qGSrclr5AHJ5VXILYMK+v+AsmPmynfHMT9sXfKc4lXJv
         uqeA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1785869069; x=1786473869; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yOcdgk1wdFj1Z6mmAZGKU5LAITNpPVAwHwOExpuoED4=;
        b=KgvWrk85YybY1o0tEf8LvwpHtCVxH8vFYltrTEgLMSO5DZW4wFlQabQ+tsPbMZpQ6M
         rI+caujZicw5y7fXFVTnDnVBaXYOzCyqSu0YL6bnHAHr/R/SDcvv9XtunKzm7dXuTODM
         JUNtYu9AM0jrOoYvvfTQyqqPMjwG4bKDcyPMfLCGHaP4dBqk/SkxqlzJsPN4d/tJJXg1
         5N5vmfPf+uZtZztJPSehaIDSXiHtPxRKp+dvlvba4YugMlCvXEnPfKWDpKcNBzNavm36
         cnaxHPiZZvMO2YSY2cQRO7z4YSe/Nm7sdJPDBQACyMma1MSwxYJDaeXY07prE9eFdshW
         TK2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785869069; x=1786473869;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yOcdgk1wdFj1Z6mmAZGKU5LAITNpPVAwHwOExpuoED4=;
        b=AQ0M6TbZICQ4quBm5e3oy67/ALKOvdgIz96SlT36KeSeCJEbUwj9SBg2toEVGpSCrG
         KUmF6JEntrO8D+WrTjnJdOdFjUwtHOEhEpnE7JypcJ5+gisKaiujQs+b0+LsRLVvsDpH
         NPaSdUrvQnxiNOm/hDBfiICk8HlCYldRFE8iyartHQoUBlmCOWE3F5RtY0trt1ercXkT
         01vdpykmORuSBabXZOyOOMpffkFoY2iNi+AWqIs4zehdKFWjA9lQ/srN60zGcRrxoScs
         NqoNtzTDxNCEIY/Q+S7wwYgBH+IXoH0ZlhUeFIPdDX2UbekQQlIwQKoorvJZijuDj/E8
         jpOw==
X-Forwarded-Encrypted: i=1; AHgh+RquaCo4DlX5RwkbZNC2HYHUOpXloC8rnRsPrLtqJ7ycpIYhuKuY6Uf+sqo8gxWE+eZ9mlVY64BuQIwb@vger.kernel.org
X-Gm-Message-State: AOJu0YyoZ2n5JwDKOn8BTTNJ5Nr2WZoUSTa5Ii5YPH6Uyaynn2NGwOV7
	d9NPUDWkZUPdNMBryQQq6tmuFyi5QWvWRYJN0sZW+//QhjZSU6KE+o3NY3OwgdROuvqs+uPiZCq
	5XjLCD+vVl3qzeGXuVbayE3p3ejDlpexy85kr4J/Fbw==
X-Gm-Gg: AR+sD10YfcSN5V3ThTQiudWOS8V9FmvkaOprWwConhlcKvXt76362VZIKhYHGz+k7wD
	7tnBzcTXTx10nLauMi2mlplz0tb3o3GgGUDTEs3vHid1htxe10TIv8C2hTo2kEKIOUMwabIVVf2
	mNYLZA43JrI5jx+3+5/NOjRDQK0JQMSp+Pm/XNEjYKAA1M36gVJYo4lfI4t3tuRBdqvgEygFhxT
	WYwDcd/Cn1Y8lyalwUcu0C23yGxFAspJ6xrwthOuI+sk3RrVtVwO/dF97A/f798clVfyvDYQEjP
	laXvOj4/qh6b3NeU0HxhlFlanYeWuELel5bXv/LnRbMGDeLALY6X6+5Lkwaxh+MDjWtUt+KZPPr
	/p1BrG2lYPTbm
X-Received: by 2002:a17:907:c386:b0:c20:38e2:b355 with SMTP id
 a640c23a62f3a-c2039f6e614mr14509566b.4.1785869068883; Tue, 04 Aug 2026
 11:44:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260717051233.383373-1-jinpu.wang@ionos.com> <20260717052537.611431F000E9@smtp.kernel.org>
In-Reply-To: <20260717052537.611431F000E9@smtp.kernel.org>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Tue, 4 Aug 2026 20:44:17 +0200
X-Gm-Features: AUfX_myONWp2_qNE5Gm8c2FQvZV2SEBhEWxgv1arpWXFMYsv0UFPyK3w759S4lo
Message-ID: <CAMGffE=gipMNJkTLoSBj26mGWsTmp2aiFKM3yRe12BdjwWftBw@mail.gmail.com>
Subject: Re: [PATCHv2] md: clear MD_CLOSING when array_state_store() bails on
 interrupted lock
To: sashiko-reviews@lists.linux.dev
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Team,

Regarding the pre-existing issue reported by the bot, it is not
related to this fix and cannot be triggered in normal cases, so I will
skip it for now.

Linux RAID folks, do you have a chance to check this patch? It fixes a
problem we hit by chance.

Thanks,
Jinpu

On Fri, Jul 17, 2026 at 7:25=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] Calling `restart_array()` with the `mddev->lock` spinlock held c=
an sleep because it clears the disk read-only flag, which triggers a `GFP_K=
ERNEL` memory allocation for a uevent.
> --
>
> --- Patch [1]: [PATCHv2] md: clear MD_CLOSING when array_state_store() ba=
ils on interrupted lock ---
> commit 3ae9b81fbeee45b412994652c2c3b3ac1b35d177
> Author: Jack Wang <jinpu.wang@cloud.ionos.com>
>
> md: clear MD_CLOSING when array_state_store() bails on interrupted lock
>
> This commit ensures that MD_CLOSING is correctly cleared if
> mutex_lock_interruptible() fails while writing to array_state. It introdu=
ces
> a common exit label and a boolean flag to track whether the flag was actu=
ally
> set by the current thread.
>
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index d1465bcd86c81..7b7a4d9259079 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> [ ... ]
> > @@ -4696,7 +4698,7 @@ array_state_store(struct mddev *mddev, const char=
 *buf, size_t len)
> >       }
> >       err =3D mddev_lock(mddev);
> >       if (err)
> > -             return err;
> > +             goto out_clear_closing;
>
> [Severity: High]
> This is a pre-existing issue, but just above this code in array_state_sto=
re(),
> there is a fast path that can sleep while holding a spinlock.
>
> If a privileged user sets the md device to read-only using
> blockdev --setro /dev/md0 and then writes 'active' to
> /sys/block/md0/md/array_state, the code acquires the mddev->lock spinlock
> and calls restart_array():
>
> drivers/md/md.c:array_state_store() {
>     ...
>     spin_lock(&mddev->lock);
>     if (st =3D=3D active) {
>         restart_array(mddev);
>     ...
> }
>
> restart_array() unconditionally calls set_disk_ro() to ensure the disk is
> read-write:
>
> drivers/md/md.c:restart_array() {
>     ...
>     set_disk_ro(disk, 0);
>     ...
> }
>
> Because the disk was set to read-only, set_disk_ro() clears the flag and
> triggers a uevent:
>
> block/genhd.c:set_disk_ro() {
>     ...
>     set_disk_ro_uevent(disk, read_only);
>     ...
> }
>
> This calls into kobject_uevent_env(), which performs an unconditional
> GFP_KERNEL allocation:
>
> lib/kobject_uevent.c:kobject_uevent_env() {
>     ...
>     devpath =3D kobject_get_path(kobj, GFP_KERNEL);
>     ...
> }
>
> Can this sequence cause a sleep-in-atomic bug and potentially lead to a
> deadlock or panic?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717051233.38=
3373-1-jinpu.wang@ionos.com?part=3D1
