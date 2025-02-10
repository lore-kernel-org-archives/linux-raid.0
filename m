Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BDF18C011
	for <linux-raid@vger.kernel.org>; Mon, 10 Feb 2025 06:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739167307; cv=none; b=FHKP2fCRVFbZwN5/pUgHRfY5HodEvyiNolizXBq6Ayw4zEzmtVZz0Flc40owWCLcFnihAkz/ajcVotz2q2BbmHZQGN14hWy62X25q3I6TnHRO/Zd7aqH9YcT5ZI4YQhmsNA5GpJyMMmkvCK8rf9a3laImLk/hWxRO+DKznnmblk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739167307; c=relaxed/simple;
	bh=Ua7IfkpGeIoAYer+WVQ0iHhOnYvv6BLF0BOQ00/LWJo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=VhpJgiiBj4CpjbUY7ovkNbjvyJ/NtOek3YuQwQxaRZKsgoCEYwD/HwwLoj5g5kFEgH9nc8zRAw58u5zGkQ9F7VPgHe47YGBXC/K1x9J3cg0Bm+SVc7v80dXjzqa9QTWqL+egYSWd04Pc7ljgXY/c9so7XEiAOyFph+hyeTeuAtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V1kicFyb; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V1kicFyb"
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e5b29779d74so3453295276.2
        for <linux-raid@vger.kernel.org>; Sun, 09 Feb 2025 22:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739167304; x=1739772104; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0y91SMEqXsL8JJmkxVaExovrOt3IIxlivZ32ITUhZ4U=;
        b=V1kicFybcvZWV9Qer2DXQeINtpCj0FgaC8Wv4RBy72l79z7b0HmBy+OEX4FF3/gAwr
         +8pRFsgCnLV1/W4z1RNqn3uzyef50MMSvKwx7eGidHJRGq1Y8JdBPyPb0h/mwDtB6H70
         oysZLsPb3KDFLXQ6N7quWdwmXJJrcxpXgtXdvxQPdvmU2H6pWpIACcoQoujWp4TpLeoA
         RzXuQ11owPbXgvKncKs5TTaGPeJgLZB1GLDhskT0BCKWe0vXgd6etGPHBh7OGJsg968y
         3kFk4QYeavpa8kzj8UbRguEJUX4C+7nQHxlw4s7XgJqdSiFZwRHBnBMRKzod4X0iLY3C
         LupQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739167305; x=1739772105;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0y91SMEqXsL8JJmkxVaExovrOt3IIxlivZ32ITUhZ4U=;
        b=mOKOS5K4u4GJ5IbtAC/+8Bd2ZnxD+ymD6fNLUuEsbsoNwyiKosb69Grw7PP2yYxmSK
         maDdTCz+TLzJCNtSEG+adpil1Xxr4q9jVHz1CQfEcuEJGazTvNgyLk3ukqJKnDm7OIo0
         Ll2a2OP0fUEt+ICEqlY4Z28uLiJZT4trp7/XlxUGaYwfhm2NKEDzCNCND86fCzb3j5xS
         85rtXlw1Kv4Jf+w4bIqttuY3fPOt8XIkncJ2csm03RVmRWjEbTAtPbeWZeGL/4klUHuH
         kzZqBpMgsxbbKjsWbUB0NzFXbVVVzXo2O3avUL0VN39i9Ya6k5d82wUSH9OVChOZ02cO
         Z0Gg==
X-Gm-Message-State: AOJu0YyaNF39crJOZVPVax/9JPQBg8ZXOM3vDmEBeD8wO6nsG8nozolA
	y/xL847aevIH+M56DKh4aevlLKGwWXJHQ9/NHCXJoIa2f5pjazYIyX65h/DP9E1LzIwAzOk8DYB
	4epPWGUCSHFprXavMnlBaTGHjgZBkAe1s
X-Gm-Gg: ASbGncvRHxhddL0SFnTVBYRfMeE27dUL6MZChucfvwNhF86QE7t/6ui8OSIPwIcPpHt
	pMobCleQ9pnEr229NAd9S9Umkpk+dsnrRDorXKnMPYfRvk/ULRIKhWzbDe/5dcZtYgw5W/yw8hw
	==
