Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A03931E831
	for <linux-raid@vger.kernel.org>; Tue, 29 Sep 2026 07:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790667496; cv=none; b=QR/oI5Ifdse1ZFcQ+goJGWkjdb9f3phNJhaa4YxM/403+ak2ojzuJiW74AHQIrBrJQUnmfxeMvIpgoezW+2YAtvqC2VE12+qGjSQEfxYz9U1cjcBLlNyCS6sFMe64U7+xlXGOEgVoocx0rNsCkDpWrcaf9OTlB9VA8V9DpRb0po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790667496; c=relaxed/simple;
	bh=ODVKLSw4UQBJXZZmNH9DKwFhJw9Ac3420dO3fQGtAag=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ZShbbhVihlTtULyKHncbyusmgQdGrzAzkw4FgVHzgVVut1S60afuAjk3IB3+iFeWWpJ/2ktUIkZqGx+41XQkizAvXJFwN4Ov88LdbZCClazQhsxBOt0Y4B7rWDYzRnJq/Xapi1x5tMIflBKxSCIHW75ZLcQgSzuqZUgkV4iocJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KdaTy9fW; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KdaTy9fW"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ffa15f67fso15492625e9.2
        for <linux-raid@vger.kernel.org>; Tue, 29 Sep 2026 00:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790667493; x=1791272293; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=olPoRoj6Q3FNvSOVrmcrQZUWbcZjryfiG4iHSOAucPk=;
        b=KdaTy9fWjdlssDOp8Fo+iK4HoYZ6esIh4Y3418Zh9tEIdGQyfTwRdv1r5g1aeewm25
         Kti7qrcYBVy3tyYddMbVn4/o+fVLenlthGz5tVnMLsJNmKShvWvgLgtzz4xm4nqBf8xh
         9S0FEo3olgInQbsXUvN6kBsKmFen61IW32BLC3PdggJkaVZVa1t4C//7/H8C+Ri7/NHx
         2WQX0WEjgGzZOoM1u0/Shi8do3lu7yCgnOlh6QV9QnMWq4LKlKkrvblBglVmganqFRqf
         Q4aG8WK6WG7kJB2DNTkRXugYInahD3+a5X+nf/8xc1ZcbUbUYeYC+9jxdxakDFsPryFr
         uoPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790667493; x=1791272293;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=olPoRoj6Q3FNvSOVrmcrQZUWbcZjryfiG4iHSOAucPk=;
        b=VUH6DsYhmAihBZSKcbf9oS4/Us/mCgnCDO6P+0UPwgqYkG7JmYTdjZC+71zGyZ0jWy
         atFnaCfXq02ZUOKtjE8ZiXyK4lNrN4yjn5UKShGRI1v6PyYIL3OLku8gHK53KW2q6lZ9
         1LL0qyqZzy/hre9DAx+zm+E/+TyufkE/TOYyHjWK9a5TSb6C44Fkq+N10t1P02T7bDJH
         VNy0KAgVuWj0U8KmNM34HJvAyR/ayVL4KurqnlL1/NXd0BFmV2gEl6hgpz4XaefcXrKP
         1A9zCfa7kHeBHWlVC/l/f9+m9a+DtVmKbxaFvR5vXhWsAGGTS+JfKtke338Yow+DsmOu
         CQBQ==
X-Forwarded-Encrypted: i=1; AKwUvBxilaonuT2e6CVOIVXhaKqMKI8fZsoZHtntU25705k99MTY8NYbrwFESJ+t3p/dUIYh4hSCgeeW+94t@vger.kernel.org
X-Gm-Message-State: AFuF++kLlw1jeUQszMXUFt3Y9QZcU72QH9sXIhEfscuJBql8mzEMceVH
	aMO249BD0+biCCHF+bgkOQHAtIROZyQ4wjD6ssf7DP8wmI/nYRb8JmPY1OUYmA==
X-Gm-Gg: AYBFou1ghwi71oboWf0L2XhwjJiQli1UesnPNvQwf/4hamS0Gj6/6gB+MVPDOrFs5tK
	4OFBk2TonEU1K4rSJHynvT7OOBKi1B1PZKTYMuv3iTqix6v8mYegjRUuIkb7oBEHa+Zhr5B4LOJ
	9+CZtCpjbuYbOY/3vYsTgPdULMZi0X9ykFN5PXUeYlnrnw4CrBZr/OF9yVeyZ9M4hyoNc0eb2NU
	BGo2PX1LHJDXClWTHvMYs21ME2pQUAq7Q8QKv1P1uQXYFLbzXMYMmiKn3JXLrTxOWLQda0s6sVe
	VccJilCM0sXpembXaqEk0RisIRpMY6IbVJ2D0aHm/aw3wdNRvrXGHuIfhHNmW8QoWQiIWw/Ak0n
	yrn604BOVmTN+y05F10JoItSEGgY2dbCc4NbSs6fXx67YXyOujHHpynCqgLJNvGJviNegCa1kew
	otu2/RvvJcmtBV2sC8Ug4KxqQTKm0NE7FEbLhyLrCCWP0HMaa2xJbY4qQRbi+pfyyYqkz4lQBaC
	KQbBmovqf3hE+XYKfXGYPYVxCToDXA=
