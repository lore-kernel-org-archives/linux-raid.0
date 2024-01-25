Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261916FC9
	for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 01:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706147886; cv=none; b=g1dzdljX4WcqDIq/D3qhOl4H8D01JWTVXKQ93r1Yro30/s9rdJq5FHxZUfuunhSu0i1R8vOcUNIB6t5DyKUP4K2IET143Vuv3ZTqC+3IrqN7D2BiipGBaIk85mmGHTQTH6iPA60/Do3nyf953ILPe8SvaipPsUcitpy56HpWhSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706147886; c=relaxed/simple;
	bh=n5q1RkA3klcjD17L45bh5l/9uegDbi9Zgp8k2KkWK08=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B4lBBp1e2gKzwy/4LpTEApKKRvZjb7ZVi8dZTxSG7g2VAq9t/7BhqJsDrh+awSSRvfUAqIQv4BCuU8iw15qW4zuvLjqtc1iistLUxXY17HwSc4zLnAjqWWz9srB9AfaQvtZ8le+IOFIWePUTvSjYS+3vRVYyUsY/k6+0aUaqhmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E14hgP3+; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E14hgP3+"
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-36278a62926so12917375ab.3
        for <linux-raid@vger.kernel.org>; Wed, 24 Jan 2024 17:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706147883; x=1706752683; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zaTQzdo2MNxji0n+aQEF7zSxFH2aJj91xCUTiX8LM/E=;
        b=E14hgP3+PEd12UhWXBao/NOzu8b1EeIb55dQwDmUGWnNL9EVpmmLIMNYcXD9bi22/d
         UHUFHhs9n4+193HwELatHokd8OQAnW/6ZDI0lh+PJY59oK+dVvHdGYeIGMZZZtejKNX1
         pQNtACq9C3wYVtlL5c5T8ODMH0W02uSUMCEJuqHZxzvW0oO8C8UFsqg6OVDyWSQCMDng
         6NEkWgwXwfwmrUZZE/jBc+ZhBXXAdcJX9RBTmrRKGANpzQFSShTtGxVK9vqfeTP7CSUU
         i9hPj57eBs039PV0iHkQHFOuawXduWjqplF5jX2yOQKtmjIk++5WYb/3Lmy8P3Vg2vi3
         hdXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706147883; x=1706752683;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zaTQzdo2MNxji0n+aQEF7zSxFH2aJj91xCUTiX8LM/E=;
        b=MNeG9a5RQvqIG3iRCVusN5SRRSwzC2zkSXi1Kj3g96XdwnA6U98wQ7y5Ua77d5Luxq
         8dVssJYCRuK+/lGnS0uSjPUL7rHGZA9MruxCUWb/JvNwAzc4PXMJvw6uwTu9/q6ZVVHl
         o31Sn5M596Flezo0KpV/DI/qFkEAtwUGVW7V6GwU8HtrbhiqcBEU/cqCNAM1ti7cDbrz
         m+iIjcBiOaBMvJ8TlPYOth+v5fx4A7IcdtWfTDS3VciSozG51ux50ZzGvcqrjmal3Bm+
         825SVA/E9jhQqKzZus3eX0H14f5GDw1dAkEtqZObJ3Kq7iYdc2RWOHrBkr+COPYJpk7b
         U95A==
X-Gm-Message-State: AOJu0YyATv3W4yMWOdN79cJ3RSRcQZk18/B4Oly/1wllkh0dwrICZn7u
	PXQwKqrgJ7uTSE/hl95vsxXUw2fKP5LQKNy8JA3OzN9fdhd1DTXO4Er8fFWXEckTNYmOeKi7qKh
	KcHlw/jMrCkji4hDoOunUpoEA/ec=
X-Google-Smtp-Source: AGHT+IGChNUqxFjTmtsz6vB9QW042UYCAR/LZ7xAP/z3aaqMDbdrVNcnB1pjSKexlIrq2H1W+Pw30C83ETg2YS1TwKI=
X-Received: by 2002:a05:6e02:1064:b0:361:9249:5aed with SMTP id
 q4-20020a056e02106400b0036192495aedmr397200ilj.52.1706147883184; Wed, 24 Jan
 2024 17:58:03 -0800 (PST)
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
 <CAAMCDef52pGpqOpOFRW8LAyiXtaJNzDderb7KLx8GR0BqP2epg@mail.gmail.com>
 <544664840.269616.1706131905741@mail.yahoo.com> <CAAMCDecCCCH9oOtx08g-yLwo_8JCHMkyUKu-f91du7O40wy+EA@mail.gmail.com>
 <5112393.323817.1706145196938@mail.yahoo.com>
In-Reply-To: <5112393.323817.1706145196938@mail.yahoo.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Wed, 24 Jan 2024 19:57:51 -0600
Message-ID: <CAAMCDefBd2qToWacy9HTs8UmimVi6eKgADg=BN7RkCnfE7Cirg@mail.gmail.com>
Subject: Re: Requesting help recovering my array
To: RJ Marquette <rjm1@yahoo.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

dd if=3D/dev/sdb of=3D/root/sdb.512byte.block.save bs=3D512 count=3D1
(repeat on each damaged drive with its name).
then
dd if=3D/dev/zero of=3D/dev/sdb bs=3D512 count=3D1     (for each disk).

the first command makes a copy of that first block just in case and
the 2nd command clears the first 512 bytes that contains the partition
data.

On Wed, Jan 24, 2024 at 7:13=E2=80=AFPM RJ Marquette <rjm1@yahoo.com> wrote=
:
>
> It looks like this is what happened after all.  I searched for "MBR Magic=
 aa55" and found someone else with the same issue long ago:  https://server=
