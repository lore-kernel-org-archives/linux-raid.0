Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FEA3C1D57
	for <linux-raid@vger.kernel.org>; Wed, 14 Oct 2026 12:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791981230; cv=pass; b=TBXIkg+ME1tEHM7yx4cLZaRktLRTvOJoJBtl2v477wmcoU8GbyZZKLxEifpoauz4oMllk855mUPzqytO31IOP0OCZmgi2sCDv1ErSPpOP4kEr9ECobgTL0DVdCu0b1mlQJyjWHfIGz/cGP+f/UetCzMa+pnnIHJsCCb0vGjW31A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791981230; c=relaxed/simple;
	bh=5LQu2scU6Wzy7H+0+F4mLdz9KrGpX5VTW+VuvPiHq2A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TL4ng3He4vEBLOIotgDvPEK2DaH/HJndsbEA/3V+FBDwmmTGa3cQNyEDOYgwhYmPkf/FeYCKLOMqiwTXx5t7INh5vxM5fAIM4l78AO8pyL7hClQg+tNn37HFHbfZiQzreAlio4wjKqTnFktPBMsUjMCy3C87QHVMMBT0uJBWyfE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=fV7z8XkS; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="fV7z8XkS"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c329dc7e0f5so60224966b.1
        for <linux-raid@vger.kernel.org>; Wed, 14 Oct 2026 05:33:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791981225; cv=none;
        d=google.com; s=arc-20260327;
        b=Dn63mX3RIdzuezfsi5Aw4eRUzV7PoVa9ca9FR3yi3ntpzWZ4XfZWdirPwnMfX4g2Tu
         VWIoVKoi65EXn8tMAn8dUpqfOPuytZfDpqPVPDebwrpyWWfew5rKLQBSlhlbc3Eyn7Jb
         1ObE2AfsIke7Rc5rn9AIuEcQgVQjvyomjoOwapKPkrPx8QzEIlHvWddvwE7VUKbqfFOr
         kYY8DfdcJSNgxsXeP29YHya8JH6KzgGQS+Lh/ZKXN2k5+OSig5Yi4aE8k6LYamFfJQKS
         nvnXKfP1+EkZKfyb4KRHVp5lWiUBAS7nTBT8CMZsjZKNzU+0nHvubULb6+57P/3XZzTe
         lr9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xc6OYIsIblBkxyIfP1OcMrgJAKJXZ0gf3E+YejrIirI=;
        fh=mTP6TkWV1IhQRgyhsEpYqIpiXvhDlZKdHAfNRdOTDjk=;
        b=Vt5Qf7xYao3C8ZyqpAmccehC3ATBjE6g1w592dDnXwlKuU8dm1v74XfO0oN4IRSrbR
         LxKoa1o8BOaczuY9AaMBhkXliNz/nE7hgfWmXi4rS4h0YmFJo5KsRX8nCbBLtSd943bI
         PNez0ooxQlw/ATrFYEWvcFcMji6sJLnbKv3PrkmC7VAM4UNSitN1Ir/TMKuE/oq3aKpx
         LBajUJB0QYti2z5Df7SQ3QAXRy9YKxT38TAw1Wt3ptKa7KA8WCKtOvUhXh4LAvgQNcNz
         tIfG7wLnm1ywfJpJKdcD7KNzXCYbjmihWQRVvkzwtF1bCedLaplIUO7YwCpLLG3wgT0R
         CLBg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1791981225; x=1792586025; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xc6OYIsIblBkxyIfP1OcMrgJAKJXZ0gf3E+YejrIirI=;
        b=fV7z8XkSVk5LFJ98KHvdR4wygqZXawwoxxC5oJ8IUq+CiQyYqNr/QRhE9rxQAdsD5I
         pPS8LBeUZAyu75NrZtxFw/aojX8tuGCvxS/iSesc/m92bjI8JLMMlpJ8F+nD7aUk/3j1
         0MHKQcZQEtIGxgb/yncEL54NUArQsc8ifPmmCBS+Gjb2wbyN67gcH/HJqGSS9dtr8KYl
         hpWgIbXIP6Ibe6K3cP8V7EeTTZbf7i8+WlkRl7zJmFXd5b+rCsqkl2+aEh192qz7doJI
         RdEGQdYUhjP4Qb+F5Hh6EFatqSOsxVr/grggO8Z3vE5RtzrH8hZOaMn6nsG/cVbOK+Zk
         QPxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791981225; x=1792586025;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xc6OYIsIblBkxyIfP1OcMrgJAKJXZ0gf3E+YejrIirI=;
        b=OqdvswgBrGjtoCdOVB4k/UivXCdNR3k6SVmj8x5/M3fWzzEFvC4Ck6rA+7cpQH18Ny
         HImBjKR9e/qqmKhtbkRUl+1Mb5WxRJ4jQNi0/em3cDbD5qx7+qCuZdAFRkmY6J7kcWal
         qaHe/GTPM3ln5kv22mSvkQDnbsg8Q9x6zQ51t66fcxXCsV6LDznOaKkJ4JWhNwVaDpz7
         2Gbq6elFmY/tif9EPDZkUnXIa8hacW/BZ6a7cESz2ulf9L8DJ6YTG8mbpH4E6XVbh5wB
         5eJzBbymL0Gc94eSR42k7LrRyeQjoX+f9WCZ57C6/dMbq2goljDd0HhL5idqURgMa+0R
         ocfA==
