From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/4] Add --initrd argument to mdadm
Date: Sun, 22 Jan 2012 22:17:58 +1100
Message-ID: <20120122221758.412b18d4@notabene.brown>
References: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com>
	<1326797330-4488-3-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/UyIgty/C7=XN1aPXc5wE7N1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1326797330-4488-3-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, kay@redhat.com, harald@redhat.com, lpoetter@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

--Sig_/UyIgty/C7=XN1aPXc5wE7N1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Jan 2012 11:48:48 +0100 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> When --initrd is parsed, mdadm will change the first character of
> argv[0] to '@'. This is used to signal to systemd that mdadm was
> launched from initramfs and should not be shut down before returning
> to the initramfs.
>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  ReadMe.c |    3 +++
>  mdadm.c  |   10 ++++++++++
>  mdadm.h  |    1 +
>  3 files changed, 14 insertions(+), 0 deletions(-)
>=20
> diff --git a/ReadMe.c b/ReadMe.c
> index 9aa798b..49dc04f 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -111,6 +111,7 @@ struct option long_options[] =3D {
>      {"kill-subarray", 1, 0, KillSubarray},
>      {"update-subarray", 1, 0, UpdateSubarray},
>      {"udev-rules", 2, 0, UdevRules},
> +    {"initrd", 0, 0, InitrdOpt},
> =20
>      /* synonyms */
>      {"monitor",   0, 0, 'F'},
> @@ -268,6 +269,8 @@ char OptionHelp[] =3D
>  "  --query       -Q   : Display general information about how a\n"
>  "                       device relates to the md driver\n"
>  "  --auto-detect      : Start arrays auto-detected by the kernel\n"
> +"  --initrd           : Set first character of argv[0] to @ to indicate =
the\n"
> +"                       application was launched from initrd.\n"
>  ;
>  /*
>  "\n"
> diff --git a/mdadm.c b/mdadm.c
> index f07fac2..c0ccf55 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -174,6 +174,16 @@ int main(int argc, char *argv[])
>  				homehost =3D optarg;
>  			continue;
> =20
> +		/*
> +		 * --initrd sets first char of argv[0] to @. This is used
> +		 * by systemd to signal that the tast was launched from
> +		 * initrd/initramfs and should be preserved during shutdown
> +		 */
> +		case InitrdOpt:
> +			c =3D argv[0];
> +			c[0] =3D '@';
> +			continue;

Why not:
                        argv[0][0] =3D '@';
??

Also I'm wondering about the choice of "initrd" as the option name.
After all, we mostly use initramfs these days.

 --preboot ??
 --systemd-root-storage-daemon ??

OK, the second is a joke, and the first is introducing terminology that isn=
't
widely used...

 --for-root
??

I'm open to suggestions, but I'm not seeing --initrd as the best choice just
yet.

Otherwise this and 1/4 are OK.

Thanks,
NeilBrown

--Sig_/UyIgty/C7=XN1aPXc5wE7N1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTxvwZjnsnt1WYoG5AQI1Cw/+I+//nrt23DSYCppgrlbfiyH4NkHtIyhs
WxwHXsnUEy4bVT6YUpzp5oEucDun6/d0IgtwDF8zVLpEKW7qHVN48TNMJlXx4K6Z
QsAVkAMJrcd6IFOpz8/2ff5YebHZOhroYezsvPoAvUp7qn61B9Xc0VcE0Sowzcxc
pY02jNMsftp6Ad++R6RqhA4wtk4CY2VpIzJAfnkwwrtLTsmSmA03l9zXW9hVzOMr
Tu656UCOlagXjjkTe/Y//XR5i9qmASiotmZt8QPAT82Ok3glQ3NhqKwBHleWlE3m
2Qmjby4tzMAKC4eh4n49lcnzyi5MzQKYl1P8Vs5WweAdsFmCLykqc35o6pjRt7Tb
4AIzRLCZuo7vNSoV6NkVQYGaC3CZBHtWnxs3uQ1WcUX2suEFY6krhvFTw1iWHi8h
niu4raSI2ip6mOomlcTbsI/2EZ2EEqU5PQwCf0hSSj5jfaQijqsX2EKfMguYZF7F
60i+lYtqslsXR7+4EJTporzeqRp8A4odb6LhiDWAKyrG/2HaWqf2jKn3Zk/AFYZW
RBCkCH1bnLO4k0EvnWg3uw7rNdxI/5WtQ+n5nbY2bkJGlAVI/VPhKQajMs7A5IOo
wI/J3ZN//0pO3eJUGUTIEdNwpCw1vg5E0T3fiVDV5VzUkcEbThSEGfIUoSHyUACu
qtLcObZL6sY=
=+ZP8
-----END PGP SIGNATURE-----

--Sig_/UyIgty/C7=XN1aPXc5wE7N1--
