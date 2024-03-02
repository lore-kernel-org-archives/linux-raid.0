Received: from meesny.iki.fi (meesny.iki.fi [195.140.195.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B6D1C16
	for <linux-raid@vger.kernel.org>; Sat,  2 Mar 2024 12:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=195.140.195.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709383673; cv=pass; b=B7sp+sw6j3HYViDT8TyM2KGqcizN6iGYIsc9Xbfo4McmoGMxicNxZpc9cNigoKHysDeglkixBkKkyl23T6rceVU3D0yHn2OOR6i2dBSronJs/TbfNsNwvTKgpntMkHIKS3kQiGAYM1ichk3SmxhbwRV+xZE3lDkHl8V+bfvhWnI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709383673; c=relaxed/simple;
	bh=VY9XaptTFejf/WgAOyOuT/oZDwSxFnEyOyj9x9hKeY0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=am26wRef13E1ZHg23RXjGslssKnIOFwIWvLyY8+QN+coUgjOHlitwQkbOE/xA8DVoYg3jln7JM9+lwD+d0uvXncdmC0CwEa1RnaPwSMeisjCMq2Hhulgr3p2kGKAocffPigsECdlAhoszhinaXQ0IusuAu0M1+xz2K1fE78m5So=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b=ALK5u2PE; arc=pass smtp.client-ip=195.140.195.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b="ALK5u2PE"
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: tovi)
	by meesny.iki.fi (Postfix) with ESMTPSA id 4Tn4Vq5rr5zyxR
	for <linux-raid@vger.kernel.org>; Sat,  2 Mar 2024 14:47:46 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
	t=1709383667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HeeTBDsDGES9iuwKIlXey7c2L78toNt/o+7zpvRtvPQ=;
	b=ALK5u2PErqBSTJRYB1GVlTCHyOdbbPpjrsCHQGLJP9WK/130ykLJtpoeD8xVyTqmQNmQJq
	Jw6M+siC02AduIEvG1/VSU6g5HtppKPFMXLcjyPZMRciJ4r9M71irj6blN88vioVhp3b5Q
	ibY+wCfaZ/otGaO5Cdj7CSD4G+21CpA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=meesny; t=1709383667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HeeTBDsDGES9iuwKIlXey7c2L78toNt/o+7zpvRtvPQ=;
	b=Gx+FftnZ5dUq2U8irY2BjV3IshpiqCHYwnNZbkl9yoO9T5xIY9/xC+nQl+9gpddhVTupdb
	+BWJWkQ+DVkdrWhIHFfKeQlU49KfBjDfQ62kTX2E375YOHtW9/FZHj2v1k6O5jAdQT6l3k
	OUVix6jXLqsNTXus9rpQm9kwnfm4c9o=
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=tovi smtp.mailfrom=tovi@iki.fi
ARC-Seal: i=1; s=meesny; d=iki.fi; t=1709383667; a=rsa-sha256; cv=none;
	b=CCHwxpaZzjcgzm7kSGRWH98EWogKCpdqqoODubWe2nqYrbIS6obbSU7TKMm7NjgCKBOs01
	g0flbAuZi1WkQeVy6Aad75C5dHjjGsoSDqeiHafO2YO7pmHp70Da+vRlHVbY2igNRH8Q3X
	3ZARgHc0kMBBZPlYbXS+HnLqEGQSGQw=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6e4560664b5so2502848b3a.1
        for <linux-raid@vger.kernel.org>; Sat, 02 Mar 2024 04:47:46 -0800 (PST)
X-Gm-Message-State: AOJu0Yzl19L5V1t8eLFoIWZxdt4tpVbZhI+k0kvk+gP12PL1KS6XGgNU
	URBiFFlxUjwfTahmJ8q1VCH9kzFzwNnIqVB8Z24yOn+fVMMsx/C3WdMutkFRX2PU8tWQeI+kZ3m
	72W7qQfhjpmCqjJXe5Ru9StKIT6U=
X-Google-Smtp-Source: AGHT+IHDxnvfeaeyweHM/6NmEX3aZMaHDVl/H4kgbKrjmZ2C7Nnj8PJB/xE0v0ErfsfflyEykxGIE4Y9N2dm/CGvwIs=
X-Received: by 2002:a05:6a21:3989:b0:1a1:4491:7ff6 with SMTP id
 ad9-20020a056a21398900b001a144917ff6mr3421362pzc.41.1709383664658; Sat, 02
 Mar 2024 04:47:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADC_b1dj8AodZxYF0tLPnfv0S3xHGnCBVOmvWgyCZt4LqHze=w@mail.gmail.com>
 <CAAMCDecAJ4QP29v_Qgv4xi8vNL-RWEB+v_HMkAtY2Z3rk9zKZw@mail.gmail.com>
 <59dc6165-38f7-407b-b57b-730ac9d4c267@plouf.fr.eu.org> <CADC_b1fJGMSsYjzh8nTnSi2ZgoGmzY_wube2MzgAtr5QwtRzGw@mail.gmail.com>
 <bc3475bd-cdf7-4698-b21a-236e4d055537@plouf.fr.eu.org> <CADC_b1fhFm61QcQd_xud+fS=_068cnf=Hv99SGAeSms-Z-9igg@mail.gmail.com>
 <7453a03a-33e2-414c-aa06-b71d71d2ad5c@eyal.emu.id.au>
In-Reply-To: <7453a03a-33e2-414c-aa06-b71d71d2ad5c@eyal.emu.id.au>
From: Topi Viljanen <tovi@iki.fi>
Date: Sat, 2 Mar 2024 14:47:33 +0200
X-Gmail-Original-Message-ID: <CADC_b1fMW_vc=HzRswceYiQ0JL_gsHhcgkbXhzmnHOyE4u+tEw@mail.gmail.com>
Message-ID: <CADC_b1fMW_vc=HzRswceYiQ0JL_gsHhcgkbXhzmnHOyE4u+tEw@mail.gmail.com>
Subject: Re: Requesting help with raid6 that stays inactive
To: eyal@eyal.emu.id.au
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Yes I check the drive letter to serialnumber after every boot and then
match the order to the original.

testdisk is showing so much wrong data too that I don't believe this
is useful to run.

Is there a way to identify the raid partitions from the separate
devices and then restore those partition information?
I don't really know what to do next now.

Topi

On Sat, 2 Mar 2024 at 14:03, <eyal@eyal.emu.id.au> wrote:
>
> On 2/3/24 20:55, Topi Viljanen wrote:
> > Hi,
> >
> > syslog entries before any problems:
> >
> > Feb 18 19:52:53 NAS-server kernel: [    5.755150] md/raid:md0: device
> > sde operational as raid disk 5
> > Feb 18 19:52:53 NAS-server kernel: [    5.755158] md/raid:md0: device
> > sdb operational as raid disk 0
> > Feb 18 19:52:53 NAS-server kernel: [    5.755160] md/raid:md0: device
> > sdf operational as raid disk 3
> > Feb 18 19:52:53 NAS-server kernel: [    5.755162] md/raid:md0: device
> > sdg operational as raid disk 1
> > Feb 18 19:52:53 NAS-server kernel: [    5.755164] md/raid:md0: device
> > sdd operational as raid disk 2
> > Feb 18 19:52:53 NAS-server kernel: [    5.755166] md/raid:md0: device
> > sdc operational as raid disk 4
> > Feb 18 19:52:53 NAS-server kernel: [    5.757272] md/raid:md0: raid
> > level 6 active with 6 out of 6 devices, algorithm 2
> > [...]
> > Feb 18 19:52:54 NAS-server smartd[1188]: Device: /dev/sdc [SAT],
> > ST4000DM004-2CV104, S/N:WFN14WVT, WWN:5-000c50-0bee83a77, FW:0001,
> > 4.00 TB
> > Feb 18 19:52:54 NAS-server smartd[1188]: Device: /dev/sdd [SAT],
> > ST4000DM000-1F2168, S/N:Z305RJAR, WWN:5-000c50-087ccf402, FW:CC54,
> > 4.00 TB
> > Feb 18 19:52:54 NAS-server smartd[1188]: Device: /dev/sdb [SAT],
> > ST4000DM000-1F2168, S/N:Z305RFDP, WWN:5-000c50-087cd03a5, FW:CC54,
> > 4.00 TB
> > Feb 18 19:52:55 NAS-server smartd[1188]: Device: /dev/sde [SAT], WDC
> > WD40EZRX-00SPEB0, S/N:WD-WCC4E7TULA48, WWN:5-0014ee-2b5d93dd9,
> > FW:80.00A80, 4.00 TB
> > Feb 18 19:52:55 NAS-server smartd[1188]: Device: /dev/sdf [SAT],
> > ST4000DM000-1F2168, S/N:Z305RVDW, WWN:5-000c50-087cc5e98, FW:CC54,
> > 4.00 TB
> > Feb 18 19:52:55 NAS-server smartd[1188]: Device: /dev/sdg [SAT],
> > ST4000DM000-1F2168, S/N:Z305RTB8, WWN:5-000c50-087cc9d0b, FW:CC54,
> > 4.00 TB
> >
> > Isn't that quite clear how the order should be? I have added those
> > disks to the create array in that order 0,1,2,3,4,5
> > Should I try something else?
>
> What is meant by '0,1,2,3,4,5'? You mean some order of /dev/sd{x,y,z,...}.
> Now the disk names may be different from your old setup. This is normal.
> You need to use the Serial Numbers to have the correct order.
> So in this case I see
>         0 sdb Z305RFDP now sdx
>         1 sdg Z305RTB8 now sdy
>         etc.
>
> Or maybe you already did this, so ignore this note.
>
> > I was wondering if the problem is unused space? The only disk having
> > it partition table have this:
> > Unused Space : before=254896 sectors, after=7856 sectors
> >
> > So if creating a new array starts from the wrong place? Can that be
> > somehow inspected?
> >
> > Topi
> >
> > On Sat, 2 Mar 2024 at 11:46, Pascal Hambourg <pascal@plouf.fr.eu.org> wrote:
> >>
> >> On 02/03/2024 at 09:50, Topi Viljanen wrote:
> >>>
> >>> I was able to get the order of the devices from old syslog file
> >>> (smartd) and then created the array again:
> >> (...)
> >>> Running fsck caused so many errors that the mounted ext4 was empty.
> >>> I reset the overlay array and now I'm running analyze with testdisk.
> >>
> >> Then I am afraid that the order was wrong and testdisk will not be able
> >> to retrieve much.
> >>
>
> --
> Eyal at Home (eyal@eyal.emu.id.au)
>
>
