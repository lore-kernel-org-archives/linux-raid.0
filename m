Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BB911187
	for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 23:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706223630; cv=none; b=ZEeEmpkeo4DNMmLQjq0F0sGkSnLrT3c9vfymblMFmkGIySxm65Qtw6RlQqO/pD3ESqIW9igllKhPaGDNLZPqpwPnAmKFeAOBFVop3lgJJNw+DrGEaW4Spy7lqSK02NEVYPNugiHpmT4T38uj2FN6R8DqLuTI2LNDIMSecucDUyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706223630; c=relaxed/simple;
	bh=ENJLxeVKvpMoSlr6wwdEUD75nTWOSyULYdscwlyH6Pw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RgksAPPIjq6IVGu/WZk2B6BCZ2HlsII16khMkraUbY7xOFf0IDI8Hmjbndyng3ngp4jA2hanwILBjI7TyqttD5ZVBQtpvq1YFlhq3Rqo7BRUcqz7v6uQGkM7tJlWaHV2wYdbQKH1bRFeyzENYmX4boojJxaUQiKxwMsNHglZQ44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jf3KvRzy; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jf3KvRzy"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-362a0b95874so5556045ab.0
        for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 15:00:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706223627; x=1706828427; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dRKdNtq6DI15McNSGbgUqOc4PbWbapzq/uTSWvoGfgU=;
        b=Jf3KvRzyjyDiBCOLyWA+bcTwDh1Pwe6oSoKd9Er1lx6OjKlXGjaiXtLT0g/Hq4R3ZO
         JsmhXDCZtbcfgTjN5Q9dmmQ3iHTbeL41XaHwwNDIpGZ6Tsn7dPkO2/JdgSNw+30rA37C
         xEa3hkSmrLrsfBKejzROo3p0RTxanpoTllRpoMlMytgpzoK4Nf/o7Y0wGHxcG3TIRlCE
         vchoNF/gNLP+Y3nfGWtdSP5STgNlYoESkfuaM1wCY4WTXdX2k+DBxNEKeOSnuW0/X0qB
         vjAM/v76olp0PtDKKVo8F+mFBtAMSzsIiYdSx+mWHhaukN1l7VwIUsp0+7h9pJ7l/oZ5
         v+sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706223627; x=1706828427;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dRKdNtq6DI15McNSGbgUqOc4PbWbapzq/uTSWvoGfgU=;
        b=rpaaLX8I9NBMNmWOLaTCmp80RkdlGcxsWPUpXnM+KJtTh2iIPhPQvqWYlohRTfUyWg
         VPY+K4AToofl/lJNlKvKnsL0KVc7+O5+Z7Iabfx+8LbC8qCoV1Z+Ey2yjKzsa67Ve79K
         ZctY2FWiKfbitMP9GCdBvrqPKBzIUJvi7GLsjLWDCNnZL5EGtxXzMk3uDkHs1FlUKOsK
         oiNphyhHiZ7PKlcUKMBI+Dtl0yHoCBxgcPwqomGqiBnaoctpeC4k0dzZEE41zyy+VYjl
         R9+ZtD37rkqsO0WOm8t5Ws8On0KTyTAib8adyRr9n2ZQYmc6TaKwTtcLd6Zi8Y+jNIWg
         0GNw==
X-Gm-Message-State: AOJu0Yw8fb1gDViY4eFyhdyhVdS2ks9hzzJzlFc/1DgtF2EzuKNBbGQf
	en+qXbKMzEuGI0U7glEuwRGxWL/Ld7DxyVFo2znkJeiSjK7G8S9P6Nb/tIsc3Fnhs8tPGKKvm9r
	Eul9YhNgVBJ/p31iBYB7hV4iOZqeRoRzfnPw=
X-Google-Smtp-Source: AGHT+IFwinXb11yINlLUMPrH/Q805fYCVkSBegz1wJRjfKBNm0CTPxcg5+rZq8Shqx70zxo43vtqUwLAj5YZ44kvxCk=
X-Received: by 2002:a05:6e02:1c27:b0:361:9832:40dc with SMTP id
 m7-20020a056e021c2700b00361983240dcmr484310ilh.83.1706223626905; Thu, 25 Jan
 2024 15:00:26 -0800 (PST)
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
 <1421467972.497057.1706207603224@mail.yahoo.com> <CAAMCDedT1-ar56AQNKPX4xoHGEh4A3o7jHU6PBratxUKPDhv7g@mail.gmail.com>
 <CAAMCDef11MgVfeH07T+CNu9AE8hZ6fHiMh=Zdr7BQXD_CDwMwg@mail.gmail.com>
