Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D155131E26
	for <linux-raid@vger.kernel.org>; Wed, 24 Jan 2024 21:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706132708; cv=none; b=DKLMUjnFfpQVeLadIq8x2oM/vpGSzRgcQeTWbGp/9KZ+Gpve9Vd7aUuRqPf3HsbW7H+UGP2gEbJCnf9wovir3tOAL9z5nJNciMxlRwqmGD/BzXKQB1GqH3xqjs/rvtGtz2/jfcgQlo2qSPfjsXp8ehdUZqZ7gZ1XrXxtfF/JgWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706132708; c=relaxed/simple;
	bh=rgxVyOm3qjf8cMChBz4TcX3eEN7vpt250xtkHX5sI9g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A/KuPFd49s8leRprsiQ4g//AIO51rwQ3Fw018hJ3ACJAv+l97NflN35xYT+wnNi0wVAm/A4o/1I6aUJqSE+M3lKk6QPmwyLA9BYHannkTfUgqIQTCbJB9d5xONPO4jXY4ch6FCVgtZgA8WqBe4rNYbWg/S90Uo9UQkkLBgt6cw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gZNEoFtH; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gZNEoFtH"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7bc332d49f6so263702739f.1
        for <linux-raid@vger.kernel.org>; Wed, 24 Jan 2024 13:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706132706; x=1706737506; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ME4S51/xbYHlCI/2HA3v9K7JulOPPa/XT9SgrSoGiyI=;
        b=gZNEoFtHF5CR4iR933Wbj9sx17nsV5MXMqWmSdxCjSmmdOlNhAPCT9dNqXrvoJFkid
         ZBha2PiyQWw5uSCcAII8chlBg/1aIuUYD9Ogumh5fClBHedCtuPZCQNVn/UKvhuRM1j/
         xtsarXb4pZZItT/lKLF0PdjYwrIYDYCTh/db7MhhmUdsqjl+WurlDY0L4+0mx3BdBdTl
         vTjUwjaxbg3Xq0nUHltf4hAGNr979FHuZcJH1Qsfas9Ng9Kt4g/1NeW/rqHzj1+95Eet
         oAuOAjPAOycuCwQQAu/uJFx3jYyMeMnrzfg1XZppaMPfuofT/gZeT/YAawh03w0wUITv
         rXxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706132706; x=1706737506;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ME4S51/xbYHlCI/2HA3v9K7JulOPPa/XT9SgrSoGiyI=;
        b=rFa7bR8XvPduzvnBCZuqehiBjnimY8YIgu85UiluLhFgJ6zpcvFYsbHwd6ZIDfNpi2
         +m0T5K/zs02KW1ZqbOTbsKBAJnHiPVF8LthfrMJxVWH1H271ojbPB5YXvRVpLBhb87oQ
         9MWS3CHvV0iGe1zp46aUum5H/QN1tZGb4Tu6K08WpHUbY/Pbm1gmtMo3LQf/XyrIpmAs
         1u5vXvtOJlaK0zhr22nNh1wFPLQ0o5tq+RP7dWzGPEgBhfbtnmFb4aWmTD4VZ3uG95Jv
         UxoMZs7XoZ/8PWkLhyUi5eeUsBMDbp/iGbJoiegOwxdVfwr98o7RMLpeohwX/JLdlytd
         nzQw==
X-Gm-Message-State: AOJu0Yze1pkIPzgdSVwCDWyFS52sgXZqv25OLm032wFPDz5d01O6Bkb2
	HzGfwQtA/qknrZRvvEzXc83yS/M1N09cUx8yu19BuRsZ/8DQ/TjBpfU85uEc4YRxz+ScRJAdc2d
	VIH0g+n1atd3Qwu1FwOnWc9L3Wc3AuLbJ
X-Google-Smtp-Source: AGHT+IHIswHz2HQCAesir1kvFDWnd7H/vOCwLZrcxLJ/mbvNnYZuLXMpj5RmZAnG8aeMRIX1oJX2ngyJDNeZUYQYpW8=
X-Received: by 2002:a5d:8788:0:b0:7ba:82fd:ffd0 with SMTP id
 f8-20020a5d8788000000b007ba82fdffd0mr97747ion.16.1706132706041; Wed, 24 Jan
 2024 13:45:06 -0800 (PST)
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
 <CAAMCDef52pGpqOpOFRW8LAyiXtaJNzDderb7KLx8GR0BqP2epg@mail.gmail.com> <544664840.269616.1706131905741@mail.yahoo.com>
In-Reply-To: <544664840.269616.1706131905741@mail.yahoo.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Wed, 24 Jan 2024 15:44:55 -0600
Message-ID: <CAAMCDecCCCH9oOtx08g-yLwo_8JCHMkyUKu-f91du7O40wy+EA@mail.gmail.com>
Subject: Re: Requesting help recovering my array
To: RJ Marquette <rjm1@yahoo.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Well, if you have a /dev/sdb1 device and you think the mdadm device is
/dev/sdb (not sdb1) then SOMEONE added a partition table at some point
in time or you are confused what you mdadm device is.   if sdb is a
mdadm device and it has a partition table then mdadm --examine may see
the partition table and report that and STOP reporting anything else.

