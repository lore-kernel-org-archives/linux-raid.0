From: NeilBrown <neilb@suse.com>
Subject: Re: [MDADM PATCH] Check and remove bitmap first when reshape to raid0
Date: Tue, 22 Dec 2015 15:20:02 +1100
Message-ID: <87twnb2jyl.fsf@notabene.neil.brown.name>
References: <1450753774-4358-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1450753774-4358-1-git-send-email-xni@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: Jes.Sorensen@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 22 2015, Xiao Ni wrote:

> If reshape one raid device with bitmap to raid0, the reshape progress will
> start. But it'll fail and lose some components. So it should remove bitma=
p=20
> first.=20
>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  Grow.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/Grow.c b/Grow.c
> index 6dfb9c9..db4daa8 100755
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1590,6 +1590,15 @@ int Grow_reshape(char *devname, int fd,
>  		pr_err("Cannot increase raid-disks on this array beyond %d\n", st->max=
_devs);
>  		return 1;
>  	}
> +	if (s->level =3D=3D 0 &&=20
> +	    (array.state & (1<<MD_SB_BITMAP_PRESENT)) &&=20
> +	    !(array.state & (1<<MD_SB_CLUSTERED))) {
> +                array.state &=3D ~(1<<MD_SB_BITMAP_PRESENT);
> +                if (ioctl(fd, SET_ARRAY_INFO, &array)!=3D 0) {
> +                        pr_err("failed to remove internal bitmap.\n");
> +                        return 1;
> +                }
> +        }
>=20=20
>  	/* in the external case we need to check that the requested reshape is
>  	 * supported, and perform an initial check that the container holds the

applied, thanks.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWeM9yAAoJEDnsnt1WYoG5K0gP+wes8KM0EwSkOS3C6aV9b4Jq
JyzBM28Qjlqzr4pmNfPozK/smTXMuL8ijXQg5fy1lEFDqaRj1ER3wLsV9hyP3Iud
8c64+mC0cxNJg6vh5ENNMKqU19K58+dCEYnvmQwcKsEJ50CQ+dzVqzuFa04mbaMU
YIeSNHTq6jxbY5VzV9POiGT4W1g06le9QNnVjFT7cpKWIP1U8f7JxmHQsts5WFV/
ZnIYdCUPSBzYnFkrOcVkZIEA5YTQv29MInZW+rX8/XA8TPX9mAK9OJT+HD8mOlVw
RtxwKJ1N0L0yuZ+c+FrW9SHsrjazDWV+rhC4i9wsqOIdmGNvwX47EPMpoIPDWKOa
I1YhSvND0trNQog6CdzVnaHsPQpalha2si55rHUM4kJVu/0VZBij9IRqdvp7VSyk
V1y7zRLMcNAhbu4bZxidOqxTGgEotBLvF3qYmBismhLig8SwPCdaZsF+gKYFYAS8
O8tC6So82p2JOr00RXBulubso9qym2+O2o08bxY4j8oh27oFM/M9TD0+zzcufjig
d5Cf+RLu5+83I1POVvd8E+DjdNdMdhmKxPi35B3xhy8qy8iw8MsPtFf9DNPTxKUI
t/s/Y9QeWg1axW8/jLbauv6xh4QQsqALdfZuTgP7Zhee1prHKwS2w3mx07HevBhG
SMdnO+04GtoDzyNXls/z
=xHQo
-----END PGP SIGNATURE-----
--=-=-=--