X-Gm-Message-State: AFq9FYJClpgesLO0Q7PU5pB42gSZnYcGQcL3SV6Nfa2+u2yCAmZCANad
	lxjsTIgj/LFVhjzbKs5eNx/Ha7AX1PVi71Yn4Yg9WeRsFtS6/6bsDGn+wfA808T/6BS1Zf84siU
	BRqEEa5x97lcKdXCiCk3X4s2BP6zHrgF3D2/1yONYKkiapZJ3QkGcuPZ4jw==
X-Gm-Gg: AYBFou2VA2DWQiT13Wl2P0+c0dUNcONIpn6VXZLkzkQ/zIAS/Ys+rzAUpQSexwpDQbf
	i0Xjlo813p9+M0DO8gv3Q2fJmcCuwHF43aiKQjmHfWWO91kfPJk42besHeaqGyqeWXgrtBZM4Ls
	E+UvHGGL6lBkdYk6ZOCQYE+beNk21FN8weFPuu71LOLWdOdL0bPkuAgxQ4Isz9A4cTivJjRl6fY
	u+GpWQOcU7OIZ3C6YOClpCPr/XVE89N8XWpKBYjA6TAKPN9+EpF+8gXQrLe27IypktBzbYh5Feb
	Y8hZxoceqmx6eUuGmt3XskhiumEZWB+roEzmflD+iJS1APZlDJFrIBj3MRqwNR+oag==
X-Received: by 2002:a17:906:c10b:b0:c29:5172:c532 with SMTP id
 a640c23a62f3a-c31a9f90cf0mr1591771666b.4.1791981225241; Wed, 14 Oct 2026
 05:33:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261014114830.615589-1-jinpu.wang@ionos.com> <sashiko-outbox-171234@kernel.org>
In-Reply-To: <sashiko-outbox-171234@kernel.org>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Wed, 14 Oct 2026 14:33:34 +0200
X-Gm-Features: AclHuK-VUY2tO56miFi14QNouGTHw5CYl_-Mcn4FjH6FftaHezCVW9gFtUZ8ChM
Message-ID: <CAMGffEk1GDMquLszFvDC-KPn1827QjA-J9rVoKoHQm_H3Su3FA@mail.gmail.com>
Subject: Re: [PATCH] md: allow growing logical_block_size on a running array
To: sashiko-reviews@lists.linux.dev
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 14, 2026 at 2:00=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
> - [High] md: Unbalanced mutex unlock on mddev_lock() failure in lbs_store=
()
This one is fixed in
https://lore.kernel.org/linux-raid/20261013141241.2257621-1-yukuai@kernel.o=
rg/T/#u
> - [High] md: TOCTOU race in lbs_store() bypasses opener check and deadloc=
ks via queue freeze
Second is valid, seems no simple solution, safer to lbs change when
array is inactive. I will drop the patch
> --
>
> commit 4267b7426d911d22ecfdc4aa203d879ce4f9a759
> Author: Jack Wang <jinpu.wang@cloud.ionos.com>
>
>     md: allow growing logical_block_size on a running array
>
>     Growing logical_block_size on a running array required stopping it
>     first. Handle it directly in lbs_store(), similar to
>     mddev_set_closing_and_sync_blockdev(): under open_mutex, refuse with
>     -EBUSY if the array is closing or has openers, otherwise apply the
>     bigger LBS.
>
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 680b34a63cb3d..c885d405bf466 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
>
> [ ... ]
>
> > @@ -6026,8 +6026,36 @@ lbs_store(struct mddev *mddev, const char *buf, =
size_t len)
> >       if (mddev->pers) {
>
> [Severity: High]
> Since this check of mddev->pers is performed locklessly, can a concurrent
> thread starting the array race with it?
>
> If mddev->pers is null, we fall through to the bottom path and block on
> mddev_lock(mddev). Concurrently, another thread executing do_md_run() cou=
ld
> acquire reconfig_mutex, set mddev->pers to non-null, start the array, and
> release the lock.
>
> When lbs_store() wakes up and acquires reconfig_mutex, it does not re-ver=
ify
> mddev->pers or check atomic_read(&mddev->openers) > 0 before calling
> mddev_set_logical_block_size():
>
> drivers/md/md.c:lbs_store() {
>     ...
>         if (mddev->pers) {
>         ...
>                 return len;
>         }
>
>         err =3D mddev_lock(mddev);
>         if (err)
>                 goto unlock;
>
>         err =3D mddev_set_logical_block_size(mddev, lbs);
>     ...
> }
>
> Does this blindly apply a new logical block size to a running array with
> active openers? Furthermore, since mddev_set_logical_block_size() invokes
> queue_limits_commit_update_frozen() which waits for all active I/O to dra=
in
> while holding reconfig_mutex, could this deadlock if active I/O completio=
n
> requires reconfig_mutex?
>
> [Severity: High]
> If mddev_lock() fails (e.g., interrupted by a signal, returning -EINTR),
> does it jump to an unbalanced unlock?
>
> drivers/md/md.c:lbs_store() {
>     ...
>         err =3D mddev_lock(mddev);
>         if (err)
>                 goto unlock;
>
>         err =3D mddev_set_logical_block_size(mddev, lbs);
>
> unlock:
>         mddev_unlock(mddev);
>         return err ?: len;
> }
>
> Because mddev_lock() failed, reconfig_mutex was not acquired, but the unl=
ock
> label unconditionally calls mddev_unlock(mddev) to release it. Could this
> attempt to unlock an unheld mutex and trigger a lockdep splat or kernel
> panic?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014114830.61=
5589-1-jinpu.wang@ionos.com?part=3D1
