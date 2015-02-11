From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH RESEND] Monitor: fix for regression with container
 devices
Date: Wed, 11 Feb 2015 15:38:14 +1100
Message-ID: <20150211153814.333cb17a@notabene.brown>
References: <1423476830-15635-1-git-send-email-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/UlezOo5xUotKFca5.P3l832"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1423476830-15635-1-git-send-email-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

--Sig_/UlezOo5xUotKFca5.P3l832
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon,  9 Feb 2015 11:13:50 +0100 Artur Paszkiewicz
<artur.paszkiewicz@intel.com> wrote:

> This patch fixes 2 problems introduced by commit 9a518d8: not closing a
> file descriptor and ignoring container devices. Array state is always
> "inactive" for containers, so we make sure that the device is not a
> container by reading also the "level" sysfs entry.
>=20
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> Reviewed-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  Monitor.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>=20
> diff --git a/Monitor.c b/Monitor.c
> index 971d2ec..66d67ba 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -483,11 +483,17 @@ static int check_array(struct state *st, struct mds=
tat_ent *mdstat,
>  		    strncmp(buf,"inact",5) =3D=3D 0) {
>  			if (fd >=3D 0)
>  				close(fd);
> -			if (!st->err)
> -				alert("DeviceDisappeared", dev, NULL, ainfo);
> -			st->err++;
> -			return 0;
> +			fd =3D sysfs_open(st->devnm, NULL, "level");
> +			if (fd < 0 || read(fd, buf, 10) !=3D 0) {
> +				if (fd >=3D 0)
> +					close(fd);
> +				if (!st->err)
> +					alert("DeviceDisappeared", dev, NULL, ainfo);
> +				st->err++;
> +				return 0;
> +			}
>  		}
> +		close(fd);
>  	}
>  	fd =3D open(dev, O_RDONLY);
>  	if (fd < 0) {

Thanks for the patch.

I don't think I agree with the logic of using 'level' though.
For the sort of arrays  that I need to ignore here, 'level' will be empty.

It would make sense to test 'metadata' though.  If that starts 'external:',
then we don't want to ignore the array.

Could you confirm that this works please?

Thanks,
NeilBrown

diff --git a/Monitor.c b/Monitor.c
index 971d2ecbea72..6e085cb24993 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -483,11 +483,18 @@ static int check_array(struct state *st, struct mdsta=
t_ent *mdstat,
 		    strncmp(buf,"inact",5) =3D=3D 0) {
 			if (fd >=3D 0)
 				close(fd);
-			if (!st->err)
-				alert("DeviceDisappeared", dev, NULL, ainfo);
-			st->err++;
-			return 0;
+			fd =3D sysfs_open(st->devnm, NULL, "metadata");
+			if (fd < 0 || read(fd, buf, 9) !=3D 9 ||
+			    strncmp(buf, "external:", 9) !=3D 0) {
+				if (fd >=3D 0)
+					close(fd);
+				if (!st->err)
+					alert("DeviceDisappeared", dev, NULL, ainfo);
+				st->err++;
+				return 0;
+			}
 		}
+		close(fd);
 	}
 	fd =3D open(dev, O_RDONLY);
 	if (fd < 0) {

--Sig_/UlezOo5xUotKFca5.P3l832
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVNrctjnsnt1WYoG5AQJVzw/6Aus38M5HL/peudCU6BtcsmhG76iNmBIu
51Hn5bKZgGYQqeK6WuZt788a2oxn4ltXS5d0XXQPNVpXKVFllPK45EYAjZZXS+5+
/E/9Op8eaQ20TWpBwbXyBvhyM3Mlm36CoiyJFVTBUWM56P385EphPsb/oK562tD1
0i/fd0ZQ91UMGe5JmRAcen+E6mNP2ndvh0D2BtY7f1/mI4aNdYnA6y7RtoocEkgs
QaDPpQFrM70NSkQHCPgxLD8ZQoI9a5z6wFxSi4Ql4wJqUTxZ4Pw9S2FteqOSJLnm
FarqAdZ8a2enq4oYtp2Hrmwg0tp4IimLJS7OJea+xBTdj+x6nzDCqK2va1Ks+e6K
YyoEwhMN6ErODKODVwSyLxwJ1iKKwRPUumlz3rIWmaVClZrbBvn2pxdazLeTp2eU
ZNt2PeesPCl4htO273btnj2avJFNRcXqaL2v15FBmo7Fz9gyq9yCyg3hYzv/Fpup
/b9/ck1XbXnUNMfQX35hNbmPMfM7a9ohuaqQiz4+qKS2MdHzzc8VfpmcD+4DAxC/
3vAWmJb0DJLp/HpIwS4ag/WAkRmKmq41OB29DLRV85BdX1YRpJ5jmL+l9CRqBW+v
ZRWL8Vg144szhRpLAjALLrVFmk8ZbwaHIbfaJIGMgmCGHHNEAYk1PZ0keGLIiHPQ
qsBt3RObdTI=
=HWCU
-----END PGP SIGNATURE-----

--Sig_/UlezOo5xUotKFca5.P3l832--
