Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1F07E760
	for <linux-raid@vger.kernel.org>; Wed, 24 Jan 2024 21:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706131239; cv=none; b=SQOzp5nZO2H66s+L4ze4oeTiTKGE74YZQ9XEZCoBiakHlmPwPKoKbnk7xDAEYoq2USNeI1HUC7CghWMeLKUBM8j+aRS07HllZ+s/iS1BiSc2NoKTl7NIOsvsQEoVlIWbKBfufCrhXkePtHDSz/B6tyy5wBoK75OwQ9aGNGXH1ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706131239; c=relaxed/simple;
	bh=ORmSVS/3eZ4Bl5ltvzkK0UzKOlkh4YG2Lr35w/lEvPs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CSvxSwC68A7IfQpzNqjArACRDC7sXfw/nRdbclYlx24InemgBXA1CVMja7y+n7nbXqj69nWMC1obGEB0VX1EMB7JzhOQpeJpYWUC8F7b+QfP/zLunyMJ6QqMJ9l1UqA5mPMBvZMMCGhGBjkVDcOEUl1Pj+lEjYwo4VV7EeDXIDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hehVy3dd; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hehVy3dd"
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7ba9f1cfe94so2583539f.1
        for <linux-raid@vger.kernel.org>; Wed, 24 Jan 2024 13:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706131236; x=1706736036; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z9DtkXcOZIkFysUlT9wQjyevu2p8ukcycgR0DHVqm1Q=;
        b=hehVy3ddflK6lEdnvAs+72gAgPg1BKWo0aPmWIxFYxfymjBjdYD1OQpP1WL/V2MsgA
         itXHfdpJxt5U+z+GIPevQHiIhyBs045pqYQgnAzMWyThn1F1Qc8PXGRX2NZhG/EXeLuC
         trj1xqi3MAqzwZ/XDggBr0VlpPiUf9H1gpMikN/RW+lZQ72PEzsdzHY1eD7Pt+I4tUiS
         M5DgBMnj3M6DAEuf9d9e51EhVnflYMQRYCvLn4Q5pxjPz3Z3GhFiacqdMOPC7+ApQRI1
         G8w56XVtxeOy4temXGyDXiHfjsdrOAo1EnZ+7894NBPLmIB5QY67C/JoO3+yIO/su93z
         EqSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706131236; x=1706736036;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z9DtkXcOZIkFysUlT9wQjyevu2p8ukcycgR0DHVqm1Q=;
        b=TI4yxixvL8nmgz/hJ6ddfHrbzKVo+mBbAUE/OCGEbO+BZSPmCAIRKMxJ21+l6R5Oui
         WWzMzbGLNw2gD0X0tIjkyURLY0Up+IPDgAMn3bjHkLxfaI0A+QbC/WOff2W84SzquTUo
         BaR+gyVzaOjbIicT+PSaOJkTcs2PKAnTIXSGzJMfRtVUpH16nPljqJHWNITOCKG1hzRx
         7Cv76rwzXW3Rme6uGxwF7bCR7eZN+agV03HRQg6w3im+HPFoQqP0SxXfnjOPPtQoTDK4
         eXgVB2AxqPqQaxoqGpn9tCunhoOYlHlCVNpMY802+iKXZ1FRwLKMbC9DjWUfgZ6T27S8
         XgMQ==
X-Gm-Message-State: AOJu0YyV2esyp7MtQWMdcy/fB7aRxs5Kap2jJ+Ic9X+1YKafJgYBetKC
	bmIGhfJjGl7DTdGDK4nYYB3rZYg7l8ZbFjjo97A1OXgBIMPTyGwdvJm1KbCNy1JFFgf/Btfif+7
	tcTc4fPbYNCbiscv36MZpnxfkvL7AeTju
