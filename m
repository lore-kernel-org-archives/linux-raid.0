Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5278133F8C1
	for <linux-raid@vger.kernel.org>; Tue,  6 Oct 2026 03:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791258196; cv=pass; b=WAysa9tyVoGTo45wODV9/rv36iv95LD/LQstKnE6S0mk4fjGJKG0f8Hugnp7LuXbaHioPQ4I/M3/nIkyA9z/eTJl4oqvvEw8v3Oyi/IXswCT6jEefAcsZUvkVDzKTZ4mio55mRs0OUOZU5NhobBZqKQYw4Qnfsfav7mFiHON2ig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791258196; c=relaxed/simple;
	bh=TE1M8Xp9r8nWKhc0pgoLmT0J1KG+EsmuYHdJ9qwlb4k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZHc7ZsIX3Osq+jxgBCAEG5ILM/LRHPuzGqjoZREpyrv22Twgm0mkgsXB6cO3N3T6PbmpusINay9l2V1dWRlGt2e+6Pz8B5ZkroaeGunobS4IyCT70Q29H8dw8Ndp3FBs9zOabaJ1jFMU1AbNK8HYqgZ/sS+fSz0NWtTT+ZYHYLU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PDDHg3a2; arc=pass smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PDDHg3a2"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-6774639a8a4so2154412d50.0
        for <linux-raid@vger.kernel.org>; Mon, 05 Oct 2026 20:43:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791258194; cv=none;
        d=google.com; s=arc-20260327;
        b=hcZ13snS2lYrquv9JK0UrIXTdQcOMSFMLaVf8cbnY1Pwl6oFMrfzxB8hc/bkqHShTD
         3J/sy8vuNGzObQi1csZT7Zf3954W0iq+5c+5yt1gu9i8cE/O8SSg3iwJOY6KzKusLqHt
         ZyiQxZqv2jVR7o8guf6oLEninDYECrPGp9rN38V97+LnZO1pnoGvp8nbikqQenFXUgVc
         51g7u4vqhv7FrDl1cQfzFulaM52UHZtti/IEmLxcafgjHvl3kx/2vrOuJA7t7jXpZNMK
         Em7FSXVhp33rvssMjZfvtXTzePb48p11NoESGHC2M1pl/M3yIE0kmChBJRw9a5RRkUNa
         hVGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BEXTeQGLzgEVv8xuPTN36lgrQGwcruNuHdFhXGEDQxE=;
        fh=6uB7LiP+v+HhnrO2kGDikm8OD17EtB27lgePVTrUtY8=;
        b=eWJpWEOQONjjls3H66V7W7ShoPIZAW6gjsJpHjR89uYLizUWfyrvPbT7kOg/DOcqAV
         QZT/9uQcpP2AXxscfNEL/ywLMDFaz9TSRAjNuyCeUqgtjRodn6BH14XiX3cCL0h/OLv7
         24rm28OjhZqzT8WMrYS/WU+98TRnVXeHskgMCwpuDu5dBt0Ji+fikuFjfunZR+DI8YIu
         c9xP/1nxtLDKH31Gaf6l4BLBGw0002OJevof63+ln/8wMY1cczhazYsoqCVYGzrWrZeT
         YUGEryL7OUtZ5mUEN9RvQaZ8OAZZ05xBCx/1NIndrgWq1X6CkvVmLmfFZTXAxviaObV/
         IpWw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791258194; x=1791862994; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BEXTeQGLzgEVv8xuPTN36lgrQGwcruNuHdFhXGEDQxE=;
        b=PDDHg3a2LCqs+3XiRwyQt0AVuCeWE893FNKT0ilCYLizGNoF0Ro72mkC4XZ7pZiRGY
         fJUrVp50i0p6gdpkFdWfuutcSlbokOt4n+OoPdfXMr/1jKQB3iIDQz4gotpKFoeyLBJC
         f1wZCI1S6ch9Q0qU0LGW7r8Z589g7lh5Pam02mEIdrEHKdKURfYupRCAP9gWyuU+bDkD
         0+Kj/582bszSJRZMz32uOfB3p37sk/FHyXl71OBivn/+XJaYCtOF/5Up5Ss/qOyvglRq
         zr/ZJRrVMp/CcrlWGaBbwAoKhUPZaCkvuwOgFZSZE4cm4jpJ5nTC8x7ytU0pTATQuwcy
         V1CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791258194; x=1791862994;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BEXTeQGLzgEVv8xuPTN36lgrQGwcruNuHdFhXGEDQxE=;
        b=ODV5aIcQ4uVx6vYmmZUIBEEYhBUVR5Gx4oxjijin5UAfx6TkADWV+dWpWLIP+eRekH
         knH+ABwP1GABkl63RNFeRkDtw6je0VupSSJOS/D+dw0V6vQ4/l6xS1smtuAx0l1/DCfm
         s90MSQUb4Z98qWX7ZbJ4zeSL6SbUmUSr5wd2icz1McSXGDzt4vHK4HXlrhnJm/CykNF9
         KWJ2DZce02m029H4CJqVOZQBteePex4kwBlXYF0SDejBNYKyS8iAEBUUEfRPWmCVdOaZ
         3Fzs/4fwG7fmBFX49hOkyX6u14+jNphaF4OAyGlahBjG0tMcVdFHQXHy529kN0GlwOAS
         D/EA==
