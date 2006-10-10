From: Doug Ledford <dledford@redhat.com>
Subject: Re: avoiding the initial resync on --create
Date: Tue, 10 Oct 2006 17:26:25 -0400
Message-ID: <1160515585.2917.182.camel@fc6.xsintricity.com>
References: <20061009125700.GA10191@piper.madduck.net>
	 <20061009134946.GA26122@harddisk-recovery.com>
	 <1160411520.2917.76.camel@fc6.xsintricity.com>
	 <20061010095524.GF7416@boogie.lpds.sztaki.hu>
	 <1160502476.2917.134.camel@fc6.xsintricity.com>
	 <20061010203755.GA14865@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-47Pw7fhJZGj3/sDyEhzE"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061010203755.GA14865@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: Erik Mouw <erik@harddisk-recovery.com>, linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-47Pw7fhJZGj3/sDyEhzE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2006-10-10 at 22:37 +0200, Gabor Gombas wrote:
> You don't get my point. I'm not talking about normal operation, but
> about the case when the filesystem becomes corrupt, and fsck has to glue
> together the pieces. Consider reiserfs:

See my other on list mail about the fallacy of the idea that consistency
of garbage data blocks is any better than inconsistency.  As I mentioned
in it, even if it's a deleted file, a lost metadata block, etc., it will
always be consistent if it's a valid block to consider during rebuild
because *at some point in time* since the filesystem was created, it
will have been written.  Reiserfsck is just as susceptible to random
garbage on a single disk not part of any raid array as it is to
inconsistent blocks in a raid1 as it is to a fully synced raid1 array
with garbage that looks like a reiserfs.  That's a shortcoming of that
filesystem and there is no one to blame but Hans Reiser for that.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-47Pw7fhJZGj3/sDyEhzE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFLBABTzP9PM7pjw8RAvJ0AJ9gMAA0UvPtnt2eTxDxpw3BM4ugxQCfYBrE
GZv59tqz4pQlbQR0GpJvpIA=
=8IkR
-----END PGP SIGNATURE-----

--=-47Pw7fhJZGj3/sDyEhzE--

