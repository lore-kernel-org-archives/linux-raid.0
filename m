From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] 07reshape5intr: Set speed_limit_min to be able to
 reduce resync speed below 1000
Date: Thu, 12 Jul 2012 16:40:04 +1000
Message-ID: <20120712164004.573c65c6@notabene.brown>
References: <1341993186-8207-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hH1c7qVc9bOTO3kljOjQYdD"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1341993186-8207-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/hH1c7qVc9bOTO3kljOjQYdD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Jul 2012 09:53:06 +0200 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> We need to set speed_limit_min accordingly, otherwise setting
> speed_limit_max below 1000 will have no effect.
>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  tests/07reshape5intr |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/tests/07reshape5intr b/tests/07reshape5intr
> index 6a26bf0..71ef2c7 100644
> --- a/tests/07reshape5intr
> +++ b/tests/07reshape5intr
> @@ -20,6 +20,7 @@ do
> =20
>    mdadm -CR $md0 -amd -l5 -c $chunk -n$disks --assume-clean $devs
>    mdadm $md0 --add $dev6
> +  echo 20 > /proc/sys/dev/raid/speed_limit_min
>    echo 20 > /proc/sys/dev/raid/speed_limit_max
>    mdadm --grow $md0 -n $[disks+1]
>    check reshape
> @@ -27,6 +28,7 @@ do
>    mdadm --stop $md0
>    mdadm --assemble $md0 $devs $dev6
>    check reshape
> +  echo 1000 > /proc/sys/dev/raid/speed_limit_min
>    echo 2000 > /proc/sys/dev/raid/speed_limit_max
>    check wait
>    echo check > /sys/block/md0/md/sync_action


Applied, thanks.

NeilBrown

--Sig_/hH1c7qVc9bOTO3kljOjQYdD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/5xRDnsnt1WYoG5AQJf6w/9Gt02m50w54CAdZ2yAqwKRH/CRpCrkn+N
s4jYuGZ6ZQDtu78R07cCtfn1oLgfXC9qrpjxRhH8c4tFa5Ex2udsfrDUBcqV9C/A
1XpHCYDf1hfpb1sxAKJXITwOkc3ZznBMilv/x7T0Avk7wBl/R+pnyaAcf75M349z
96cPVKAwKEl+/hnE0co3YVlgu/iuvFCzsTw3cGHz/QoushBhETYkKqV3yohgmsfh
/BVBmuh6ocWYKHWCSxUvdndphMj4UrP1c8/2xfuN43eedv9c9v+8gpmuOslL2V++
PLG6BJhE3Tt5d4uFWXF49kljgTBPzz35B79mJCV+xU+CGs1cDVy7Ga41YTZ+ObkJ
H6qjf5aL6uCjFab/CyKcKd0L2YWBhjYoVSw1BrWZpl6X/etCLW8gLzspCmj//Df7
vsok10+i0nUR1/yc9JlwOFZ2q55sdEAtjS7xb3bjt3bybcdnpe5besA5df4LxlmZ
aHkWTsClSC7WcnMr8qvVm2xX55q9zoKUTg3lJWeruAO+rd2xjNbrNv+RtfVjmFJt
92/1cFsQhjmXrBEScODmnXSKEszy3QYbs8ROY2MLkM2iE7L9Klya9FmqLqBtlLOK
fWayUKrI2rBtuqgOnSYocHW3xsyXMtOmpQ8GY+Zp2IYJ+9cg3D80VFpQoEZf5pQh
5PlAGUcjaJg=
=Zsf2
-----END PGP SIGNATURE-----

--Sig_/hH1c7qVc9bOTO3kljOjQYdD--
