From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 01/10] Add nodes option while creating md
Date: Wed, 29 Apr 2015 11:30:08 +1000
Message-ID: <20150429113008.253c02f7@notabene.brown>
References: <1429860641-5839-1-git-send-email-gqjiang@suse.com>
	<1429860641-5839-2-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/z4E=2HcJBAKqvxbT68R3s.6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1429860641-5839-2-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: gqjiang@suse.com
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

--Sig_/z4E=2HcJBAKqvxbT68R3s.6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 24 Apr 2015 15:30:32 +0800 gqjiang@suse.com wrote:

> From: Guoqing Jiang <gqjiang@suse.com>
>=20
> Specifies the maximum number of nodes in the cluster that may use
> this device simultaneously. This is equivalent to the number of
> bitmaps created in the internal superblock (patches to follow).
>=20
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>

This doesn't really make much sense coming first in the series.  It sets up=
 a
value that is never used.

I would much rather 03/10 came first - which would just create 4 bitmaps.
Then have this patch to allow that '4' to be changed.


> ---
>  Create.c   |  1 +
>  ReadMe.c   |  1 +
>  mdadm.8.in |  5 +++++
>  mdadm.c    | 20 +++++++++++++++++++-
>  mdadm.h    |  3 +++
>  5 files changed, 29 insertions(+), 1 deletion(-)
>=20
> diff --git a/Create.c b/Create.c
> index ef28da0..b73f6cb 100644
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
> index a630310..bd8d59e 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -966,6 +966,11 @@ However for RAID0, it is not possible to add spares.=
  So to increase
>  the number of devices in a RAID0, it is necessary to set the new
>  number of devices, and to add the new devices, in the same command.
> =20
> +.TP
> +.BR \-\-nodes
> +Specify the maximum number of nodes in the cluster that will use this
> +device simultaneously. If not specified, this defaults to 4.
> +

I think this should mention that it only makes sense with --bitmap=3Dcluster
(which of course isn't available at this point....)


>  .SH For assemble:
> =20
>  .TP
> diff --git a/mdadm.c b/mdadm.c
> index 3e8c49b..bce6a76 100644
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
> +				exit(2);
> +			}
> +			continue;
>  		case O(CREATE,'x'): /* number of spare (eXtra) disks */
>  			if (s.sparedisks) {
>  				pr_err("spare-devices set twice: %d and %s\n",
> @@ -1377,6 +1384,17 @@ int main(int argc, char *argv[])
>  	case CREATE:
>  		if (c.delay =3D=3D 0)
>  			c.delay =3D DEFAULT_BITMAP_DELAY;
> +
> +		if (!strncmp(s.bitmap_file, "internal", 9) ||
> +			!strncmp(s.bitmap_file,"none", 4)) {

I'm sorry but I absolutely *hate* this construct.
The '!' at the front makes it seem like you are testing that the string does
*not* have that value, but it is exactly the reverse.
And why "strncmp" rather than "strcmp" ??

Please use

    if (strcmp(s.bitmap_file, "internal") =3D=3D 0 ||
        strcmp(s.bitmap_file, "none) =3D=3D 0) {

except.... what about if bitmap_file in /path/to/somewhere.  Presumably you
want to exclude that case too.
May be
   if (strcmp(s.bitmap_file, "cluster") !=3D 0) {
??

Thanks,
NeilBrown


> +			if (c.nodes) {
> +				pr_err("--nodes argument is incompatible with --bitmap=3D%s.\n",
> +					s.bitmap_file);
> +				rv =3D 1;
> +				break;
> +			}
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


--Sig_/z4E=2HcJBAKqvxbT68R3s.6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVUA0IDnsnt1WYoG5AQJZAQ/+Kku/0+2lBwDyOX9nMCw4BkX3Jg6yMeX9
OhfoeEMRRGzkQphW8HijK0ewCkqOPa2/kIiJiLfQfTukaWhCqFGyiMxCy7tikMZ7
58OvAb7qgE90J90OxkG2ig6wITYkENCzI1KL+yECdGiu9s7FPWpVCzJ6xR5n3lIs
ITAxph/7CQ0RhJau+wW7PymEtCUFPkOBhqVm0rCvCndRHEzE/oZxd5GseufQ7jBA
yt0ralJzZDdbF5baGcRB5YYQ4hcg7w/u+mgInduiSCOVqVrT/4QlRDcgm5DaR5e8
U3+HQA6FFquSTzyYhMqWN0cDT5tyX3Nw3tLPttUG8qRN7zpihyCGwn4sUze3OFll
pzktqeTlXE4BU4S5/ryaaawg3o7cSS5wV6+G7eRtSnMcobIXZzu13JLeMLfpTEio
3//XBHYAN4Cqpflv0/f0pRXfuffCMjGf17aJT0ExETa4yZRMXsNNNyQYORLbJA3s
NjWm6yOjw0fXYD8YJkzRtPbBCL/6/8+vyknB4muu8oAFS5M8+GTedPsKz5QLs5PF
iKJ8/euLY1hgKyyxVEIB45S/tncszY0buXlseWOhDswxFhpGM+hITiZSVE5+KwMW
eHDAcKwHmzmHvOkQFfnEfl3A78b/ORyR4l53JtueDtiRAbKCW4+eHz7BIlZtWlRP
bxGhp512gK0=
=rwme
-----END PGP SIGNATURE-----

--Sig_/z4E=2HcJBAKqvxbT68R3s.6--
