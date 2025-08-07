Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAF524BC07
	for <linux-raid@vger.kernel.org>; Thu,  7 Aug 2025 08:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754556032; cv=none; b=UBF2Ljs6Z3fJPT6Qu75XU0nHDybz8vGDCh85KwL4zftEW0Zqj7nHZqEazhv7fs/vlV8ec0KBwYxUw41G0jNIGhGtzFgV/q+RUs41sHkp9nH1INcGfp1ygH2vJn9Lc0X3Rw/IV1iSNjgv8XgZDbLDPCTuvGsFUjtiAKdo0pdcKhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754556032; c=relaxed/simple;
	bh=W12Q9sxnLQ46HvWgazJD1HhXjzU0cdZHGSh5IFWlN+k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L92Zlgl6OLzBhHXrqWTpeXEExfrxv+NUC8pFwkH4WGltQTJu6qOKfg+x9HxIUCMlYtMUI6oUFLmm4+1/sryAD32tsW61KLPWpTGHi9mjYA8496dqGmjB9H5vVsE8n7LjT9hUvK6H7ji/lD1eIwvBfJ5ssCucp5DGPtt5VLYEjMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fXfQ5uJT; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fXfQ5uJT"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-71a3f7f0addso7264777b3.2
        for <linux-raid@vger.kernel.org>; Thu, 07 Aug 2025 01:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754556030; x=1755160830; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4AdQFvId35nJMuc52fIKxKu/0bOnV1yoLJPef+Xd8Wk=;
        b=fXfQ5uJT68y4egTT5SZ3WjbsF5wmSEJlZznOpeBJEKSBkUZl1wz5vV3HQcCs9CfDHm
         2Vc1hr+K9osQXSatVyL6BoNs4As0zBY3wyo/kpjYc33a7CPxVDBiZtuimKU4rwmRs1Fh
         8qM3/m/UAGdVLMWxwko5MK8AN5fu0XzkWCqlW2rpsIqQyoA4w2lSg92+DNCsdp1JUrJ4
         TjulGT8rBVyowUtY+lO85Nd0SvXMPsXPBicCFxjHph5aiImaMRUNlhlWpCV2vXD5ZI+9
         AdFCHKi/Qd5QxttdlzzasBXXV05ukbdf3ebBfOTHZBpQo3fiqMJAeChSooHGRVyDg4l5
         RV1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754556030; x=1755160830;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4AdQFvId35nJMuc52fIKxKu/0bOnV1yoLJPef+Xd8Wk=;
        b=Pj+CzMol6uLgmzvwhgtKwiwZ3nEYIzwFiw+B5mrPzcUYtxNFyKZIwPiDd9lfVvG0+v
         I4IIle3J4s3eLsCio0jbULraoq7QYN8giHRrFpfqn7a4E/fzztHW0Gh23JbaeLPr3vCS
         CCN+iG7tAykXBBL8ctazQVQL6y3ODkv4WnOkTGJ9TCHQsM9JfeURFO6fEaXnbEIbb6dd
         L4B6nkAkNnzA8iK+td7euKRpNBRYm/KNEz5S3QKwWRqKRJJvugbiqFKxa7mNcO1IhiUG
         2n/+9QKMMaNUDJH1ADXX3w9VOh7L3TZmNwifoVOunoQtKxZQnPyBXaK7xGo+O8bDy8sA
         6I3g==
X-Forwarded-Encrypted: i=1; AJvYcCUbx81W0q58zpT/8EUQK1z9OEvGVJG835Hr5o4AR4MjEefZJJ9ASVWCoBHHYM5Ax/Zh3eLBW55rLa/1@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2R31xMHiQ0goiS/FmuuoTzg9UFtATDJk0VfkHexVWktkib5Jx
	A6BjNueBkWUws5Q11T1DPCd5rAop7UTo/RlRND1kC6ia5LcoQA8wBRnsfub+k1hNQlpeVJReFpa
	dP9SSNvl+IIhOshn59UtgzqZTRS1yJaQQ6Q==
