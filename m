From: NeilBrown <neilb@suse.de>
Subject: Re: Last working drive in RAID1
Date: Fri, 6 Mar 2015 08:52:22 +1100
Message-ID: <20150306085222.19dd30ce@notabene.brown>
References: <54F7633F.3020503@gmail.com>
	<20150305084634.2d590fe4@notabene.brown>
	<54F78BD9.403@gmail.com>
	<20150305102622.016ec792@notabene.brown>
	<54F87C7C.8020501@youngman.org.uk>
	<54F8B5D2.8070304@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/+Ip9EcS_sO+p14cK2IhXQHg"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54F8B5D2.8070304@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Wols Lists <antlists@youngman.org.uk>, Eric Mei <meijia@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/+Ip9EcS_sO+p14cK2IhXQHg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 05 Mar 2015 15:00:18 -0500 Phil Turmel <philip@turmel.org> wrote:

> On 03/05/2015 10:55 AM, Wols Lists wrote:
> > Sorry to butt in, but I'm finding this conversation a bit surreal ...
> > take everything I say with a pinch of salt. But the really weird bit
> > was "what does linux do if /dev/sda disappears?"
> >=20
> > In the old days, with /dev/hd*, the * had a hard mapping to the
> > hardware. hda was the ide0 primary, hdd was the ide1 secondary, etc
> > etc. I think I ran several systems with just hdb and hdd. Not a good
> > idea, but.
> >=20
> > Nowadays, with sd*, the letter is assigned in order of finding the
> > drive. So if sda is removed, linux moves all the other drives and what
> > was sdb becomes sda.
>=20
> On reboot, yes.  Not live.  If /dev/sda has anything using it when
> unplugged, it stays there and gives errors.  Existing devices retain
> their names, and new devices are added to the end.  Only if all users
> are completely unhooked will a kernel name get re-used live.
>=20
> > Which is why you're advised now to always refer
> > to drives by their BLKDEV or whatever, as linux provides no guarantees
> > whatsoever about sd*. The blockdev may only be a symlink to whatever
> > the sd*n code of the disk is, but it makes sure you get the disk you
> > want when the sd*n changes under you.
>=20
> Correct, but once assembled or mounted, the kernel names are locked.
>=20
> > Equally surreal is the comment about "what does raid1 do with no
> > working devices?". Surely it will do nothing, if there's no spinning
> > rust or whatever underneath it? You can't corrupt it if there's
> > nothing there to corrupt?
>=20
> It has to stay there to give errors to the upper layers that are still
> hooked to it.  When they are administratively "unhooked", aka unmounted
> or disassociated with mdadm --remove.
>=20
> Or, quite possibly, the device is plugged back in, at which point the
> device name is there for it (as long as you use the same port, of
> course).  In which case the filesystem may very well resume successfully.

I was with you right up to this last point.
When a device is unplugged and then plugged back in, it will always get a n=
ew
name.  Detecting "is the same device" is far from fool-proof, particularly =
as
the device could have been plugged into some other machine and has 'fsck' e=
tc
run.
Once a mounted device is unplugged, that mount is permanently unusable.

NeilBrown


>=20
> > Sorry again if this is inappropriate, but you're coming over as so
> > buried in the trees that you can't see the wood.
>=20
> Sometimes the expanded view is appropriate :-)
>=20
> Regards,
>=20
> Phil Turmel


--Sig_/+Ip9EcS_sO+p14cK2IhXQHg
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVPjQFjnsnt1WYoG5AQKHeg/+LgmLq2Mo0TX8qkUVj0pMQjQtPjucp/eW
ESejLJh5BZ2cuHI53csLyiVIK0/r++HdOin21+KyIr/a6F5whSvccyJHNErzJSJ5
olHmY/3d2XolMSw3SG/Pk1GZ5899cnNu/QonHHhNbseos3xCzQPvhu1Q+06HjHU3
THEVvY2lFc92u+4D01Gx9STHKpIELcDFHs5cxolJKu5QMI8mWFC80Xofk71VJ/J5
w+a1bubAYWJrvx+mR/R1ZJnWD24l3dFsgOa3TAjzc1McnKq2o6BBJK0BXPe5CRmt
qm3xtOtF6AErDQUOfYzYR9/MiFggphCjKLfQh3HOO9Gxk+xAhe+zrUvEEeIFsgxf
mCjIHlCGV/QKvffRudjVGasiI+3SElpZ97D76AHsXsTd2SakKQHiBKsFW88c9oNW
pOXk9igRqYqfasSLLIY1FIC1AwyCrmkZDdQp4J66g1MEanXxhfbChyK+uwDulfcj
R9QcXR0IQ5LHyrnSGNPViibsZAKf3cO1Aw7DxKPdU2Wn80w33uZKUzZC/lhHKzvd
7l+9ip16FP4ohfFf5ky7vSPDpPeB+U+Nuyq/3EZA3dNfHL9TNSJZxCb2NjdOfyO5
Kr6cLsnl9Iz5/osUrf2K8A+FxizJq2Vn7I2pIBMK17cq5NNuCJ5Pd95VS3mPGdsp
09qW2+c8jnw=
=gOqW
-----END PGP SIGNATURE-----

--Sig_/+Ip9EcS_sO+p14cK2IhXQHg--