X-Google-Smtp-Source: AGHT+IGLl2RDFYcxT/wpePr8SqmK0Ch6dETLK0IM37ugc+gvIoml+xrkIxavPLU8PrIBPjcCPBEPQTkdO+vBKOo005Q=
X-Received: by 2002:a05:6902:1b02:b0:e57:8b0d:27e0 with SMTP id
 3f1490d57ef6-e5b4624eab9mr9719056276.31.1739167304400; Sun, 09 Feb 2025
 22:01:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAD4guxO5uyTZWuOxzMAj1WqAY1UHnfAqGgia1QZiqiaOQv=89Q@mail.gmail.com>
 <1826ee0e-ac29-4b45-bd3e-54ea81be684a@plouf.fr.eu.org> <CAD4guxMmgJ+wCiHFqsgW-OKSVqvmxtra+ng0FRqfjRPK4LGS0w@mail.gmail.com>
In-Reply-To: <CAD4guxMmgJ+wCiHFqsgW-OKSVqvmxtra+ng0FRqfjRPK4LGS0w@mail.gmail.com>
From: Raffaele Morelli <raffaele.morelli@gmail.com>
Date: Mon, 10 Feb 2025 07:01:18 +0100
X-Gm-Features: AWEUYZkjcjH_j65V6c9O1vS2mXyxzHQ-K-UmU3bdsljCgWDNup1R9v9FB46mPQI
Message-ID: <CAD4guxPh5Z2R-THVvPgWmeurG5ko_ejUN9qq9AKXnYNSfJP04g@mail.gmail.com>
Subject: Re: Problem with RAID1 - unable to read superblock
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

For the sake of knowledge.

As both drive were in "good condition" according to ddrescue at least
I simply have mount the new one in read only and got the data back to
life
mount -t ext4 -o ro /dev/sdb /mnt/data_disk/

/r

Il giorno gio 6 feb 2025 alle ore 06:41 Raffaele Morelli
<raffaele.morelli@gmail.com> ha scritto:
>
> Il giorno mer 5 feb 2025 alle ore 21:42 Pascal Hambourg
> <pascal@plouf.fr.eu.org> ha scritto:
> >
> > On 05/02/2025 at 13:03, Raffaele Morelli wrote:
> > >
> > > Last week we found it was in read only mode, I've stopped and tried to
> > > reassemble it with no success.
> > > dmesg recorded this error
> > >
> > > [7013959.352607] buffer_io_error: 7 callbacks suppressed
> > > [7013959.352612] Buffer I/O error on dev md126, logical block
> > > 927915504, async page read
> > > [7013959.352945] EXT4-fs (md126): unable to read superblock
> >
> > No error messages from the underlying drives ?
>
> I have logs to scan for details
>
> > > We've found one of the drive with various damaged sectors so we
> > > removed both and created two images first ( using ddrescue -d -M -r 10
> > > ).
> >
> > Is either image complete or do both have missing blocks ?
>
> There are no errors, pct rescued is 100%, everything seems fine.
>
> > > We've set up two loopback devices (using losetup --partscan --find
> > > --show) and would like to recover as much as possible.
> > >
> > > Should I try to reassemble the raid with something like
> > > mdadm --assemble --verbose /dev/md0 --level=1 --raid-devices=2
> > > /dev/loop18 /dev/loop19
> >
> > If the RAID members were partitions you must use the partitions
> > /dev/loopXpY, not the whole loop devices.
> >
> > If either ddrescue image is complete, you can assemble the array in
> > degraded mode from a single complete image.
> > If both images are incomplete and the array has a valid bad block list,
> > you can try to assemble the array from both images.
> >
> > In either case, assemble the array read-only.
>
> Actually we're here
>
> /dev/md0:
>            Version : 1.2
>      Creation Time : Wed Feb  5 11:12:32 2025
>         Raid Level : raid1
>         Array Size : 3906885440 (3.64 TiB 4.00 TB)
>      Used Dev Size : 3906885440 (3.64 TiB 4.00 TB)
>       Raid Devices : 2
>      Total Devices : 2
>        Persistence : Superblock is persistent
>
>      Intent Bitmap : Internal
>
>        Update Time : Wed Feb  5 22:27:49 2025
>              State : clean
>     Active Devices : 2
>    Working Devices : 2
>     Failed Devices : 0
>      Spare Devices : 0
>
> Consistency Policy : bitmap
>
>               Name : aria-pcpl:0  (local to host aria-pcpl)
>               UUID : 3b27a574:b12fa078:28872721:15bf710c
>             Events : 7984
>
>     Number   Major   Minor   RaidDevice State
>        0       7       22        0      active sync   /dev/loop22
>        1       7       23        1      active sync   /dev/loop23
