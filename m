From: NeilBrown <nfbrown@novell.com>
Subject: Re: [PATCH 1/2] imsm: use timeout when waiting for reshape progress
Date: Thu, 07 Jan 2016 11:11:31 +1100
Message-ID: <87h9iq9rkc.fsf@notabene.neil.brown.name>
References: <1452010576-10733-1-git-send-email-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1452010576-10733-1-git-send-email-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 06 2016, Artur Paszkiewicz wrote:

> Waiting for reshape progress is done by using select() on sync_completed
> to block until an exception condition is signalled on the
> filedescriptor. This happens when the attribute's value is updated by
> the kernel, but if the array is stopped when mdadm is blocked on
> select() this will never happen, because this attribute is then removed
> and apparently the kernel doesn't do sysfs_notify() when removing a
> sysfs attribute. So set a 3 second timeout for the sysfs_wait() call.

I wonder if we should fix that in the kernel somehow...

I've applied this patch and the following one - thanks.

NeilBrown

>
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  super-intel.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/super-intel.c b/super-intel.c
> index 98fe835..68cc8d6 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -10297,7 +10297,8 @@ int wait_for_reshape_imsm(struct mdinfo *sra, int=
 ndata)
>=20=20
>  	do {
>  		char action[20];
> -		sysfs_wait(fd, NULL);
> +		int timeout =3D 3000;
> +		sysfs_wait(fd, &timeout);
>  		if (sysfs_get_str(sra, NULL, "sync_action",
>  				  action, 20) > 0 &&
>  				strncmp(action, "reshape", 7) !=3D 0) {
> --=20
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWja0zAAoJEDnsnt1WYoG5NPkP/2XDsxW3p3cELKAT1sGXtOsR
QHhQ04n32SLvLHdOjLv/2l4SEYt8g2jXkGndRyOorhYhW7aVr0enfxsoB9lngBzU
83IC2la3EkqxjTtK0V821ZLrdxqgAUMDz/9YUe1BQuWbXzB5L0ZKaph82ctSspbS
ISMnybBH4ibhb3+FLKkjmdTXrITdObEJlSfzgTJX1XAJTMROtrVlZ02pw2/JfB7b
HchqxU98sVUXf53SlUX/n2OKd1ojC4S7rPAWxhzzSgaxHH1Z5xVQDSbdWjBRBRKo
CQ5+5Eok7BLwXO4edv2oGF7PR03OvYnuvWd1szDBgyf9WmIG2run6UPT93j3Oj3A
+PAGRCuyoxuJD6NLikcNvFsQkUHGpSiCHkBhdTNtGRsbMj3mV/85hi0g9yuhoDnE
sYORPK7nXU5jpufnLYMc7kK4w755Es/RgBsFvA9PMPC3wCEuHgR7z+8zpGEcwb23
Mhzh61nPS0N2ADysLlkZuks2VNA83GNpSU+26L+SP4m6K0RYxbroc8lnZNP2B4Yi
jNHK23Xi8qRM7BV7D0mPRlpuTjurY6ja2yGddS3JH4wBqnNK7v6baXx9aksgX14r
ntVRUxfDXrBjQrkFIVovblNahub8nug7LTk+S8uiRThDodwE9W6+NbN2SyvGqzqu
5zYo4YA6FDPgeowFr3uA
=EUdL
-----END PGP SIGNATURE-----
--=-=-=--
