Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B642F12AE;
	Fri, 12 Jun 2026 03:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781233870; cv=none; b=ZxkOWKpdIJ1Q3ShiXut6/ZstMxIFPktBBH2x53CtDyE2I5iyANibj4h2ZauDWIdkvilI3EOCgTLL8vy9D789mqDuojjO/i8RUSrBPIcWrbmtWNwidiFlEjnbjn9gzWB9pjd9fkg+tKh760/TQakt6fjJ6FWx4AAEzhTdZsfDhE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781233870; c=relaxed/simple;
	bh=r+LdII9mCqsAf/u214BlaFzoet7YzIBP/2z0+0eMxGU=;
	h=Message-ID:Mime-Version:Content-Type:Date:To:Subject:Cc:From:
	 References:In-Reply-To; b=c6pOfzFGFhvT/kAn8fyIffjRV4rniZXkaUUQp8CCJuJlcHotozAUiCsTgAyPs4NUqiWPxpNQI5EKQW6w43se3ZgK7ptgu7W3FskSjkdaQ/VjzqgdfUwJ9FZFUo5CMTrbeErLOnP0+hWiwbp7FCwc8T3IWStC0qofJGj+KJqBPgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=TeEbw2Pd; arc=none smtp.client-ip=162.62.57.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="TeEbw2Pd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1781233856;
	bh=jGlsIIp4WdkA90uTA7KfIfoeQ8BjYxUutIzYjko+8nk=;
	h=Date:To:Subject:Cc:From:References:In-Reply-To;
	b=TeEbw2PdvTZvovT6HCm+o2PsdztFSYo/Qz2DQRxk7NUydZd94MSR0XFArZtkThoDO
	 C+ZycL3jIgCR9vUArEsRnIR+Un35al81lzSOUxAkE7hgaixCBXXzikohD4VowgquoJ
	 UCoBaOYfAAbU/Hk7HFl/lzOYbDLfq4WKXdofXzp4=
Received: from MacBook-Pro.local ([183.134.211.52])
	by newxmesmtplogicsvrszb43-0.qq.com (NewEsmtp) with SMTP
	id 26085C66; Fri, 12 Jun 2026 11:09:32 +0800
X-QQ-mid: xmsmtpt1781233772tderodvpm
Message-ID: <tencent_E8A377BE09482BD1053AFB9E82E817D2550A@qq.com>
X-QQ-XMAILINFO: OToYBcNOiosRWMwScPkh7r3kP3GPC5SmDkOxlKmcl2a2+qLYpZWkIsqr9nH/6O
	 J9aQYagQm+Ho2XrJvQ4Z+T1xgOcqWgonkQMeK4nvoTkIrYD9oe80mdTQfTN3wHtQNDgEsTpoTq+p
	 60/7FqRQ19GsEDJ5m/Hwu38jaMETEPWFkuxDkGVwwf4NcjleN5VhU/3zz2oykXiUHsks4/DTi1cW
	 7TqKy7cvQace8FGebelDiLi3+oLjzOmJME5BzLdR/ELs4i2AB1AZSbVP0BGMYjaZGUaoMUqMzrvC
	 jrkl1VvMj7cO/TozpRdvJV3VvP6bQKsODiiVjtuRAkmFwP+nA718j7Az2Mp2w2pmmZ11xzyrOVu/
	 3+phgNOhGL93blGvEnfBNbH6xrDXEHVxjUiBKwbsceXiQA1bhUF4XJosjTJSuOqUN415keYIcDWb
	 wFvsMN/w/0yH+tEJPKnbieKDPnIFN+ZyqbKNGTi0y2oc8vu4py0x5eQEqbtHpz2smKI1hF1Uh1kH
	 dZdU2aIDvj4K5MzMgcECweCqx9onlnKLb+fPF8CV3PRpcQun5W+NyxlCOl3PqZ9I+HUpHPynVdbm
	 wDdRmWrRrafq6I/3aMXFHMZ9kCSIrGJJOPTFknQfQN076VeTExumlP5NsFkerTVysS45pblv37IS
	 ndRnsROyDmymcs91PemFejH/zVexeldAyU0RxUL1YzHbt25i9O7hjbWENevMnnOcEKjVghmL138k
	 hfFuTAlzV+i3OlG4EajwglPgAI1QVyk9XEikFbeDaYfvypH0Q4GsuDHY5plmzT7AhZn8ZUbUASva
	 WcJHIXATyBASGMc6RzHHXVpNCNH6HtFpx2PcJOAdKQ7npk4SKK7rPVghJjemjIFyUHWPTUQ5nDV1
	 GOFpxgkb8a4tasHDlhyMgTr0kKoXPNJtrBDA24DVYnNNAxjSkhBButjuQm59vuPDashlh2knoImi
	 EfcfL4qVZ3zHPTmi5JKlxyiEZLxImUkP1fsEPLJ0JSARuGYUiS5h1JjzNG8dOpw+drHU/H/+aCi1
	 0NZHlPvCr5OQfCDEBwVrPy58SxgSsHl0dXpd8ZgxQi/Q1hSxEAMr2ep9Sy6j6awjDh1LCvbw==
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 12 Jun 2026 11:09:32 +0800
X-OQ-MSGID: <DJ6QOAER0YE8.18Q3Y7NPPWYMV@foxmail.com>
To: <david.laight.linux@gmail.com>, "Kees Cook" <kees@kernel.org>,
 <linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-raid@vger.kernel.org>
