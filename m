From: Doug Ledford <dledford@redhat.com>
Subject: Re: chunk size (was Re: Time to deprecate old RAID formats?)
Date: Tue, 23 Oct 2007 20:14:11 -0400
Message-ID: <1193184851.10336.8.camel@firewall.xsintricity.com>
References: <18200.49267.763509.924873@stoffel.org>
	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	 <18200.53593.687483.120827@stoffel.org>
	 <1192810534.1666.68.camel@firewall.xsintricity.com>
	 <18200.56684.14194.630264@stoffel.org>
	 <Pine.LNX.4.64.0710191239250.27246@p34.internal.lan>
	 <18200.57042.989520.666476@stoffel.org>
	 <Pine.LNX.4.64.0710191245230.7849@p34.internal.lan>
	 <1192813477.1666.74.camel@firewall.xsintricity.com>
	 <Pine.LNX.4.64.0710191305130.9497@p34.internal.lan>
	 <1192814581.1666.87.camel@firewall.xsintricity.com>
	 <47193314.5010606@ziu.info>
	 <1192886944.1666.124.camel@firewall.xsintricity.com>
	 <471E49D2.9070608@ziu.info>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Lj5K2XXCE1rqIxscL4ZA"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <471E49D2.9070608@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <nozo@ziu.info>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-Lj5K2XXCE1rqIxscL4ZA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-23 at 21:21 +0200, Michal Soltys wrote:
> Doug Ledford wrote:
> >=20
> > Well, first I was thinking of files in the few hundreds of megabytes
> > each to gigabytes each, and when they are streamed, they are streamed a=
t
> > a rate much lower than the full speed of the array, but still at a fast
> > rate.  How parallel the reads are then would tend to be a function of
> > chunk size versus streaming rate.=20
>=20
> Ahh, I see now. Thanks for explanation.
>=20
> I wonder though, if setting large readahead would help, if you used large=
r=20
> chunk size. Assuming other options are not possible - i.e. streaming from=
=20
> larger buffer, while reading to it in a full stripe width at least.

Probably not.  All my trial and error in the past with raid5 arrays and
various situations that would cause pathological worst case behavior
showed that once reads themselves reach 16k in size, and are sequential
in nature, then the disk firmware's read ahead kicks in and your
performance stays about the same regardless of increasing your OS read
ahead.  In a nutshell, once you've convinced the disk firmware that you
are going to be reading some data sequentially, it does the rest.  With
a large stripe size (say 256k+), you'll trigger this firmware read ahead
fairly early on in reading any given stripe, so you really don't buy
much by reading the next stripe before you need it, and in fact can end
up wasting a lot of RAM trying to do so, hurting overall performance.

> >=20
> > I'm not familiar with the benchmark you are referring to.
> >=20
>=20
> I was thinking about=20
> http://www.mail-archive.com/linux-raid@vger.kernel.org/msg08461.html
>=20
> with small discussion that happend after that.
--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-Lj5K2XXCE1rqIxscL4ZA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHHo5TTzP9PM7pjw8RAqoMAJ4lUKPNBX9+NqSRBA4J6hm5yfitxACfXwSI
hnGSBaPMRI6pt6UqFxmOEqU=
=HhUo
-----END PGP SIGNATURE-----

--=-Lj5K2XXCE1rqIxscL4ZA--

