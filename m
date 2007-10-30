From: Doug Ledford <dledford@redhat.com>
Subject: Re: Implementing low level timeouts within MD
Date: Tue, 30 Oct 2007 13:39:44 -0400
Message-ID: <1193765984.10336.519.camel@firewall.xsintricity.com>
References: <1193418753.4771.17.camel@w100>
	 <1193425254.10336.290.camel@firewall.xsintricity.com>
	 <87tzoc7soa.fsf@willow.rfc1149.net>  <1193721577.3876.12.camel@w100>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-v4NJhXEi3+jvy19ysLw6"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193721577.3876.12.camel@w100>
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Alonso <alberto@ggsys.net>
Cc: Samuel Tardieu <sam@rfc1149.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-v4NJhXEi3+jvy19ysLw6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-30 at 00:19 -0500, Alberto Alonso wrote:
> On Sat, 2007-10-27 at 12:33 +0200, Samuel Tardieu wrote:
> > I agree with Doug: nothing prevents you from using md above very slow
> > drivers (such as remote disks or even a filesystem implemented over a
> > tape device to make it extreme). Only the low-level drivers know when
> > it is appropriate to timeout or fail.
> >=20
> >   Sam
>=20
> The problem is when some of these drivers are just not smart
> enough to keep themselves out of trouble. Unfortunately I've
> been bitten by apparently too many of them.

Really, you've only been bitten by three so far.  Serverworks PATA
(which I tend to agree with the other person, I would probably chock
this up to Serverworks, not PATA), USB storage, and SATA (the SATA stack
is arranged similar to the SCSI stack with a core library that all the
drivers use, and then hardware dependent driver modules...I suspect that
since you got bit on three different hardware versions that you were in
fact hitting a core library bug, but that's just a suspicion and I could
well be wrong).  What you haven't tried is any of the SCSI/SAS/FC stuff,
and generally that's what I've always used and had good things to say
about.  I've only used SATA for my home systems or workstations, not any
production servers.

> I'll repeat my plea one more time. Is there a published list
> of tested combinations that respond well to hardware failures
> and fully signals the md code so that nothing hangs?

I don't know of one, but like I said, I've not used a lot of the SATA
stuff for production.  I would make this one suggestion though, SATA is
still an evolving driver stack to a certain extent, and as such, keeping
with more current kernels than you have been using is likely to be a big
factor in whether or not these sorts of things happen.

> If not, I would like to see what people that have experienced
> hardware failures and survived them are using so that such
> a list can be compiled.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-v4NJhXEi3+jvy19ysLw6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHJ2xfTzP9PM7pjw8RAnlkAJ9HPUAQdl6pc6QdG5N/kYcGQsncIgCcDy2C
hDktsPzp/q+49cfs+GsVfSY=
=zwL6
-----END PGP SIGNATURE-----

--=-v4NJhXEi3+jvy19ysLw6--