X-Forwarded-Encrypted: i=1; AKwUvBxqjfhw1JlDrWosG0U0uUmxAQ4Jsxd0JE/eg1Dzxd6+sEBceEO2OMaYEMJJqlDQckTfuHZ+bVQ25HYv@vger.kernel.org
X-Gm-Message-State: AFq9FYIBWUPzkF/RQQLE6FlYNrmWL10IBR/Y8WWeicSStmxy2dRDT2ZQ
	87fHrT3Hz+VuGnyocOlapbB9JhQazPWfd1ZC991KZvWOHlWKCRUVTtO49Y1tVzovY2vxp4iwMVh
	CqAmcZm3KDqw1hee/6ASihwZLlnMaA0s=
X-Gm-Gg: AYBFou1XGG99BAiCa6Y9koZHtSlzuHyDvBlVX9XMDzS/rI508ozkf6b+AhHF1iRGdjN
	ihWDLsDl55jLv91pr4lCw6AT6XY4/Zk6Xy0qAeoMwMEiVuNBFKDIu5gAcV7NGiGzXftR/JAY03e
	GJK0ndubVnKMKOxOT3xBsvjIAwC6CEvb4qD5XpMaDrJPvhdqRqtsjPk2gVIZaT+BjL5c4lM9qdO
	Ni5oVYHzf8gue/4jWY2ZZA1jM8dZO1K49r7ZO7t94VrldfIce0n+DkEvHInzvTZC9zoRM76RqQl
	r0W7dz2B46z5aR573ugI/oHh5qESTuveLZ5aWzsYNxWIB0XAH5d0d15ryw31colT6RxV
X-Received: by 2002:a05:690e:4145:b0:674:1336:7d5b with SMTP id
 956f58d0204a3-677bd380447mr3369449d50.52.1791258193959; Mon, 05 Oct 2026
 20:43:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261004055712.1293-1-yogeshgaur.83@gmail.com> <32152011-b196-4dc0-ba7e-495f2132ad15@fygo.io>
In-Reply-To: <32152011-b196-4dc0-ba7e-495f2132ad15@fygo.io>
From: Yogesh Gaur <yogeshgaur.83@gmail.com>
Date: Tue, 6 Oct 2026 09:13:03 +0530
X-Gm-Features: AclHuK-etZgMZhRThOtRlbtdP2ce2Ph0ESLyjNgIBlEnFN-xlVATRsrCZ1wzbZg
Message-ID: <CAG6enPwFpBK=VyEPEnw9a26Yg+Gzt0enieHpYvnJz-v7L5ALyw@mail.gmail.com>
Subject: Re: [PATCH] md: don't hand out the array before md_alloc() has added mddev->kobj
To: yukuai@fygo.io
Cc: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Li Nan <magiclinan@didiglobal.com>, 
	Xiao Ni <xiao@kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, 
	Logan Gunthorpe <logang@deltatee.com>, syzbot+95eeb4ada2349a2170ea@syzkaller.appspotmail.com, 
	stable@vger.kernel.org, "xiaobai050@gmail.com" <xiaobai050@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 5, 2026 at 10:35=E2=80=AFPM yu kuai <yukuai@fygo.io> wrote:
