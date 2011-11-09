From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: control number of active imsm volumes in the
 system
Date: Thu, 10 Nov 2011 10:04:31 +1100
Message-ID: <20111110100431.430e124d@notabene.brown>
References: <F9123E44003394499FDD2B17C60621D404EB0C@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1CoEzuYZoyObb_t1ZoOuPvP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F9123E44003394499FDD2B17C60621D404EB0C@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/1CoEzuYZoyObb_t1ZoOuPvP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 9 Nov 2011 11:11:37 +0000 "Labun, Marcin" <Marcin.Labun@intel.com>
wrote:

> From: Marcin Labun <Marcin.Labun@intel.com>
> Subject: [PATCH] imsm: control number of active imsm volumes in the system
>=20
> IMSM supports maximum supported volumes in the system according to OROM d=
efined value.
> Block creation and activation of volume if number of active volumes is gr=
eater then OROM defined maximum.
>=20
> Signed-off-by: Marcin Labun <marcin.labun@intel.com>


Hi Marcin,
 I don't think it is sensible to count assembled arrays in mdstat, because
 that is not what you really want to know.
 You really want to know how many array are described in the metadata to
 ensure you don't add too many.
 In validate_geometry_imsm_orom you have the 'struct intel_super' so it is
 just super->anchor->num_raid_devs isn't it?

NeilBrown


> ---
>  super-intel.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++++++=
+++--
>  1 files changed, 64 insertions(+), 3 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index e4d71e7..eb76e95 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -531,6 +531,7 @@ static int attach_hba_to_super(struct intel_super *su=
per, struct sys_dev *device
>  	return 1;
>  }
> =20
> +
>  static struct sys_dev* find_disk_attached_hba(int fd, const char *devnam=
e)
>  {
>  	struct sys_dev *list, *elem, *prev;
> @@ -1665,8 +1666,9 @@ static void print_imsm_capability(const struct imsm=
_orom *orom)
>  	       imsm_orom_has_chunk(orom, 1024*16) ? " 16M" : "",
>  	       imsm_orom_has_chunk(orom, 1024*32) ? " 32M" : "",
>  	       imsm_orom_has_chunk(orom, 1024*64) ? " 64M" : "");
> -	printf("      Max Disks : %d\n", orom->tds);
> -	printf("    Max Volumes : %d\n", orom->vpa);
> +	printf("    Max Disks                 : %d\n", orom->tds);
> +	printf("    Max Volumes per array     : %d\n", orom->vpa);
> +	printf("    Max Volumes per controller: %d\n", orom->vphba);
>  	return;
>  }
> =20
> @@ -5089,11 +5091,61 @@ static int imsm_default_chunk(const struct imsm_o=
rom *orom)
>  	return min(512, (1 << fs));
>  }
> =20
> +static int count_external_arrays_by_format(char *name, char* hba, int ve=
rbose)
> +{
> +	struct mdstat_ent *mdstat =3D mdstat_read(0, 0);
> +	struct mdstat_ent *memb =3D NULL;
> +	struct mdstat_ent *vol =3D NULL;
> +	int fd =3D -1;
> +	int count =3D 0;
> +	struct dev_member *dev =3D NULL;
> +	char *path =3D NULL;
> +	int num =3D 0;
> +
> +	for (memb =3D mdstat ; memb ; memb =3D memb->next) {
> +		if (memb->metadata_version &&
> +		    strncmp(memb->metadata_version, "external:", 9) =3D=3D 0  &&
> +		    (strcmp(&mdstat->metadata_version[9], name) =3D=3D 0) &&
> +		    !is_subarray(memb->metadata_version+9) &&
> +		    memb->members) {
> +			dev =3D memb->members;
> +			fd =3D -1;
> +			while(dev && (fd < 0)) {
> +				path =3D malloc(strlen(dev->name) + strlen("/dev/") + 1);
> +				if (path) {
> +					num =3D sprintf(path, "%s%s", "/dev/", dev->name);
> +					if (num > 0)
> +						fd =3D open(path, O_RDONLY, 0);
> +					if ((num <=3D 0) || (fd < 0)) {
> +						if (verbose)
> +							fprintf(stderr, Name ": Cannot open %s: %s\n",
> +								dev->name, strerror(errno));
> +					}
> +					free(path);
> +				}
> +				dev =3D dev->next;
> +			}
> +			if ((fd >=3D 0) && disk_attached_to_hba(fd, hba)) {
> +				for (vol =3D mdstat ; vol ; vol =3D vol->next) {
> +					if (vol->metadata_version &&
> +					    is_container_member(vol, memb->dev))
> +						count++;
> +				}
> +			}
> +			if (fd >=3D 0)
> +				close(fd);
> +		}
> +	}
> +	free_mdstat(mdstat);
> +	return count;
> +}
> +
>  #define pr_vrb(fmt, arg...) (void) (verbose && fprintf(stderr, Name fmt,=
 ##arg))
