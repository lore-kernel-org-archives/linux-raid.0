From: NeilBrown <neilb@suse.de>
Subject: Re: DDF: regression caused by 273989b9 / ce45c819
Date: Wed, 7 Aug 2013 17:09:55 +1000
Message-ID: <20130807170955.7333a5a6@notabene.brown>
References: <52013D0B.8060404@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1yHZd9OrIP8ALIlgBuxtSEr"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52013D0B.8060404@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/1yHZd9OrIP8ALIlgBuxtSEr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 06 Aug 2013 20:14:35 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> Hi Neil,
>=20
> these patches break the unit test 10ddf-geometry. I saw the regression
> with both patches applied. The problem occurs when subarrays are
> deleted. With these patches in place, sync_metadata() will not overwrite
> deleted conf records on disk, but lseek() over them instead. When the
> meta data is read back, this will cause errors.
>=20
> I would like to ask you to play safe here and revert these patches. It
> might be possible to fix the --kill-subarray problem, but there are
> other possible scenarios where the number of valid conf records on a
> disk decreases - I don't think we have a reliable way to check whether
> it is safe to skip over empty entries. We must also be prepared for
> other DDF implementations to read our meta data, so we must refrain from
> putting any writing anything that might be confusing.
>=20
> Regards
> Martin

Yes, you are right.  That wasn't such a good idea, thanks.

I've changed it to allocate a large buffer (which is done for 'read' - and =
we
use the same buffer), fill that in and write.  That is a lot faster than lo=
ts
of individual writes, due to the fact that the fd is O_DIRECT.

Thanks,
NeilBrown

--Sig_/1yHZd9OrIP8ALIlgBuxtSEr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUgHywznsnt1WYoG5AQLKCw//VYGGTaWRD0SzqeVg4xs+ThByuCuX0VlW
LX4qbgvqN+/KqJUpHfgI/+NKocWb2yEAbsQGyCuGMt9jFm8gsvEfiM2WaR3LDPf3
K3pWPfMKbyYKwoRCd8u0i83DpR2/L8gHM32M359voVqziu9Pnd3ftGQJfov/WUQT
0JQHhwSCx+VNW8YlmlOAlpB05YUkgxlWaMqTFThDbqXcpfBrcfir58qVbcDGWSI1
ODyaeooz/zSlqitvLF1IpGDiw7qrEzDLBt1ILqw+7di2Hcz55k1riMd0kVXZb8kl
8AwdxGDHmcR2MqahAznonfCyBArH0c7Z0IQeUYFWD/21Pbyx6MWUG9NxWBtwveg+
9zSEcg/lZqZO4ItcsiMj8zeeP3QJvxVmHoUsWR4fua3W1d9d4370fb5CoLtF4rd7
7YlSMO49eXC8AkwKZ78C8UZuU4rrgpUvsC7tQqFJEZ8o5LubEnPYrwravz1RY6BH
qDV6PpMWhLKjz507KB3DbjTA54QxDeDqe/bhVkQ1u0MDPiHpapBphFviOETTXlUz
vPJswdpcrpl3ypI1NocdvPg8+bJaIwLC65GZxzlMZmWMK69hzDU+588C5Di/pyZ9
pWQSHtQHSKXAzxkqP5IcP3kVB27pUQK8EaAkcRj7ZTwQSDpyOp3PuWP+KV9poj6j
F8lxSGdz9hM=
=A+8c
-----END PGP SIGNATURE-----

--Sig_/1yHZd9OrIP8ALIlgBuxtSEr--
