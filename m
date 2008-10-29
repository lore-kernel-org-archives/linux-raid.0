From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch mdadm-2.6.7.1 0/3] Misc fixes for mdadm-2.6.7.1
Date: Wed, 29 Oct 2008 19:14:05 -0400
Message-ID: <1225322045.26510.86.camel@firewall.xsintricity.com>
References: <cover.1225306892.git.dledford@redhat.com>
	 <18696.59934.872875.299706@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jYG5DyiiX+RD5OaigV08"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18696.59934.872875.299706@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-jYG5DyiiX+RD5OaigV08
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-30 at 09:56 +1100, Neil Brown wrote:
> That leaves a largish slab of your code that I wasn't really sure
> what it was adding.

It was dealing with the fact that is_standard() has more than just two
return values.  It has -1, 0, and 1 (and 2 in my patch, but you've
changed yours in such a way that it's not necessary any more).  That
makes this test fail for certain ARRAY lines:

> +	if (match && (rv =3D is_standard(match->devname, &devnum))) {
> +		devnum =3D (rv > 0) ? (-1-devnum) : devnum;

As an example, create an array that doesn't use standard syntax, in my
case I was testing with /dev/md/root as a partitioned array.  The array
line in my mdadm.conf looked like this:

ARRAY /dev/md/root level=3Draid1 num-devices=3D2 metadata=3D0.90 auto=3Dmdp=
4
UUID=3De38b03c0:444d484e:910e8462:063f083e

Given a command invocation of mdadm -I <device>, and that device's uuid
matches the above array line, you really want to use the information in
the ARRAY line whether is_standard returns -1, 0, or 1.  So, that big
multiswitch statement was the possible invocations of mdadm -I with a
device that matches the array UUID in the config file but uses a
non-standard name, eg someone did a create on /dev/md0, then a -Eb >>
mdadm.conf, then vi mdadm.conf and add auto=3Dmdp4 to the ARRAY /dev/md0
line.  Obviously, we would have refused to create the array with that
name and that auto setting, so I was preserving that behavior at run
time too.  Hence the size of that section of code.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband


--=-jYG5DyiiX+RD5OaigV08
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkI7j0ACgkQTzP9PM7pjw+jAQCeMuAVDJU49U+nv28fITsVGYD0
Y9EAnRMkTQlXls5nNEA4Qfx8OIZ1WytR
=FkMJ
-----END PGP SIGNATURE-----

--=-jYG5DyiiX+RD5OaigV08--