fault.com/questions/580761/is-mdadm-raid-toast  Looks like his was caused b=
y a RAID configuration option in BIOS.  I recall seeing that on mine; I mus=
t have activated it by accident when setting the boot drive or something.
>
> I swapped the old motherboard back in, no improvement, so I'm back to the=
 new one.  I'm now running testdisk to see if I can repair the partition ta=
ble.
>
> Thanks.
> --RJ
>
>
>
> On Wednesday, January 24, 2024 at 04:45:19 PM EST, Roger Heflin <rogerhef=
lin@gmail.com> wrote:
>
>
>
>
>
> Well, if you have a /dev/sdb1 device and you think the mdadm device is
> /dev/sdb (not sdb1) then SOMEONE added a partition table at some point
> in time or you are confused what you mdadm device is.  if sdb is a
> mdadm device and it has a partition table then mdadm --examine may see
> the partition table and report that and STOP reporting anything else.
>
> And note that that partition table could have been added at any point
> in time since the prior reboot.  I have found (and fixed) ones that
> were added years earlier and found on the next reboot for something
> similar a year or 2 later.  On my own stuff before a hardware/mb
> upgrade i will do a reboot to make sure that it reboots cleanly as all
> sorts of stuff can happen (ie like initramfs/kernel  changes causing a
> general failure to boot).
>
> On Wed, Jan 24, 2024 at 3:31=E2=80=AFPM RJ Marquette <rjm1@yahoo.com> wro=
te:
> >
> > I didn't touch the drives.  I shut down the computer with everything wo=
rking fine, swapped motherboards, booted the new board, and discovered this=
 problem immediately when the computer failed to boot because the array was=
n't up and running.  I definitely haven't run fdisk or other disk partition=
ing programs on them.
> >
> > Other than the modifications to the mdadm.conf to describe the drives a=
nd partitions (none of which have made any difference), I modified my fstab=
 to comment out the raid array so the computer would boot normally.  I've b=
een trying to figure out what is going on ever since.  I've tried to avoid =
doing anything that might write to the drives.
> >
> > I thought this upgrade would take an hour or two to swap hardware, not =
days of troubleshooting.  That was the advantage of software RAID, I though=
t.
> >
> > Thanks.
> > --RJ
> >
> >
> >
> >
> > On Wednesday, January 24, 2024 at 04:20:51 PM EST, Roger Heflin <rogerh=
eflin@gmail.com> wrote:
> >
> >
> >
> >
> >
> > Are you sure you did not partition devices that did not previously
> > have partition tables?
> >
> > Partition tables will typically cause the under device (sda) to be
> > ignored by all of tools since it should never having something else
> > (except the partition table) on it.
> >
> > I have had to remove incorrectly added partition tables/blocks to make
> > lvm and other tools again see the data.  Otherwise the tools ignore
> > it.
> >
> > On Wed, Jan 24, 2024 at 12:06=E2=80=AFPM RJ Marquette <rjm1@yahoo.com> =
wrote:
> > >
> > > Other than sdc (as you noted), the other array drives come back like =
this:
> > >
> > > root@jackie:/etc/mdadm# mdadm --examine /dev/sda
> > > /dev/sda:
> > >  MBR Magic : aa55
> > > Partition[0] :  4294967295 sectors at            1 (type ee)
> > >
> > > root@jackie:/etc/mdadm# mdadm --examine /dev/sda1
> > > mdadm: No md superblock detected on /dev/sda1.
> > >
> > >
> > > Trying your other suggestion:
> > > root@jackie:/etc/mdadm# mdadm --assemble /dev/md0 /dev/sdb1 /dev/sde1=
 /dev/sdf1 /dev/sdg1
> > > mdadm: no recogniseable superblock on /dev/sdb1
> > > mdadm: /dev/sdb1 has no superblock - assembly aborted
> > >
> > > root@jackie:/etc/mdadm# mdadm --assemble /dev/md0 /dev/sdb /dev/sde /=
dev/sdf /dev/sdg
> > > mdadm: Cannot assemble mbr metadata on /dev/sdb
> > > mdadm: /dev/sdb has no superblock - assembly aborted
> > >
> > >
> > > Basically I've tried everything here:  https://raid.wiki.kernel.org/i=
ndex.php/Linux_Raid
> > >
> > > The impression I'm getting here is that we aren't really sure what th=
e issue is.  I think tonight I'll play with some of the BIOS settings and s=
ee if there's something in there.  If not I'll swap back to the old motherb=
oard and see what happens.
> > >
> > > Thanks.
> > > --RJ
> > >
> > >
> > >
> > >
> > >
> > > On Wednesday, January 24, 2024 at 12:06:26 PM EST, Sandro <lists@peng=
uinpee.nl> wrote:
> > >
> > >
> > >
> > >
> > >
> > > On 24-01-2024 13:17, RJ Marquette wrote:
> > >
> > > > When I try the command you suggested below, I get:
> > > > root@jackie:/etc/mdadm# mdadm --assemble /dev/md0 /dev/sd{a,b,e,f,g=
}1
> > > > mdadm: no recogniseable superblock on /dev/sda1
> > > > mdadm: /dev/sda1 has no superblock - assembly aborted
> > >
> > >
> > > Try `mdadm --examine` on every partition / drive that is giving you
> > > trouble. Maybe you are remembering things wrong and the raid device i=
s
> > > /dev/sda and not /dev/sda1.
> > >
> > > You can also go through the entire list (/dev/sd*), you posted earlie=
r.
> > > There's no harm in running the command. It will look for the superblo=
ck
> > > and tell you what has been found. This could provide the information =
you
> > > need to assemble the array.
> > >
> > > Alternatively, leave sda1 out of the assembly and see if mdadm will b=
e
> > > able to partially assemble the array.
> > >
> > > -- Sandro
> > >
> >
>
