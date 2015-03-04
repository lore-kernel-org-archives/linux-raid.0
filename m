From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] IMSM-orom: make sure, that device list is supported
Date: Wed, 4 Mar 2015 16:00:52 +1100
Message-ID: <20150304160052.4a64461f@notabene.brown>
References: <20150227144550.9215.35006.stgit@gklab-154-222.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/layWLSnV2M5A4FNQNGAHMUC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150227144550.9215.35006.stgit@gklab-154-222.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

--Sig_/layWLSnV2M5A4FNQNGAHMUC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Feb 2015 15:45:50 +0100 Pawel Baldysiak
<pawel.baldysiak@intel.com> wrote:

> Devices list in PCI Data Structure is supported only in
> 3 and above revision. Make sure that this is checked.
>=20
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  platform-intel.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/platform-intel.c b/platform-intel.c
> index 37274da..c6a28e8 100644
> --- a/platform-intel.c
> +++ b/platform-intel.c
> @@ -227,6 +227,8 @@ struct pciExpDataStructFormat {
>  	__u16 vendorID;
>  	__u16 deviceID;
>  	__u16 devListOffset;
> +	__u16 pciDataStructLen;
> +	__u8 pciDataStructRev;
>  } __attribute__ ((packed));
> =20
>  static struct orom_entry oroms[SYS_DEV_MAX];
> @@ -323,7 +325,8 @@ static int scan(const void *start, const void *end, c=
onst void *data)
> =20
>  	const struct imsm_orom *orom =3D add_orom(imsm_mem);
> =20
> -	if (ptr->devListOffset) {
> +	/* only PciDataStructure with revision 3 and above supports devices lis=
t. */
> +	if (ptr->pciDataStructRev >=3D 3 && ptr->devListOffset) {
>  		const __u16 *dev_list =3D (void *)ptr + ptr->devListOffset;
>  		int i;
> =20

Applied, thanks.

NeilBrown

--Sig_/layWLSnV2M5A4FNQNGAHMUC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVPaRhDnsnt1WYoG5AQJNBw/+M/Yq8n4W0HAD2XgTkI6827YwFh8uzDcP
ckahvicpynjQ1tr6GQ03S8CYnoTRlDW/g1XFvkwQzHysoRHv4nrjGXNDa3YYYEwB
OooFUicciWnQxng5UrNQzfmuHWTGUHb0SmFdDS9143p6D26gJAW+Qqdy78510e5x
uFnbzCaAiR/nRPAr27GCcQEltO7BrtSlc9JMrOQQ2ccX4uyMzdNxRh6NSfaHUWVY
Wc4oSfiozBt41ZFW96dCmU2Sbfz2e705w+UjBm1YOw/QTY6iAtROQxAIYn4digHZ
pZMMkdeN+QpPDMpC0lbrIehRVafEZLEdbFFMIrT0AqcKOTSx9FRQyd++szfSmZhm
ZlnEy8M8HmPQQ7SZPQhGSg3K4rZbvIZJoLBRjnhLTKI+3TbFyTaLx7TtkdQP7WDh
FsK/txj033wnvNeXPF5Aw1UJQA7DJdQPkLzd2VOOjH5o6JKrtfmPjA8KwOGA07f0
mJ70xOa9StOhSZ2/OPlV2LsZRnpkVPvPEXbFt8bcLgdz+8YbFku8uGsdX8pfms9P
Tm9AIkZT2yy7dhNVi0EZiEPyXGf1osbaSet/i8LsCvJaUAD6ffdqZe9tkB/J1RD8
/QC4ptnA7SNQblR4IBi7xVxHV1EPP3UQu84q9xYNkWoccPKWG0uYuCJY6bELeazE
rsaHTVHEvkU=
=A4EJ
-----END PGP SIGNATURE-----

--Sig_/layWLSnV2M5A4FNQNGAHMUC--
