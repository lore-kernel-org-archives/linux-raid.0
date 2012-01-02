From: NeilBrown <neilb@suse.de>
Subject: Re: dirty chunks on bitmap not clearing (RAID1)
Date: Tue, 3 Jan 2012 09:58:18 +1100
Message-ID: <20120103095818.094a7825@notabene.brown>
References: <CAGtzr3fC8bWLa4A5eRRgjHCtgfENdx4jtaKNb53dD7NX61nf7g@mail.gmail.com>
	<20110831173842.44ab5b03@notabene.brown>
	<alpine.DEB.2.00.1108311313550.27546@ubuntu>
	<20111223094815.6beaf413@notabene.brown>
	<CAGRgLy7AtJf=3AkmU3nU4BMpfLqVVTVP5OmQe6YKZQBcdOeOeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/M8Vnqmp.H7U1+2iiBEP.4a="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy7AtJf=3AkmU3nU4BMpfLqVVTVP5OmQe6YKZQBcdOeOeg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: Chris Pearson <pearson.christopher.j@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/M8Vnqmp.H7U1+2iiBEP.4a=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 26 Dec 2011 20:07:16 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hello Neil,
>=20
> from the patch it looks like for raid levels with more than a single
> redundancy, like 3-way raid1 or raid6, when there is an additional
> missing drive, the bits will still not be cleared, correct?

Correct.  This is by design.


> This seems to be protected by !bitmap->mddev->degraded part. Because
> these bits are still needed to rebuild future drive(s)?

Exactly.

NeilBrown


>=20
> Thanks,
>   Alex.
>=20
>=20
> On Fri, Dec 23, 2011 at 12:48 AM, NeilBrown <neilb@suse.de> wrote:
> > On Wed, 31 Aug 2011 13:23:01 -0500 (CDT) Chris Pearson
> > <pearson.christopher.j@gmail.com> wrote:
> >
> >> I'm happy to apply a patch to whichever kernel you like, but the block=
s have since cleared, so I will try and reproduce it first.
> >
> > I have finally identified the problem here. =C2=A0I was looking into a =
different
> > but related problem and saw what was happening. =C2=A0I don't know what=
 I didn't
