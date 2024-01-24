Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6D213665E
	for <linux-raid@vger.kernel.org>; Wed, 24 Jan 2024 22:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706135865; cv=none; b=Dx78RHORBCMRGSWSCtSfs2VCkPNHLRUdHLTPvho6PcKV8VD1QX638LxfFvGYrSh2ffDqVebZis660QshnbbziBj+98UPEVeuI0XyMas0ByuEjD99hh2WGX3V0QDwD2I1R+aIkfkzhAqfKo+vp/to/UN0cZU1DGris5tynWxmOjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706135865; c=relaxed/simple;
	bh=MlwhxEvihGkJIq0M2IP59tJaznMkQDVvsSNcgUEqrFo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=jmum+PBLFegQE+vPcZDIYTtLwV3Nn8Q1/Scg4oBVIfEA+CsFRkaI8TAAcuJOK1/9/a8vk9qOnthos7wp3YLf1XrgwjwgGjs8aOrfN8Rnx58p1cUrg2faqSxC4By6NWgXZsK4hgRVOjQJxZDSzxf39ad81DR05n1hZI9UooaB2os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QB/P8qzo; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QB/P8qzo"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7bf2a5cf9cbso300070739f.1
        for <linux-raid@vger.kernel.org>; Wed, 24 Jan 2024 14:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706135863; x=1706740663; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DkCQaUr2BJo7eU3mGhGHQDu2JfAdIlAEUNWAe6dB61M=;
        b=QB/P8qzoD7TOn+oW1uhYfsrClBmHX/A8KtBjm1a7W6tDytiYOET6jDfzXJHPLDuBBG
         jHua8sAvvfWsi4oYQoGuiHVYbkOJSO7SRQfvZQNZHDimii5JpWdVwuGhdH8CiP1Bznrv
         hhedYHNk/bZylv2EjoI65o5gECjT3fs6KdiSq7PW7DieYYKcK/joJa7KYZw1m+2dvG04
         OEzjcU2sSChAqYyi3g0Xvr8Xk7Rf4k5IVbijcjh8Cn9/HwUs5wvIYmTKu3D5/lMH2RDl
         LXDCyFAFb7gEjES3tH4FMQit/MtEZkHRDotVs+razpDm7b6D4db3ZYeZhtSw0I7VgBa1
         7rGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706135863; x=1706740663;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DkCQaUr2BJo7eU3mGhGHQDu2JfAdIlAEUNWAe6dB61M=;
        b=Fd975rYb37MQwWa0zD4SU+gz6l69ZcnG17HTWg4+PgoAV+owqX72T8AjZp+gzYq+KU
         pxB3ScLPJ7rLZaIoUltkZVv79oyit0oe1INXeyDiItnvLToC6b5xdWAE88MnB3Ly8/4m
         Fudikqsc9iz9Ox3oo+6Uw4XOeDvafomwDED2PV2Ju+CAORnNGX7meDPjwo4kCrA8qA6P
         +iuWgtpnzkNpD92EGZjbVtqD+9HMUQf9cZ9c8UiTNEumURR8CXc8VnkKEmPMzK8ZRjE4
         OXpOfI1GlELAa8gwju6JNno2PqZRDeWtIyh3e5dQoc1ZELfCsjx4+N7WbHP2yFWvULmx
         hnYw==
X-Gm-Message-State: AOJu0Yz2S3FDw64L2Ye5Sw/+z245gj8adRyUCj22jrwI5OtCgXs93c55
	3Rx0R4TT0I3IQI1Z5hZhR1CghLFS/uv6rkRhUAzn912FjlGx6XDAkPXL1PW3InAWKWYOXl1HT4R
	Eprjfng8C5wYsROqAfE37TAagrU8=
