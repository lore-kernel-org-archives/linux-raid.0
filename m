Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAEA134A6
	for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 22:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706222246; cv=none; b=eLO69bs3xTTGooArnethq+s3ttvwaayVMVQ7JErWjkdHsWG6CCDw0CDryIx6Dvjl3mW3FNrWQBbp2bUo6+z7tpmhMABzzkfbY6nPxm97whdn3lE10un+OMat3byzespfPa9FAu7rkKAw/eYdJ2mSjVYa6E1YRzQ6DrM2gg3Z2ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706222246; c=relaxed/simple;
	bh=FuWPvMqhe2Cg+1FHQCTAo7BfiX60UrS6RsOwHwQw3vI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hW+vLwd33Ki0EGfXZ05QcqOer2yNtg2udwG9wvZcNqnrofE0h9YlD5KdJhh/e4IPPhpbNdQ+8Y0XhC16QXzUshiND92dplMNuGyoxvlq7MlKhH5T5J6XooPz/9orzeTJ2w9U26Pt6kCVORPohZImYF7tIn+hYbZbrcB9mQkilLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DqGH8jA+; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DqGH8jA+"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7bc332d3a8cso460997939f.2
        for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 14:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706222244; x=1706827044; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IBueexijrDMyUohaIFBcdRJzVVnuFfPAQtDPg/vzW60=;
        b=DqGH8jA+nDD6jcVls5zqYD9/IWiZKZiQNSNUE0FXIn78ecZ37TFHXcqSDRHzOPAd41
         UghMUQQmo2JBukQ5YMalIvCAjlsvTqwkADXkPzPk7E2jC1NwzAGnSCrixAG8Yj+dByix
         uz+K8Fob1jkc6kmGqbf3b499RJpKrcp4gCGkBZPGTvNHybMgNqEYG/vj0dNCJrSi8F0G
         NRUHu9NYDHjKd6J8eHPTX6QBLbVTDosGvMwvGd5jqZ1TgN/QZhv58tTPiO2YRlgLu8Oj
         4TBwi+GEE8ihdSlwMyfAjwHODL3YJhPYkKekX6IOW4A+GurCBU8sdnubEq8BKsfYVWhD
         yryA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706222244; x=1706827044;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IBueexijrDMyUohaIFBcdRJzVVnuFfPAQtDPg/vzW60=;
        b=byunHCRT+mLGnf5IKYvK1ylz3arIX3pj6n4YgRLn4wScTK75yZdNSxxxZ6szNv4Pud
         BMp5Fwr4ef8vMdpPwpcPh+zWA5f9SidNPTSBToUFBxc+gVgPA9MpVxh3UYrJH1Ve06ND
         d20Wm0WKoo9gSMhtQZYjSLb7dXIf2UrfThnISTo9QbnyeGBuOxs9k39sp8HV8jtGv2c0
         7C0bOQpJilDX4p+DuByE/Ehxy9fdesHUdId640Pu/M1UK2UmDC2cUeF2q+h3b4v03ji0
         ZFgUiPTT6Euz7OZEBUp8rV4fmrNUwoG+ks6Q3xTGs27WBR5vOmk17mCyDIDQ0cRxk9NU
         g46A==
X-Gm-Message-State: AOJu0YzSWnxErsILgRLGiQmnBqHkQScwROOkAtBJgu95lbVKxf58AD2s
	2aRKr8N9R3ny1lbllD++G5ozAPZiHZF63V/rtXbXXaZqKlmG3A5GkJh8zamcqzK6LRUsCfmhWVj
	8GOQKBVqVlKKqopBb36aMignVLfVc8a5PIDd02Q==
X-Google-Smtp-Source: AGHT+IEZS7c0HAMFMEMDHP7BFzjXeuRp1/vEKeb3oPkbcuLlvFcdKjjBWPWzVxvOJaeFFx/7AikON8zgPezS3gGpatI=
X-Received: by 2002:a5d:934d:0:b0:7be:f359:6b75 with SMTP id
 i13-20020a5d934d000000b007bef3596b75mr476850ioo.28.1706222244246; Thu, 25 Jan
 2024 14:37:24 -0800 (PST)
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
 <1700056512.428301.1706195329259@mail.yahoo.com> <CAAMCDefTxHVRNbhfyGuaoGXLs0=jKdLgd-rSdCXMpiBgYM-4iQ@mail.gmail.com>
 <1421467972.497057.1706207603224@mail.yahoo.com>
In-Reply-To: <1421467972.497057.1706207603224@mail.yahoo.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Thu, 25 Jan 2024 16:37:13 -0600
Message-ID: <CAAMCDedT1-ar56AQNKPX4xoHGEh4A3o7jHU6PBratxUKPDhv7g@mail.gmail.com>
Subject: Re: Requesting help recovering my array
To: RJ Marquette <rjm1@yahoo.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

If the one that is working right does not have a partition then
someway the partitioning got added teh the broken disks.  The
partition is a gpt partition which another indicated is about 16k
which would mean it overwrote the md header at 4k, and that header
being overwritten would cause the disk to no longer be raid members.

The create must have the disks in the correct order and with the
correct parameters,     Doing a random create with a random order is
unlikely to work, and may well make things unrecoverable.

I believe there are instructions on some page about md repairing that
talks about using overlays.   Using the overlays lets you create an
overlay such that the underlying devices aren't written to such that
you can test a number of different orders and parameters to find the
one that works.

I think this is the stuff about recovering and overlays that you want to fo=
llow.

