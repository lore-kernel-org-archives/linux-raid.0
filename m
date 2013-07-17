From: NeilBrown <neilb@suse.de>
Subject: Re: Backup file size when migrating from raid5 to raid6?
Date: Thu, 18 Jul 2013 06:51:59 +1000
Message-ID: <20130718065159.0a40207e@notabene.brown>
References: <CAH-e9vLTY2eo0p3ud5FaWNe_2f8hej0aitFuu8K0M1RZdObiXQ@mail.gmail.com>
	<CAH-e9vLiK6=HmDjM=Ub7p_Lxrp_L0x1bkAa2oP=ykajqvtkfDQ@mail.gmail.com>
	<loom.20130717T145156-76@post.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/oyRtDZfIWbJ0a8aiWhE4nBO"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20130717T145156-76@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Boyan Alexiev <alexiev@resonance.bg>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/oyRtDZfIWbJ0a8aiWhE4nBO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Jul 2013 13:01:15 +0000 (UTC) Boyan Alexiev <alexiev@resonance.b=
g>
wrote:

> If You have array with 9 devices and add another one You may at same time
> grow array and change raid level. In this case You not need backup file.
> Please try this:
> mdadm --grow /dev/md0 --raid-devices=3D10 --level=3D6=20
>=20

You can only skip the backup file if you  are increasing the number of *dat=
a*
devices.  I don't think your example does that.

(However with mdadm-3.3 this problem goes away if you have a new enough
kernel).

NeilBrown

--Sig_/oyRtDZfIWbJ0a8aiWhE4nBO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUecD9Dnsnt1WYoG5AQL4nA//XC6umlxRP7BX3FZnVeQQeeLPua4slmx1
zMi9dEchWLj/r/0utJvJDIvtdKjkHTVuB5cEcuE1jiszHc/Q/MAVbbL1HvFVVADU
vTbSGJeRdkmOIHGP9gnSewERBaxdtEaC+NXM+WYg1hbTaJ5t+WQvFKcE0OBWQdkW
NSWyFnEnBbfRfbeay4m7cTjhGoJZAj4x5cj8K2x4UfSEZwQuvQeC24OPEATCkKSM
M1Nq1IOjgrhH7mBh8eOs5WeH/BUaz8+96JbBC+CLsIa8HFq23CZZVqhcclIZkEhY
D428O8vKI/whBTPwthc7BPrHPuvdb5Yuh/BR/YaTJ65Izj+G7HNTsbubQX5acPGb
TgUupHP8451ePfZwmZjcvFK3V8OfGv+VLZ8+DPdUTOmL2pEUK1dJTmVH07q3zsUx
TSyH9eDBMlKZzIKMCp22VL8DmIc+5VaC6X54qhftikEPGO9XpYfufNQwKPVA8uJA
L5QBJjnl2XfYru5NK9TPS8LbDDyTt9r72vMvTEkW++ab9lgrKR+aTqLX6kKRziov
k8PLalVKl33YoP9wS9f8gMtAaHwtG3kCY63EBoUUjHOlQ/Dl1OhyexE5OGxkMzS2
eqW41f7DNljlWmxE2kNFPWmkaDCrO64qtSQQINVK7eoWWKKvCmqI3qOVtTNL6N+v
hR0/UxHi4Yg=
=rRPJ
-----END PGP SIGNATURE-----

--Sig_/oyRtDZfIWbJ0a8aiWhE4nBO--
