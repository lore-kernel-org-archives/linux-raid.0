From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 5/8] {platform,super}-intel: Fix two resource leaks
Date: Wed, 09 Mar 2016 09:45:47 +1100
Message-ID: <87d1r4lhb8.fsf@notabene.neil.brown.name>
References: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com> <1457458252-20203-6-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1457458252-20203-6-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com, linux-raid@vger.kernel.org
Cc: gqjiang@suse.com, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 09 2016, Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> The code did not free 'dir' allocated by opendir(). An additional
> benefit is that this simplifies the for() loops.
>
> Fixes: 60f0f54d ("IMSM: Add support for VMD")
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  platform-intel.c | 7 ++++++-
>  super-intel.c    | 6 +++++-
>  2 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/platform-intel.c b/platform-intel.c
> index 88818f3..c60fd9e 100644
> --- a/platform-intel.c
> +++ b/platform-intel.c
> @@ -724,8 +724,10 @@ char *vmd_domain_to_controller(struct sys_dev *hba, =
char *buf)
>  		return NULL;
>=20=20
>  	dir =3D opendir("/sys/bus/pci/drivers/vmd");
> +	if (!dir)
> +		return NULL;
>=20=20
> -	for (ent =3D dir ? readdir(dir) : NULL; ent; ent =3D readdir(dir)) {
> +	for (ent =3D readdir(dir); ent; ent =3D readdir(dir)) {
>  		sprintf(path, "/sys/bus/pci/drivers/vmd/%s/domain/device",
>  			ent->d_name);
>=20=20
> @@ -734,8 +736,11 @@ char *vmd_domain_to_controller(struct sys_dev *hba, =
char *buf)
>=20=20
>  		if (strncmp(buf, hba->path, strlen(buf)) =3D=3D 0) {
>  			sprintf(path, "/sys/bus/pci/drivers/vmd/%s", ent->d_name);
> +			closedir(dir);
>  			return realpath(path, buf);
>  		}
>  	}
> +
> +	closedir(dir);
>  	return NULL;
>  }
> diff --git a/super-intel.c b/super-intel.c
> index 158f4e8..e1bee75 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -1781,7 +1781,10 @@ static int print_vmd_attached_devs(struct sys_dev =
*hba)
>  	 * this hba
>  	 */
>  	dir =3D opendir("/sys/bus/pci/drivers/nvme");
> -	for (ent =3D dir ? readdir(dir) : NULL; ent; ent =3D readdir(dir)) {
> +	if (!dir)
> +		return 1;
> +

Returning '1' looks really weird here.  I can see it is consistent with
	if (hba->type !=3D SYS_DEV_VMD)
		return 1;

above, but still....
As the return value is never used, should we just make it 'void' ??

Thanks,
NeilBrown

> +	for (ent =3D readdir(dir); ent; ent =3D readdir(dir)) {
>  		int n;
>=20=20
>  		/* is 'ent' a device? check that the 'subsystem' link exists and
> @@ -1814,6 +1817,7 @@ static int print_vmd_attached_devs(struct sys_dev *=
hba)
>  		free(rp);
>  	}
>=20=20
> +	closedir(dir);
>  	return 0;
>  }
>=20=20
> --=20
> 2.5.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW31YbAAoJEDnsnt1WYoG5GFgQAJNJODncjsKfjDgB8pcqs8ik
AtDFOVMN8EisaYliLdBanm5Pv0h+AdxoTrIHkCjKxxCIA7ZGcWOAPXp3TJZOCL7P
oT0pghsClXRMlTP1mBjYScxmtDxrGTQxoaNKrzE5b0TC+ncmI+RfRVU+h5Qrmpvq
ae2jxmr0S4Iz+m+b0s2/1R7ZGAp7uW9b26qs58lD8oYcmpbEjnhR04V+V6P98als
AJkKddwXGYgkHVtpT0XXMYAh6ncQc1QHEqOH5tOMjQOwtlIfEJVkChTQUa5oXtNP
WGfWJ3w52LlvIXJYePeqyxSW5FLicBY0g/5w0Krls4GhYOE+nu+9UCGsZt59qSpr
OudGOAAuHVNaTZxPjREauqdRDQMuLSTtpDZXcHjUg/Xc3RkfGCjVkiZDUZIbzlig
lR8Yt0johcWsoUkS7DTegCYhYyPL/qT25VAMfCkxUjNnNNaHfWBlBIR8slByd5fn
IOHtrwwh0LwToDn5jMUb+sBB6xKuSv7z3PXEQJqhrtlf8BJgdFozMRLYykF1VIYf
hgQBYovW9PWOKgkEqJcU+GHal0Dbj0BW2UxxckiJ3SkHMTL9e2iZpra/Uhh7GvGm
gXUIuy9hbLs01D/hB6CgXIz60KH5hlMJ1j1QmOiUAepnmgQp4ToqFfgOwub3J7yD
Z/PTCDjIESXlLs/UAFNb
=VUU0
-----END PGP SIGNATURE-----
--=-=-=--
