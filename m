From: Doug Ledford <dledford@redhat.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Tue, 30 Oct 2007 12:48:40 -0400
Message-ID: <1193762920.10336.511.camel@firewall.xsintricity.com>
References: <20071026095417.GC32550@percy.comedia.it>
	 <1193424779.10336.287.camel@firewall.xsintricity.com>
	 <20071026223046.GB8210@boogie.lpds.sztaki.hu>
	 <1193531160.10336.397.camel@firewall.xsintricity.com>
	 <20071028141336.GC22861@percy.comedia.it>
	 <1193593675.10336.404.camel@firewall.xsintricity.com>
	 <20071029084118.GC15475@percy.comedia.it>
	 <1193671853.10336.428.camel@firewall.xsintricity.com>
	 <20071029214416.GB24635@percy.comedia.it>
	 <1193699142.10336.503.camel@firewall.xsintricity.com>
	 <20071030065549.GA13545@percy.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eUcFk1HbzD8y8jZsGKgK"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071030065549.GA13545@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-eUcFk1HbzD8y8jZsGKgK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-30 at 07:55 +0100, Luca Berra wrote:

> Well it might be a matter of personal preference, but i would prefer
> an initrd doing just the minumum necessary to mount the root filesystem
> (and/or activating resume from a swap device), and leaving all the rest
> to initscripts, then an initrd that tries to do everything.

The initrd does exactly that.  The rescan for superblocks does not
happen in initrd or mkinitrd, it must be done manually.  The code in
mkinitrd uses the mdadm.conf file as it stands, but in the initrd image
it doesn't start all the arrays, just the needed arrays to get booted
into your / partition.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-eUcFk1HbzD8y8jZsGKgK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHJ2BoTzP9PM7pjw8RAiCUAJ4h5phxuh30h4ZnVuhSdyfnmPf9+wCfX1BI
RI6LEOuoNn5u6dZUt+18YIU=
=Kr3e
-----END PGP SIGNATURE-----

--=-eUcFk1HbzD8y8jZsGKgK--

