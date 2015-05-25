From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH V3 02/11] Add nodes option while creating md
Date: Mon, 25 May 2015 14:13:58 +1000
Message-ID: <20150525141358.25dd3cbd@notabene.brown>
References: <1432092043-24220-1-git-send-email-gqjiang@suse.com>
	<1432092043-24220-3-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/OCorouxBjtIbgDQ1hnLfwAX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1432092043-24220-3-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.com
List-Id: linux-raid.ids

--Sig_/OCorouxBjtIbgDQ1hnLfwAX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 May 2015 11:20:34 +0800 Guoqing Jiang <gqjiang@suse.com> wrote:

> Specifies the maximum number of nodes in the cluster that may use
> this device simultaneously. This is equivalent to the number of
> bitmaps created in the internal superblock (patches to follow).
>=20
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  Create.c   |  1 +
>  ReadMe.c   |  1 +
>  mdadm.8.in |  6 ++++++
>  mdadm.c    | 34 +++++++++++++++++++++++++++++++++-
>  mdadm.h    |  3 +++
>  super1.c   |  1 +
>  6 files changed, 45 insertions(+), 1 deletion(-)
>=20
> diff --git a/Create.c b/Create.c
> index 69f5432..e4577af 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -531,6 +531,7 @@ int Create(struct supertype *st, char *mddev,
>  				st->ss->name);
>  		warn =3D 1;
>  	}
> +	st->nodes =3D c->nodes;
> =20
>  	if (warn) {
>  		if (c->runstop!=3D 1) {
> diff --git a/ReadMe.c b/ReadMe.c
> index 87a4916..30c569d 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -140,6 +140,7 @@ struct option long_options[] =3D {
>      {"homehost",  1, 0,  HomeHost},
>      {"symlinks",  1, 0,  Symlinks},
>      {"data-offset",1, 0, DataOffset},
> +    {"nodes",1, 0, Nodes},
> =20
>      /* For assemble */
>      {"uuid",      1, 0, 'u'},
> diff --git a/mdadm.8.in b/mdadm.8.in
> index 4aec0db..9c1497e 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -971,6 +971,12 @@ However for RAID0, it is not possible to add spares.=
  So to increase
>  the number of devices in a RAID0, it is necessary to set the new
>  number of devices, and to add the new devices, in the same command.
> =20
> +.TP
> +.BR \-\-nodes
> +Only works when the array is for clustered environment. It specify the
> +maximum number of nodes in the cluster that will use this device
> +simultaneously. If not specified, this defaults to 4.
> +

"It specifies the maximum"...

>  .SH For assemble:
> =20
>  .TP
> diff --git a/mdadm.c b/mdadm.c
> index 3e8c49b..15a43d2 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -588,7 +588,14 @@ int main(int argc, char *argv[])
>  			}
>  			ident.raid_disks =3D s.raiddisks;
>  			continue;
> -
> +		case O(CREATE, Nodes):
> +			c.nodes =3D parse_num(optarg);
> +			if (c.nodes <=3D 0) {
> +				pr_err("invalid number for the number of "
> +						"cluster nodes: %s\n", optarg);

Please don't break strings on to multiple lines.
    pr_err("invalid number for the number of cluster node: %s\n",
           optarg);

it doesn't matter if it exceeds 80 columns for this case.


> +				exit(2);
> +			}
> +			continue;
>  		case O(CREATE,'x'): /* number of spare (eXtra) disks */
>  			if (s.sparedisks) {
>  				pr_err("spare-devices set twice: %d and %s\n",
> @@ -1097,6 +1104,15 @@ int main(int argc, char *argv[])
>  				s.bitmap_file =3D optarg;
>  				continue;
>  			}
> +			if (strcmp(optarg, "clustered")=3D=3D 0) {
> +			    s.bitmap_file =3D optarg;
> +			    /* Set the default number of cluster nodes
> +			     * to 4 if not already set by user
> +			     */
> +			    if (c.nodes < 1)
> +				    c.nodes =3D 4;
> +			    continue;
> +			}
>  			/* probable typo */
>  			pr_err("bitmap file must contain a '/', or be 'internal', or 'none'\n"
>  				"       not '%s'\n", optarg);
> @@ -1377,6 +1393,22 @@ int main(int argc, char *argv[])
>  	case CREATE:
>  		if (c.delay =3D=3D 0)
>  			c.delay =3D DEFAULT_BITMAP_DELAY;
> +
> +		if (strcmp(s.bitmap_file, "clustered") =3D=3D 0) {
> +			if (s.level !=3D 1) {
> +			    pr_err("--bitmap=3Dclustered is currently supported with RAID mir=
ror only\n");
> +			    rv =3D 1;
> +			    break;
> +			}
> +		} else {
> +			if (c.nodes) {
> +				pr_err("--nodes argument is incompatible with --bitmap=3D%s.\n",
> +					s.bitmap_file);
> +				rv =3D 1;
> +				break;
> +			}

That's a bit careless....

 ./mdadm -C /dev/md0 -l1 -n2 --nodes=3D5 /dev/loop[01]
 Segmentation fault


NeilBrown



> +		}
> +
>  		if (s.write_behind && !s.bitmap_file) {
>  			pr_err("write-behind mode requires a bitmap.\n");
>  			rv =3D 1;
> diff --git a/mdadm.h b/mdadm.h
> index 141f963..9d55801 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -344,6 +344,7 @@ enum special_options {
>  	Dump,
>  	Restore,
>  	Action,
> +	Nodes,
>  };
> =20
>  enum prefix_standard {
> @@ -418,6 +419,7 @@ struct context {
>  	char	*backup_file;
>  	int	invalid_backup;
>  	char	*action;
> +	int	nodes;
>  };
> =20
>  struct shape {
> @@ -1029,6 +1031,7 @@ struct supertype {
>  			 */
>  	int devcnt;
>  	int retry_soon;
> +	int nodes;
> =20
>  	struct mdinfo *devs;
> =20
> diff --git a/super1.c b/super1.c
> index 7928a3d..78d98a7 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -2144,6 +2144,7 @@ add_internal_bitmap1(struct supertype *st,
>  	bms->daemon_sleep =3D __cpu_to_le32(delay);
>  	bms->sync_size =3D __cpu_to_le64(size);
>  	bms->write_behind =3D __cpu_to_le32(write_behind);
> +	bms->nodes =3D __cpu_to_le32(st->nodes);
> =20
>  	*chunkp =3D chunk;
>  	return 1;


--Sig_/OCorouxBjtIbgDQ1hnLfwAX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWKhhjnsnt1WYoG5AQJuEg//aVHDOTxDqI4XvcD3ccj9t0xUTKU5x6lI
n86F/dzJ1Rfq/tEAHCAMz/HSNuX1R4/CRu7eUxWESC8WYvlqJSgwxwBa+vsu3gRF
Cx1ss/1WbBAPIQoqJk1aQA4OthEoxsDJ/tZdX6EAd8ZBjNkPEqRb9A1XDhYrggsG
xzzK8F+QVOWqxeO68aV1ookc1P7A7uqSB6vHCtyKbcsLa+WUAWZBmoUOAadxMpkY
UGJV0e9PXb+tsrDJEgF00rhMGW3E46sCrUci03mi2mfIkWht6zgyrijkEwGama6U
GTEsEcvZUqlPLHvZKWr3om97LIKYZxc2Gmb5MzyGuEUHVG23Qf8fU915dp9zCc3v
zhc/z4qXZyvdoXROzQJG4+7WbjmvHtWdBIX10gax5sSMRGrVrHxnJJpOcKS8gGkR
12+vpnB/7v78I2UL+/rzT8sLmmv05fbMYjOCmps5Wglxi7VNRfAOXCUfwQYdPmt/
IX7cj6xDgS4AuaTk/6SudfKlnIei8EUASxDgNZIW4jGWp1+E/TQez+5E1S5h97lc
RXD32T9/EtaziFp4sAX5MAj7JSNpKzjSZZaqwCJSi3fPahBmCY18kz9tHidE6Qw4
S+/u5ZOqTh3tuhFFrt6pYa47GPQXWhKxvCyTYR6s9XZiRMJvaBFfyF7AH/utTbWd
+VJ2vyuCWUk=
=hzYx
-----END PGP SIGNATURE-----

--Sig_/OCorouxBjtIbgDQ1hnLfwAX--