>
> Hi,
>
> =E5=9C=A8 2026/10/4 13:57, Yogesh Gaur =E5=86=99=E9=81=93:
> > md_alloc() publishes the gendisk before it is done setting the mddev up=
:
> >
> >       disk->private_data =3D mddev;
> >       ...
> >       error =3D add_disk(disk);
> >       if (error)
> >               goto out_put_disk;
> >
> >       kobject_init(&mddev->kobj, &md_ktype);
> >       error =3D kobject_add(&mddev->kobj, &disk_to_dev(disk)->kobj, "%s=
", "md");
> >
> > add_disk() makes /dev/mdN openable, and md_open() only refuses the open
> > when MD_CLOSING is set.  mddev comes from mddev_alloc() and is zeroed,
> > so anything that gets in between add_disk() and kobject_add() sees an
> > mddev->kobj that has never been through kobject_init() - no ktype, no
> > kref, state_initialized clear.
> >
> > syzbot opens the array in that window and issues ADD_NEW_DISK:
> >
> >    kobject: '(null)' (ffff8880120640f0): is not initialized, yet kobjec=
t_get() is being called.
> >    WARNING: lib/kobject.c:642 at kobject_add_internal+0xea/0xcd0 lib/ko=
bject.c:225
> >     kobject_add_varg lib/kobject.c:374 [inline]
> >     kobject_add+0x163/0x240 lib/kobject.c:426
> >     bind_rdev_to_array+0x80c/0xdd0 drivers/md/md.c:2621
> >     md_add_new_disk+0xe3b/0x1850 drivers/md/md.c:7684
> >     md_ioctl+0x200a/0x2610 drivers/md/md.c:8499
> >
> > bind_rdev_to_array() is not the only way in.  md_run() calls
> > sysfs_create_group(&mddev->kobj, &md_redundancy_group), and
> > internal_create_group() has its own WARN_ON(!kobj->sd), so RUN_ARRAY in
> > the same window warns too.  Guarding the individual callers would mean
> > finding all of them; the window itself is what should not be reachable.
> >
> > Refuse the open until md_alloc() has added the kobject.  mddev->kobj.sd
> > is NULL until kobject_add() creates the directory, and stays set for th=
e
> > rest of the mddev's life: commit ca39f7502425 ("md: fix mddev->kobj
> > lifetime") dropped the explicit kobject_del() and lets the final put do
> > the removal.  md.c already tests mddev->kobj.sd for "is this array
> > published yet" in mddev_unlock() and md_run().
> >
> > This cannot deadlock against add_disk() itself: device_add_disk() only
> > opens the disk to scan partitions when get_capacity(disk) is non-zero,
> > and md_alloc() does not set the capacity - md_run() does, long after.
> >
> > Fixes: ca39f7502425 ("md: fix mddev->kobj lifetime")
> > Reported-by: syzbot+95eeb4ada2349a2170ea@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3D95eeb4ada2349a2170ea
> > Cc: stable@vger.kernel.org
> > Assisted-by: LLM
> > ---
> >   drivers/md/md.c | 9 +++++++++
> >   1 file changed, 9 insertions(+)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 680b34a63cb3..e3326b78aef7 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -8610,6 +8610,15 @@ static int md_open(struct gendisk *disk, blk_mod=
e_t mode)
> >       if (test_bit(MD_CLOSING, &mddev->flags))
> >               goto out_unlock;
> >
> > +     /*
> > +      * md_alloc() publishes the gendisk with add_disk() before it has
> > +      * initialised and added mddev->kobj, so an array opened in that =
window
> > +      * would let ioctls reach a kobject that is still all zeroes.  Wa=
it for
> > +      * md_alloc() to finish rather than handing out the device early.
> > +      */
> > +     if (!mddev->kobj.sd)
> > +             goto out_unlock;
> > +
> >       atomic_inc(&mddev->openers);
> >       mutex_unlock(&mddev->open_mutex);
>
> This is the same problem that I already replied in another thread, the sa=
me solution
> with different code.
>
> Re: [PATCH] md: prevent opening an array before its sysfs kobject is
> ready - yu kuai <https://lore.kernel.org/all/a19e3020-272b-4f93-8535-00fa=
07002d91@fygo.io/#t>
>

Thanks Kuai. Yes just refusing the open would be going to move the
race condition. I had missed earlier patch from xiaobai050, sorry for
the duplicate.

I would send a v2 that holds reconfig_mutex from add_disk() through
kobject_add() in md_alloc(), so an ioctl issued in that window waits
instead of failing the open. RUN_ARRAY is covered as well, since
md_run() also uses mddev->kobj and runs under same lock.

Thanks
Yogesh
> >
>
> --
> Thanks,
> Kuai