In-Reply-To: <CAAMCDef11MgVfeH07T+CNu9AE8hZ6fHiMh=Zdr7BQXD_CDwMwg@mail.gmail.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Thu, 25 Jan 2024 17:00:16 -0600
Message-ID: <CAAMCDefv8XuxJqDOCQV+u80TT+Jnr8fVik+vzhc7NWy+NPU=Cw@mail.gmail.com>
Subject: Re: Requesting help recovering my array
To: RJ Marquette <rjm1@yahoo.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

looking further gpt may simply clear all it could use.

So you may need to look at the first 16k and clear on the overlay that
16k before the test.

On Thu, Jan 25, 2024 at 4:53=E2=80=AFPM Roger Heflin <rogerheflin@gmail.com=
> wrote:
>
> and given the partition table probably eliminated the disk superblocks
> step #1 would be to overlay sdX (not sdx1) and remove the partition
> from the overlay and begin testing.
>
> The first test may be simply the dd if=3D/dev/zero of=3Doverlaydisk bs=3D=
256
> count=3D8 as looking at the gpt partitions I have says that will
> eliminate that header and then try an --examine and see if that finds
> anything, if that works you won't need to go into the assume clean
> stuff which simplifies everything.
>
> My checking says the gpt partition table seems to start 256bytes in
> and stops before about 2k in before hex 1000(4k) where the md header
> seems to be located on mine.
>
>
>
> On Thu, Jan 25, 2024 at 4:37=E2=80=AFPM Roger Heflin <rogerheflin@gmail.c=
om> wrote:
> >
> > If the one that is working right does not have a partition then
> > someway the partitioning got added teh the broken disks.  The
> > partition is a gpt partition which another indicated is about 16k
> > which would mean it overwrote the md header at 4k, and that header
> > being overwritten would cause the disk to no longer be raid members.
> >
> > The create must have the disks in the correct order and with the
> > correct parameters,     Doing a random create with a random order is
> > unlikely to work, and may well make things unrecoverable.
> >
> > I believe there are instructions on some page about md repairing that
> > talks about using overlays.   Using the overlays lets you create an
> > overlay such that the underlying devices aren't written to such that
> > you can test a number of different orders and parameters to find the
> > one that works.
> >
> > I think this is the stuff about recovering and overlays that you want t=
o follow.
> >
> > https://raid.wiki.kernel.org/index.php/Irreversible_mdadm_failure_recov=
ery
> >
> >
> > On Thu, Jan 25, 2024 at 12:41=E2=80=AFPM RJ Marquette <rjm1@yahoo.com> =
wrote:
> > >
> > > No, this system does not have any other OS's installed on it, Debian =
Linux only, as it's my server.
> > >
> > > No, the three drives remained connected to the extra controller card =
and were never removed from that card - I just pulled the card out of the c=
ase with the connections intact, and swung it off to the side.  In fact the=
y still haven't been removed.
> > >
> > > I don't understand the partitions comment, as 5 of the 6 drives do ap=
pear to have separate partitions for the data, and the one that doesn't is =
the only that seems to be responding normally.  I guess the theory is that =
whatever damaged the partition tables wrote a single primary partition to t=
he drive in the process?
> > >
> > > I do not know what caused this problem.  I've had no reason to run fd=
isk or any similar utility on that computer in years.  I know we want to fi=
gure out why this happened, but I'd also like to recover my RAID, if possib=
le.
> > >
> > > What are my options at this point?  Should I try something like this?=
  (This is for someone's RAID1 setup, obviously the level and drives would =
change for me.):
> > >
> > > mdadm --create --assume-clean --level=3D1 --raid-devices=3D2 /dev/md0=
 /dev/sda /dev/sdb