X-Received: by 2002:a05:600c:540e:b0:4a0:1d:3ac4 with SMTP id 5b1f17b1804b1-4a0001d3ba8mr127287325e9.6.1790667493041;
        Tue, 29 Sep 2026 00:38:13 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([141.2.113.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a00cf9b150sm53285835e9.7.2026.09.29.00.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 00:38:12 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: sashiko-reviews@lists.linux.dev
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
Subject: Re: [PATCH 2/2] md: add a control device for array management
In-Reply-To: <20260928202622.B1EC61F000FF@smtp.kernel.org>
References: <20260928201224.3602262-1-abd.masalkhi@gmail.com>
 <20260928201224.3602262-3-abd.masalkhi@gmail.com>
 <20260928202622.B1EC61F000FF@smtp.kernel.org>
Date: Tue, 29 Sep 2026 09:38:11 +0200
Message-ID: <m2ecec4ie4.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi Kuai,

Sorry, I forgot to mark this series as RFC.

On Mon, Sep 28, 2026 at 20:26 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 9 potential issu=
e(s) to consider:
> - [High] md: MD_STOP_ARRAY mutual exclusion bypass via control device
> - [High] md: md_ctl_exit is marked __init and omitted from md_exit()
> - [High] md: self-deadlock in get_mddev_dev and get_mddev_uuid via mddev_=
put
> - [Medium] md: binary UUID lookup fails for UUIDs starting with 0x00
> - [Medium] md: missing null-termination enforcement allows stack OOB read
> - [Low] md: direct cast from __u64 to user pointer causes warnings
> - [Low] md: uninitialized pointer passed to get_raid_version()
> - [Low] md: unknown ioctl flags return -ENOTTY instead of -EINVAL
> - [Low] md: unprivileged un-ratelimited pr_err allows log flooding
> --
>
> commit dd168c18138734c235c0b8b1c097fa7a18b6baa8
> Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
> Subject: md: add a control device for array management
>
> This patch introduces a misc character device, /dev/md-control, to allow
> MD management ioctls without holding a block device reference. New 64-bit
> safe ioctls are provided that specify the target array by name, UUID, or
> device number.
>
>>     The new ioctls use the existing MD_MAJOR ioctl type, starting at 0x4=
0,
>>     with an MD_ prefix. Every request structure has a flags field. Unkno=
wn
>>     flags are rejected with -EINVAL.
>
> [Severity: Low]
> The implementation of ctl_flags_valid() below actually returns -ENOTTY for
> unknown flags. Should the implementation be updated to match this documen=
ted
> behavior?
>
I will fix this in v2.

> diff --git a/drivers/md/md-ctl.c b/drivers/md/md-ctl.c
> new file mode 100644
> index 0000000000000..84923b0a2fa3c
> --- /dev/null
> +++ b/drivers/md/md-ctl.c
> @@ -0,0 +1,597 @@
> [ ... ]
> +static struct mddev *get_mddev_dev(dev_t dev)
> +{
> +	struct mddev *mddev, *ret =3D NULL;
> +
> +	if (MINOR(dev) >=3D (1 << MINORBITS))
> +		return ERR_PTR(-EINVAL);
> +
> +	if (MAJOR(dev) !=3D MD_MAJOR)
> +		dev &=3D ~((1 << MdpMinorShift) - 1);
> +
> +	spin_lock(&all_mddevs_lock);
> +	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
> +		if (mddev->unit =3D=3D dev) {
> +			ret =3D mddev_get(mddev);
> +			if (ret && !mddev->gendisk) {
> +				mddev_put(mddev);
> [Severity: High]
> Does calling mddev_put() while holding all_mddevs_lock cause a self-deadl=
ock?
>
I will fix this in v2.

> If the reference count was 0 before mddev_get(), mddev_put() will drop it
> back to 0 and internally call atomic_dec_and_lock(&mddev->active,
> &all_mddevs_lock). Since the current CPU already holds the non-recursive
> all_mddevs_lock, this will deadlock the system. This pattern also appears
> in get_mddev_uuid().
>
> +				ret =3D ERR_PTR(-EBUSY);
> +			}
> +			break;
> +		}
> +	}
> +	spin_unlock(&all_mddevs_lock);
> +
> +	return ret ? ret : ERR_PTR(-ENODEV);
> +}
> +
> +static struct mddev *get_mddev_name(const char *name)
> +{
> +	unsigned long minor;
> +	struct mddev *mddev, *ret =3D NULL;
> +
> +	if (strncmp(name, "md", 2))
> +		return ERR_PTR(-EINVAL);
> +
> +	if (name[2] !=3D '_' && (!isdigit(name[2]) ||
> +			       kstrtoul(&name[2], 10, &minor) ||
> [Severity: Medium]
> Can this result in an out-of-bounds read on the kernel stack?
>
> The name field is populated via copy_from_user() on the md_ctl structure
> without enforcing null-termination. If a user populates the entire 32-byte
> name field without a null terminator, kstrtoul() will read past the array
> bounds into adjacent stack memory until it finds a non-digit character.
>
I will fix this in v2.

> +			       minor > MINORMASK))
> +		return ERR_PTR(-EINVAL);
> [ ... ]
> +static struct mddev *ctl_find_mddev(struct mdu_ioctl *md_ctl)
> +{
> +	struct mddev *ret =3D ERR_PTR(-EINVAL);
> +
> +	if (*md_ctl->uuid) {
> [Severity: Medium]
> Does this correctly evaluate the binary UUID?
>
> Checking *md_ctl->uuid only evaluates the first byte of the 16-byte array.
> If an array is created with a randomly generated UUID that happens to sta=
rt
> with 0x00, the UUID lookup will be skipped and fallback to checking the n=
ame
> or device number instead.
>
I will fix this in v2.

> +		if (*md_ctl->name || md_ctl->dev) {
> +			pr_err("md: only supply one of name, uuid or dev number\n");
> [Severity: Low]
> Could this allow an unprivileged user to flood the kernel log buffer?
>
> Since this is triggered directly by user input via ioctl, using an
> un-ratelimited pr_err() here instead of pr_err_ratelimited() or pr_debug()
> allows dmesg flooding.
>
I will use pr_err_ratelimited() in v2.

> +			return ret;
> +		}
> [ ... ]
> +static long md_ctl_ioctl(struct file *filp, uint cmd, ulong u)
> +{
> +	int err;
> +	unsigned int old_cmd;
> +	unsigned int noio_flags =3D 0;
> +	struct mddev *mddev;
> +	void __user *arg;
> +	struct mdu_ioctl md_ctl;
> +
> +	err =3D ctl_ioctl_valid(cmd);
> +	if (err)
> +		return err;
> +
> +	if (cmd =3D=3D MD_RAID_VERSION)
> +		return get_raid_version(mddev, (struct mdu_version64 __user *)u);
> [Severity: Low]
> Does this pass an uninitialized mddev pointer to get_raid_version()?
>
get_raid_version() should not take mddev as a parameter; I will fix this
in v2.

> mddev is evaluated and passed in a register before it is initialized by
> ctl_find_mddev(), resulting in undefined behavior.
>
> +
> +	if (copy_from_user(&md_ctl, (void __user *)u, sizeof(md_ctl)))
> +		return -EFAULT;
> +
> +	err =3D ctl_flags_valid(cmd, md_ctl.flags);
> +	if (err)
> +		return err;
> +
> +	mddev =3D ctl_find_mddev(&md_ctl);
> +	if (IS_ERR(mddev))
> +		return PTR_ERR(mddev);
> +
> +	old_cmd =3D try_convert_ioctl_cmd(cmd, md_ctl.flags);
> +	if (old_cmd) {
> +		err =3D md_do_ioctl(mddev->gendisk->part0, 0, old_cmd, md_ctl.arg);
> [Severity: High]
> Does delegating to md_do_ioctl() bypass the MD_STOP_ARRAY mutual exclusio=
n?
>
> When MD_STOP_ARRAY is called here via the control device, md_do_ioctl() c=
alls
> mddev_set_closing_and_sync_blockdev(mddev, 1), which assumes the caller h=
olds
> the block device open. Because the control ioctl caller doesn't hold the
> block device, atomic_read(&mddev->openers) > 1 will evaluate to false if
> exactly one other task has the array open, allowing the array to be stopp=
ed
> while it is actively in use.
>
Yes that might happen. I will fix this in v2.

> +		goto out;
> +	}
> +
> +	arg =3D (void __user *)md_ctl.arg;
> [Severity: Low]
> Does this direct cast from __u64 to a pointer cause compiler warnings on
> 32-bit architectures?
>
> It is recommended to use u64_to_user_ptr() to handle the pointer translat=
ion
> correctly for compat userspace.
>
I will fix this in v2.

> +	switch (cmd) {
> [ ... ]
> +void __init md_ctl_exit(void)
> +{
> +	misc_deregister(&md_ctl_misc);
> +}
> [Severity: High]
> Is md_ctl_exit() marked __init by mistake?
>
> Additionally, it appears this function is completely omitted from the
> module unload path (md_exit() in md.c doesn't call it). This would leak t=
he
> misc device when the md module is unloaded, and any subsequent access to
> /dev/md-control would cause a use-after-free panic.
>
I will fix this in v2.

> --=20
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928201224.36=
02262-1-abd.masalkhi@gmail.com?part=3D2

--=20
Best Regards,
Abd-Alrhman
