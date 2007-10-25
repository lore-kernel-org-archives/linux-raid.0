From: Doug Ledford <dledford@redhat.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Thu, 25 Oct 2007 03:01:52 -0400
Message-ID: <1193295712.10336.94.camel@firewall.xsintricity.com>
References: <18200.49267.763509.924873@stoffel.org>
	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	 <18200.53593.687483.120827@stoffel.org>
	 <1192810534.1666.68.camel@firewall.xsintricity.com>
	 <18200.56684.14194.630264@stoffel.org>
	 <1192813877.1666.79.camel@firewall.xsintricity.com>
	 <18200.63987.514073.184865@stoffel.org> <471E7DC6.7050206@tmr.com>
	 <1193184555.10336.3.camel@firewall.xsintricity.com>
	 <18207.56169.769976.512617@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sT8L/ons6JPyWmqR/djK"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18207.56169.769976.512617@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Bill Davidsen <davidsen@tmr.com>, John Stoffel <john@stoffel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-sT8L/ons6JPyWmqR/djK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-10-25 at 09:55 +1000, Neil Brown wrote:

> As for where the metadata "should" be placed, it is interesting to
> observe that the SNIA's "DDFv1.2" puts it at the end of the device.
> And as DDF is an industry standard sponsored by multiple companies it
> must be ......
> Sorry.  I had intended to say "correct", but when it came to it, my
> fingers refused to type that word in that context.
>=20
> DDF is in a somewhat different situation though.  It assumes that the
> components are whole devices, and that the controller has exclusive
> access - there is no way another controller could interpret the
> devices differently before the DDF controller has a chance.

Putting a superblock at the end of a device works around OS
compatibility issues and other things related to transitioning the
device from part of an array to not, etc.  But, it works if and only if
you have the guarantee you mention.  Long, long ago I tinkered with the
idea of md multipath devices using an end of device superblock on the
whole device to allow reliable multipath detection and autostart,
failover of all partitions on a device when a command to any partition
failed, ability to use standard partition tables, etc. while being 100%
transparent to the rest of the OS.  The second you considered FC
connected devices and multi-OS access, that fell apart in a big way.
Very analogous.

So, I wouldn't necessarily call it wrong, but it's fragile.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-sT8L/ons6JPyWmqR/djK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHID9gTzP9PM7pjw8RAiw+AJ4k3nLpXQ+Nl/5GX3sNplmEyDEUBQCcD3R/
FvdIF67ijnowQQEyFWpiVTM=
=RW4+
-----END PGP SIGNATURE-----

--=-sT8L/ons6JPyWmqR/djK--

