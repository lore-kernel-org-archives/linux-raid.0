Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F48125AE
	for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 22:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706223208; cv=none; b=i7GjC7TnZCZkWOC4RVPSBSn0H7MyZRdeSvwafjtXAralEw6ZKAzbxTxUxabykVTILexPUFgk5wlaO+SaXv9/27TJPk1dl1SuD7OsvcOT9ZF8PESkipfOAKqjq9zf8DV4ZqYwe8DtOUXvqrh7YfYhS0hGNBTZwmTwJ+8asoFYNV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706223208; c=relaxed/simple;
	bh=b9dpEYY6dysezY2skydNfLV6TdBDcs/HF0Jee1mk5Kk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JdUXRxmglVIp5FcIez4fP+/gBxWxKJlt8rfkbaGk3P37w4/lmEfFjZLJtUIrTg6fJUYQDCtcdvPtf/xfr8AXBbk2T4oWqLPW4AI49O5V8S46yeY7xMFPhBC6ivbH7cAuSNhnG5/B+N+2WBRkVqp/YYkxMnY+WSWKDoY9naAZ8xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xie22YHv; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xie22YHv"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7bbec1d1c9dso335959239f.1
        for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 14:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706223203; x=1706828003; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U68voOzBY+6bw36ji1Hz7fQtszcCiRR1bCbYFj7GFSg=;
        b=Xie22YHvRsU6LewE1zE0DEXporzzj/sBK3r0v2CI0LUhTs32wmaOHr8iarf+9CcQCr
         wO+VPBrWhCWeK+39xix0xj1l5uY4T1flOYMJJh3Cf4tkUheW6zV0cE/4xjATFaN086Hz
         PjWVbaTeR7+Mk9muEkcumtROoANiWX/PQyU6+SkPj6ZRoCLhJyVqlmtFnU5pGrUyKomh
         veEqFqUPBSc3WcfJblCZhXp47QxkfM8i9JfKKsMNgY75FWAkrfdrj38J3Tmnx/772b80
         trrn0ARJzzFR54LYhaLS77rOx0zA0rycGnHoEFcaV0bMS8M2W1R4pYsJdjusvhE5GYJ3
         8hvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706223203; x=1706828003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U68voOzBY+6bw36ji1Hz7fQtszcCiRR1bCbYFj7GFSg=;
        b=uj9d8vQbxeTASpgZ7/xeD++g51sjugO3wQYV0AF3P8IJCXNiCYOqyWxRvf8NbM+9w5
         XhteRON+8ivIim+zpBk2P4u9ProUBdnKErmOG5FlXe4x5SWgTRDZvdYZeVnrr+WolkTn
         vaBokpBMI5oEXMcwk+TyGN+OjZoW4Fpgzne7prwbLS4JqNlFPlwLtJWUud2mtV/+An+k
         LuzyfI7HFXj0WUYuhJ8Y/YEO4uIjW0WFu3q6C63LFfToqM6oxTLBTYfQBU5rYsAvJ78t
         F2aKR42Sr82ol4qcdhkIaUnC7+fbUB/ylzcrELdFDMuB3oMWHCHMJpjp7bOaXDt9AcYL
         axdA==
X-Gm-Message-State: AOJu0YwukRWxvC8tXIIx3h/seQGco/6Fnk0jlZ8q+b4L1Hn8Pjdm/Ujy
	dv5iZw6Q+xmFIDT2AM5XF4nTsXoYQETFyS4jzBdgyonxVru5eQGpwC2O/mSdedHJgw4YBHuSQE+
	LLWPhWQXEU92bFfRJaVbg1EuLilFUeAFCTNc=
