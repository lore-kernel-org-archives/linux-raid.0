From: NeilBrown <neilb@suse.de>
Subject: Re: Making spare device into active
Date: Tue, 12 Aug 2014 17:13:06 +1000
Message-ID: <20140812171306.72715f62@notabene.brown>
References: <CAAOsTSmkyCqLxrG-q2PQxnbXiAC1zz=qw6+ekMUmY=N+ZoHZ-w@mail.gmail.com>
	<20140809103159.338bef61@notabene.brown>
	<CAAOsTSn=SCbBmEoViMvVvRmR9GbdVovLAJyFo_v2EFk2v+-TaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/1aKxZo+z9JXEkUp3SSTNos1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAOsTSn=SCbBmEoViMvVvRmR9GbdVovLAJyFo_v2EFk2v+-TaQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik =?UTF-8?B?SG9ybsOtaw==?= <patrik@dsl.sk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/1aKxZo+z9JXEkUp3SSTNos1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 9 Aug 2014 10:33:49 +0200 Patrik Horn=C3=ADk <patrik@dsl.sk> wrote:

> 2014-08-09 2:31 GMT+02:00 NeilBrown <neilb@suse.de>:
> > On Fri, 8 Aug 2014 19:25:24 +0200 Patrik Horn=C3=ADk <patrik@dsl.sk> wr=
ote:
> >
> >> Hello Neil,
> >>
> >> I am experiencing the problem with one RAID6 array.
> >>
> >> - I was running degraded array with 3 of 5 drives. When adding fourth
> >> HDD one of the drives reported read errors, later disconnected and
> >> then it was kicked out from array. (It was maybe doing of controller
> >> and not drive, not important.)
> >>
> >> - The array has internal intent bitmap. After the drive reconnected
> >> I've tried it to --re-add to array with 2 of 5 drives. I am not sure
> >> if that should work? But it did not, recovery got interrupted just
> >> after start and drive was marked as spare.
> >
> > No, that is not expected to work.  RAID6 survives 2 device failures, no=
t 3.
> > Once three have failed, the array has failed.  You have to stop it, and=
 maybe
> > put it back together.
> >
>=20
> I know what RAID6 is. There were no user writes at the time of kicking
> out the drive so re-add with bitmap can theoretically work? I hoped
> there were no writes at all so the drive can be re-added. But in any
> case if you issue re-add and it cant be re-added mdadm should not
> touch the drive and mark it spare. That is what complicated things,
> after that it is not possible to reassemble the array without changing
> device role back to active.

You are right that if you ask for "re-add" and it can't re-add, mdadm should
not touch the drive and mark it spare.
I'm fairly sure it doesn't with current code.  I think the patch which fixed
this in the kernel was bedd86b7773fd97f0d which was in 3.0.

What kernel are you using.



>=20
> >>
> >> - Right now I want to assemble array to get data out of it. Is it
> >> possible to change "device role" field in device's superblock so it
> >> can be assembled? I I have --examine and --detail output from before
> >> the problem and so I know at which position the kicked drive belongs.
> >
> > Best option is to assemble with --force.
> > If that works then you might have a bit of data corruption, but most of=
 the
> > array should be fine.
> >
>=20
> Should assemble with --force work also in this case, when one drive is
> marked spare in his superblock? I am not 100% if I tried it, I choosed
> different way for now.

Using --force should with fail to do anything, or produce the best possible
result.  I can't say if it would have worked for you as I don't have
complete details.  Possibly it wouldn't, but it wouldn't hurt to try.


>=20
> For now I used dm snapshots over drives and recreated array on them.
> It worked so I am rescuing data I need this way and will decide what
> to do next.
>=20
> Were write intent bitmaps destroyed when I tried to re-add drive? Now
> on snapshots it is of course destroyed because I recreated array, but
> on the drives I have bitmaps after failing array and trying re-add
> kicked drive back.

The bitmap is copied on all drives and should survive is most cases.

>=20
> There were no user space writes at the time, but some lower layers
> maybe wrote something. If the bitmaps are preserved, is there any tool
> to show their content and find out which chunks can be incorrect?

"mdadm --examine-bitmap /dev/sdX" will give summary details but not list all
the affect blocks.  It wouldn't be too hard to get mdadm to report that
info.  I'm not sure how really useful it would be.


>=20
> > If it fails, you probably need to carefully re-create the array with al=
l the
> > right bits in the right places.  Maybe sure to create it degraded so th=
at it
> > doesn't automatically resync, otherwise if you did something wrong you =
could
> > suddenly lose all hope.
> >
> > But before you do any of that, you should make sure your drives and
> > controller are actually working.  Completely.
> > If any drive has any bad blocks, then get a replacement drive and copy
> > everything (maybe using ddrescue) from the failing drive to a good driv=
e.
> >
> > There is no way to just change arbitrary fields in the superblock, so y=
ou
> > cannot simply "set the device role".
> >
> > Good luck.
>=20
> Thanks. For now it seems that data is intact.

That's always good to hear :-)

NeilBrown


--Sig_/1aKxZo+z9JXEkUp3SSTNos1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+m+gjnsnt1WYoG5AQI4Gw/+LAKcq5+91PrVoOqYTLoA2aw3n1Op+98Z
+14ZdmotVTJP5+n3LRIZYmTnRee01pur2zMmrUhhtxfjF4TpGt/yDFWtcewlXHBX
TX4tpsgpX1dV7pBFZqsjvH0lkjHTWmy+bX+rSckts9Hw+8Pv7px3EE11lRaVJk2d
aqQ3IIP0fC1PYNle5nD9/eVJdYkm/lgaDWgNrrUvAAWzcrE23lUR8GXFCZfSAHd9
HoX7wfEayO/aoUK2/PibTK2DcfDo/lTzOSF9wuPGshIpRsZ2ElU6RD/vSEeHD/W+
M3SRBr1cOa+kYHQgN/wehEMbhkuueCcqISnAxH1ya+r7w+ABhwNQnydQhla0YQ/+
dQvfFDEJOvornFhLe3eSMUzlLgjWa+UVDeayPEQ97ZG95rBbjX4dXwKWtuasuM2L
zweTvpPjaiNdHt1xs19e/zVwDBNsOOwHsDn13zFRGSfOKcxvMVYEC12u71F8+LGu
g9lUnRzZL1NZyPsMoSeGL56JIbrT5kUtz1wl0XPelGtQV6M9UXhFWmTwWhcgUHZw
L3iYJSDHFwwPFVLMLWrVU8Vz0tX1ZyURwzk+/TJ4xOBP42vPKuAlKuHSUhaJW5we
xPvATY1WftFCXIJU2+QIgG8h3XZa692GNqr1kIZ/l0MO+0shAkqS1fEf24uebfd8
NQhUw3PTN1M=
=BlXr
-----END PGP SIGNATURE-----

--Sig_/1aKxZo+z9JXEkUp3SSTNos1--
