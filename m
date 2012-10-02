From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md: register new md sysfs file 'uuid' read-only
Date: Wed, 3 Oct 2012 08:30:31 +1000
Message-ID: <20121003083031.51093f0c@notabene.brown>
References: <1349185330-9024-1-git-send-email-sebastian.riemer@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/oGJ/PEIO3vV3egRuPEarDdA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1349185330-9024-1-git-send-email-sebastian.riemer@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: sebastian.riemer@profitbricks.com
List-Id: linux-raid.ids

--Sig_/oGJ/PEIO3vV3egRuPEarDdA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue,  2 Oct 2012 15:42:10 +0200 Sebastian Riemer
<sebastian.riemer@profitbricks.com> wrote:

> Report the UUID of the MD array in the following format:
> xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
>=20
> This is useful if you don't want to wait for udev to
> identify your MD array.

If you don't want to wait for udev, run "mdadm -D --export /dev/mdwhatever"
and extract the uuid from that.

And the UUID format you mention is different from the format used by mdadm,
which makes me like the patch even less.


What problem are you trying to solve here?

NeilBrown

>=20
> Signed-off-by: Sebastian Riemer <sebastian.riemer@profitbricks.com>
> ---
>  drivers/md/md.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 308e87b..4e654d1 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3730,6 +3730,14 @@ static struct md_sysfs_entry md_raid_disks =3D
>  __ATTR(raid_disks, S_IRUGO|S_IWUSR, raid_disks_show, raid_disks_store);
> =20
>  static ssize_t
> +uuid_show(struct mddev *mddev, char *page)
> +{
> +	return sprintf(page, "%pU\n", mddev->uuid);
> +}
> +static struct md_sysfs_entry md_uuid =3D
> +__ATTR(uuid, S_IRUGO, uuid_show, NULL);
> +
> +static ssize_t
>  chunk_size_show(struct mddev *mddev, char *page)
>  {
>  	if (mddev->reshape_position !=3D MaxSector &&
> @@ -4667,6 +4675,7 @@ static struct attribute *md_default_attrs[] =3D {
>  	&md_level.attr,
>  	&md_layout.attr,
>  	&md_raid_disks.attr,
> +	&md_uuid.attr,
>  	&md_chunk_size.attr,
>  	&md_size.attr,
>  	&md_resync_start.attr,


--Sig_/oGJ/PEIO3vV3egRuPEarDdA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGtrBznsnt1WYoG5AQJmHg/9EP0r5ySrXb0dBmkBDK2h03j+1+2BsLfp
jPFFf0aNbrSy6LpVx0gM/xUFD7r51BvbmJZROKW5Z5ITS9fGOATd/7PqF/Pzsy8L
tO+++OJpTVDm9B1JX35vmh3WKfg9y6sOJKdHM3etmo3Fe1uasCEbuU7sBkCRjGIM
RPPPVlE2OzFE7lOBkXWBqlpkRDKXd/+kMaU7tBeCOMAsw5NFbeIgSnq45yxu/QKz
SmZEO2d3uiuP6LesFaNTRhfprdFJixxpfyks8PJGPq8KI8hOfBoV3yJtv80PygOO
eEbVmA49U8IR//2t/fZcG4s+LFwrICNWMw/LEr1BDWVChzwwAxKHEowKcjyavcP7
RbjPDbK665/406KLaQRDp09ApyN5KsWs9WQSdTiM4ijvgT4aXhd9FnlmqoeD4ba6
jO9+T+OMfbdGgJbTDbxWEwXD02/itasE7Kbh+ovc/k+MwjOBqDNLdg85yi8aK1ux
KQUDwOOHDLPM4DQsAx/6QcyehOothlK3e1grwLuEPAU3vvmxQSO0lfxA6qf7t9Lt
oHJPasjKmJqjxAylLmuDDOfQBYb1WHuAxjKjd47q7/ISJJr+H/jsFhmc11Q+xmVx
SMsicxlCv+O0SejoZ+Cfv+px50tR5LkHD6fq5ZGYVo6Uy9/ZWdKNMqJa/DAH5cCU
22i+C4PyRtc=
=SYKQ
-----END PGP SIGNATURE-----

--Sig_/oGJ/PEIO3vV3egRuPEarDdA--