X-Gm-Gg: ASbGncvGI0sDkBRYsi3+fs/tqlLR3z5mK4dMKI+qgSfeaO1N73itPVet9eJMoRNK14M
	0zQMKZ6CYdOU1SR3Eb6Hs4B+5Ek40pUYnEOY7MkFVEvw5vDAaxBBpQyG8K1a6Qk7drywOQkISJ8
	Zmzsiuxa1CQbglgQb5tr49GxD+gQlxoRBEoaxIYLWM1/KFk+l2WMx0fIrQVENe4DEe+xu1Yw289
	5jKeup0qRtVyA4tSdbQxcDXnUVSpjxuB6usL6NzKg==
X-Google-Smtp-Source: AGHT+IEkFIxreMcM3xTcMGEns3/muj7PZzLAkLzEU4vENxTkL/5WxfU4v8vZypihMlLH3E+tI+lXO43jLMOhYFXEvys=
X-Received: by 2002:a05:690c:4988:b0:71a:413d:5668 with SMTP id
 00721157ae682-71bdbbab6e8mr27122377b3.11.1754556030007; Thu, 07 Aug 2025
 01:40:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <f654db67-a5a5-114b-09b8-00db303daab7@redhat.com> <CALTww28TpRRTzjqsOXGoUrLHEk=ca85zRcDanGqgTyytA-34ow@mail.gmail.com>
In-Reply-To: <CALTww28TpRRTzjqsOXGoUrLHEk=ca85zRcDanGqgTyytA-34ow@mail.gmail.com>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Thu, 7 Aug 2025 09:40:19 +0100
X-Gm-Features: Ac12FXwNRKxJxfh4GBD6NpoYEm_ijYIXVR3N5QBg40lsJYyHIZxTlNjnDEW9beQ
Message-ID: <CAMw=ZnTosW4OecBCFdVNqiw9VjSL6msUx6yYBE=9vsEn7JeKqA@mail.gmail.com>
Subject: Re: md regression caused by commit 9e59d609763f70a992a8f3808dabcce60f14eb5c
To: Xiao Ni <xni@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Yu Kuai <yukuai3@huawei.com>, Song Liu <song@kernel.org>, 
	linux-raid@vger.kernel.org, vkuznets@redhat.com, yuwatana@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Aug 2025 at 01:04, Xiao Ni <xni@redhat.com> wrote:
>
> Hi all
>
> It needs to use the latest upstream mdadm
> https://github.com/md-raid-utilities/mdadm/ which has fixed this
> problem. And for fedora, it hasn't updated to the latest upstream. So
> it has this problem. I'll update fedora mdadm to latest upstream.
>
> Best Regards
> Xiao

Thank you for looking into it and providing a solution - however,
isn't it against the rules to break existing released userspace
components and requiring new versions to be released in order to use a
new kernel version? Is there any way this kernel patch could be
amended to avoid breaking the existing userspace as it is?

Thanks

> On Wed, Aug 6, 2025 at 11:28=E2=80=AFPM Mikulas Patocka <mpatocka@redhat.=
com> wrote:
> >
> > Hi
> >
> > I report that the commit 9e59d609763f70a992a8f3808dabcce60f14eb5c cause=
s
> > problem with this mdadm script:
> >
> > modprobe brd rd_size=3D1048576
> > mdadm --create /dev/md/mdmirror --name mdmirror --uuid aaaaaaaa:bbbbbbb=
b:cccccccc:00000001 /dev/ram0 /dev/ram1 -v -f --level=3D1 --raid-devices=3D=
2
> > mdadm -v --stop /dev/md/mdmirror
> > mdadm --assemble /dev/md/mdmirror --name mdmirror -v
> >
> > Prior to this commit, the last command successfully assembles the array=
.
> > After this commit, it reports an error "mdadm: Unable to initialize
> > sysfs".
> >
> > See https://bugzilla.redhat.com/show_bug.cgi?id=3D2385871
> >
> > This is the strace of the failed mdadm --assemble command:
> >
> > mknodat(AT_FDCWD, "/dev/.tmp.md.2512:9:127", S_IFBLK|0600, makedev(0x9,=
 0x7f)) =3D 0
> > openat(AT_FDCWD, "/dev/.tmp.md.2512:9:127", O_RDWR|O_EXCL|O_DIRECT) =3D=
 4
> > unlink("/dev/.tmp.md.2512:9:127")       =3D 0
> > fstat(4, {st_mode=3DS_IFBLK|0600, st_rdev=3Dmakedev(0x9, 0x7f), ...}) =
=3D 0
> > readlink("/sys/dev/block/9:127", "../../devices/virtual/block/md12"...,=
 199) =3D 33
