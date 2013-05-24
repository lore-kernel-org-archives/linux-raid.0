From: NeilBrown <neilb@suse.de>
Subject: Re: Attempt to change raid1 to raid0 results in division error in
 kernel
Date: Fri, 24 May 2013 21:27:03 +1000
Message-ID: <20130524212703.25af11fb@notabene.brown>
References: <20130523104400.GA827@gbl-macbook>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Q5vxIuHDcQkUbr/PBdDUZYt"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130523104400.GA827@gbl-macbook>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Goliasz <r.goliasz@digital-science.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Q5vxIuHDcQkUbr/PBdDUZYt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 23 May 2013 11:44:00 +0100 Robert Goliasz
<r.goliasz@digital-science.com> wrote:

> Hi,
>=20
> When attempting to change raid level from 1 to 0 (I was doing some testing
> trying to convert a raid1 array to a raid10 one), I got a division error.
>=20
> I'm on Debian sid, output of uname -a is:
>=20
>   Linux gbl-macbook 3.2.0-4-amd64 #1 SMP Debian 3.2.35-2 x86_64 GNU/Linux
....
> I attempted to run this:
>=20
>   gbl-macbook# mdadm --grow /dev/md0 -l 0
>   zsh: segmentation fault  mdadm --grow /dev/md0 -l 0
>   gbl-macbook#=20
>=20
> All my terminals have shown the following alert:
>=20
>   Message from syslogd@gbl-macbook at May 23 11:26:11 ...
>    kernel:[569106.802042] divide error: 0000 [#1] SMP=20

Fixed by commit 24b961f811a3e790a9b93604d25 which is in linux-3.4


http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=
=3D24b961f811a3e790a9b93604d25

NeilBrown

--Sig_/Q5vxIuHDcQkUbr/PBdDUZYt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUZ9Ohznsnt1WYoG5AQIt6BAAjpaFTzNgN9fyCJP4+4/m6SYIYA4bzpt1
9ZLHScbpkUi5z+Xn2cNhVHNFR58YoL4+udZbMiVxjmEzmINz/R6p0VKO8kWTaRvQ
UjMZKTDyiNFhL0lxMHu14OQRV2TY9ehN4WtTutXDcvWPetCwpuJTRlWLZZfKk9Aa
9rAkeZg2Hr/O/e0l0cMeTHIoFG1M5ssu2CH52P7VxX7qYJI4pYBoDz1bVUN4qAlA
+59QNZLxFqtwb6P6juQgQCb8irmIDhmjAFiw5J9KiJLlC1RGaPPKTs4yY8ABafO9
QRnf7GCw4GdH8ZkF9jqtlYQ4l6FAxY8Psi8XPMTqhrf3dh+xza6XVh9QtAljzY0g
b12FUomPm+7XMl7QMG42H6dCOX63Kk78rLSh34oPujRwTE3Lpv43PY5CsEmG3Ztc
deyjN30Yj5eEgPLvwTTM0wbfq+x1HzQD3vCy3ZNEzr8tZrrlu+bRSKKZqXAXV9OT
i9dVLoLp34hZtlvjy0iR0r5bs78It67bpXHVvRVRJVaQKD70NDvtVk+p/RZ3QSP/
XaHh7L6wptZfG0LH7RNxUMweJfOtDKyIUWvr2ajDjbFAVS00VKF2QDxfVH4lgGe+
FSD8/V2lfy1czEWagng323mulzZO02/TxUYFNTM37LjiCbXJ8QDQMRphpql94bGW
cbsAy/GaqGc=
=7qSM
-----END PGP SIGNATURE-----

--Sig_/Q5vxIuHDcQkUbr/PBdDUZYt--
