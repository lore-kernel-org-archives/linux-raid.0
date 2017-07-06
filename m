From: NeilBrown <neilb@suse.com>
Subject: Re: Disk Monitoring
Date: Thu, 06 Jul 2017 13:31:37 +1000
Message-ID: <87inj6xmue.fsf@notabene.neil.brown.name>
References: <CAJH6TXgvrVckHDmh1oiN9mupLrsS2NP3J44bG1_wE9Nnx4=yHQ@mail.gmail.com> <20170628104545.z7anvliygsjrhqax@vault.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170628104545.z7anvliygsjrhqax@vault.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Johannes Truschnigg <johannes@truschnigg.info>, Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 28 2017, Johannes Truschnigg wrote:

> Hi Gandalf,
>
> On Wed, Jun 28, 2017 at 12:25:55PM +0200, Gandalf Corvotempesta wrote:
>> Hi to all
>> I always used hardwre raid but with my next server I would like to use m=
dadm.
>>=20
>> Some questions:
>>=20
>> 1) all raid controllers have proactive monitoring features, like
>> patrol read, consistency check and (more or less) some SMART
>> integration.
>> Any counterpart in mdadm?
>
> mdmon(8) is what you seek. Also, monitoring the kernel debug ringbuffer I=
 can
> highly recommend.

Not mdmon(8).
Possible you mean "mdadm --monitor".

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlldrxoACgkQOeye3VZi
gblbvA//cNx4OCDGdDNhJqQIyn2KmSBqynHXa1rnWQCyao7xA8ldlO8xZ+YSBI+Q
YYjWQNEJ8ruluYBZb8sqT1sa1JUxv2DdkbeFs5XcdtXqXLTOu/74DQzyRCNADATZ
SMDghJI5ZK1Wukr2wWe5d4E5ba2BLq0MXZ/hU7Rj2ThgMNSpstLFdYi+GsYNJY6u
kYlocrLoyaX7NiDLs746x0sInHxxsv31bSuz9jjyNvuK2wXd7stjTG8HbHeL1EuS
BUkchBlFBy2G8+nFAZe7eTLvjAdENrDWFCVVTKxyvizXljfiwZ0FZptcw1w/mSaP
lr03ZMwsKwit3KFmO/KeiRdRERUTpPgho9MrWJqubS3rWX6hAgB5J3M7aNc0ib7W
QWWxaL3xAj+DD4uUf+psWRj+DI4TugtdqWvBNRd6AeOVW0DyxNRuRmROYp0gzi2t
F54NzgLj8XIwDpelxibKL/x/5rHkrYK5gEd/tCkZSLWfDXsoqjOXkECzZLT/8L9b
V2PQwFM/hvw/aFpPqZrdMberB6HDGxbuRBA/lwxtQjn4x9zrSkg6AOPPF2RvceG1
VsROLya9eAeo/HZLMyX4ZS8+s9gyikPXlZUxhl7trQfYwz/H6X6kOUAol4ZsIYuW
ncaKHOiGtH0fLdtqCh5O13vHvv28HWXjcAOZyy0l/v0LNu9vHwA=
=19lK
-----END PGP SIGNATURE-----
--=-=-=--
