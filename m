From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: mdraid causing mvsas to lockup? (was: Re: recommended 4port SATA controller ?)
Date: Fri, 18 Sep 2009 04:58:22 -0600
Message-ID: <200909180458.22305.tfjellstrom@shaw.ca>
References: <4AB22135.7030405@kaneda.iguw.tuwien.ac.at> <73e903670909171635r4e60cb7cj548ae6ad8b152e3e@mail.gmail.com> <200909171759.49606.tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200909171759.49606.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Kristleifur =?iso-8859-1?q?Da=F0ason?= <kristleifur@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu September 17 2009, Thomas Fjellstrom wrote:
> On Thu September 17 2009, Kristleifur Da=F0ason wrote:
> > On Thu, Sep 17, 2009 at 11:02 PM, Thomas Fjellstrom <tfjellstrom@sh=
aw.ca>
>=20
> wrote:
> > > On Thu September 17 2009, John Bridges wrote:
> > >> I'm a fan of the SuperMicro AOC-SAT2-MV8, great card.
> > >> http://www.supermicro.com/products/accessories/addon/AOC-SAT2-MV=
8.cfm
> > >>
> > >> It's an 8 port PCI-X card, works in both PCI and PCI-X slots.
> > >>
> > >> SATA2
> > >>
> > >> Drivers for Linux are stable, built in.
> > >
> > > Have you had any experience with the AOC-SASLP-MV8? I've got one =
and
> > > have been having no end of issues with it under linux.
> > >
> > > --
> > > Thomas Fjellstrom
> > > tfjellstrom@shaw.ca
> > > --
> >
> > I have,
> >
> > or rather, I've tried to get an AOC-SASLP-MV8 card going. I think I
> > can safely say that at least Linux kernel 2.6.31 is a requirement. =
The
> > card was basically useless with everything up to 2.6.30, then I tri=
ed
> > 2.6.31-rc5 on a whim and it kicked in. Built-in driver support, tha=
t
> > is. However it wasn't stable, it dropped disks when syncing a large
> > array. I've been meaning to test on 2.6.31 final, and am pretty
> > optimistic.
>=20
> Yeah, the driver didn't appear till .30. I have 2.6.31-git4 installed=
 right
> now, and no matter what I do, the controller starts spewing errors:
>=20
> [ 1455.698186] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc=3D =
5
> [ 1455.698196] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc=3D =
5
> ...
> [ 1424.708085] end_request: I/O error, dev sdh, sector 3072
> [ 1424.708106] sd 0:0:3:0: [sdh] Unhandled error code
> [ 1424.708111] sd 0:0:3:0: [sdh] Result: hostbyte=3DDID_OK
> driverbyte=3DDRIVER_TIMEOUT
> [ 1424.708118] sd 0:0:3:0: [sdh] CDB: Read(10): 28 00 00 00 08 00 00 =
04 00
>  00
>=20
> And thats with perfectly good disks, and with smartd/hddtemp disabled=
 (they
> were causing one of my disks to barf).
>=20
> All I have to do is start a read from any disk, and after a few minut=
es,
>  the card starts erroring out, and then dies.
>=20
> It actually seems like it got more unstable from .30 to .31.
>=20
> I've been trying to get some help with it on the lkml/ide/scsi lists =
for a
> while now, one person has tried to help, but thats about it.
>

Very strange. I've found that reading from all 4 drives currently conne=
cted to=20
the controller at once, works. I have 4 dd commands, one reading off ea=
ch=20
drive, and so far no errors, the dd commands aren't locking up, and the=
y are=20
going full speed (120MB/s per drive).

If however I attempt to bring up the md raid0 array ontop of these disk=
s, the=20
controller locks up, and all of the disks become inaccessible.

Maybe it has something to do with it, but just as the system is booting=
, I get=20
the following, maybe related, maybe not:

ata_id[5183]: HDIO_GET_IDENTITY failed for '/dev/block/8:96'
ata_id[5188]: HDIO_GET_IDENTITY failed for '/dev/block/8:112'
ata_id[5184]: HDIO_GET_IDENTITY failed for '/dev/block/8:80'

(those map to sdg, sdh, and sdf in that order, no report for sde, the f=
irst=20
disk in the controller)


> > -- Kristleifur
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Thomas Fjellstrom
tfjellstrom@shaw.ca
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
