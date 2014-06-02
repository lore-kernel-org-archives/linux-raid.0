From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: retry load_and_parse_mpb if we suspect mdmon has
 made modifications
Date: Mon, 2 Jun 2014 12:36:56 +1000
Message-ID: <20140602123656.2e52d529@notabene.brown>
References: <1401455913-28657-1-git-send-email-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Vkq=nECyli+5fn/cnLqpX.z"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1401455913-28657-1-git-send-email-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

--Sig_/Vkq=nECyli+5fn/cnLqpX.z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 30 May 2014 15:18:33 +0200 Artur Paszkiewicz
<artur.paszkiewicz@intel.com> wrote:

> If the checksum verification fails in mdadm and mdmon is running, retry
> the load to get a consistent snapshot of the mpb.
>=20
> Based on db575f3b
>=20
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> Reviewed-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  super-intel.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index f0a7ab5..037c018 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -4422,6 +4422,7 @@ static int load_super_imsm(struct supertype *st, in=
t fd, char *devname)
>  {
>  	struct intel_super *super;
>  	int rv;
> +	int retry;
> =20
>  	if (test_partition(fd))
>  		/* IMSM not allowed on partitions */
> @@ -4444,6 +4445,22 @@ static int load_super_imsm(struct supertype *st, i=
nt fd, char *devname)
>  	}
>  	rv =3D load_and_parse_mpb(fd, super, devname, 0);
> =20
> +	/* retry the load if we might have raced against mdmon */
> +	if (rv =3D=3D 3) {
> +		struct mdstat_ent *mdstat =3D mdstat_by_component(fd2devnm(fd));
> +
> +		if (mdmon_running(mdstat->devnm) && getpid() !=3D mdmon_pid(mdstat->de=
vnm)) {
> +			for (retry =3D 0; retry < 3; retry++) {
> +				usleep(3000);
> +				rv =3D load_and_parse_mpb(fd, super, devname, 0);
> +				if (rv !=3D 3)
> +					break;
> +			}
> +		}

The only thing you use from mdstat is devnm, and that is the thing you pass=
ed
to mdstat_by_component to get mdstat....

Can you just do
   char *devnm =3D fd2devnm(fd);
   if (mdmon_running(devnm) && ......)

??

NeilBrown


> +
> +		free_mdstat(mdstat);
> +	}
> +
>  	if (rv) {
>  		if (devname)
>  			pr_err("Failed to load all information "


--Sig_/Vkq=nECyli+5fn/cnLqpX.z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU4vjSDnsnt1WYoG5AQL+bQ/7Bf0rHvzzH4y8uWgi7Rb+CKmN+KMA/Vl4
PrqyUOrpRIj+b4sqKj4H4V24YiC98MJ0/SqKIQOprBl3rNrZu2MQ+hknY7J+knGO
DCo1x3hpow413PakUlsvmL0eWqwApydHJ/4DX/eZkJFOyJ3ih4S7u/ugyJRU6D4E
S15/v5BnM/Gkz/qEaoujSEV78DPhS8Tn9y4RQkhufEhZz/pV2QzC0/fwRGs/UBJY
H4sQxdUx1YJLPDm0pZMPNY7YMEe7ssMylSKZvKH8N01Tpn6rQVSB5pQG4oQLYJEe
iWlFbNp+pq6ZDffO2ghEOJUxPrFH82PVVn03MmswPMWQMp0xeuPfEfGetjAedv4u
Y65euoXmlM5Zj56Graq7lkDUVHJHTAWr2/7W8QPP6iiIH39THzmUEeqTsJSr/kqf
KVo1IvJydEhHwSSQPtO6gRsBzDc0GNpkYQpAcrveoD+i0QP95mJB3QL/U6+6RD5h
C0zO1wMPPQX4Qs+wEA5p8s3Oor3eYbzLwAYFxOEP03N6v5+vEyaQAzEWboOJeSuW
p40DR55vIvm+ODygpKgZciqOogksrFH1Z3IzuON/olgMsePtMLAS3Y+uSQYOVOdM
yGi7LaXWAk6hjiJH8/QG0x4G3LPMDMacFwlZuGXJReM2Qn2QQfqSiQkT+3YKdXpr
rHuoQWe9OJI=
=bmW7
-----END PGP SIGNATURE-----

--Sig_/Vkq=nECyli+5fn/cnLqpX.z--