> > notice it before.
> >
> > You can easily reproduce the problem by writing to an array with a bitm=
ap
> > while a spare is recovering. Any bits that get set in the section that =
has
> > already been recovered will stay set.
> >
> > This patch fixes it and will - with luck - be in 3.2.
> >
> > Thanks,
> > NeilBrown
> >
> > From b9664495d2a884fbf7195e1abe4778cc6c3ae9b7 Mon Sep 17 00:00:00 2001
> > From: NeilBrown <neilb@suse.de>
> > Date: Fri, 23 Dec 2011 09:42:52 +1100
> > Subject: [PATCH] md/bitmap: It is OK to clear bits during recovery.
> >
> > commit d0a4bb492772ce5c4bdfba3744a99ed6f6fb238f introduced a
> > regression which is annoying but fairly harmless.
> >
> > When writing to an array that is undergoing recovery (a spare
> > in being integrated into the array), writing to the array will
> > set bits in the bitmap, but they will not be cleared when the
> > write completes.
> >
> > For bits covering areas that have not been recovered yet this is not a
> > problem as the recovery will clear the bits. =C2=A0However bits set in
> > already-recovered region will stay set and never be cleared.
> > This doesn't risk data integrity. =C2=A0The only negatives are:
> > =C2=A0- next time there is a crash, more resyncing than necessary will
> > =C2=A0 be done.
> > =C2=A0- the bitmap doesn't look clean, which is confusing.
> >
> > While an array is recovering we don't want to update the
> > 'events_cleared' setting in the bitmap but we do still want to clear
> > bits that have very recently been set - providing they were written to
> > the recovering device.
> >
> > So split those two needs - which previously both depended on 'success'
> > and always clear the bit of the write went to all devices.
> >
> > Signed-off-by: NeilBrown <neilb@suse.de>
> >
> > diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> > index b690711..6d03774 100644
> > --- a/drivers/md/bitmap.c
> > +++ b/drivers/md/bitmap.c
> > @@ -1393,9 +1393,6 @@ void bitmap_endwrite(struct bitmap *bitmap, secto=
r_t offset, unsigned long secto
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 atomic_read(&bitmap->behind_writes),
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 bitmap->mddev->bitmap_info.max_write_behind);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > - =C2=A0 =C2=A0 =C2=A0 if (bitmap->mddev->degraded)
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Never clear bits =
or update events_cleared when degraded */
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 success =3D 0;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0while (sectors) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sector_t blocks;
> > @@ -1409,7 +1406,7 @@ void bitmap_endwrite(struct bitmap *bitmap, secto=
r_t offset, unsigned long secto
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0return;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (success &&
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (success && !bitm=
ap->mddev->degraded &&
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bi=
tmap->events_cleared < bitmap->mddev->events) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0bitmap->events_cleared =3D bitmap->mddev->events;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0bitmap->need_sync =3D 1;
> >
> >
> >
> >>
> >> On Wed, 31 Aug 2011, NeilBrown wrote:
> >>
> >> >Date: Wed, 31 Aug 2011 17:38:42 +1000
> >> >From: NeilBrown <neilb@suse.de>
> >> >To: Chris Pearson <kermit4@gmail.com>
> >> >Cc: linux-raid@vger.kernel.org
> >> >Subject: Re: dirty chunks on bitmap not clearing (RAID1)
> >> >
> >> >On Mon, 29 Aug 2011 11:30:56 -0500 Chris Pearson <kermit4@gmail.com> =
wrote:
> >> >
> >> >> I have the same problem. =C2=A03 chunks are always dirty.
> >> >>
> >> >> I'm using 2.6.38-8-generic and mdadm - v3.1.4 - 31st August 2010
> >> >>
> >> >> If that's not normal, then maybe what I've done differently is that=
 I
> >> >> created the array, raid 1, with one live and one missing disk, then
> >> >> added the second one later after writing a lot of data.
> >> >>
> >> >> Also, though probably not the cause, I continued writing data while=
 it
> >> >> was syncing, and a couple times during the syncing, both drives
> >> >> stopped responding and I had to power off.
> >> >>
> >> >> # cat /proc/mdstat
> >> >> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> >> >> [raid4] [raid10]
> >> >> md127 : active raid1 sdd1[0] sdc1[2]
> >> >> =C2=A0 =C2=A0 =C2=A0 1904568184 blocks super 1.2 [2/2] [UU]
> >> >> =C2=A0 =C2=A0 =C2=A0 bitmap: 3/15 pages [12KB], 65536KB chunk
> >> >>
> >> >> unused devices: <none>
> >> >>
> >> >> # mdadm -X /dev/sd[dc]1
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Filename : /dev/sdc1
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : 6d746962
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 4
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : 43761dc5:4383cf0f:=
41ef2dab:43e6d74e
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 40013
> >> >> =C2=A0 Events Cleared : 40013
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : OK
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0Chunksize : 64 MB
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Daemon : 5s flush period
> >> >> =C2=A0 =C2=A0 =C2=A0 Write Mode : Allow write behind, max 256
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0Sync Size : 1904568184 (1816.34 GiB 1950=
.28 GB)
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Bitmap : 29062 bits (chunks), 3 =
dirty (0.0%)
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Filename : /dev/sdd1
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Magic : 6d746962
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 4
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : 43761dc5:4383cf0f:=
41ef2dab:43e6d74e
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 40013
> >> >> =C2=A0 Events Cleared : 40013
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : OK
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0Chunksize : 64 MB
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Daemon : 5s flush period
> >> >> =C2=A0 =C2=A0 =C2=A0 Write Mode : Allow write behind, max 256
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0Sync Size : 1904568184 (1816.34 GiB 1950=
.28 GB)
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Bitmap : 29062 bits (chunks), 3 =
dirty (0.0%)
> >> >
> >> >I cannot see how this would be happening. =C2=A0If any bits are set, =
then they
> >> >will be cleared after 5 seconds, and then 5 seconds later the block h=
olding
> >> >the bits will be written out so that they will appear on disk to be c=
leared.
> >> >
> >> >I assume that if you write to the array, the 'dirty' count increases,=
 but
> >> >always goes back to three?
> >> >
> >> >And if you stop the array and start it again, the '3' stays there?
> >> >
> >> >If I sent you a patch to add some tracing information would you be ab=
le to
> >> >compile a new kernel with that patch applied and see what it says?
> >> >
> >> >Thanks,
> >> >
> >> >NeilBrown
> >> >
> >> >
> >> >>
> >> >>
> >> >> Quoting NeilBrown <neilb@suse.de>:
> >> >>
> >> >> > On Thu, October 15, 2009 9:39 am, aristizb@ualberta.ca wrote:
> >> >> >> Hello,
> >> >> >>
> >> >> >> I have a RAID1 with 2 LVM disks and I am running into a strange
> >> >> >> situation where having the 2 disks connected to the array the bi=
tmap
> >> >> >> never clears the dirty chunks.
> >> >> >
> >> >> > That shouldn't happen...
> >> >> > What versions of mdadm and the Linux kernel are you using?
> >> >> >
> >> >> > NeilBrown
> >> >> >
> >> >> >>
> >> >> >> I am assuming also that when a RAID1 is in write-through mode, t=
he
> >> >> >> bitmap =C2=A0indicates that all the data has made it to all the =
disks if
> >> >> >> there are no dirty chunks using mdadm --examine-bitmap.
> >> >> >>
> >> >> >> The output of cat /proc/mdstat is:
> >> >> >>
> >> >> >> md2060 : active raid1 dm-5[1] dm-6[0]
> >> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A02252736 blocks [2/2] [UU]
> >> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0bitmap: 1/275 pages [12KB], 4KB chunk=
, file: /tmp/md2060bm
> >> >> >>
> >> >> >>
> >> >> >> The output of mdadm --examine-bitmap /tmp/md2060bm is:
> >> >> >>
> >> >> >> Filename : md2060bm
> >> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Magic : 6d746962
> >> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Version : 4
> >> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UUID : ad5fb74c:=
bb1c654a:087b2595:8a5d04a9
> >> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Events : 12
> >> >> >> =C2=A0 =C2=A0Events Cleared : 12
> >> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 State : OK
> >> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Chunksize : 4 KB
> >> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Daemon : 5s flush period
> >> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0Write Mode : Normal
> >> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Sync Size : 2252736 (2.15 GiB 2.31 G=
B)
> >> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Bitmap : 563184 bits (c=
hunks), 3 dirty (0.0%)
> >> >> >>
> >> >> >>
> >> >> >> Having the array under no IO, I waited 30 minutes but the dirty =
data
> >> >> >> never gets clear from the bitmap, so I presume =C2=A0the disks a=
re not in
> >> >> >> sync; but after I ran a block by block comparison of the two dev=
ices I
> >> >> >> found that they are equal.
> >> >> >>
> >> >> >> The superblocks and the external bitmap tell me that all the eve=
nts
> >> >> >> are cleared, so I am confused on why the bitmap never goes to 0 =
dirty
> >> >> >> chunks.
> >> >> >>
> >> >> >> How can I tell if the disks are in sync?
> >> >> >>
> >> >> >>
> >> >> >> Thank you in advance for any help
> >> >> --
> >> >> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> >> >> the body of a message to majordomo@vger.kernel.org
> >> >> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
> >> >
> >> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/M8Vnqmp.H7U1+2iiBEP.4a=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTwI2ijnsnt1WYoG5AQIMjhAAm1p4tnemUztI9qTnS7HHyefo17mWX8XE
DOW19fuaKbNJcBj//3opEf/nmkAiyr6hcY1lyUbvMqknZogR6bYQ5V5wMC5JcD90
hSHbfr+1nbcEZoEuQKLZmu6H9/7smPiq8uOO1/0F8L8wlLd+EBsMdm0BRpC4gHdZ
aPCg2mfyt+osMvwRwlr58s6Biir3SkIauIcz4+0WpEOd6xm007qkFVJqXNwTLrWx
eNapIdejvuOX9RZgO8ZrMdEz/Qgd3HSv4bYmOwXhZ25UH9Qz6omxnLajOoLtHL7X
PHKjwlPFHRhMWuENtCjegLcjoBHpX70U2lnyZp2597NchEvk0dOFSWwzmEOK1tT4
5s3i3iVulZqZ3RlaPUixcyIHQoSHRkvACB9Ue34tp9T3/c6luoRS7sP1IgKdQV2n
WY+gNJYx0gsimZmDDMQJpJDq3dRM3SXRmgK2vhSoTlEetiLLj040uYAGj7kDsdz1
Lf8tda9vmSMSq8L94JVfKqiDuUvcdncn9doreJz6CsSxqB73J8Sky68Qxyb3mk7R
tDNFMYwpQEENaNPUJPnIsJe2+8UqXwTWvCVjcAYhbQWg1YC4Zco7zQ357G6ib5pN
iu1WFJ6bR6UidqHue0lWBkV0ajK5WyoXssHWIEfdxgI0EEPZWZYYV7NoAIgxXROw
XGPOLd00buo=
=8RkL
-----END PGP SIGNATURE-----

--Sig_/M8Vnqmp.H7U1+2iiBEP.4a=--