>  static int
>  validate_geometry_imsm_orom(struct intel_super *super, int level, int la=
yout,
>  			    int raiddisks, int *chunk, int verbose)
>  {
> +	int count =3D 0;
>  	/* check/set platform and metadata limits/defaults */
>  	if (super->orom && raiddisks > super->orom->dpa) {
>  		pr_vrb(": platform supports a maximum of %d disks per array\n",
> @@ -5101,7 +5153,16 @@ validate_geometry_imsm_orom(struct intel_super *su=
per, int level, int layout,
>  		return 0;
>  	}
> =20
> -        /* capabilities of OROM tested - copied from validate_geometry_i=
msm_volume */
> +	if (super->orom) {
> +		count =3D count_external_arrays_by_format("imsm", super->hba->path, ve=
rbose);
> +		if (super->orom->vphba <=3D count) {
> +			pr_vrb(":  platform does not support more then %d raid volumes.\n",
> +			       super->orom->vphba);
> +			return 0;
> +		}
> +	}
> +
> +	/* capabilities of OROM tested - copied from validate_geometry_imsm_vol=
ume */
>  	if (!is_raid_level_supported(super->orom, level, raiddisks)) {
>  		pr_vrb(": platform does not support raid%d with %d disk%s\n",
>  			level, raiddisks, raiddisks > 1 ? "s" : "");


--Sig_/1CoEzuYZoyObb_t1ZoOuPvP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrsG/znsnt1WYoG5AQLI6hAAuuNx6aSekHH3FQ9cxfAkPa6HyVGo2ndL
+9abhFgyxBeV3drgDIad30p+3VNp/Phgngcds1i6K5Nwv2TajRHYwT+sdGpKWgb8
zXvSMJQmCRHCghDT9wRvcAQn0wRBXBj1BWpXXU9Iz42tWo08lBh/5tGDmZcGoHPJ
tWceHayM85tOchjbKiGQ4C8ZH5SJDnoUhHzBax1SLOVtevoOFnCLNJhWDrtKv0f0
cboaYixnbQEkbgGphMMabFElaU6eKQocbiCIB6zG3E5SiAtK9wAcp37ZN3zP63DM
0j5yYio3dTkSPKQ3mH1UAY/zKSN1M7LpKSSEUYnxmpH2Y5CYkGJhTzCKySsoiVm3
ah8EkTTWV1GjgaAQ0Sgi7K984bqvcCLDEWk/wPna3QGChWGAlQUEzKtLG/9Tde0i
DpJ+Pu4jl6ksu31NUxFYdeX1a4+8rZdhk+Shftp+2gtMk65+gcTzcqhFI5t+9Ih+
NNHmEvvUBK2VenbDNtZefhKB8ctsao/Xj3ZEwZfzwA/tqt0oQQvFVdHNw4KN2MR0
XUpa1T1c1Q465QhoB68dKwcwsnq5NyDVr+3GGfCVdeZWyqJER6/WPumf5nEwJSin
y3SBPtyBolYLNVMd1YfkH6zk6qbxH6IiStG5je5vVI4eTD6pwhKBo8be6IZHZMvS
JcYkuWgl9f4=
=9zR2
-----END PGP SIGNATURE-----

--Sig_/1CoEzuYZoyObb_t1ZoOuPvP--