X-Google-Smtp-Source: AGHT+IGBQSqSAxbMBqRJ1BVlpz/vYjwAfW+xMdTbpTXrennug0zLkZdxN08ntPHPc3FkicdTP/bqg8CsDW++6mIqR4I=
X-Received: by 2002:a05:6602:2563:b0:7bf:c4b9:66d8 with SMTP id
 dj3-20020a056602256300b007bfc4b966d8mr27818iob.5.1706223202864; Thu, 25 Jan
 2024 14:53:22 -0800 (PST)
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
In-Reply-To: <CAAMCDedT1-ar56AQNKPX4xoHGEh4A3o7jHU6PBratxUKPDhv7g@mail.gmail.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Thu, 25 Jan 2024 16:53:12 -0600
Message-ID: <CAAMCDef11MgVfeH07T+CNu9AE8hZ6fHiMh=Zdr7BQXD_CDwMwg@mail.gmail.com>
Subject: Re: Requesting help recovering my array
To: RJ Marquette <rjm1@yahoo.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

and given the partition table probably eliminated the disk superblocks
step #1 would be to overlay sdX (not sdx1) and remove the partition
from the overlay and begin testing.

The first test may be simply the dd if=3D/dev/zero of=3Doverlaydisk bs=3D25=
6
count=3D8 as looking at the gpt partitions I have says that will
eliminate that header and then try an --examine and see if that finds
anything, if that works you won't need to go into the assume clean
stuff which simplifies everything.

My checking says the gpt partition table seems to start 256bytes in
and stops before about 2k in before hex 1000(4k) where the md header
seems to be located on mine.



On Thu, Jan 25, 2024 at 4:37=E2=80=AFPM Roger Heflin <rogerheflin@gmail.com=
> wrote:
>
> If the one that is working right does not have a partition then
> someway the partitioning got added teh the broken disks.  The
> partition is a gpt partition which another indicated is about 16k
> which would mean it overwrote the md header at 4k, and that header
> being overwritten would cause the disk to no longer be raid members.
>
> The create must have the disks in the correct order and with the
> correct parameters,     Doing a random create with a random order is
> unlikely to work, and may well make things unrecoverable.
>
> I believe there are instructions on some page about md repairing that
> talks about using overlays.   Using the overlays lets you create an
> overlay such that the underlying devices aren't written to such that
> you can test a number of different orders and parameters to find the
> one that works.
>
> I think this is the stuff about recovering and overlays that you want to =
follow.
>
> https://raid.wiki.kernel.org/index.php/Irreversible_mdadm_failure_recover=
y
>
>
> On Thu, Jan 25, 2024 at 12:41=E2=80=AFPM RJ Marquette <rjm1@yahoo.com> wr=
ote:
> >
> > No, this system does not have any other OS's installed on it, Debian Li=
nux only, as it's my server.
> >
> > No, the three drives remained connected to the extra controller card an=
d were never removed from that card - I just pulled the card out of the cas=
e with the connections intact, and swung it off to the side.  In fact they =
still haven't been removed.
> >
> > I don't understand the partitions comment, as 5 of the 6 drives do appe=
ar to have separate partitions for the data, and the one that doesn't is th=
e only that seems to be responding normally.  I guess the theory is that wh=
atever damaged the partition tables wrote a single primary partition to the=
 drive in the process?
