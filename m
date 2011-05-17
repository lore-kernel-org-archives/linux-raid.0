From: NeilBrown <neilb@suse.de>
Subject: Re: permanently removing a spare
Date: Wed, 18 May 2011 05:44:14 +1000
Message-ID: <20110518054414.3df34a76@notabene.brown>
References: <BANLkTinbk9VMuiLNUA8VW-gE1Znbf9caWA@mail.gmail.com>
	<BANLkTim+8mu9xuUsQvCXPXUSVLfpveGofg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTim+8mu9xuUsQvCXPXUSVLfpveGofg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tobias McNulty <tobias@caktusgroup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 17 May 2011 15:09:18 -0400 Tobias McNulty <tobias@caktusgroup.c=
om>
wrote:

> On Wed, May 11, 2011 at 9:49 PM, Tobias McNulty <tobias@caktusgroup.c=
om> wrote:
> >
> > Hi all,
> >
> > After successfully converting my raid6 array to raid5, I of course
> > neglected to update mdadm.conf, so the array was absent on reboot. =
=A0A
> > quick mdadm --assemble brought the array back online.
> >
> > However, now I am trying to update mdadm.conf, and I hit what I thi=
nk
> > is this bug:
> >
> > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D610184
> >
> > So I thought I'd try to remove the spare from my raid5 array. =A0I
> > marked it as failed and then removed it, and the spare no longer sh=
ows
> > in /proc/mdstat:
> >
> > md0 : active raid5 sda[0] sdd[3] sdc[2] sdb[1]
> > =A0 =A0 =A05860543488 blocks level 5, 64k chunk, algorithm 2 [4/4] =
[UUUU]
> >
> > However, when I do mdadm -Es, I still see it:
> >
> > ARRAY /dev/md0 UUID=3D25a818ff:68f07e28:0d7656f3:2f233380
> > =A0 spares=3D1
> >
> > And I still see the "error: superfluous RAID member (4 found)." err=
or
> > when running update-grub (even if I leave out the spares=3D1 part).
> >
> > Is there a way to "permanently" remove the spare "slot" from the
> > array? =A0I tried mdadm --grow --spare-devices=3D0, since the man p=
age
> > arguably suggests that --spare-devices should work in grow mode, bu=
t
> > running the command reports that it's not actually supported. =A0To=
 the
> > credit of the man page, the description of --spare-devices *does* s=
ay
> > it is used in the *initial* array creation.
> >
> > Does what I'm trying to do make sense? =A0Is there a way to make th=
e
> > array forget that it ever had a spare in the first place?
> >
> > I'm a little afraid to reboot until I get this figured out.
>=20
> Hey all - I think I am missing something obvious but I am not sure
> what it is, and I still haven't turned up anything in my own
> searching.
>=20
> Do you have any advice for what I need to do so that the array is
> mounted automatically on boot again?
>

If you want to stop a spare from looking like part of the array, simply

   mdadm --zero-superblock /dev/DEVICENAME

But you really want it to assemble automatically at boot and I cannot s=
ee how
a spare would interfere with that, bugs.debian.org isn't responding jus=
t now.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
