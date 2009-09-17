From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: recommended 4port SATA controller ?
Date: Thu, 17 Sep 2009 17:59:49 -0600
Message-ID: <200909171759.49606.tfjellstrom@shaw.ca>
References: <4AB22135.7030405@kaneda.iguw.tuwien.ac.at> <200909171702.47552.tfjellstrom@shaw.ca> <73e903670909171635r4e60cb7cj548ae6ad8b152e3e@mail.gmail.com>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73e903670909171635r4e60cb7cj548ae6ad8b152e3e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kristleifur =?iso-8859-1?q?Da=F0ason?= <kristleifur@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu September 17 2009, Kristleifur Da=F0ason wrote:
> On Thu, Sep 17, 2009 at 11:02 PM, Thomas Fjellstrom <tfjellstrom@shaw=
=2Eca>=20
wrote:
> > On Thu September 17 2009, John Bridges wrote:
> >> I'm a fan of the SuperMicro AOC-SAT2-MV8, great card.
> >> http://www.supermicro.com/products/accessories/addon/AOC-SAT2-MV8.=
cfm
> >>
> >> It's an 8 port PCI-X card, works in both PCI and PCI-X slots.
> >>
> >> SATA2
> >>
> >> Drivers for Linux are stable, built in.
> >
> > Have you had any experience with the AOC-SASLP-MV8? I've got one an=
d have
> > been having no end of issues with it under linux.
> >
> > --
> > Thomas Fjellstrom
> > tfjellstrom@shaw.ca
> > --
>=20
> I have,
>=20
> or rather, I've tried to get an AOC-SASLP-MV8 card going. I think I
> can safely say that at least Linux kernel 2.6.31 is a requirement. Th=
e
> card was basically useless with everything up to 2.6.30, then I tried
> 2.6.31-rc5 on a whim and it kicked in. Built-in driver support, that
> is. However it wasn't stable, it dropped disks when syncing a large
> array. I've been meaning to test on 2.6.31 final, and am pretty
> optimistic.

Yeah, the driver didn't appear till .30. I have 2.6.31-git4 installed r=
ight=20
now, and no matter what I do, the controller starts spewing errors:

[ 1455.698186] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc=3D 5
[ 1455.698196] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc=3D 5
=2E..
[ 1424.708085] end_request: I/O error, dev sdh, sector 3072
[ 1424.708106] sd 0:0:3:0: [sdh] Unhandled error code
[ 1424.708111] sd 0:0:3:0: [sdh] Result: hostbyte=3DDID_OK=20
driverbyte=3DDRIVER_TIMEOUT
[ 1424.708118] sd 0:0:3:0: [sdh] CDB: Read(10): 28 00 00 00 08 00 00 04=
 00 00

And thats with perfectly good disks, and with smartd/hddtemp disabled (=
they=20
were causing one of my disks to barf).

All I have to do is start a read from any disk, and after a few minutes=
, the=20
card starts erroring out, and then dies.

It actually seems like it got more unstable from .30 to .31.

I've been trying to get some help with it on the lkml/ide/scsi lists fo=
r a=20
while now, one person has tried to help, but thats about it.

> -- Kristleifur
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Thomas Fjellstrom
tfjellstrom@shaw.ca
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