> > openat(AT_FDCWD, "/proc/mdstat", O_RDONLY) =3D 5
> > fcntl(5, F_SETFD, FD_CLOEXEC)           =3D 0
> > fstat(5, {st_mode=3DS_IFREG|0444, st_size=3D0, ...}) =3D 0
> > read(5, "Personalities : [raid1] \nunused "..., 1024) =3D 48
> > read(5, "", 1024)                       =3D 0
> > close(5)                                =3D 0
> > ioctl(4, STOP_ARRAY, 0)                 =3D 0
> > openat(AT_FDCWD, "/dev/ram1", O_RDWR|O_EXCL|O_DIRECT) =3D 5
> > ioctl(5, BLKSSZGET, [512])              =3D 0
> > fstat(5, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(0x1, 0x1), ...}) =
=3D 0
> > ioctl(5, BLKGETSIZE64, [1073741824])    =3D 0
> > lseek(5, 4096, SEEK_SET)                =3D 4096
> > read(5, "\374N+\251\1\0\0\0\0\0\0\0\0\0\0\0\252\252\252\252\273\273\273=
\273\314\314\314\314\0\0\0\1"..., 4096) =3D 4096
> > lseek(5, 0, SEEK_CUR)                   =3D 8192
> > fstat(5, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(0x1, 0x1), ...}) =
=3D 0
> > close(5)                                =3D 0
> > write(2, "mdadm: /dev/ram1 is identified a"..., 72) =3D 72
> > openat(AT_FDCWD, "/dev/ram0", O_RDWR|O_EXCL|O_DIRECT) =3D 5
> > ioctl(5, BLKSSZGET, [512])              =3D 0
> > fstat(5, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(0x1, 0), ...}) =3D =
0
> > ioctl(5, BLKGETSIZE64, [1073741824])    =3D 0
> > lseek(5, 4096, SEEK_SET)                =3D 4096
> > read(5, "\374N+\251\1\0\0\0\0\0\0\0\0\0\0\0\252\252\252\252\273\273\273=
\273\314\314\314\314\0\0\0\1"..., 4096) =3D 4096
> > lseek(5, 0, SEEK_CUR)                   =3D 8192
> > fstat(5, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(0x1, 0), ...}) =3D =
0
> > close(5)                                =3D 0
> > write(2, "mdadm: /dev/ram0 is identified a"..., 72) =3D 72
> > openat(AT_FDCWD, "/dev/ram0", O_RDONLY|O_EXCL|O_DIRECT) =3D 5
> > ioctl(5, BLKSSZGET, [512])              =3D 0
> > fstat(5, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(0x1, 0), ...}) =3D =
0
> > ioctl(5, BLKGETSIZE64, [1073741824])    =3D 0
> > lseek(5, 4096, SEEK_SET)                =3D 4096
> > read(5, "\374N+\251\1\0\0\0\0\0\0\0\0\0\0\0\252\252\252\252\273\273\273=
\273\314\314\314\314\0\0\0\1"..., 4096) =3D 4096
> > lseek(5, 0, SEEK_CUR)                   =3D 8192
> > close(5)                                =3D 0
> > fstat(4, {st_mode=3DS_IFBLK|0600, st_rdev=3Dmakedev(0x9, 0x7f), ...}) =
=3D 0
> > readlink("/sys/dev/block/9:127", 0x7ffcd3ed18b0, 199) =3D -1 ENOENT (Ad=
res=C3=A1=C5=99 nebo soubor neexistuje) !!! FAILURE !!!
> > newfstatat(AT_FDCWD, "/sys/block/md127/md", 0x7ffcd3ed1a30, 0) =3D -1 E=
NOENT (Adres=C3=A1=C5=99 nebo soubor neexistuje)
> > write(2, "mdadm: Unable to initialize sysf"..., 34) =3D 34
> > unlink("/run/mdadm/map.lock")           =3D 0
> > close(3)                                =3D 0
> > close(4)                                =3D 0
> > exit_group(1)                           =3D ?
> >
> > See the line that is marked "!!! FAILURE !!!". Prior to the commit
> > 9e59d609763f70a992a8f3808dabcce60f14eb5c, mdadm is able to read the
> > /sys/dev/block/9:127 symlink.
> >
> > Mikulas
>
