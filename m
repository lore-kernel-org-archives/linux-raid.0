Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F032BB05
	for <linux-raid@vger.kernel.org>; Sat, 25 May 2024 19:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716665281; cv=none; b=haF9QQTyaAwHNVRNkcBsRtQdEOWivBlIEnOC2RBrek2rhTQbn/d3xoV2Z81aElpBSURHDpuVtE82UNf6SALh9/SjSWRvi1Wdcqlufbp91Hi5KyKsVti7g/NyGCJM/aEXvh0DNRMSzQxuAhJGCYygNNeHMqNPGvnciK3kipUe+5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716665281; c=relaxed/simple;
	bh=8D6vnEcZD0Yz+0qbegjOepYr/J9OjwUzGxNdUxKMOaI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F3g4ScQV5c6XMAqNBspMoKU22OhElkLexxnFmNVbjXccQ16HXtREfvLq0kjpsj8hLEGInq2298ZX4YIUGofkweX9Dyi6pMhAnik7GBtBf1tSE1qtZlc7qNbm0s8cJKMu4U3u9+gY3AJc/f4FNL/fA31yebhFz4oFJp28rTx2ABQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eeq7jP3h; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eeq7jP3h"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7eabd8f4b58so19265239f.3
        for <linux-raid@vger.kernel.org>; Sat, 25 May 2024 12:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716665279; x=1717270079; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c0MkvPWO6O5O4GL1MOaKa5nAfXbfCksRFjsqltxT76Y=;
        b=Eeq7jP3hzib0C2sU8bpywC74X37OESN3n3Hi/DWTm/t0IeAM553XdD3m+LAPJG67nX
         mlrKarLm3/Qa2Ky7hCrO/YclEhWQlOJvIDOFQtOFx4Syn/h4+AV5AxE4zxoLJaw3E/L1
         7MMftW6N3qc8hTgPID8S8pun304ozpBqLDkfGU+eDtmICG9ABLVBWErU5qqOfCbnDH3y
         g0aRTySaLzs9Q0P9jv71CYaf/TM+vlqMSEX6mU7fyJY/D64cki+NcGXSgC7CIDXbV+6m
         DNuxRW+SAPxToZRaZMlvhPlv4wx2dSZmjqtyfbzUFFo856rMgb4LYv/8mVHepRSLW26f
         /YVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716665279; x=1717270079;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c0MkvPWO6O5O4GL1MOaKa5nAfXbfCksRFjsqltxT76Y=;
        b=stOesnih3pIb8LEsxcwUJbKG1CvgYy0oJQJxp9Plq7MZuiS+Qb/oKQoI4335Q+vhMF
         J7NKmw8tlAwODGGxmSK6fg7TrIr1GBd1dNj0MWIMwCZzWu0MdZybfDQOBvDjzkJcelNv
         9tREATPfySINMkN9fns35JYAalesRVLS+tnE/a87uRUibLOZCL1pCDlW8m18rxQmWMAw
         NeukHh68Qjb9IVu+SNOG1g15QGox/j+jkUIVba5sphd6GVT+6VHh/9+ZwkWkEfY5akvi
         2pAC8ZRxMYpVGdunVfVkY4FnMI9vmomRECDzYnSoqRw55zGfCV2xk39y9ADH/sAVsGlw
         WXSg==
X-Gm-Message-State: AOJu0Yz/ZSb0egXL8PDqNyUZTzZVj8Ud5XEDpo1sLqUhq6GaZbuZq+0u
	umlaxeImvBzeYbQECIzP5Wo0/1vAZB1zcbwFrRbIFe5ZZt2HoP8Sfz8wZgpMJxkigd59t5CIj9Z
	kjvS5PCZWhuXhSrMkAwlkHqYi8oaGOg==
X-Google-Smtp-Source: AGHT+IGP4ggm75ufer+MnhbgvpGscyEUH7UkwAGrmj8GujF1WIt3uLgC59mJ524xRrqnxMP5ncZfR9XW4ZtXuAvxfcg=
X-Received: by 2002:a05:6602:18f:b0:7de:a982:c4a5 with SMTP id
 ca18e2360f4ac-7e8c4c0aea2mr600344939f.6.1716665278744; Sat, 25 May 2024
 12:27:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1910147.LkxdtWsSYb@selene> <87y180qyyk.fsf@vps.thesusis.net>
 <4705980.vXUDI8C0e8@selene> <26411775.1r3eYUQgxm@selene>
In-Reply-To: <26411775.1r3eYUQgxm@selene>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Sat, 25 May 2024 14:27:47 -0500
Message-ID: <CAAMCDeewS11GguARHTvUB9455vJHARRRP=+0wrZLXWjWb-i=6g@mail.gmail.com>
Subject: Re: RAID-1 not accessible after disk replacement
To: Richard <richard@radoeka.nl>
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Going bigger works once you resize the fs (that requires a separate
command specific to your fs).

Going smaller typically requires the FS to be umounted, maybe fscked,
and resized smaller (assuming the FS even supports that, xfs does not)
before the array is made smaller.  Resizing the array or LV smaller
before and/or without the fs being resized only ends when the resize
smaller is undone (like you did).  When going smaller I also tend to
make the fs a decent amount smaller than I need to, then make the
array smaller and then resize the fs up using no options (so it uses
the current larger device  size).



On Fri, May 24, 2024 at 10:56=E2=80=AFAM Richard <richard@radoeka.nl> wrote=
:
>
> Op vrijdag 24 mei 2024 17:23:49 CEST schreef Richard:
> > Philip, Kuai,
> >
> > Op donderdag 23 mei 2024 18:23:31 CEST schreef Phillip Susi:
> > > Richard <richard@radoeka.nl> writes:
> > > > I grew (--grow) the RAID to an smaller size as it was complaining a=
bout
> > > > the
> > > > size (no logging of that).
> > > > After the this action the RAID was functioning and fully accessible=
.
> > >
> > > I think you mean you used -z to reduce the size of the array.  It
> > > appears that you are trying to replace the failed drive with one that=
 is
> > > half the size, then shrunk the array, which truncated your filesystem=
,
> > > which is why you can no longer access it.  You can't shrink the disk =
out
> > > from under the filesystem.
> > >
> > > Grow the array back to the full size of the larger disk and most like=
ly
> > > you should be able to mount the filesystem again.  You will need to g=
et
> > > a replacement disk that is the same size as the original that failed =
if
> > > you want to replace it, or if you can shrink the filesystem to fit on
> > > the new disk, you have to do that FIRST, then shrink the raid array.
> >
> > I followed your advice, and made the array size the same as it used to =
be.
> > I'm now able to see the data on the partition (RAID) again.
> > Very nice.
> >
> > Thanks a lot for your support.
>
> I'm getting a bigger drive.  That means that I'm going to get the followi=
ng
> setup:
>
> /dev/sda6 403GB  (the one that is now the active partition)
>
> I'll make /dev/sdb6 the same size, also 403 GB.
>
> The array size is now set at 236 GB (with sda6 having a size of 403GB).
>
> Once both 403GB partitions are part of the array, would it then be possib=
le to
> grow the array from 236GB to 400GB?  Or will that result in problems as w=
ell?
>
> --
> Richard
>
>
>
>