> >
> > I do not know what caused this problem.  I've had no reason to run fdis=
k or any similar utility on that computer in years.  I know we want to figu=
re out why this happened, but I'd also like to recover my RAID, if possible=
.
> >
> > What are my options at this point?  Should I try something like this?  =
(This is for someone's RAID1 setup, obviously the level and drives would ch=
ange for me.):
> >
> > mdadm --create --assume-clean --level=3D1 --raid-devices=3D2 /dev/md0 /=
dev/sda /dev/sdb
> >
> > That's from this page:  https://askubuntu.com/questions/1254561/md-raid=
-superblock-gets-deleted
> >
> > I'm currently running testdisk on one of the affected drives to see wha=
t that turns up.
> >
> > Thanks.
> > --RJ
> >
> > On Thursday, January 25, 2024 at 12:43:58 PM EST, Roger Heflin <rogerhe=
flin@gmail.com> wrote:
> >
> >
> >
> >
> >
> > You never booted windows or any other non-linux boot image that might
> > have decided to "fix" the disk's missing partition tables?
> >
> > And when messing with the install did you move the disks around so
> > that some of the disk could have been on the intel controller with
> > raid set at different times?
> >
> > That specific model of marvell controller does not list support raid,
> > but other models in the same family do, so it may also have an option
> > in the bios that "fixes" the partition table.
> >
> > Any number of id10t's writing tools may have wrongly decided that a
> > disk without a partition table needs to be fixed.  I know the windows
> > disk management used to (may still) complain about no partitions and
> > prompt to "fix" it.
> >
> > I always run partitions on everything.  I have had the partition save
> > me when 2 different vendors hardware raid controllers lost their
> > config (random crash, freaked on on fw upgrade) and when the config
> > was recreated seem to "helpfully" clear a few kb at the front of the
> > disk.  Rescue boot, repartition, mount os lv, and reinstall grub
> > fixed those.
> >
> > On Thu, Jan 25, 2024 at 9:17=E2=80=AFAM RJ Marquette <rjm1@yahoo.com> w=
rote:
> > >
> > > It's an ext4 RAID5 array.  No LVM, LUKS, etc.
> > >
> > > You make a good point about the BIOS explanation - it seems to have a=
ffected only the 5 RAID drives that had data on them, not the spare, nor th=
e other system drive (and the latter two are both connected to the motherbo=
ard).  How would it have decided to grab exactly those 5?
> > >
> > > Thanks.
> > > --RJ
> > >
> > >
> > > On Thursday, January 25, 2024 at 10:01:40 AM EST, Pascal Hambourg <pa=
scal@plouf.fr.eu.org> wrote:
> > >
> > >
> > >
> > >
> > >
> > > On 25/01/2024 at 12:49, RJ Marquette wrote:
> > > > root@jackie:/home/rj# /sbin/fdisk -l /dev/sdb
> > > > Disk /dev/sdb: 2.73 TiB, 3000592982016 bytes, 5860533168 sectors
> > > > Disk model: Hitachi HUS72403
> > > > Units: sectors of 1 * 512 =3D 512 bytes
> > > > Sector size (logical/physical): 512 bytes / 4096 bytes
> > > > I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> > > > Disklabel type: gpt
> > > > Disk identifier: AF5DC5DE-1404-4F4F-85AF-B5574CD9C627
> > > >
> > > > Device    Start        End    Sectors  Size Type
> > > > /dev/sdb1  2048 5860532223 5860530176  2.7T Microsoft basic data
> > > >
> > > > root@jackie:/home/rj# cat /sys/block/sdb/sdb1/start
> > > > 2048
> > > > root@jackie:/home/rj# cat /sys/block/sdb/sdb1/size
> > > > 5860530176
> > >
> > > The partition geometry looks correct, with standard alignment.
> > > And the kernel view of the partition matches the partition table.
> > > The partition type "Microsoft basic data" is neither "Linux RAID" nor
> > > the default type "Linux flesystem" set by usual GNU/Linux partitionin=
g
> > > tools such as fdisk, parted and gdisk so it seems unlikely that the
> > > partition was created with one of these tools.
> > >
> > >
> > > >>> It looks like this is what happened after all.  I searched for "M=
BR
> > > >>> Magic aa55" and found someone else with the same issue long ago:
> > > >>> https://serverfault.com/questions/580761/is-mdadm-raid-toast  Loo=
ks like
> > > >>> his was caused by a RAID configuration option in BIOS.  I recall =
seeing
> > > >>> that on mine; I must have activated it by accident when setting t=
he boot
> > > >>> drive or something.
> > >
> > >
> > > I am a bit suspicious about this cause for two reasons:
> > > - sde, sdf and sdg are affected even though they are connected to the
> > > add-on Marvell SATA controller card which is supposed to be outside t=
he
> > > motherboard RAID scope;
> > > - sdc is not affected even though it is connected to the onboard Inte=
l
> > > SATA controller.
> > >
> > > What was contents type of the RAID array ? LVM, LUKS, plain filesyste=
m ?
> > >
> >