And note that that partition table could have been added at any point
in time since the prior reboot.  I have found (and fixed) ones that
were added years earlier and found on the next reboot for something
similar a year or 2 later.  On my own stuff before a hardware/mb
upgrade i will do a reboot to make sure that it reboots cleanly as all
sorts of stuff can happen (ie like initramfs/kernel  changes causing a
general failure to boot).

On Wed, Jan 24, 2024 at 3:31=E2=80=AFPM RJ Marquette <rjm1@yahoo.com> wrote=
:
>
> I didn't touch the drives.  I shut down the computer with everything work=
ing fine, swapped motherboards, booted the new board, and discovered this p=
roblem immediately when the computer failed to boot because the array wasn'=
t up and running.  I definitely haven't run fdisk or other disk partitionin=
g programs on them.
>
> Other than the modifications to the mdadm.conf to describe the drives and=
 partitions (none of which have made any difference), I modified my fstab t=
o comment out the raid array so the computer would boot normally.  I've bee=
n trying to figure out what is going on ever since.  I've tried to avoid do=
ing anything that might write to the drives.
>
> I thought this upgrade would take an hour or two to swap hardware, not da=
ys of troubleshooting.  That was the advantage of software RAID, I thought.
>
> Thanks.
> --RJ
>
>
>
>
> On Wednesday, January 24, 2024 at 04:20:51 PM EST, Roger Heflin <rogerhef=
lin@gmail.com> wrote:
>
>
>
>
>
> Are you sure you did not partition devices that did not previously
> have partition tables?
>
> Partition tables will typically cause the under device (sda) to be
> ignored by all of tools since it should never having something else
> (except the partition table) on it.
>
> I have had to remove incorrectly added partition tables/blocks to make
> lvm and other tools again see the data.  Otherwise the tools ignore
> it.
>
> On Wed, Jan 24, 2024 at 12:06=E2=80=AFPM RJ Marquette <rjm1@yahoo.com> wr=
ote:
> >
> > Other than sdc (as you noted), the other array drives come back like th=
is:
> >
> > root@jackie:/etc/mdadm# mdadm --examine /dev/sda
> > /dev/sda:
> >  MBR Magic : aa55
> > Partition[0] :  4294967295 sectors at            1 (type ee)
> >
> > root@jackie:/etc/mdadm# mdadm --examine /dev/sda1
> > mdadm: No md superblock detected on /dev/sda1.
> >
> >
> > Trying your other suggestion:
> > root@jackie:/etc/mdadm# mdadm --assemble /dev/md0 /dev/sdb1 /dev/sde1 /=
dev/sdf1 /dev/sdg1
> > mdadm: no recogniseable superblock on /dev/sdb1
> > mdadm: /dev/sdb1 has no superblock - assembly aborted
> >
> > root@jackie:/etc/mdadm# mdadm --assemble /dev/md0 /dev/sdb /dev/sde /de=
v/sdf /dev/sdg
> > mdadm: Cannot assemble mbr metadata on /dev/sdb
> > mdadm: /dev/sdb has no superblock - assembly aborted
> >
> >
> > Basically I've tried everything here:  https://raid.wiki.kernel.org/ind=
ex.php/Linux_Raid
> >
> > The impression I'm getting here is that we aren't really sure what the =
issue is.  I think tonight I'll play with some of the BIOS settings and see=
 if there's something in there.  If not I'll swap back to the old motherboa=
rd and see what happens.
> >
> > Thanks.
> > --RJ
> >
> >
> >
> >
> >
> > On Wednesday, January 24, 2024 at 12:06:26 PM EST, Sandro <lists@pengui=
npee.nl> wrote:
> >
> >
> >
> >
> >
> > On 24-01-2024 13:17, RJ Marquette wrote:
> >
> > > When I try the command you suggested below, I get:
> > > root@jackie:/etc/mdadm# mdadm --assemble /dev/md0 /dev/sd{a,b,e,f,g}1
> > > mdadm: no recogniseable superblock on /dev/sda1
> > > mdadm: /dev/sda1 has no superblock - assembly aborted
> >
> >
> > Try `mdadm --examine` on every partition / drive that is giving you
> > trouble. Maybe you are remembering things wrong and the raid device is
> > /dev/sda and not /dev/sda1.
> >
> > You can also go through the entire list (/dev/sd*), you posted earlier.
> > There's no harm in running the command. It will look for the superblock
> > and tell you what has been found. This could provide the information yo=
u
> > need to assemble the array.
> >
> > Alternatively, leave sda1 out of the assembly and see if mdadm will be
> > able to partially assemble the array.
> >
> > -- Sandro
> >
>
