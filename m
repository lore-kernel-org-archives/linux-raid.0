Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C141E861
	for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 17:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706204627; cv=none; b=tNP0d5MNRb6d+cbF5nr5WRETRF22kpP16Fac5Ha38ciopMeWBWOVb9B47UyEvFbBf/gatjf7NmFNV16U6bnmWFHbi5ai6P/7q9MyIcQEZWQAmGwBSzNIaOLxuwGMJTG5yNK0r3wBnyFRpzKiEaoIgW4S1seR/GyrjDc7w9Dsmfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706204627; c=relaxed/simple;
	bh=4iDvoYVj5KnTuDUW5Tv73M9ZqxG9/Bfq1s7wgk+iRvI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XM6WacsWjbcgbNQkz6zenIuXy8FfdXOh1r3x+S1ShOaKbtXxioAuYxwCRRKP5js5skoDUeK3uno9AtJoRAmvRzAV5Y6Uu27K+X1b+elZ6OsduKU2XrnGFJbtt3di/DATD/7kOyd77QU1qQCY6VJhac3/wTs2PLTSSe8ZNHikyoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gr96JAhg; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gr96JAhg"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7baa8da5692so317140439f.0
        for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 09:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706204624; x=1706809424; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q7LGiqVU/JyUjB4u4/P1gfCAEhJf0y+m37WP2BeRLcY=;
        b=Gr96JAhg413pRjqwP1QZzCGprgCzc7DKffzt2az1nm0CUEwKDQdHvEVZYqGEZmEwBt
         OhRJyzipWPquvTRF5ZKDdZsz5BeNBsZqb3NjuYVoA+0C8xiif3ImjtgCoXcWrlMIqBVd
         x2G1NratUVYvWqD+ONTMGKHO1D/ERroajDsXHemokC2MUEnxPGxqTKVsoCG1ibDVMp1y
         q/CGkpY09quClz+rZ8iPKukrnBr7u9MH8nxQgsS1KiUVBFBMu+h1xqdHNFRgZa0CdlSs
         MkD4TIflMEnBSZJpEtpMVGGW2UtU842z3OTde9NusEuawnDdXEmY/xuiD/U2hc87zuG3
         3VbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706204624; x=1706809424;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q7LGiqVU/JyUjB4u4/P1gfCAEhJf0y+m37WP2BeRLcY=;
        b=oeE1LUsiVmXtyRwnjkSDrzBCur/YNjExp1QjvUWyBtZtbIQRO2Ftjg3GdFXnx5XQgw
         azqFXTzopNV7VCyQ6Vra1YzPF59PQxgnAdBh7RHFlbilieyCMltM/xiphf26CyFb/LNe
         VoDyFeOxQ7lKtJANqRgtDfuSGbWtgi2XfU3N0VYnFduYOFQiYRj2GYiYa40Cxn+06kmy
         LBc1noNuMdzonzNoz2DaxU9QPnl6pthIZgilK9W81uT1qva2peWyUOEctjWUDxSXRD7T
         af/8eU8t5HSsjmz+6gOlgx/addldq/PeqcTL48UdIFQP8I7Pkey331XxiHI+Nrlakro2
         kkeA==
X-Gm-Message-State: AOJu0YxxSlOI1G6D2si1+5tspcZNn649CR4i2PrySZ6/mjzVZGZZPoNq
	QQy30rpD07EyyHBkNDqNzjmZgRlcEVrYX/TVAaA8o8yig/p75BXVD50vxBdOFWiEv9NpsOgHlt6
	fYiG3N0h0L1zOsZKxjVsZUopqNbM=
X-Google-Smtp-Source: AGHT+IGUKsqChD239y1cSBPrH9r6wwk1EtvIP3tC1IZG8ePGbv+6tb8Z3V+xQDpxAqeIldIHB4oHlvk5VXpSqeGgVhA=
X-Received: by 2002:a5e:8341:0:b0:7ba:cb37:3e38 with SMTP id
 y1-20020a5e8341000000b007bacb373e38mr173530iom.10.1706204624143; Thu, 25 Jan
 2024 09:43:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <432300551.863689.1705953121879.ref@mail.yahoo.com>
 <04757cef-9edf-449a-93ab-a0534a821dc6@thelounge.net> <1085291040.906901.1705961588972@mail.yahoo.com>
 <0f28b23e-54f2-49ed-9149-87dbe3cffb30@thelounge.net> <598555968.936049.1705968542252@mail.yahoo.com>
 <755754794.951974.1705974751281@mail.yahoo.com> <20240123110624.1b625180@firefly>
 <12445908.1094378.1706026572835@mail.yahoo.com> <20240123221935.683eb1eb@firefly>
 <1979173383.106122.1706098632056@mail.yahoo.com> <006fe0ca-a2fb-4ccd-b4d4-c01945d72661@penguinpee.nl>
 <2058198167.201827.1706119581305@mail.yahoo.com> <CAAMCDef52pGpqOpOFRW8LAyiXtaJNzDderb7KLx8GR0BqP2epg@mail.gmail.com>
 <544664840.269616.1706131905741@mail.yahoo.com> <CAAMCDecCCCH9oOtx08g-yLwo_8JCHMkyUKu-f91du7O40wy+EA@mail.gmail.com>
 <5112393.323817.1706145196938@mail.yahoo.com> <CAAMCDefBd2qToWacy9HTs8UmimVi6eKgADg=BN7RkCnfE7Cirg@mail.gmail.com>
 <efa91e20-0c84-4652-8652-94270c63a52d@plouf.fr.eu.org> <1822211334.391999.1706183367969@mail.yahoo.com>
 <ab04e35d-b099-441b-b829-428a2c9c2dd8@plouf.fr.eu.org> <1700056512.428301.1706195329259@mail.yahoo.com>
