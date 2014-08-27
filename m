From: NeilBrown <neilb@suse.de>
Subject: Re: Add BBL to existing array
Date: Wed, 27 Aug 2014 21:52:06 +1000
Message-ID: <20140827215206.51e6e37e@notabene.brown>
References: <20140827090707.GA15857@dolores.internal.speartail.com>
	<20140827192721.57c57c3b@notabene.brown>
	<20140827103213.GE15857@dolores.internal.speartail.com>
	<20140827210700.5a9b3e60@notabene.brown>
	<20140827112908.GF15857@dolores.internal.speartail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Bu7KbpK.LLoksl1TcmZFG2="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140827112908.GF15857@dolores.internal.speartail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Hoeg <peter@hoeg.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Bu7KbpK.LLoksl1TcmZFG2=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Aug 2014 19:29:08 +0800 Peter Hoeg <peter@hoeg.com> wrote:

> Neil,
>=20
> >> It basically runs:
> >> # mdadm --assemble --scan --run --auto=3Dyes
> >>
> >> so it would become:
> >> # mdadm --assemble --update=3Dbbl --scan --run --auto=3Dyes
> >
> >Sorry, --update and --scan are incompatible.
>=20
> That explains that...
>=20
> >> That didn't work. I ended up in the initramfs and had to manually bring
> >> up the RAID as well as LVM to get the machine booted.
> >
> >That would have been a good time to wield the --update=3Dbbl seeing you =
were
> >assembling the array anyway.
>=20
> I actually did - I ran:
>=20
> mdadm --assemble --update=3Dbbl /dev/md0
>=20
> Which returned without error, but it doesn't seem to have changed
> anything (or am I looking in the wrong place?)
>=20
> # mdadm --detail /dev/md0


A bbl exist separately on each component device.
Try=20
   mdadm --examine /dev/sda2

look for
   Bad Block Log : 512 entries available at offset XXX sectors

NeilBrown

--Sig_/Bu7KbpK.LLoksl1TcmZFG2=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU/3GZjnsnt1WYoG5AQJfOQ/+JKgoWigXKrOtarTM6ObhhNUfzCY5rHGP
Qaf4QmiAasg8o4uDaqfJaXMoGMxgr7i1KKUkQnvORXzuoIA/flr/sjax/8PxQ5SO
LArX3D7fF6cRV+5PHKwW9e+oi1lElhkLMuULK5I0ZFU7z9D9fY1cO1CmIBPez4XH
YG+5ia3ZeTodJsjie8cMq0g6LrV2y+BIxAX/uyDc7KKYOA9UMVGbU91GcxpCdDug
3KQBbc95EXzSWvPjlNTFk4N1NAVOOmUnozpz5Dx7RV5KKrqg/rlaFvS5tTXcGWD7
LuRWeeqtP3lC7MKu9k3r+R/rJ4AFi7yLJcIG88QQ/PxEKvgIH9Tz3cmmSIZi/6+/
tNUJZYjO8lA0auc0yQnkiX4X6bxnxBVeFfEJ3JwyQoMYdjsW5kVMLonaXFCYGJ7R
IieAuWSg8rKaNUisWM+MdG0bD1zNu2rswX3Lq4zgZ4n8tGkJ4KcHduico3p1/1sF
MAjb2KNxjvauVy23wxigmlDnpOnHvJQNs3TFsBZPeK2nip0Z8Fplx4Eiqu61J68x
J3gT8c1Xk/A35xqyAWsG94TnbhfmRQpio1PwwSpCw844tCjdxHShUsmWKDDL8kNE
fDEhhb38FP2iRIWCyrNBu4QQ4MWPcIYE4hap4YfN3duTJgSM5VQTrfpXu721pMf7
VIYPFSrS7Xo=
=Ei9I
-----END PGP SIGNATURE-----

--Sig_/Bu7KbpK.LLoksl1TcmZFG2=--
