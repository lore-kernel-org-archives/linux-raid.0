From: Marc MERLIN <marc@merlins.org>
Subject: Re: How can I ensure that my swraid saves checkpoints with sysrq reboot?
Date: Wed, 12 Sep 2012 14:52:36 -0700
Message-ID: <20120912215236.GL28054@merlins.org>
References: <20120912165208.GA12152@merlins.org> <20120913072944.06021ab6@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VrqPEDrXMn8OVzN4"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120913072944.06021ab6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--VrqPEDrXMn8OVzN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 13, 2012 at 07:29:44AM +1000, NeilBrown wrote:
> Hi Marc,
>=20
> md registers a reboot notifier.  When that is called it tries to checkpoi=
nt
> everything.
> All varieties of the 'reboot' system call seem to call the reboot notifie=
rs.
> alt-sysrq-b doesn't use the same path.  It calls machine_emergency_restar=
t,
> bypassing all the reboot handling.
>=20
> Once upon a time I had the idea that killing the md threads would lead to
> proper checkpointing, so alt-sysrq-I would do-the-right-thing.
> I'm not sure if it does though.
>=20
> But alt-sysrq-o (power off) seems to use the normal reboot handling and so
> works - as you noticed.  So that should always be safe and seems to be the
> only safe approach.

Thank you for confirming what I thought I saw.

For my specific case, I'll be ok because I have a controllable power supply,
but obviously for the hosted server case, this sucks since sending a
poweroff makes sure the machine won't come back.

Is there a chance you can contact whoever is responsible for the sysrq-b
codepath to make the right call so that you get a chance to sync arrays, or
should admins just know to use sysrq-i and then sysrq-r ?

Thanks,
Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - A.S.=
R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet coo=
king
Home page: http://marc.merlins.org/ =20

--VrqPEDrXMn8OVzN4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQCVAwUBUFEEJH4xUKZ2O+kBAQIu8AP/cbihjVJ+db+CICh1r5ilK2F0NTHEIW8K
KEDUVxGb7qkqtsWIE3xuLfAi3ybIedzEmIwnr6jHGbtR5m031p4uX2igoFmPv1Mv
0N8fUC9sgJmnW0CELGu44Y6UrUKXpGzsQf5kh3cgmwke6pb2dBxStHt3w3a89QKg
sfSjR5QvfSQ=
=atJm
-----END PGP SIGNATURE-----

--VrqPEDrXMn8OVzN4--
