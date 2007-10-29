From: Doug Ledford <dledford@redhat.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Mon, 29 Oct 2007 11:30:53 -0400
Message-ID: <1193671853.10336.428.camel@firewall.xsintricity.com>
References: <20071019212303.GB2013@teal.hq.k1024.org>
	 <1192830129.1666.103.camel@firewall.xsintricity.com>
	 <20071020075349.GA17431@teal.hq.k1024.org>
	 <1192885917.1666.112.camel@firewall.xsintricity.com>
	 <20071026095417.GC32550@percy.comedia.it>
	 <1193424779.10336.287.camel@firewall.xsintricity.com>
	 <20071026223046.GB8210@boogie.lpds.sztaki.hu>
	 <1193531160.10336.397.camel@firewall.xsintricity.com>
	 <20071028141336.GC22861@percy.comedia.it>
	 <1193593675.10336.404.camel@firewall.xsintricity.com>
	 <20071029084118.GC15475@percy.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4Fn8eY7XJMl+ax9CPjO8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071029084118.GC15475@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-4Fn8eY7XJMl+ax9CPjO8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-10-29 at 09:41 +0100, Luca Berra wrote:

> >Remaking the initrd installs the new mdadm.conf file, which would have
> >then contained the whole disk devices and it's UUID.  There in would
> >have been the problem.
> yes, i read the patch, i don't like that code, as i don't like most of
> what has been put in mkinitrd from 5.0 onward.
> Imho the correct thing here would not have been copying the existing
> mdadm.conf but generating a safe one from output of mdadm -D (note -D,
> not -E)

I'm not sure I'd want that.  Besides, what makes you say -D is safer
than -E?

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-4Fn8eY7XJMl+ax9CPjO8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHJfytTzP9PM7pjw8RAnToAJ9qnnzgW/810tyN6WE80iZ7Y12eQwCfW45f
8puLCEpQBk4iJqE6trzurKk=
=vo/7
-----END PGP SIGNATURE-----

--=-4Fn8eY7XJMl+ax9CPjO8--

