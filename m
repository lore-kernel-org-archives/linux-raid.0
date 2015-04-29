From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 09/10] mdadm: change the num of cluster node
Date: Wed, 29 Apr 2015 11:51:51 +1000
Message-ID: <20150429115151.0763e980@notabene.brown>
References: <1429860641-5839-1-git-send-email-gqjiang@suse.com>
	<1429860641-5839-10-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/j6WYHR5g=J/lR=esjIoOwtC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1429860641-5839-10-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: gqjiang@suse.com
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

--Sig_/j6WYHR5g=J/lR=esjIoOwtC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 24 Apr 2015 15:30:40 +0800 gqjiang@suse.com wrote:

> From: Guoqing Jiang <gqjiang@suse.com>
>=20
> This extends nodes option for assemble mode, make the num of
> cluster node could be change by user.
>=20
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  Assemble.c | 4 ++++
>  ReadMe.c   | 2 +-
>  mdadm.c    | 3 +++
>  mdadm.h    | 1 +
>  super1.c   | 6 ++++++
>  5 files changed, 15 insertions(+), 1 deletion(-)
>=20
> diff --git a/Assemble.c b/Assemble.c
> index e1b846c..22042a9 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -649,6 +649,10 @@ static int load_devices(struct devs *devices, char *=
devmap,
>  							    devname, 0, 0, c->homecluster);
>  				tst->ss->write_bitmap(tst, dfd, NameUpdate);
>  			}
> +			if (strcmp(c->update, "nodes") =3D=3D 0) {
> +				tst->nodes =3D c->nodes;
> +				tst->ss->write_bitmap(tst, dfd, NodeNumUpdate);
> +			}

Doesn't there need to be some test that there is enough free space on all
devices to store the extra bitmaps (when nodes is increasing)??

NeilBrown





>  			if (strcmp(c->update, "uuid")=3D=3D0 &&
>  			    !ident->uuid_set) {
>  				ident->uuid_set =3D 1;
> diff --git a/ReadMe.c b/ReadMe.c
> index c854cd5..d1830e1 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -140,7 +140,7 @@ struct option long_options[] =3D {
>      {"homehost",  1, 0,  HomeHost},
>      {"symlinks",  1, 0,  Symlinks},
>      {"data-offset",1, 0, DataOffset},
> -    {"nodes",1, 0, Nodes},
> +    {"nodes",1, 0, Nodes}, /* also for --assemble */
>      {"home-cluster",1, 0, ClusterName},
> =20
>      /* For assemble */
> diff --git a/mdadm.c b/mdadm.c
> index 20f195d..344bde2 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -589,6 +589,7 @@ int main(int argc, char *argv[])
>  			}
>  			ident.raid_disks =3D s.raiddisks;
>  			continue;
> +		case O(ASSEMBLE, Nodes):
>  		case O(CREATE, Nodes):
>  			c.nodes =3D parse_num(optarg);
>  			if (c.nodes <=3D 0) {
> @@ -744,6 +745,8 @@ int main(int argc, char *argv[])
>  				continue;
>  			if (strcmp(c.update, "home-cluster")=3D=3D0)
>  				continue;
> +			if (strcmp(c.update, "nodes")=3D=3D0)
> +				continue;
>  			if (strcmp(c.update, "devicesize")=3D=3D0)
>  				continue;
>  			if (strcmp(c.update, "no-bitmap")=3D=3D0)
> diff --git a/mdadm.h b/mdadm.h
> index d8b0749..97892e6 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -357,6 +357,7 @@ enum prefix_standard {
>  enum bitmap_update {
>      NoUpdate,
>      NameUpdate,
> +    NodeNumUpdate,
>  };
> =20
>  /* structures read from config file */
> diff --git a/super1.c b/super1.c
> index e43bef1..047e799 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -1329,6 +1329,9 @@ static int update_super1(struct supertype *st, stru=
ct mdinfo *info,
>  		sb->devflags |=3D WriteMostly1;
>  	else if (strcmp(update, "readwrite")=3D=3D0)
>  		sb->devflags &=3D ~WriteMostly1;
> +	else if (strcmp(update, "nodes")=3D=3D0)
> +		/* Just a placeholder since no related member in mdp_superblock_1 */
> +		;
>  	else
>  		rv =3D -1;
> =20
> @@ -2222,6 +2225,9 @@ static int write_bitmap1(struct supertype *st, int =
fd, enum bitmap_update update
>  	    free(new_name);
>  	    break;
>  	}
> +	case NodeNumUpdate:
> +	    bms->nodes =3D __cpu_to_le32(st->nodes);
> +	    break;
>  	case NoUpdate:
>  	default:
>  	    break;


--Sig_/j6WYHR5g=J/lR=esjIoOwtC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVUA5Nznsnt1WYoG5AQKFUQ//RauHwDUv8k8zGdNdOVi+btUPrr7yhkcV
ywY+kJA+0uTigjKrhSQrtMi6dAMph4DOIp4R4eMaR1EmjSQ25aBt+DHhYO6wI6NB
g3vaDPESaGWpMKwuj7Upzy3TDXVw0bQpcvA8XcFNaFxgmm/pmZGf/iJciusCd+y3
D/Qi4zOvA1CXSMOHHj3USE+3dDVRz5Vxeha1YTkXM3lpLck/U7OjJd7OKjYcr9k4
Bzf3g2fwCvVFSMaitXci/jHuDdb77mxlbjXFcFWR+Av2HxChyf3ZfqC1tQeYrPFM
yI9fA5KAN4TZZSV6kL0PsnyWj/JVdfLj2GYRf0phfBwo8OPOW3si71psVZVFPi3O
eQfI4+u1sGQKBaj+OKjnISN8qUjz95CezfrxLjkQbWk5VHGewDrVfRb4arydhGhJ
KpZYaRTmy+Vnz4CSruKacXOdYBwf1gVOAA1QSnvF+yoBSw7uI6VN3rHdThVTGPNs
MPNa0S6xR9VIRnZnw0ubQAkw7Qbxa1aOJbuc7jfqZir9t3FzAsPf/0ShXRf//RVG
hACEzLSJFxey5w1Z1/UjORmEjfSifqZtY0aiZEXQCmkeIoWawcRSR2CpVgO+arNp
DuwWdwbDw4ZKsh3GjtTWepRJGMhH1yKkxAa3p3SFHghlIby8HtCBBtHOax/jn0jP
TtrLtRwxrXs=
=2VQ4
-----END PGP SIGNATURE-----

--Sig_/j6WYHR5g=J/lR=esjIoOwtC--