In-Reply-To: <1700056512.428301.1706195329259@mail.yahoo.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Thu, 25 Jan 2024 11:43:33 -0600
Message-ID: <CAAMCDefTxHVRNbhfyGuaoGXLs0=jKdLgd-rSdCXMpiBgYM-4iQ@mail.gmail.com>
Subject: Re: Requesting help recovering my array
To: RJ Marquette <rjm1@yahoo.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

You never booted windows or any other non-linux boot image that might
have decided to "fix" the disk's missing partition tables?

And when messing with the install did you move the disks around so
that some of the disk could have been on the intel controller with
raid set at different times?

That specific model of marvell controller does not list support raid,
but other models in the same family do, so it may also have an option
in the bios that "fixes" the partition table.

Any number of id10t's writing tools may have wrongly decided that a
disk without a partition table needs to be fixed.  I know the windows
disk management used to (may still) complain about no partitions and
prompt to "fix" it.

I always run partitions on everything.   I have had the partition save
me when 2 different vendors hardware raid controllers lost their
config (random crash, freaked on on fw upgrade) and when the config
was recreated seem to "helpfully" clear a few kb at the front of the
disk.   Rescue boot, repartition, mount os lv, and reinstall grub
fixed those.

On Thu, Jan 25, 2024 at 9:17=E2=80=AFAM RJ Marquette <rjm1@yahoo.com> wrote=
:
>
> It's an ext4 RAID5 array.  No LVM, LUKS, etc.
>
> You make a good point about the BIOS explanation - it seems to have affec=
ted only the 5 RAID drives that had data on them, not the spare, nor the ot=
her system drive (and the latter two are both connected to the motherboard)=
.  How would it have decided to grab exactly those 5?
>
> Thanks.
> --RJ
>
>
> On Thursday, January 25, 2024 at 10:01:40 AM EST, Pascal Hambourg <pascal=
@plouf.fr.eu.org> wrote:
>
>
>
>
>
> On 25/01/2024 at 12:49, RJ Marquette wrote:
> > root@jackie:/home/rj# /sbin/fdisk -l /dev/sdb
> > Disk /dev/sdb: 2.73 TiB, 3000592982016 bytes, 5860533168 sectors
> > Disk model: Hitachi HUS72403
> > Units: sectors of 1 * 512 =3D 512 bytes
> > Sector size (logical/physical): 512 bytes / 4096 bytes
> > I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> > Disklabel type: gpt
> > Disk identifier: AF5DC5DE-1404-4F4F-85AF-B5574CD9C627
> >
> > Device     Start        End    Sectors  Size Type
> > /dev/sdb1   2048 5860532223 5860530176  2.7T Microsoft basic data
> >
> > root@jackie:/home/rj# cat /sys/block/sdb/sdb1/start
> > 2048
> > root@jackie:/home/rj# cat /sys/block/sdb/sdb1/size
> > 5860530176
>
> The partition geometry looks correct, with standard alignment.
> And the kernel view of the partition matches the partition table.
> The partition type "Microsoft basic data" is neither "Linux RAID" nor
> the default type "Linux flesystem" set by usual GNU/Linux partitioning
> tools such as fdisk, parted and gdisk so it seems unlikely that the
> partition was created with one of these tools.
>
>
> >>> It looks like this is what happened after all.  I searched for "MBR
> >>> Magic aa55" and found someone else with the same issue long ago:
> >>> https://serverfault.com/questions/580761/is-mdadm-raid-toast  Looks l=
ike
> >>> his was caused by a RAID configuration option in BIOS.  I recall seei=
ng
> >>> that on mine; I must have activated it by accident when setting the b=
oot
> >>> drive or something.
>
>
> I am a bit suspicious about this cause for two reasons:
> - sde, sdf and sdg are affected even though they are connected to the
> add-on Marvell SATA controller card which is supposed to be outside the
> motherboard RAID scope;
> - sdc is not affected even though it is connected to the onboard Intel
> SATA controller.
>
> What was contents type of the RAID array ? LVM, LUKS, plain filesystem ?
>
