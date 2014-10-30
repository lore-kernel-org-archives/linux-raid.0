From: NeilBrown <neilb@suse.de>
Subject: Re: Grub2/raid quickie ...
Date: Thu, 30 Oct 2014 12:03:14 +1100
Message-ID: <20141030120314.0841b558@notabene.brown>
References: <5451818B.6010809@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Rk=cv+ttTb21V/KoYdzxU9L"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5451818B.6010809@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Rk=cv+ttTb21V/KoYdzxU9L
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 30 Oct 2014 00:08:43 +0000 Wols Lists <antlists@youngman.org.uk>
wrote:

> After my last shenanigans, I've now got my main system booting
> successfully from a raid / partition. HOWEVER.
>=20
> I'm somewhat puzzled by grub.cfg, and this is in part behind why my dev
> system won't boot raid properly, I think. Grub uses two different UUIDs!?=
!?
>=20
> One of them, (mduuid/...) is dead easy to find, "mdadm -D" gives the md
> uuid of the array. But the other one, the "root=3DUUID=3D...", I'm damned=
 if
> I can find that id anywhere! Does anyone know a command, that will tell
> me what that id is, so I can fix grub.cfg on my development system?

blkid /dev/whatever

>=20
> (As an aside, how do I retrospectively force a name onto an array so
> that I can guarantee it will be called /dev/md100, or /dev/mdhome, or
> whatever? I daren't use the /dev/mdxxx name at the moment, because they
> change and the result is a system that fails to boot, or is unusable, or
> some other malarkey. Dead easy for me to fix, but my wife will go spare!)

 mdadm --assemble /dev/mdhome --update=3Dname  list-of-devices

You cannot do this without stopping the array, sorry.  Boot off a usb or CD
is necessary.

NeilBrown


>=20
> Cheers,
> Wol
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/Rk=cv+ttTb21V/KoYdzxU9L
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVFGOUjnsnt1WYoG5AQI3jxAAoQLt14yBpDoyz/OH3zGSQ6PmFu1e2wat
iJyykT6DnKE859OPC2k0TBqS1U9uc9qI4uXpiz7oWRItHHaeiVwKj6HPpQhsP5Gr
O3seg0of8NVl7tCaPQ0P3cE0fKUHg560JJVn8FVvHXV+BnNx7oj120kBPiOJRyUn
86S8TXzD44s9dpM1kVmb6z28GjdmC62UyYCFcZh35MMK07vQwr87MvG2uz/1n3Xa
HyK01U+90d7i8lQX25D49JPF6YZubL/9rP6CXb1NYvjI4J70nQI56HYc/JHnkpyb
e7uvu17cyabNM9mf59VSAROPagEKbMQK7syc84acSHSBqCKz9JirUGPTrmPsWukn
a/BLRyvb0AUtAhi6peIUl6TK+aV1zFcItQqPxhPUaJ0Bnh0DsAhN6BJrOsRQ/8Nh
BB9Rloq6uxMyHxYTR1oJBHQZKHmg45yHsOGCx8JgEENjeHfFYvVRYCNgI5C7T0jK
S8zbBTn4gD/pDs+jedySUi1We7SZ2SuNfb5SOTwI94HXMkklfPnGJSSzoEJhJ87+
fUoZ/NQoEaerEg+JNJg/cTLR/nX3kHCZGJWnllv6SATWmUUdHgkfpRM0U6tlB3/8
JqMRh/9RVgcesazBQbfuUAjym9uSgEQFPeTYiylr0lZK1mHIWlFjt1AhP50WY2C8
dSInpxxPj0E=
=izg0
-----END PGP SIGNATURE-----

--Sig_/Rk=cv+ttTb21V/KoYdzxU9L--
