Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E434438B
	for <linux-raid@vger.kernel.org>; Thu,  7 Aug 2025 00:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754525074; cv=none; b=OvIumhBvAD+OFSp2D8pT/vPvkz0XrWb+1tnsf5ZCHmYQZvY12mS6qbMuBIxqIDvcyxpvcGAQv3aJgGl809D8dg/nIOrXNSHDduJSqasjR2EuspE8Wz1gYXOaxJboP36Yoqc2HRNw6qSluvLzgg9iiczKbap133UMZzm8UaBVDDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754525074; c=relaxed/simple;
	bh=YXvsjrEh+DuLyLBepn5+kXREbryxPGxIOwQ+9H5TKmY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ILH5jZEii24IzcKsZxMxM35hf/19Zc1ZOIQ4z1S4TzOuQupq0JdrP1jqHxEwbZKiJdZZkSuv//AW2aQdTtS1B25eDmXpbA4pNAhifJCBMONrzHEMXM6f4SFC545BeG2UeOrY6Ifs4PI0jMdnJCtCwMbEY808wqxuPmwWW5zla8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IFEav3yh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IFEav3yh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754525072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ex95qYJBUGAkNba+tniBDJjq3y/G41YHziswxh41ZmY=;
	b=IFEav3yhOixnVQdvH2XsxEXsdK7ZRZ1MsaEZLufhCyzaERTzNhH6OWMhEO2Le+Rmv7QjwW
	+txzkI+BdrHqh/z3KQ0KwLVmtN9P85jth5mx6GdW+m2VfnOuq5segkp1AwTetxL5przvmA
	E3dKAe8MKUPVa/4Aw00QtgSHDDQR4FY=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-Xjd1HlSNN4-2pClhROuJ0g-1; Wed, 06 Aug 2025 20:04:30 -0400
X-MC-Unique: Xjd1HlSNN4-2pClhROuJ0g-1
X-Mimecast-MFC-AGG-ID: Xjd1HlSNN4-2pClhROuJ0g_1754525069
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-3322dedb9d8so1635871fa.0
        for <linux-raid@vger.kernel.org>; Wed, 06 Aug 2025 17:04:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754525069; x=1755129869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ex95qYJBUGAkNba+tniBDJjq3y/G41YHziswxh41ZmY=;
        b=Nf0rFopkv4To1Nq9dfrVIKkiKgxJ4pNuTvO89SReTyG8wFaWTZUXNdfgETQboE9HBD
         AIaVI7Wmyk8gUDr6yL1MxQ+P14ZpL7dk6Xgcv8MBTmxVdUcyO95sWO2vNKyr877rPfSt
         d2OH8YGCIp04qpesosSipR9xZaBYa2X9v9AQ8+gnDOXwpLxXqHl4DiSFQvTPCUp0ltBL
         rlA82UPs4t0AeykNsLyDADzShkKmtzEiMLUit9vofs7MO5txbHHl/TDZXuDZywDcbesy
         tyl2RkcwVjYpuVgUX+ex9qEGijEYnecJD3HJgtNKccWtRF88Dg+VFHmWJIx76YU9xqsM
         s/uQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUxfFfqDBrpBeJTZpVoErWQ8q6AyV8qHTYgBOpTZa2EsHUR2SdaNl28wwvzFnE6ljq/e31uBrEKSss@vger.kernel.org
X-Gm-Message-State: AOJu0YzXP2NZ66mH/Kq9bNSeqwImWN/UHXWiuuJPuHzK72vGpXQtMprf
	r5iyYZQVnbVNGys1fYb1mrekF+BVXWrVRNUHB2aNiLNrpVCdT/+stLmAA3AzJHM16BlDcP0whCr
	5EZJfgW6DTyrbTk41GUvg6tYT0Ui17lTck8DA+3rrUrnSYpEqI/yobOsJyEbFnbLnGUEK6jpkRl
	MfAIUeHCLeoPcoM+T13LNUuhgTZNmKX9p1Lnldlw==
