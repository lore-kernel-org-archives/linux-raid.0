From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Bug#624343: linux-image-2.6.38-2-amd64: frequent message "bio
 too big device md0 (248 > 240)" in kern.log
Date: Mon, 02 May 2011 01:00:57 +0100
Message-ID: <1304294457.2833.111.camel@localhost>
References: <20110427161901.27049.31001.reportbug@servo.factory.finestructure.net>
	 <1304051980.3105.46.camel@localhost>
	 <8739kyf53e.fsf@servo.factory.finestructure.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-AR7Pgh1jHOjltjppy/V6"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8739kyf53e.fsf@servo.factory.finestructure.net>
Sender: linux-raid-owner@vger.kernel.org
To: Jameson Graef Rollins <jrollins@finestructure.net>, 624343@bugs.debian.org
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-AR7Pgh1jHOjltjppy/V6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2011-05-01 at 15:06 -0700, Jameson Graef Rollins wrote:
> On Fri, 29 Apr 2011 05:39:40 +0100, Ben Hutchings <ben@decadent.org.uk> w=
rote:
> > On Wed, 2011-04-27 at 09:19 -0700, Jameson Graef Rollins wrote:
> > > I run what I imagine is a fairly unusual disk setup on my laptop,
> > > consisting of:
> > >=20
> > >   ssd -> raid1 -> dm-crypt -> lvm -> ext4
> > >=20
> > > I use the raid1 as a backup.  The raid1 operates normally in degraded
> > > mode.  For backups I then hot-add a usb hdd, let the raid1 sync, and
> > > then fail/remove the external hdd.=20
> >=20
> > Well, this is not expected to work.  Possibly the hot-addition of a dis=
k
> > with different bio restrictions should be rejected.  But I'm not sure,
> > because it is safe to do that if there is no mounted filesystem or
> > stacking device on top of the RAID.
>=20
> Hi, Ben.  Can you explain why this is not expected to work?  Which part
> exactly is not expected to work and why?

Adding another type of disk controller (USB storage versus whatever the
SSD interface is) to a RAID that is already in use.

> > I would recommend using filesystem-level backup (e.g. dirvish or
> > backuppc).  Aside from this bug, if the SSD fails during a RAID resync
> > you will be left with an inconsistent and therefore useless 'backup'.
>=20
> I appreciate your recommendation, but it doesn't really have anything to
> do with this bug report.  Unless I am doing something that is
> *expressly* not supposed to work, then it should work, and if it doesn't
> then it's either a bug or a documentation failure (ie. if this setup is
> not supposed to work then it should be clearly documented somewhere what
> exactly the problem is).

The normal state of a RAID set is that all disks are online.  You have
deliberately turned this on its head; the normal state of your RAID set
is that one disk is missing.  This is such a basic principle that most
documentation won't mention it.

> > The block layer correctly returns an error after logging this message.
> > If it's due to a read operation, the error should be propagated up to
> > the application that tried to read.  If it's due to a write operation, =
I
> > would expect the error to result in the RAID becoming desynchronised.
> > In some cases it might be propagated to the application that tried to
> > write.
>=20
> Can you say what is "correct" about the returned error?  That's what I'm
> still not understanding.  Why is there an error and what is it coming
> from?

The error is that you changed the I/O capabilities of the RAID while it
was already in use.  But what I was describing as 'correct' was that an
error code was returned, rather than the error condition only being
logged.  If the error condition is not properly propagated then it could
lead to data loss.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-AR7Pgh1jHOjltjppy/V6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATb30MOe/yOyVhhEJAQpZKA//aM7gxJ5TeTNUu+l5m40gP15CSvAoaRVU
M5UKLmDAtmNUddyfUDgGi/e2dno1lfz/JEQOrs0X3aG7gXP0RBN2ESGZ5an3JbpD
X6CudIrHd6imRahO67y1iWswPBC4VxPfksfr2DwlXsGRXBU3L8ZPWDTpg4/vc0py
htWsbkd1mKJuIucNMUv6j7oTx27Qgx9kqKYeJj0XH8MjyZFKU3fvX2xeCZ8iXAlB
dSLHI3PKmlor4ghizkKsQqptQ61YM/BSdu/Ag+RRFDS+vt9T8tXCseP0bnkzx61v
qfRPRDDarwglfm1KLmYMp+DxNzdkz51N7/+XrC4/DX765JwW4WIpZaL/hEFP4p/Z
ucAo/sjMDykPv2dx+50wCjb3wqp8lS2zqXj3UkxBL7TUKa+12jdtFN7IKE+up9/w
iJ2qCqWMMJJNS8mvNmA+px5n+uqF4hDFGa3UPTAD8MitZKa0o489sdk0THYH11JI
QEttpH94bDXgI1ZxnqhR9z6/uEPXiv/6lnMNvsPsbdiiQlLj9UztPQgdlSh+OmC6
DfTTG2gwcV8ZeWrF47sjp7WszMDcaLV7cTPzlrEuwm2q8vkkicGQtGKjlOEy2Q9q
8zWJCndQYcyFJ5cSCfeD/rJpSMGC0CMOrNAaIJ9zl1/IK2MtKV2If/79oQBZYurc
i5VZm1rjwc0=
=ex8i
-----END PGP SIGNATURE-----

--=-AR7Pgh1jHOjltjppy/V6--