Subject: Re: [PATCH next] drivers/md/md: Use bounded strings ops when
 setting disk->disk_name
Cc: "Arnd Bergmann" <arnd@kernel.org>, "Song Liu" <song@kernel.org>, "Yu
 Kuai" <yukuai@fnnas.com>
From: "Li Nan" <magiclinan@foxmail.com>
X-Mailer: aerc 0.21.0
References: <20260608095523.2606-26-david.laight.linux@gmail.com>
In-Reply-To: <20260608095523.2606-26-david.laight.linux@gmail.com>

On Mon Jun 8, 2026 at 5:55 PM CST, david.laight.linux wrote:
> From: David Laight <david.laight.linux@gmail.com>
>
> Replace strcpy() with strscpy() and sprintf() with snprintf() for safety.
>
> Signed-off-by: David Laight <david.laight.linux@gmail.com>
> ---
> This is one of a group of patches that remove potentially unbounded
> strcpy() calls.
>
> They are mostly replaced by strscpy() or, when strlen() has just been
> called, with memcpy() (usually including the '\0').
>
> Calls with copy string literals into arrays are left unchanged.
> They are safe and easily detected as such.
>
> The changes were made by getting the compiler to detect the calls and
> then fixing the code by hand.
>
> Note that all the changes are only compile tested.
>
> Some Makefiles were changed to allow files to contain strcpy().
> As well as 'difficult to fix' files, this included 'show' functions
> as they really need to use sysfs_emit() or seq_printf().
>
> All the patches are being sent individually to avoid very long cc lists.
> Apologies for the terse commit messages and likely unexpected tags.
> (There are about 100 patches in total.)
>
>  drivers/md/md.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 8b568eee8743..4b659d10fa4d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6346,11 +6346,11 @@ struct mddev *md_alloc(dev_t dev, char *name)
>  	disk->first_minor =3D unit << shift;
>  	disk->minors =3D 1 << shift;
>  	if (name)
> -		strcpy(disk->disk_name, name);
> +		strscpy(disk->disk_name, name);
>  	else if (partitioned)
> -		sprintf(disk->disk_name, "md_d%d", unit);
> +		snprintf(disk->disk_name, sizeof (disk->disk_name), "md_d%d", unit);

Please remove the space after sizeof to match the style used elsewhere in t=
his file.

>  	else
> -		sprintf(disk->disk_name, "md%d", unit);
> +		snprintf(disk->disk_name, sizeof (disk->disk_name), "md%d", unit);
>  	disk->fops =3D &md_fops;
>  	disk->private_data =3D mddev;
> =20

--=20
Thanks,
Nan