X-Gm-Gg: ASbGncsbr7I8N76HvmKoDNu0s1WRwO5WzUZCzZwJxS2ykuPPi/OeghgUvqEAiKjulDS
	b2ohscS6H6ivpg6wstMU6g0E6++POml1wPwnpOTKNIzbSfFEFhszqzD+ChzDrwMlIgMBmIAI0zL
	SbfDT0WgQhmi2DhAVLZnIgNg==
X-Received: by 2002:a2e:b8ce:0:b0:332:1398:5737 with SMTP id 38308e7fff4ca-3338137cd80mr11226051fa.24.1754525068825;
        Wed, 06 Aug 2025 17:04:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7g5iEXu3TBiJn/CjX5wHMk+94n3ngw5hhyThkvAqz9D4B8BmmDU1UEHtLckky2GUuB4MS6Gw+vp7r26hZb4U=
X-Received: by 2002:a2e:b8ce:0:b0:332:1398:5737 with SMTP id
 38308e7fff4ca-3338137cd80mr11225991fa.24.1754525068334; Wed, 06 Aug 2025
 17:04:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <f654db67-a5a5-114b-09b8-00db303daab7@redhat.com>
In-Reply-To: <f654db67-a5a5-114b-09b8-00db303daab7@redhat.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 7 Aug 2025 08:04:15 +0800
X-Gm-Features: Ac12FXyDNtq4rkBN--88BswyYNBoLFmlktIV67mFFZ4ENwaxTogVCAPKnODZlqU
Message-ID: <CALTww28TpRRTzjqsOXGoUrLHEk=ca85zRcDanGqgTyytA-34ow@mail.gmail.com>
Subject: Re: md regression caused by commit 9e59d609763f70a992a8f3808dabcce60f14eb5c
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Yu Kuai <yukuai3@huawei.com>, Song Liu <song@kernel.org>, linux-raid@vger.kernel.org, 
	vkuznets@redhat.com, yuwatana@redhat.com, luca.boccassi@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all

It needs to use the latest upstream mdadm
https://github.com/md-raid-utilities/mdadm/ which has fixed this
problem. And for fedora, it hasn't updated to the latest upstream. So
it has this problem. I'll update fedora mdadm to latest upstream.

Best Regards
Xiao

On Wed, Aug 6, 2025 at 11:28=E2=80=AFPM Mikulas Patocka <mpatocka@redhat.co=
m> wrote:
>
> Hi
>
> I report that the commit 9e59d609763f70a992a8f3808dabcce60f14eb5c causes
> problem with this mdadm script:
>
> modprobe brd rd_size=3D1048576
> mdadm --create /dev/md/mdmirror --name mdmirror --uuid aaaaaaaa:bbbbbbbb:=
cccccccc:00000001 /dev/ram0 /dev/ram1 -v -f --level=3D1 --raid-devices=3D2
> mdadm -v --stop /dev/md/mdmirror
> mdadm --assemble /dev/md/mdmirror --name mdmirror -v
>
> Prior to this commit, the last command successfully assembles the array.
> After this commit, it reports an error "mdadm: Unable to initialize
> sysfs".
>
> See https://bugzilla.redhat.com/show_bug.cgi?id=3D2385871
>
> This is the strace of the failed mdadm --assemble command:
>
> mknodat(AT_FDCWD, "/dev/.tmp.md.2512:9:127", S_IFBLK|0600, makedev(0x9, 0=
x7f)) =3D 0
> openat(AT_FDCWD, "/dev/.tmp.md.2512:9:127", O_RDWR|O_EXCL|O_DIRECT) =3D 4
> unlink("/dev/.tmp.md.2512:9:127")       =3D 0
> fstat(4, {st_mode=3DS_IFBLK|0600, st_rdev=3Dmakedev(0x9, 0x7f), ...}) =3D=
 0