X-Google-Smtp-Source: AGHT+IGLMbq48d/4C6XQn6GdB5KsNzhvlUZTNKSPqMIAlYV4UO83lnmxvZs8h+gsZwdVv/rZet56Y3XMOsldwyaNlR8=
X-Received: by 2002:a05:6e02:1745:b0:360:3b5:4863 with SMTP id
 y5-20020a056e02174500b0036003b54863mr137263ill.22.1706131236079; Wed, 24 Jan
 2024 13:20:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <432300551.863689.1705953121879.ref@mail.yahoo.com>
 <432300551.863689.1705953121879@mail.yahoo.com> <04757cef-9edf-449a-93ab-a0534a821dc6@thelounge.net>
 <1085291040.906901.1705961588972@mail.yahoo.com> <0f28b23e-54f2-49ed-9149-87dbe3cffb30@thelounge.net>
 <598555968.936049.1705968542252@mail.yahoo.com> <755754794.951974.1705974751281@mail.yahoo.com>
 <20240123110624.1b625180@firefly> <12445908.1094378.1706026572835@mail.yahoo.com>
 <20240123221935.683eb1eb@firefly> <1979173383.106122.1706098632056@mail.yahoo.com>
 <006fe0ca-a2fb-4ccd-b4d4-c01945d72661@penguinpee.nl> <2058198167.201827.1706119581305@mail.yahoo.com>
In-Reply-To: <2058198167.201827.1706119581305@mail.yahoo.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Wed, 24 Jan 2024 15:20:25 -0600
Message-ID: <CAAMCDef52pGpqOpOFRW8LAyiXtaJNzDderb7KLx8GR0BqP2epg@mail.gmail.com>
Subject: Re: Requesting help recovering my array
To: RJ Marquette <rjm1@yahoo.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Are you sure you did not partition devices that did not previously
have partition tables?

Partition tables will typically cause the under device (sda) to be
ignored by all of tools since it should never having something else
(except the partition table) on it.

I have had to remove incorrectly added partition tables/blocks to make
lvm and other tools again see the data.  Otherwise the tools ignore
it.

On Wed, Jan 24, 2024 at 12:06=E2=80=AFPM RJ Marquette <rjm1@yahoo.com> wrot=
e:
>
> Other than sdc (as you noted), the other array drives come back like this=
:
>
> root@jackie:/etc/mdadm# mdadm --examine /dev/sda
> /dev/sda:
>   MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)
>
> root@jackie:/etc/mdadm# mdadm --examine /dev/sda1
> mdadm: No md superblock detected on /dev/sda1.
>
>
> Trying your other suggestion:
> root@jackie:/etc/mdadm# mdadm --assemble /dev/md0 /dev/sdb1 /dev/sde1 /de=
v/sdf1 /dev/sdg1
> mdadm: no recogniseable superblock on /dev/sdb1
> mdadm: /dev/sdb1 has no superblock - assembly aborted
>
> root@jackie:/etc/mdadm# mdadm --assemble /dev/md0 /dev/sdb /dev/sde /dev/=
sdf /dev/sdg
> mdadm: Cannot assemble mbr metadata on /dev/sdb
> mdadm: /dev/sdb has no superblock - assembly aborted
>
>
> Basically I've tried everything here:  https://raid.wiki.kernel.org/index=
.php/Linux_Raid
>
> The impression I'm getting here is that we aren't really sure what the is=
sue is.  I think tonight I'll play with some of the BIOS settings and see i=
f there's something in there.  If not I'll swap back to the old motherboard=
 and see what happens.
>
> Thanks.
> --RJ
>
>
>
>
>
> On Wednesday, January 24, 2024 at 12:06:26 PM EST, Sandro <lists@penguinp=
ee.nl> wrote:
>
>
>
>
>
> On 24-01-2024 13:17, RJ Marquette wrote:
>
> > When I try the command you suggested below, I get:
> > root@jackie:/etc/mdadm# mdadm --assemble /dev/md0 /dev/sd{a,b,e,f,g}1
> > mdadm: no recogniseable superblock on /dev/sda1
> > mdadm: /dev/sda1 has no superblock - assembly aborted
>
>
> Try `mdadm --examine` on every partition / drive that is giving you
> trouble. Maybe you are remembering things wrong and the raid device is
> /dev/sda and not /dev/sda1.
>
> You can also go through the entire list (/dev/sd*), you posted earlier.
> There's no harm in running the command. It will look for the superblock
> and tell you what has been found. This could provide the information you
> need to assemble the array.
>
> Alternatively, leave sda1 out of the assembly and see if mdadm will be
> able to partially assemble the array.
>
> -- Sandro
>
