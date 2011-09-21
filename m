From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 13/14] Check if md allows to control reshape
Date: Wed, 21 Sep 2011 17:51:14 +1000
Message-ID: <20110921175114.0dc9042b@notabene.brown>
References: <20110916115229.5201.42794.stgit@gklab-128-013.igk.intel.com>
	<20110916115525.5201.42756.stgit@gklab-128-013.igk.intel.com>
	<20110921123338.6ede25bc@notabene.brown>
	<79556383A0E1384DB3A3903742AAC04A0324E2@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/A8G+.wEp41ygAn6r..hF715"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <79556383A0E1384DB3A3903742AAC04A0324E2@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>
List-Id: linux-raid.ids

--Sig_/A8G+.wEp41ygAn6r..hF715
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Sep 2011 07:31:48 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

>=20
>=20
> > -----Original Message-----
> > From: NeilBrown [mailto:neilb@suse.de]
> > Sent: Wednesday, September 21, 2011 4:34 AM
> > To: Kwolek, Adam
> > Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin
> > Subject: Re: [PATCH 13/14] Check if md allows to control reshape
> >=20
> > On Fri, 16 Sep 2011 13:55:25 +0200 Adam Kwolek <adam.kwolek@intel.com>
> > wrote:
> >=20
> > > It can happen that there is no mdadm in memory and 'max' was already
> > > set to sync_max. Such array cannot be put under check pointing control
> > > again.
> >=20
> > Again I don't understand what you are trying to guard against.
> > If resync_max is 'max', then the kernel is allowed to fun reshape to
> > completion without any help from mdadm.  If mdadm needs to monitor
> > things it always sets resync_max to a smaller value.
> >=20
> > Confused.
>=20
> In my opinion running reshape continuation on array that is allowed to fr=
eely reshape to the end
> is race condition (another mdadm or user via sysfs manage this array alre=
ady).
> We can tell nothing about restart point (read from metadata) when md runs=
 with reshape already.
> I think we should not allow to attach mdadm to such reshape process.
>=20
> I think this guard is required.
>=20

I see what your point is now.  I was just a bit confused by the message that
is printed which seems to say something different.

If we need to guard something here, we need to guard against a lot more than
just sync_max =3D=3D "max".  We need to guard against another mdadm process
monitoring the array (the extra .pid file I mentioned) and also if sync_max
has any value larger than what we would expect from the metadata.

So a test that rejects an attempt to continue reshape on an array where
sync_max is not the correct value makes sense.  Just testing for "max"
doesn't.

Thanks,
NeilBrown

--Sig_/A8G+.wEp41ygAn6r..hF715
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOeZdyG5fc6gV+Wb0RAhfFAKC3xdLPF3IA2zFzWEDbJSbFBtIJ0wCg0kUH
SDwc0kkz0SeudcrPmnBJTvo=
=lnZS
-----END PGP SIGNATURE-----

--Sig_/A8G+.wEp41ygAn6r..hF715--
