From: NeilBrown <neilb@suse.de>
Subject: Re: Paranoid mode for RAID-1 ?
Date: Mon, 27 Apr 2015 16:49:24 +1000
Message-ID: <20150427164924.2aee3831@notabene.brown>
References: <1610581828.22506051.1430116628556.JavaMail.zimbra@laposte.net>
	<972437107.22507366.1430116679975.JavaMail.zimbra@laposte.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/+rYBWX8CoNzRVbDR0AtE=l1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <972437107.22507366.1430116679975.JavaMail.zimbra@laposte.net>
Sender: linux-raid-owner@vger.kernel.org
To: Jean-Baptiste Thomas <cau2jeaf1honoq@laposte.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/+rYBWX8CoNzRVbDR0AtE=l1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 27 Apr 2015 08:37:59 +0200 (CEST) Jean-Baptiste Thomas
<cau2jeaf1honoq@laposte.net> wrote:

> I'm looking for a way to get MD to operate in a mode in which
> reading a sector from a RAID-1 device would not succeed until it
> got matching data from at least two components.
>=20
> Recent experience[1] suggests that a transient problem in one
> disk can completely hose a four way RAID-1 array, which is
> otherwise supposed to still be fine after a triple total
> failure. I'm hoping that a paranoid mode would have prevented
> that.
>=20
> If there is such a thing, PLEASE tell me. If not, please tell me=20
> so I don't waste any more time looking for it.

No, there is no such thing.

There "should" be no circumstance which would make it worth while.
A drive may well report an error, but it should *never* report incorrect da=
ta
as though it were correct.  That is horribly broken.

The cost of running in a "safe" mode would be high, and the likely benefit
extremely low.  So it is unlikely that anyone would use it for long.  So
implementing it seems rather pointless.

That said: if someone were to provide an implementation I would certainly
consider reviewing it and adding it to md.

NeilBrown

>=20
> [1] "Massive RAID-1 desync"
> http://www.spinics.net/lists/raid/msg48681.html
> http://marc.info/?l=3Dlinux-raid&m=3D143003812706563&w=3D2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/+rYBWX8CoNzRVbDR0AtE=l1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVT3b9Tnsnt1WYoG5AQKoeg/+IBvUC7x3PXRu/jGGrfl9eQXurH3sc+gY
aLm3j8qEv/A2jmg47ofNUBUF2FNZn8VRp41V9C9kZoMkdJBy7MzDKFD1rhN4dRws
lBj7SlkTLdJQSSnwjy6XOoDvsZeSH6S6OM+kjoWBv0aIYA6IyJzWAzU1jtpgYE7b
7OkR9aME4BPzOCEpgqW3+NinxnUXNxU0gktm5rtqN9dXLQcgBbJ/fKko+kkKS2Zd
GdJ5dfTpeL8kNOSvHY0/s0CfSB6whKAynSblQW9bfB12NU9atHaNGP93DKUQ/maj
0r+6omc/l7ew6P/yUvfTgnI3WHwSmSU2U6a0hjVXdtyk/fNCzZkBlfYnX7mqe29g
yZF2YS3A9i4bklitMVPmVcKGap8NDHnP+c9UO0/nvTRRu0CP2ixm5a4L2UPlz9jw
e617OSNs9YPBuDVBMJtY0bWTZngIVLIrWTEQ5h4s6ntJxJO6jbY62mGpLNYWN+dk
FrsipgqLHKJdClu3koq7BZTmrKcIGnSJe5GRSgEf+lmgjQ00Xw35e7ArgslBuhW3
S/MJTdujBLcTQaytyDtfVIRl7M6dFHDStJD45IRSZUw4lvOlSjG5B5dSe4r8ukTY
OZinPP7U4ZyC5fhWBIjz50nOvN1B/nM152B3fas2owGJ4pmpIz5/voAQHe2y6CWi
wWrGylSEi7c=
=VU93
-----END PGP SIGNATURE-----

--Sig_/+rYBWX8CoNzRVbDR0AtE=l1--
