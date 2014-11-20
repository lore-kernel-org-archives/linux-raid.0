From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 5/5] imsm: use efivarfs interface for reading UEFI
 variables
Date: Thu, 20 Nov 2014 14:11:18 +1100
Message-ID: <20141120141118.07ac1027@notabene.brown>
References: <1416401610-16209-1-git-send-email-artur.paszkiewicz@intel.com>
	<1416401610-16209-6-git-send-email-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/0r7q_SKgPDLw1qzWlxW7qGa"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1416401610-16209-6-git-send-email-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

--Sig_/0r7q_SKgPDLw1qzWlxW7qGa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 19 Nov 2014 13:53:30 +0100 Artur Paszkiewicz
<artur.paszkiewicz@intel.com> wrote:

> Read UEFI variables using the new efivarfs interface, fallback to
> sysfs-efivars if that fails.
>=20
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  platform-intel.c | 37 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 36 insertions(+), 1 deletion(-)
>=20
> diff --git a/platform-intel.c b/platform-intel.c
> index 54ef37f..586a2f6 100644
> --- a/platform-intel.c
> +++ b/platform-intel.c
> @@ -416,6 +416,7 @@ static const struct imsm_orom *find_imsm_hba_orom(str=
uct sys_dev *hba)
>    (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
> =20
>  #define SYS_EFI_VAR_PATH "/sys/firmware/efi/vars"
> +#define SYS_EFIVARS_PATH "/sys/firmware/efi/efivars"
>  #define SCU_PROP "RstScuV"
>  #define AHCI_PROP "RstSataV"
>  #define AHCI_SSATA_PROP "RstsSatV"
> @@ -426,10 +427,44 @@ static const struct imsm_orom *find_imsm_hba_orom(s=
truct sys_dev *hba)
> =20
>  #define PCI_CLASS_RAID_CNTRL 0x010400
> =20
> -int read_efi_variable(void *buffer, ssize_t buf_size, char *variable_nam=
e, struct efi_guid guid)
> +static int read_efi_var(void *buffer, ssize_t buf_size, char *variable_n=
ame, struct efi_guid guid)
>  {
>  	char path[PATH_MAX];
>  	char buf[GUID_STR_MAX];
> +	int fd;
> +	ssize_t n;
> +
> +	snprintf(path, PATH_MAX, "%s/%s-%s", SYS_EFIVARS_PATH, variable_name, g=
uid_str(buf, guid));
> +
> +	fd =3D open(path, O_RDONLY);
> +	if (fd < 0)
> +		return 1;
> +
> +	/* read the variable attributes and ignore it */
> +	n =3D read(fd, buf, sizeof(__u32));
> +	if (n < 0) {
> +		close(fd);
> +		return 1;
> +	}
> +
> +	/* read the variable data */
> +	n =3D read(fd, buffer, buf_size);
> +	close(fd);
> +	if (n < buf_size)
> +		return 1;
> +
> +	return 0;
> +}
> +
> +static int read_efi_variable(void *buffer, ssize_t buf_size, char *varia=
ble_name, struct efi_guid guid)
> +{
> +	/* Try to read the variable using the new efivarfs interface first.
> +	 * If that fails, fall back to the old sysfs-efivars interface. */
> +	if (!read_efi_var(buffer, buf_size, variable_name, guid))
> +		return 0;
> +
> +	char path[PATH_MAX];
> +	char buf[GUID_STR_MAX];
>  	int dfd;
>  	ssize_t n, var_data_len;
> =20


Patch 2, 3, 4 look OK.
This one is nearly OK, but I don't like to see executable code (the
read_efi_var call) before variable declarations (even though some versions =
of
C allow it).

So if you can put that 'if' *after* the variables, it will be OK.

Thanks,
NeilBrown

--Sig_/0r7q_SKgPDLw1qzWlxW7qGa
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVG1b1jnsnt1WYoG5AQJSaQ//VvJD/kWN5NVr9B+xgd72rOVBaDjpOaXn
Vk0R1U0F1DeuhLHfWTdhh8CikPvef1HCvk0xH0jTrOq1jl94mhrHOGF3sVpubFyy
Qef4+PE8aac/YP2yV8/Dpo93pj+sZUfqlhCTDDBe+Qv25vwZoIdOGki9mO7zTQS+
2hozK42ovs36HuAl3C8TVktoEIup9yMqVhATI+O9Hy+D7a8wdHGsudJW+p4X5liG
9hLbGWCBXi3ns7BT0zIF145cUuIQ/wZYSrXr2z4TYgwCD7+MOgIzavby2g5Z9PVK
8yCMDqb58qCgVfjQwC8xJbHJbPfWefpmh4QyjSEIWRpn9/WFnW41AFl4iJLb6+x3
rfK3cxsL8Pi4FoxOVz/8Ize+MglEESpDsGihZvQaYoqpIIRrJp5DuSNFl1Rz7CjI
cSQEdxdo+yyFRBj9KXhvTr0mPoHiOuvbmfTvxXMzXDCQIGCgY5IhAvYc3PGG3WyA
xU6MPoP0q2Ns8IBxZpStcGHlcyRfTc10tB6+QNos1LrNgb87Zef7BUNDY9miIhYJ
rbOTzKoKHss0cWLLuv0+JtpXRfFcXX+yDz3wysW3EJDuJHH9Jos8hjAjfAoACAy5
mNQK0umwxG8uV3H8V2ul1U/rmPR7/1SXZzIGmo8M7BbEfipUB6KN1UL0YZGhSVtd
WU9SIkoyLI4=
=RG76
-----END PGP SIGNATURE-----

--Sig_/0r7q_SKgPDLw1qzWlxW7qGa--