https://raid.wiki.kernel.org/index.php/Irreversible_mdadm_failure_recovery


On Thu, Jan 25, 2024 at 12:41=E2=80=AFPM RJ Marquette <rjm1@yahoo.com> wrot=
e:
>
> No, this system does not have any other OS's installed on it, Debian Linu=
x only, as it's my server.
>
> No, the three drives remained connected to the extra controller card and =
were never removed from that card - I just pulled the card out of the case =
with the connections intact, and swung it off to the side.  In fact they st=
ill haven't been removed.
>
> I don't understand the partitions comment, as 5 of the 6 drives do appear=
 to have separate partitions for the data, and the one that doesn't is the =
only that seems to be responding normally.  I guess the theory is that what=
ever damaged the partition tables wrote a single primary partition to the d=
rive in the process?
>
> I do not know what caused this problem.  I've had no reason to run fdisk =
or any similar utility on that computer in years.  I know we want to figure=
 out why this happened, but I'd also like to recover my RAID, if possible.
>
> What are my options at this point?  Should I try something like this?  (T=
his is for someone's RAID1 setup, obviously the level and drives would chan=
ge for me.):
>
> mdadm --create --assume-clean --level=3D1 --raid-devices=3D2 /dev/md0 /de=
v/sda /dev/sdb
>
> That's from this page:  https://askubuntu.com/questions/1254561/md-raid-s=
uperblock-gets-deleted
>
> I'm currently running testdisk on one of the affected drives to see what =
that turns up.
>
> Thanks.
> --RJ
>
> On Thursday, January 25, 2024 at 12:43:58 PM EST, Roger Heflin <rogerhefl=
in@gmail.com> wrote:
>
>
>
>
>
> You never booted windows or any other non-linux boot image that might
> have decided to "fix" the disk's missing partition tables?
>
> And when messing with the install did you move the disks around so
> that some of the disk could have been on the intel controller with
> raid set at different times?
>
> That specific model of marvell controller does not list support raid,
> but other models in the same family do, so it may also have an option
> in the bios that "fixes" the partition table.
>
> Any number of id10t's writing tools may have wrongly decided that a
> disk without a partition table needs to be fixed.  I know the windows
> disk management used to (may still) complain about no partitions and
> prompt to "fix" it.
>
> I always run partitions on everything.  I have had the partition save
> me when 2 different vendors hardware raid controllers lost their
> config (random crash, freaked on on fw upgrade) and when the config
> was recreated seem to "helpfully" clear a few kb at the front of the
> disk.  Rescue boot, repartition, mount os lv, and reinstall grub
> fixed those.
>
> On Thu, Jan 25, 2024 at 9:17=E2=80=AFAM RJ Marquette <rjm1@yahoo.com> wro=
te:
> >
> > It's an ext4 RAID5 array.  No LVM, LUKS, etc.
> >
> > You make a good point about the BIOS explanation - it seems to have aff=
ected only the 5 RAID drives that had data on them, not the spare, nor the =
other system drive (and the latter two are both connected to the motherboar=
d).  How would it have decided to grab exactly those 5?
> >
> > Thanks.
> > --RJ
> >
> >
> > On Thursday, January 25, 2024 at 10:01:40 AM EST, Pascal Hambourg <pasc=
al@plouf.fr.eu.org> wrote:
> >
> >
> >
> >
> >
> > On 25/01/2024 at 12:49, RJ Marquette wrote:
> > > root@jackie:/home/rj# /sbin/fdisk -l /dev/sdb
> > > Disk /dev/sdb: 2.73 TiB, 3000592982016 bytes, 5860533168 sectors
> > > Disk model: Hitachi HUS72403
> > > Units: sectors of 1 * 512 =3D 512 bytes
> > > Sector size (logical/physical): 512 bytes / 4096 bytes
> > > I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> > > Disklabel type: gpt
> > > Disk identifier: AF5DC5DE-1404-4F4F-85AF-B5574CD9C627
> > >
> > > Device    Start        End    Sectors  Size Type
> > > /dev/sdb1  2048 5860532223 5860530176  2.7T Microsoft basic data
> > >
> > > root@jackie:/home/rj# cat /sys/block/sdb/sdb1/start
> > > 2048
> > > root@jackie:/home/rj# cat /sys/block/sdb/sdb1/size
> > > 5860530176
> >
> > The partition geometry looks correct, with standard alignment.
> > And the kernel view of the partition matches the partition table.
> > The partition type "Microsoft basic data" is neither "Linux RAID" nor
> > the default type "Linux flesystem" set by usual GNU/Linux partitioning
> > tools such as fdisk, parted and gdisk so it seems unlikely that the
> > partition was created with one of these tools.
> >
> >
> > >>> It looks like this is what happened after all.  I searched for "MBR
> > >>> Magic aa55" and found someone else with the same issue long ago:
> > >>> https://serverfault.com/questions/580761/is-mdadm-raid-toast  Looks=
 like
> > >>> his was caused by a RAID configuration option in BIOS.  I recall se=
eing
> > >>> that on mine; I must have activated it by accident when setting the=
 boot
> > >>> drive or something.
> >
> >
> > I am a bit suspicious about this cause for two reasons:
> > - sde, sdf and sdg are affected even though they are connected to the
> > add-on Marvell SATA controller card which is supposed to be outside the
> > motherboard RAID scope;
> > - sdc is not affected even though it is connected to the onboard Intel
> > SATA controller.
> >
> > What was contents type of the RAID array ? LVM, LUKS, plain filesystem =
?
> >
>
