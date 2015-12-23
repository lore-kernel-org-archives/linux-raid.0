From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] imsm: abort reshape if sync_action is not "reshape"
Date: Thu, 24 Dec 2015 10:04:36 +1100
Message-ID: <874mf822d7.fsf@notabene.neil.brown.name>
References: <1450871831-25452-1-git-send-email-artur.paszkiewicz@intel.com> <1450871831-25452-2-git-send-email-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1450871831-25452-2-git-send-email-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 23 2015, Artur Paszkiewicz wrote:

> When reshape was interrupted, an incorrect checkpoint would be saved in
> the migration record. Change wait_for_reshape_imsm() to return -1 when
> sync_action is not "reshape" to abort early in imsm_manage_reshape()
> without writing the migration record.
>
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  super-intel.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/super-intel.c b/super-intel.c
> index e609e0c..c7efa98 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -10300,8 +10300,10 @@ int wait_for_reshape_imsm(struct mdinfo *sra, in=
t ndata)
>  		sysfs_wait(fd, NULL);
>  		if (sysfs_get_str(sra, NULL, "sync_action",
>  				  action, 20) > 0 &&
> -				strncmp(action, "reshape", 7) !=3D 0)
> -			break;
> +				strncmp(action, "reshape", 7) !=3D 0) {
> +			close(fd);
> +			return -1;
> +		}
>  		if (sysfs_fd_get_ll(fd, &completed) < 0) {
>  			dprintf("cannot read reshape_position (in loop)\n");
>  			close(fd);
> --=20

Applied, thanks.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWeyiEAAoJEDnsnt1WYoG55icQAJVKwO45+lRiJFJzdo7R1a+h
YvSFuFE8o/EWfDXoq/HekZgXjOj9CmveMeI9gFyypRK3noIPpmzLmi4C6CiabIK8
mApOrEluiMfaIfRgQhgRtWhLfP6s6jBh9LMVPSWePZO5eUGIlGA/peppUHvF9YTs
k6BcUW+M+86MeP/VY7wodFp3drYW0GBmRA4nX6YQwAHmpkWl4uUxRamKktYCpUW2
47j7BIWKjs+85Zhf+NQhhwKGz2hasqdQIo32utTm3p/4GvSwz3+z9gCixULzJCAt
O/O5xdlPz7nxMLM97BP6C5dZOAnj7Mec2+6gsa6JN7q8M1ld7w/MgLzxF/PxKDpS
oQUgOnoZ1FoLRt4geYuHMm/A7L9yyfL8m6Yu3xVA4i6QdA49/ukWN2TZ2hXCVkLp
UiC11oRaDfwNZuY2+rRejRqu9MlkcNLSJYtO4Kf8cjy1KHXzvCJBdDL/FGjOtcqm
exxEv+bV8PPxZFxqr1HMEFx371PKhvhw+MN2G51TkWpgD2vemfIQ7MRGr3hdmi6u
DVQjrV8CPlv6GzX0L5wzO0ZZ8YgD/QNPNOJ/euu53nes8G0lE9Z4LGrapYyKPHh6
YXa5vRcVnPDZjuaW7c6aaalK7aQE4HIbeo2EW8CUybSeoUEaLLkVLC++c3KbsjU5
nK0iHy8ikcovUXMwyz+E
=i/4m
-----END PGP SIGNATURE-----
--=-=-=--
