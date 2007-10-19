From: Doug Ledford <dledford@redhat.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Fri, 19 Oct 2007 13:04:37 -0400
Message-ID: <1192813477.1666.74.camel@firewall.xsintricity.com>
References: <18200.49267.763509.924873@stoffel.org>
	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	 <18200.53593.687483.120827@stoffel.org>
	 <1192810534.1666.68.camel@firewall.xsintricity.com>
	 <18200.56684.14194.630264@stoffel.org>
	 <Pine.LNX.4.64.0710191239250.27246@p34.internal.lan>
	 <18200.57042.989520.666476@stoffel.org>
	 <Pine.LNX.4.64.0710191245230.7849@p34.internal.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zhQ3srlGJKTbq4oNVof+"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0710191245230.7849@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-zhQ3srlGJKTbq4oNVof+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-19 at 12:45 -0400, Justin Piszcz wrote:
>=20
> On Fri, 19 Oct 2007, John Stoffel wrote:
>=20
> >>>>>> "Justin" =3D=3D Justin Piszcz <jpiszcz@lucidpixels.com> writes:
> >
> > Justin> Is a bitmap created by default with 1.x?  I remember seeing
> > Justin> reports of 15-30% performance degradation using a bitmap on a
> > Justin> RAID5 with 1.x.
> >
> > Not according to the mdadm man page.  I'd probably give up that
> > performance if it meant that re-syncing an array went much faster
> > after a crash.
> >
> > I certainly use it on my RAID1 setup on my home machine.
> >
> > John
> >
>=20
> The performance AFTER a crash yes, but in general usage I remember seeing=
=20
> someone here doing benchmarks it had a negative affect on performance.=20

I'm sure an internal bitmap would.  On RAID1 arrays, reads/writes are
never split up by a chunk size for stripes.  A 2mb read is a single
read, where as on a raid4/5/6 array, a 2mb read will end up hitting a
series of stripes across all disks.  That means that on raid1 arrays,
total disk seeks < total reads/writes, where as on a raid4/5/6, total
disk seeks is usually > total reads/writes.  That in turn implies that
in a raid1 setup, disk seek time is important to performance, but not
necessarily paramount.  For raid456, disk seek time is paramount because
of how many more seeks that format uses.  When you then use an internal
bitmap, you are adding writes to every member of the raid456 array,
which adds more seeks.  The same is true for raid1, but since raid1
doesn't have the same level of dependency on seek rates that raid456
has, it doesn't show the same performance hit that raid456 does.

>=20
> Justin.
--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-zhQ3srlGJKTbq4oNVof+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHGOOlTzP9PM7pjw8RAuh3AJ0ajlj+cSZPBT9Objx9IqrMHp33SgCfSaOp
UbZ6ysLjImV9y4e/g2XpLMo=
=Uqyk
-----END PGP SIGNATURE-----

--=-zhQ3srlGJKTbq4oNVof+--

