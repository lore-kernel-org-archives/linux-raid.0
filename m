From: NeilBrown <neilb@suse.de>
Subject: Re: --no-degraded does not work
Date: Sat, 8 Nov 2014 10:22:47 +1100
Message-ID: <20141108102247.687b8863@notabene.brown>
References: <545CF69B.6040307@gautschi.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/durCVPftb5K9ISY=FVF/N/2"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <545CF69B.6040307@gautschi.net>
Sender: linux-raid-owner@vger.kernel.org
To: "P. Gautschi" <linuxlist@gautschi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/durCVPftb5K9ISY=FVF/N/2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 07 Nov 2014 17:43:07 +0100 "P. Gautschi" <linuxlist@gautschi.net>
wrote:

> As far as I understand the documentation --assemble --no-degraded should =
not start a degraded array.
> However on my system (kubuntu 14.10)
>=20
> # mdadm --assemble --no-degraded /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1 /=
dev/sde1 /dev/sdf1
> mdadm: /dev/md0 has been started with 4 drives (out of 5).
>=20
> # mdadm --detail /dev/md0
> /dev/md0:
>          Version : 1.2
>    Creation Time : Tue Nov  4 15:26:46 2014
>       Raid Level : raid5
>       Array Size : 599469328 (571.70 GiB 613.86 GB)
>    Used Dev Size : 149867332 (142.92 GiB 153.46 GB)
>     Raid Devices : 5
>    Total Devices : 4
>      Persistence : Superblock is persistent
>=20
>    Intent Bitmap : Internal
>=20
>      Update Time : Fri Nov  7 17:22:53 2014
>            State : clean, degraded
>   Active Devices : 4
> Working Devices : 4
>   Failed Devices : 0
>    Spare Devices : 0
>=20
>           Layout : left-symmetric
>       Chunk Size : 4K
>=20
>             Name : 0
>             UUID : c7465b19:c149b2d1:5b4d88ce:8c6ce432
>           Events : 642
>=20
>      Number   Major   Minor   RaidDevice State
>         0       0        0        0      removed
>         1       8       33        1      active sync   /dev/sdc1
>         2       8       49        2      active sync   /dev/sdd1
>         3       8       65        3      active sync   /dev/sde1
>         5       8       81        4      active sync   /dev/sdf1
>=20
> the array IS started when removing one disk, stopping it, reconnecting th=
e disk and then assemble the array.
> Is this the supposed behavior?

Yes, that is the correct behaviour, though I admit that it is slightly
unintuitive.

--no-degraded will cause mdadm to refuse to assemble an array which is more
degraded than it was last time it was active.

So if you have an optimal array, stop it, then try to assemble with some
devices missing, then --no-degraded will cause that to fail.

If the array is already degraded, then there doesn't seem much point in
stopping it from assembling.

Do you have a particular goal, or were you just making sure you understood?

Thanks,
NeilBrown

--Sig_/durCVPftb5K9ISY=FVF/N/2
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVF1URznsnt1WYoG5AQK0oRAAqn7lEw03D0JEhIZER46uIZVATQ6JQlKM
ppa70pEACF7X+garr3C9aWw0mvmKjLlr3L+0N/7vE04/G8Gvx9P1d6AX5wJEHNKj
cbv8W1EwfDfuWO5IEDSc26eSg80KIY8ZG3+doWorI+Mz4pH4tpExs1ovS2VgiJqK
eMh0X4I1eWSUAJ22DQ90ef5AADJotINUHxXg1hiSort9shSnOwrDNmoJ+o+omJaw
YiXeQXA4Pn8+vsdoDC6HZdRuyB6W8yV0gjGPVHgRFKyRXW2lxJ5td+1wjdlWWY9l
eGvazjggBwlsJO1CwCuxx64ApE2jsPBLdZiEzWCeHpZbgVN9jOJkJ55oFsCzbW8M
74e8lJDp08XLFaczmBsunum6TfiWFb+3lS7V+4FBtgMzifVGY9mCcDNX56w0DCjs
uXWN+2eeHUIBpmBYf4E5VZNTCMMvQ69ePFiZcGXWf4JGQ8W1h2Ksosiq8d9wmsM5
CDcoVCFPL+6nNdlBBGM34JV52jiLNSLMXleEYpfN6EC+CJ4YorjUk4qrddJoKGXl
+cYj+ztHBEO58G+vSrRkSolPuU+oZqe16ger+cpSgUMVmN46IGlLWw+88RNMESmD
Muqmjc/CunLfodBBqVKPknrxrfzvhu7kjO0bWkrxzu8PKBGLljF+1/hwMf93/cs3
5dzavMrmgE0=
=DL0P
-----END PGP SIGNATURE-----

--Sig_/durCVPftb5K9ISY=FVF/N/2--