> > >
> > > That's from this page:  https://askubuntu.com/questions/1254561/md-ra=
id-superblock-gets-deleted
> > >
> > > I'm currently running testdisk on one of the affected drives to see w=
hat that turns up.
> > >
> > > Thanks.
> > > --RJ
> > >
> > > On Thursday, January 25, 2024 at 12:43:58 PM EST, Roger Heflin <roger=
heflin@gmail.com> wrote:
> > >
> > >
> > >
> > >
> > >
> > > You never booted windows or any other non-linux boot image that might
> > > have decided to "fix" the disk's missing partition tables?
> > >
> > > And when messing with the install did you move the disks around so
> > > that some of the disk could have been on the intel controller with
> > > raid set at different times?
> > >
> > > That specific model of marvell controller does not list support raid,
> > > but other models in the same family do, so it may also have an option
> > > in the bios that "fixes" the partition table.
> > >
> > > Any number of id10t's writing tools may have wrongly decided that a
> > > disk without a partition table needs to be fixed.  I know the windows
> > > disk management used to (may still) complain about no partitions and
> > > prompt to "fix" it.
> > >
> > > I always run partitions on everything.  I have had the partition save
> > > me when 2 different vendors hardware raid controllers lost their
> > > config (random crash, freaked on on fw upgrade) and when the config
> > > was recreated seem to "helpfully" clear a few kb at the front of the
> > > disk.  Rescue boot, repartition, mount os lv, and reinstall grub
> > > fixed those.
> > >
> > > On Thu, Jan 25, 2024 at 9:17=E2=80=AFAM RJ Marquette <rjm1@yahoo.com>=
 wrote:
> > > >
> > > > It's an ext4 RAID5 array.  No LVM, LUKS, etc.
> > > >
> > > > You make a good point about the BIOS explanation - it seems to have=
 affected only the 5 RAID drives that had data on them, not the spare, nor =
the other system drive (and the latter two are both connected to the mother=
board).  How would it have decided to grab exactly those 5?
> > > >
> > > > Thanks.
> > > > --RJ
> > > >
> > > >
> > > > On Thursday, January 25, 2024 at 10:01:40 AM EST, Pascal Hambourg <=
pascal@plouf.fr.eu.org> wrote:
> > > >
> > > >
> > > >
> > > >
> > > >
> > > > On 25/01/2024 at 12:49, RJ Marquette wrote:
> > > > > root@jackie:/home/rj# /sbin/fdisk -l /dev/sdb
> > > > > Disk /dev/sdb: 2.73 TiB, 3000592982016 bytes, 5860533168 sectors
> > > > > Disk model: Hitachi HUS72403
> > > > > Units: sectors of 1 * 512 =3D 512 bytes
> > > > > Sector size (logical/physical): 512 bytes / 4096 bytes
> > > > > I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> > > > > Disklabel type: gpt
> > > > > Disk identifier: AF5DC5DE-1404-4F4F-85AF-B5574CD9C627
> > > > >
> > > > > Device    Start        End    Sectors  Size Type
> > > > > /dev/sdb1  2048 5860532223 5860530176  2.7T Microsoft basic data
> > > > >
> > > > > root@jackie:/home/rj# cat /sys/block/sdb/sdb1/start
> > > > > 2048
> > > > > root@jackie:/home/rj# cat /sys/block/sdb/sdb1/size
> > > > > 5860530176
> > > >
> > > > The partition geometry looks correct, with standard alignment.
> > > > And the kernel view of the partition matches the partition table.
> > > > The partition type "Microsoft basic data" is neither "Linux RAID" n=
or
> > > > the default type "Linux flesystem" set by usual GNU/Linux partition=
ing
> > > > tools such as fdisk, parted and gdisk so it seems unlikely that the
> > > > partition was created with one of these tools.
> > > >
> > > >
> > > > >>> It looks like this is what happened after all.  I searched for =
"MBR
> > > > >>> Magic aa55" and found someone else with the same issue long ago=
:
> > > > >>> https://serverfault.com/questions/580761/is-mdadm-raid-toast  L=
ooks like
> > > > >>> his was caused by a RAID configuration option in BIOS.  I recal=
l seeing
> > > > >>> that on mine; I must have activated it by accident when setting=
 the boot
> > > > >>> drive or something.
> > > >
> > > >
> > > > I am a bit suspicious about this cause for two reasons:
> > > > - sde, sdf and sdg are affected even though they are connected to t=
he
> > > > add-on Marvell SATA controller card which is supposed to be outside=
 the
> > > > motherboard RAID scope;
> > > > - sdc is not affected even though it is connected to the onboard In=
tel
> > > > SATA controller.
> > > >
> > > > What was contents type of the RAID array ? LVM, LUKS, plain filesys=
tem ?
> > > >
> > >