> readlink("/sys/dev/block/9:127", "../../devices/virtual/block/md12"..., 1=
99) =3D 33
> openat(AT_FDCWD, "/proc/mdstat", O_RDONLY) =3D 5
> fcntl(5, F_SETFD, FD_CLOEXEC)           =3D 0
> fstat(5, {st_mode=3DS_IFREG|0444, st_size=3D0, ...}) =3D 0
> read(5, "Personalities : [raid1] \nunused "..., 1024) =3D 48
> read(5, "", 1024)                       =3D 0
> close(5)                                =3D 0
> ioctl(4, STOP_ARRAY, 0)                 =3D 0
> openat(AT_FDCWD, "/dev/ram1", O_RDWR|O_EXCL|O_DIRECT) =3D 5
> ioctl(5, BLKSSZGET, [512])              =3D 0
> fstat(5, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(0x1, 0x1), ...}) =3D =
0
> ioctl(5, BLKGETSIZE64, [1073741824])    =3D 0
> lseek(5, 4096, SEEK_SET)                =3D 4096
> read(5, "\374N+\251\1\0\0\0\0\0\0\0\0\0\0\0\252\252\252\252\273\273\273\2=
73\314\314\314\314\0\0\0\1"..., 4096) =3D 4096
> lseek(5, 0, SEEK_CUR)                   =3D 8192
> fstat(5, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(0x1, 0x1), ...}) =3D =
0
> close(5)                                =3D 0
> write(2, "mdadm: /dev/ram1 is identified a"..., 72) =3D 72
> openat(AT_FDCWD, "/dev/ram0", O_RDWR|O_EXCL|O_DIRECT) =3D 5
> ioctl(5, BLKSSZGET, [512])              =3D 0
> fstat(5, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(0x1, 0), ...}) =3D 0
> ioctl(5, BLKGETSIZE64, [1073741824])    =3D 0
> lseek(5, 4096, SEEK_SET)                =3D 4096
> read(5, "\374N+\251\1\0\0\0\0\0\0\0\0\0\0\0\252\252\252\252\273\273\273\2=
73\314\314\314\314\0\0\0\1"..., 4096) =3D 4096
> lseek(5, 0, SEEK_CUR)                   =3D 8192
> fstat(5, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(0x1, 0), ...}) =3D 0
> close(5)                                =3D 0
> write(2, "mdadm: /dev/ram0 is identified a"..., 72) =3D 72
> openat(AT_FDCWD, "/dev/ram0", O_RDONLY|O_EXCL|O_DIRECT) =3D 5
> ioctl(5, BLKSSZGET, [512])              =3D 0
> fstat(5, {st_mode=3DS_IFBLK|0660, st_rdev=3Dmakedev(0x1, 0), ...}) =3D 0
> ioctl(5, BLKGETSIZE64, [1073741824])    =3D 0
> lseek(5, 4096, SEEK_SET)                =3D 4096
> read(5, "\374N+\251\1\0\0\0\0\0\0\0\0\0\0\0\252\252\252\252\273\273\273\2=
73\314\314\314\314\0\0\0\1"..., 4096) =3D 4096
> lseek(5, 0, SEEK_CUR)                   =3D 8192
> close(5)                                =3D 0
> fstat(4, {st_mode=3DS_IFBLK|0600, st_rdev=3Dmakedev(0x9, 0x7f), ...}) =3D=
 0
> readlink("/sys/dev/block/9:127", 0x7ffcd3ed18b0, 199) =3D -1 ENOENT (Adre=
s=C3=A1=C5=99 nebo soubor neexistuje) !!! FAILURE !!!
> newfstatat(AT_FDCWD, "/sys/block/md127/md", 0x7ffcd3ed1a30, 0) =3D -1 ENO=
ENT (Adres=C3=A1=C5=99 nebo soubor neexistuje)
> write(2, "mdadm: Unable to initialize sysf"..., 34) =3D 34
> unlink("/run/mdadm/map.lock")           =3D 0
> close(3)                                =3D 0
> close(4)                                =3D 0
> exit_group(1)                           =3D ?
>
> See the line that is marked "!!! FAILURE !!!". Prior to the commit
> 9e59d609763f70a992a8f3808dabcce60f14eb5c, mdadm is able to read the
> /sys/dev/block/9:127 symlink.
>
> Mikulas