X-Google-Smtp-Source: AGHT+IHbTM/O6Xdbsh0YttHw2q2Nmz7tkTvUURefHN5d9/HAvdR8uSNr+qJav2tRp5Pfgcl4cXZow8lA5AKRjrOTaso=
X-Received: by 2002:a5e:8c14:0:b0:7bf:1338:7bcc with SMTP id
 n20-20020a5e8c14000000b007bf13387bccmr109421ioj.40.1706135863187; Wed, 24 Jan
 2024 14:37:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <755754794.951974.1705974751281@mail.yahoo.com>
 <20240123110624.1b625180@firefly> <12445908.1094378.1706026572835@mail.yahoo.com>
 <20240123221935.683eb1eb@firefly> <1979173383.106122.1706098632056@mail.yahoo.com>
 <006fe0ca-a2fb-4ccd-b4d4-c01945d72661@penguinpee.nl> <2058198167.201827.1706119581305@mail.yahoo.com>
 <CAAMCDef52pGpqOpOFRW8LAyiXtaJNzDderb7KLx8GR0BqP2epg@mail.gmail.com>
 <544664840.269616.1706131905741@mail.yahoo.com> <CAAMCDecCCCH9oOtx08g-yLwo_8JCHMkyUKu-f91du7O40wy+EA@mail.gmail.com>
 <20240124222154.GA6210@usr01.home.robinhill.me.uk>
In-Reply-To: <20240124222154.GA6210@usr01.home.robinhill.me.uk>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Wed, 24 Jan 2024 16:37:32 -0600
Message-ID: <CAAMCDedO+sVpCm5gumf4OJMg5nytu3fOOm2081=17TDwLqEBrQ@mail.gmail.com>
Subject: Re: Requesting help recovering my array
To: Roger Heflin <rogerheflin@gmail.com>, RJ Marquette <rjm1@yahoo.com>, 
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

you might do a fdisk -l sdb and see what the partition table looks
like and what type of table it is.

And run this:
 dd if=3D/dev/sdb bs=3D1M count=3D2 | xxd -a  | more
my first block (0000) is all 00 (this is where the  partition table
goes) and my md header looks like this:

00001000: fc4e 2ba9 0100 0000 0100 0000 0000 0000  .N+.............
00001010: ea9b 97b7 9301 0e79 ef9a ac45 a0b8 4276  .......y...E..Bv
00001020: 6c6f 6361 6c68 6f73 742e 6c6f 6361 6c64  localhost.locald
00001030: 6f6d 6169 6e3a 3133 0000 0000 0000 0000  omain:13........


On Wed, Jan 24, 2024 at 4:22=E2=80=AFPM Robin Hill <robin@robinhill.me.uk> =
wrote:
>
> There have been reported cases of BIOSes auto-creating partitions on
> disks, so this is certainly a possibility. I used to use bare disks but
> have switched to partitions instead, just to prevent this sort of thing
> from happening.
>
> Cheers,
>     Robin
>
> On Wed Jan 24, 2024 at 03:44:55PM -0600, Roger Heflin wrote:
>
> > Well, if you have a /dev/sdb1 device and you think the mdadm device is
> > /dev/sdb (not sdb1) then SOMEONE added a partition table at some point
> > in time or you are confused what you mdadm device is.   if sdb is a
> > mdadm device and it has a partition table then mdadm --examine may see
> > the partition table and report that and STOP reporting anything else.
> >
> > And note that that partition table could have been added at any point
> > in time since the prior reboot.  I have found (and fixed) ones that
> > were added years earlier and found on the next reboot for something
> > similar a year or 2 later.  On my own stuff before a hardware/mb
> > upgrade i will do a reboot to make sure that it reboots cleanly as all
> > sorts of stuff can happen (ie like initramfs/kernel  changes causing a
> > general failure to boot).
> >
> > On Wed, Jan 24, 2024 at 3:31=E2=80=AFPM RJ Marquette <rjm1@yahoo.com> w=
rote:
> > >
> > > I didn't touch the drives.  I shut down the computer with everything =
working fine, swapped motherboards, booted the new board, and discovered th=
is problem immediately when the computer failed to boot because the array w=
asn't up and running.  I definitely haven't run fdisk or other disk partiti=
oning programs on them.
> > >
> > > Other than the modifications to the mdadm.conf to describe the drives=
 and partitions (none of which have made any difference), I modified my fst=
ab to comment out the raid array so the computer would boot normally.  I've=
 been trying to figure out what is going on ever since.  I've tried to avoi=
