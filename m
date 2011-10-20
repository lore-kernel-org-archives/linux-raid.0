From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm help
Date: Thu, 20 Oct 2011 14:03:15 +1100
Message-ID: <20111020140315.716d9c2e@notabene.brown>
References: <4E9F8C37.1060706@cs.utah.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cZo+o7CZYp1OEicqIRQGae4"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E9F8C37.1060706@cs.utah.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Yathindra <ydev@cs.utah.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/cZo+o7CZYp1OEicqIRQGae4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 19 Oct 2011 20:49:27 -0600 Yathindra <ydev@cs.utah.edu> wrote:

> Hi,
>=20
> I'm trying to use the faulty personality of mdadm tool to inject various=
=20
> disk failure patterns
> such as medium errors, unresponsive disk etc.
>=20
> I'm wondering if there is an option to delay commands to get an=20
> unresponsive behavior.

No, there is no way to get a delay.  You either get a success or a failure.

> Also, does rt (readtransient) and wt (writetransient) fault options act=20
> as medium errors.

They simple report an error.  The linux block layer doesn't distinguish
reliably amongst different types or errors (or it didn't last time I checke=
d).

NeilBrown


>=20
> Thanks,
> Yathi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/cZo+o7CZYp1OEicqIRQGae4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTp+Pcznsnt1WYoG5AQKAtA//QkvYbZXnq9ToaVMiND+DlEGww9KBA8D3
fMcXni4etTgx9dotX4BptR3hJo8dEFhCMpiaR0ll2U7yGIzNbSXNDqaWaAn/QJTq
33Blg8emTJRXGD4m8H2BWz/Mw/pr7ljQAiKyj4+y2z9PHP0Pzd4BXr7SeLpZmfVo
wlcEmTnMYvHY9NHVXlD/mGPBWl+ER8z6fGC76PPkc5HduRkfBHadwaJWDmTSng2B
uxXgL1S2WA7HI0zeElib9Cr3Bzqk3s6M0onNEZZskEp3VLsU+RAZO0RPBeBPVpLP
L4Ow44H4JCzqnYOpNQnqStpjUr//N8e3H3OfDKyz4kzjjmrRMfU2/u80Hl6jfonC
mq8fFlyndHS4HJ09B/ngWnFUxN7YwKscw+/MjT3lykMkGkWNViS5Lebb6C7wGCud
t5J9h7hgg6w0yzkO0WOdqdn7/HM0El18vpabwErg2vZSSfOzsjOVLRksXiJ+ga3r
WDsfo1ig0ODPoq+xe7DxdCXes77qXGv/YUu26YXwQZP7uVCQoWhlRAV6krtsYMFD
/aBkBDeF/LELagOCSuiv3NyO49MZxlRdEEKiBNNpqRUmxHtdcNqkLytRCGlgauFF
GWDTWxHQUzLRjMhzKNMDNsj/MFf3VR/JUqjILoA9ATnG7giBcTcIzisupPGouTi0
1RzuSQ6I9ZA=
=qUZ3
-----END PGP SIGNATURE-----

--Sig_/cZo+o7CZYp1OEicqIRQGae4--
