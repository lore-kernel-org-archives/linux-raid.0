From: NeilBrown <neilb@suse.de>
Subject: Re: Converting a .90 raid superblock to version 1.0 and
 whether--size parameter is needed
Date: Thu, 19 Mar 2015 12:03:45 +1100
Message-ID: <20150319120345.0d27542e@notabene.brown>
References: <21CFD7CC-7A05-4298-BD77-E1287B9F78D5@backblaze.com>
	<149825A6-89BC-4804-915B-5241EEB15300@backblaze.com>
	<20150318121054.066b963b@notabene.brown>
	<DDB9AAD7-E69F-4D82-9A4D-2200E1D4C81D@backblaze.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/.UB7IYD2EisQ76EA3Zctb5U"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <DDB9AAD7-E69F-4D82-9A4D-2200E1D4C81D@backblaze.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sean Harris <sean@backblaze.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/.UB7IYD2EisQ76EA3Zctb5U
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Mar 2015 17:58:05 -0700 Sean Harris <sean@backblaze.com> wrote:

> Thanks Neil,
> I'd like to try this but I'm having trouble installing it on Debian 5 (le=
nny).
>=20
> When I try to make install, it complains:
>=20
> ***** Parent of /run/mdadm does not exist.  Maybe set different RUN_DIR=3D
> *****  e.g. make RUN_DIR=3D/dev/.mdadm
> ***** or set CHECK_RUN_DIR=3D0
> make: *** [check_rundir] Error 1
>=20
> cat /etc/debian_version=20
> 5.0.10
>=20
> The default run directory apparently is not there ie: /run/mdadm
> That directory exists on Debian 7 but not Debian 5.
>=20
> I admittedly do not know what to set that variable to on Lenny. Can you p=
oint me to what to look for?

Does /dev/.mdadm exist?  If it does, try

  make RUN_DIR=3D/dev/.mdadm

If not, just use

  make CHECK_RUN_DIR=3D0

You don't need access to the rundir to assemble some devices.

And don't "make install".  Just "make", and then run

 ./mdadm ....

or copy mdadm to some where (e.g. /sbin/mdadm-new) and only use mdadm-new
when you particularly want the new features.

NeilBrown

--Sig_/.UB7IYD2EisQ76EA3Zctb5U
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVQogcjnsnt1WYoG5AQJQnxAAwMVkXcZdnGT0vN6tgjb4MnGDHiaJ6Zfe
BHQgXPpZBvAzS/ItPV8o8etJ0X3FKDHIh92eeprtFyR5eGkSqaFlOjnKy5XL4jTS
0lWMxheXClhCu2D3LPF1/uYbOVbVcrhIn8ChH2SWCQPEPf2mOffGRZlQp912VFjB
8TE13WXmY8Mblx51XRMZaM9TKcpuYOWcua2zAioGCCmqypemL4KeyLqipKf7L2TH
oD95ojM+2cHX63mNFk0us4hgM3O4B47ezrlECTpx87MgcIyZaoTp+F50uB0c8cr6
wekB/HU7FUfpos35jZE02sigf5LllAajuPkJBrvIWFBn90cqw5JtFCXn/65RXt25
l9wb51bSWHuHcLlAIVlYSYHjAkUQyLnnxlCt95QxqXDwNx0Iq0RsocMLaxjtuFdM
Ybi7nrw9v0g+oDsGys6FpKBIWIR55aDBG4yzUWv1X6DzBHXvDxJS5fVCmvj/Y32M
s+LcYzz48F9szSjbURWW2dQ7MsE3EziYT7jjVAlzMGubsm43EPQI3uwWgz2W0X8Y
92TSfhid4j5lwGdZw1mIzZmK316N1kprtv3SnfCR4873l0za73dCEg8CmfquZmoe
llgJ7czVfK4GwzyiHnFhyumJTJVM1ph6/AB+E4Uv/WB28tW2oodCP5DIVsGAN5Hf
kHjJVjNeXEg=
=TSXR
-----END PGP SIGNATURE-----

--Sig_/.UB7IYD2EisQ76EA3Zctb5U--