d doing anything that might write to the drives.
> > >
> > > I thought this upgrade would take an hour or two to swap hardware, no=
t days of troubleshooting.  That was the advantage of software RAID, I thou=
ght.
> > >
> > > Thanks.
> > > --RJ
> > >
> > >
> > >
> > >
> > > On Wednesday, January 24, 2024 at 04:20:51 PM EST, Roger Heflin <roge=
rheflin@gmail.com> wrote:
> > >
> > >
> > >
> > >
> > >
> > > Are you sure you did not partition devices that did not previously
> > > have partition tables?
> > >
> > > Partition tables will typically cause the under device (sda) to be
> > > ignored by all of tools since it should never having something else
> > > (except the partition table) on it.
> > >
> > > I have had to remove incorrectly added partition tables/blocks to mak=
e
> > > lvm and other tools again see the data.  Otherwise the tools ignore
> > > it.
> > >
> > > On Wed, Jan 24, 2024 at 12:06=E2=80=AFPM RJ Marquette <rjm1@yahoo.com=
> wrote:
> > > >
> > > > Other than sdc (as you noted), the other array drives come back lik=
e this:
> > > >
> > > > root@jackie:/etc/mdadm# mdadm --examine /dev/sda
> > > > /dev/sda:
> > > >  MBR Magic : aa55
> > > > Partition[0] :  4294967295 sectors at            1 (type ee)
> > > >
> > > > root@jackie:/etc/mdadm# mdadm --examine /dev/sda1
> > > > mdadm: No md superblock detected on /dev/sda1.
> > > >
> > > >
> > > > Trying your other suggestion:
> > > > root@jackie:/etc/mdadm# mdadm --assemble /dev/md0 /dev/sdb1 /dev/sd=
e1 /dev/sdf1 /dev/sdg1
> > > > mdadm: no recogniseable superblock on /dev/sdb1
> > > > mdadm: /dev/sdb1 has no superblock - assembly aborted
> > > >
> > > > root@jackie:/etc/mdadm# mdadm --assemble /dev/md0 /dev/sdb /dev/sde=
 /dev/sdf /dev/sdg
> > > > mdadm: Cannot assemble mbr metadata on /dev/sdb
> > > > mdadm: /dev/sdb has no superblock - assembly aborted
> > > >
> > > >
> > > > Basically I've tried everything here:  https://raid.wiki.kernel.org=
/index.php/Linux_Raid
> > > >
> > > > The impression I'm getting here is that we aren't really sure what =
the issue is.  I think tonight I'll play with some of the BIOS settings and=
 see if there's something in there.  If not I'll swap back to the old mothe=
rboard and see what happens.
> > > >
> > > > Thanks.
> > > > --RJ
> > > >
> > > >
> > > >
> > > >
> > > >
> > > > On Wednesday, January 24, 2024 at 12:06:26 PM EST, Sandro <lists@pe=
nguinpee.nl> wrote:
> > > >
> > > >
> > > >
> > > >
> > > >
> > > > On 24-01-2024 13:17, RJ Marquette wrote:
> > > >
> > > > > When I try the command you suggested below, I get:
> > > > > root@jackie:/etc/mdadm# mdadm --assemble /dev/md0 /dev/sd{a,b,e,f=
,g}1
> > > > > mdadm: no recogniseable superblock on /dev/sda1
> > > > > mdadm: /dev/sda1 has no superblock - assembly aborted
> > > >
> > > >
> > > > Try `mdadm --examine` on every partition / drive that is giving you
> > > > trouble. Maybe you are remembering things wrong and the raid device=
 is
> > > > /dev/sda and not /dev/sda1.
> > > >
> > > > You can also go through the entire list (/dev/sd*), you posted earl=
ier.
> > > > There's no harm in running the command. It will look for the superb=
lock
> > > > and tell you what has been found. This could provide the informatio=
n you
> > > > need to assemble the array.
> > > >
> > > > Alternatively, leave sda1 out of the assembly and see if mdadm will=
 be
> > > > able to partially assemble the array.
> > > >
> > > > -- Sandro
> > > >
> > >
> >
