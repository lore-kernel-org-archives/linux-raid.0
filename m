From: Doug Ledford <dledford@redhat.com>
Subject: Re: Raid-10 mount at startup always has problem
Date: Thu, 25 Oct 2007 02:51:51 -0400
Message-ID: <1193295111.10336.85.camel@firewall.xsintricity.com>
References: <46D3147D.2040201@amfes.com> <46D49F1A.7030409@tmr.com>
	 <46E4A39C.8040509@amfes.com> <46E4A5F0.9090407@sauce.co.nz>
	 <46E4A7C3.1040902@amfes.com> <471F5542.3020504@amfes.com>
	 <18208.13247.106651.142652@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-v1YrKkmhK99Fs8qccbiB"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18208.13247.106651.142652@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Daniel L. Miller" <dmiller@amfes.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-v1YrKkmhK99Fs8qccbiB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-10-25 at 16:12 +1000, Neil Brown wrote:

> > md: md0 stopped.
> > md: md0 stopped.
> > md: bind<sdc>
> > md: bind<sdd>
> > md: bind<sdb>
> > md: md0: raid array is not clean -- starting background reconstruction
> > raid10: raid set md0 active with 3 out of 4 devices
> > md: couldn't update array info. -22
>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>=20
> This is the most surprising line, and hence the one most likely to
> convey helpful information.
>=20
> This message is generated when a process calls "SET_ARRAY_INFO" on an
> array that is already running, and the changes implied by the new
> "array_info" are not supportable.
>=20
> The only way I can see this happening is if two copies of "mdadm" are
> running at exactly the same time and are both are trying to assemble
> the same array.  The first calls SET_ARRAY_INFO and assembles the
> (partial) array.  The second calls SET_ARRAY_INFO and gets this error.
> Not all devices are included because while when one mdadm when to
> look, at a device, the other has it locked and so the first just
> ignored it.

If mdadm copy A gets three of the devices, I wouldn't think mdadm copy B
would have been able to get enough devices to decide to even try and
assemble the array (assuming that once copy A locked the devices during
open, that it then held the devices until time to assemble the array).

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-v1YrKkmhK99Fs8qccbiB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHID0HTzP9PM7pjw8RAu+7AJ9JIR/h5l52Yw5xGCuWA0U7D0MfTwCfR7tX
NkqSduAtBeJ49CsesZW1+EM=
=Bm/6
-----END PGP SIGNATURE-----

--=-v1YrKkmhK99Fs8qccbiB--

