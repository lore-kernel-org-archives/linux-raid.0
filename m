From: NeilBrown <neilb@suse.de>
Subject: Re: Question about mdadm commit
 d6508f0cfb60edf07b36f1532eae4d9cddf7178b "be more careful about add
 attempts"
Date: Wed, 9 Nov 2011 10:41:28 +1100
Message-ID: <20111109104128.7b6f098f@notabene.brown>
References: <CAGRgLy6Q9Qq8TeykEseXX45goi4kS8wOwrUOo1+tNZyxdyFHkw@mail.gmail.com>
	<20111027085125.747691a9@notabene.brown>
	<CAGRgLy7biNy4Tj9wXhBosjC4QNy7dXC2aoimu7ezGqdL82Axxg@mail.gmail.com>
	<20111031101649.657a1ab3@notabene.brown>
	<CAGRgLy7G_M=FtdZ9mmDvxxN52+AF+L=0+OaEP=dK7Z+Z5YBYKw@mail.gmail.com>
	<20111031201933.314d130f@notabene.brown>
	<CAGRgLy5zkfy2bfrJnC_eKQ_-VAcdaKCyeSounjZ3FjBb83T0mQ@mail.gmail.com>
	<20111102095204.024dc6b2@notabene.brown>
	<CAGRgLy5WaOAg2R0FW1=cPgn+sK+PA_=T=GrLj+KWb5HVxbndzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=Xz6OdM47zKUWoSibtulSl/"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5WaOAg2R0FW1=cPgn+sK+PA_=T=GrLj+KWb5HVxbndzQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/=Xz6OdM47zKUWoSibtulSl/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 8 Nov 2011 18:23:49 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
>=20
> 1)
> after looking at this more I see the following: on ADD_NEW_DISK
> sequence (to a running array, not during assembly) in the kernel, the
> desc_nr is loaded from the superblock of the disk to be added in
> super_1_load():
> 	if (sb->level =3D=3D cpu_to_le32(LEVEL_MULTIPATH))
> 		rdev->desc_nr =3D -1;
> 	else
> 		rdev->desc_nr =3D le32_to_cpu(sb->dev_number);
> And later, in bind_rdev_to_array() it is indeed checked that desc_nr is u=
nique.
>=20
> However, at least for 1.2 arrays, I believe this is too restrictive,
> don't you think? If the raid slot (not desc_nr) of the device being
> re-added is *not occupied* yet, can't we just select a free desc_nr
> for the new disk on that path?
> Or perhaps, mdadm on the re-add path can select a free desc_nr
> (disc.number) for it (just as it does for --add), after ensuring that
> the slot is not occupied yet? Where it is better to do it?
> Otherwise, the re-add fails, while it can perfectly succeed (only pick
> a different desc_nr).

I think I see what you are saying.
However my question is: is this really an issue.
Is there a credible sequence of events that results in the current code mak=
es
an undesirable decision?  Of course I do not count deliberately editing the
metadata as part of a credible sequence of events.


>=20
> 2)
> About your suggestion of setting the In_sync flag via sysfs, I think
> it's too dangerous to blindly set it, so I am not going to do it. Let
> the kernel look at event count and decide.
>=20
> 3)
> So it looks like at present, my best way to add (not re-add) a disk
> into a specific slot is the following:
> - borrow some code from mdadm to initialize the superblock of the new
> disk, as belonging to this array (init_super).
> - use the sysfs to do what you suggested before:
> echo frozen > sync_action
> echo $major:$minor > new_dev
> echo $slot > dev-$DEVNAME/slot
> echo idle > sync_action
>=20
> Does this makes sense?

Yes it does.

NeilBrown



--Sig_/=Xz6OdM47zKUWoSibtulSl/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrm+KDnsnt1WYoG5AQIJ5xAAnz/EH+pScGDVlaSNBahOoZaPZv/DgFBZ
qe/fRGAvfsBzfXPdLM3luNH9puQCNdkOMMvXpa9fgTbuiBnRlTMXYbV+Elczd9+J
tFN9aREfhv+m9HNgdS/UekjvjVSqNeK6G3Qu40JULZ06d1/EZHT38/wOiw/iznU7
CWc0TaqUoIsqhdJ2sKtzGZyzjjBhSdWD0q05WK5qLTmP+uipQ3Glj5HPu+4BQvBl
7KljEi1AKQSNweimZ/6jKVfNr8HYoEPJ+WIvLN0VYjsWF7dy9H3mRRxmVoe5VBBm
1K0a1pkdcPf81iEHsPMyx0UhdMUik6ka3jWLFfQ6vsbxudSmiHiAtL1RfQIuR5nU
1AYkaqlkvDlgrw6jYCSfVNINnbCC5vEiVRsiBBDvQi3jn3A2fYwNoGrQAYR2WPSE
8kjl4R4n4IqCSKpff2rPQQ37dJ/KFgJPxQGaDwALkMc3XH/tKW3mvWR0+cIFdGWo
9Pcv4+lew1GeAafP3XozTzV1XRnMvRkWvws3ENG6iYADrsi8Pbz0xz7nrlx34nfy
ZXD9PKULkHZLWwvtmG/T/BMpQunpUe2jvqw4IhZRflt+iw6YNiYS364RhipLjuqc
oS+LU1hSoZxrL8K24AFg6mAKT2ItXSFaUAwMf3pfD/JWT7U/JdTkfYvICXpbwvGI
VReBKOGwWr0=
=lI8d
-----END PGP SIGNATURE-----

--Sig_/=Xz6OdM47zKUWoSibtulSl/--
