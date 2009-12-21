From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm 3.1.1: level change won't start
Date: Tue, 22 Dec 2009 10:00:52 +1100
Message-ID: <20091222100052.39ff439b@notabene.brown>
References: <73e903670912201941q44dae7b0t455d1a94f13f5c31@mail.gmail.com>
	<20091221093528.GA24168@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091221093528.GA24168@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 21 Dec 2009 09:35:28 +0000
Robin Hill <robin@robinhill.me.uk> wrote:

> On Mon Dec 21, 2009 at 03:41:33AM +0000, Kristleifur Da=C3=B0ason wro=
te:
>=20
> > Hi all,
> >=20
> > I wish to convert my 3-drive RAID-5 array to a 6-drive RAID-6. I'm =
on
> > Linux 2.6.32.2 and have mdadm version 3.1.1 with the 32-bit-array-s=
ize
> > patch from here: http://osdir.com/ml/linux-raid/2009-11/msg00534.ht=
ml
> >=20
> > I have three live drives and three spares added to the array. When =
I
> > initialize the command, mdadm does the initial checks and aborts wi=
th
> > a "cannot set device shape" without doing anything to the array.
> >=20
> > $ mdadm --grow /dev/md_d1 --level=3D6 --raid-devices=3D6
> > --backup-file=3D/root/backup.md1_to_r6
> > mdadm: metadata format 1.10 unknown, ignored.
> > mdadm: metadata format 1.10 unknown, ignored.
> > mdadm level of /dev/md_d1 changed to raid6
> > mdadm: Need to backup 1024K of critical section..
> > mdadm: Cannot set device shape for /dev/md_d1
> > mdadm: aborting level change
> >=20
> I don't think you can grow and reshape simultaneously.  I think you'l=
l
> need to do this as two operations - either grow to a 5 disk RAID5 the=
n
> reshape to a 6 disk RAID6, or reshape to a 4 disk RAID6 then grow.
>

Why do you think that?  If there is something in the documentation that
suggests that, please point it out and I'll change it.

You should be able to change level, layout, number of devices, chunksiz=
e
all at the same time.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
