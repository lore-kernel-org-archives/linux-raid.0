From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] fix: imsm: mdmon should reread component_size on wakeup
Date: Thu, 20 Sep 2012 11:30:57 +1000
Message-ID: <20120920113057.70de3a65@notabene.brown>
References: <20120917083755.26592.53269.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/UDdylkYMSKdVWY+YIo.fg/G"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120917083755.26592.53269.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

--Sig_/UDdylkYMSKdVWY+YIo.fg/G
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 17 Sep 2012 10:37:55 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> Mdmon has not read component_size (in read_and_act()) on wakeup so far.
> In case of size's expansion component_size has been changed but
> mdmon has not updated it. As a result the metadata was incorrect
> during the size's expansion. It has contained no information
> that resync was in progress (there has been no checkpoint too).
> The metadata has been as if resync has already been finished
> but it has not.
>=20
> Updating of component_size has been added to read_and_act().
> Now mdmon uses the correct value of component_size and the correct
> metadata (containing information about resync and checkpoint) is written.

Thanks, but I don't think I like this approach.

In my mind, the 'monitor' thread should only be monitoring things that it h=
as
to respond to quickly - before another write can complete.
A size change does not need to be so immediate.
So I would rather that mdadm updates component_size but not array_size, and
then 'ping's the manager.   The manager thread then checks and notices that
the component size has changed, asks the monitor to update the metadata, th=
en
sets the array_size to match.

Possibly mdadm shouldn't just 'ping' the monitor, but should send the
metadata update ... not sure which is best.

Does that make sense to you?

Thanks,
NeilBrown


>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  managemon.c |    6 +++++-
>  mdmon.h     |    1 +
>  monitor.c   |   12 ++++++++++++
>  3 files changed, 18 insertions(+), 1 deletions(-)
>=20
> diff --git a/managemon.c b/managemon.c
> index ef351b3..fd41463 100644
> --- a/managemon.c
> +++ b/managemon.c
> @@ -123,6 +123,8 @@ static void close_aa(struct active_array *aa)
>  		close(aa->info.state_fd);
>  	if (aa->resync_start_fd >=3D 0)
>  		close(aa->resync_start_fd);
> +	if (aa->component_size_fd >=3D 0)
> +		close(aa->component_size_fd);
>  	if (aa->metadata_fd >=3D 0)
>  		close(aa->metadata_fd);
>  	if (aa->sync_completed_fd >=3D 0)
> @@ -598,7 +600,8 @@ static int aa_ready(struct active_array *aa)
>  	if (aa->info.state_fd < 0)
>  		return 0;
> =20
> -	if (level > 0 && (aa->action_fd < 0 || aa->resync_start_fd < 0))
> +	if (level > 0 && (aa->action_fd < 0 || aa->resync_start_fd < 0 \
> +					    || aa->component_size_fd < 0))
>  		return 0;
> =20
>  	if (!aa->container)
> @@ -676,6 +679,7 @@ static void manage_new(struct mdstat_ent *mdstat,
>  	new->action_fd =3D sysfs_open(new->devnum, NULL, "sync_action");
>  	new->info.state_fd =3D sysfs_open(new->devnum, NULL, "array_state");
>  	new->resync_start_fd =3D sysfs_open(new->devnum, NULL, "resync_start");
> +	new->component_size_fd =3D sysfs_open(new->devnum, NULL, "component_siz=
e");
>  	new->metadata_fd =3D sysfs_open(new->devnum, NULL, "metadata_version");
>  	new->sync_completed_fd =3D sysfs_open(new->devnum, NULL, "sync_complete=
d");
>  	dprintf("%s: inst: %d action: %d state: %d\n", __func__, atoi(inst),
> diff --git a/mdmon.h b/mdmon.h
> index 59e1b53..0b82598 100644
> --- a/mdmon.h
> +++ b/mdmon.h
> @@ -32,6 +32,7 @@ struct active_array {
> =20
>  	int action_fd;
>  	int resync_start_fd;
> +	int component_size_fd; /* in case of change of array's size */
>  	int metadata_fd; /* for monitoring rw/ro status */
>  	int sync_completed_fd; /* for checkpoint notification events */
>  	unsigned long long last_checkpoint; /* sync_completed fires for many
> diff --git a/monitor.c b/monitor.c
> index c987d10..aa58384 100644
> --- a/monitor.c
> +++ b/monitor.c
> @@ -80,6 +80,17 @@ static unsigned long long read_resync_start(int fd)
>  		return strtoull(buf, NULL, 10);
>  }
> =20
> +static unsigned long long read_component_size(int fd)
> +{
> +	char buf[30];
> +	int n;
> +
> +	n =3D read_attr(buf, 30, fd);
> +	if (n <=3D 0)
> +		return 0;
> +	return strtoull(buf, NULL, 10);
> +}
> +
>  static unsigned long long read_sync_completed(int fd)
>  {
>  	unsigned long long val;
> @@ -229,6 +240,7 @@ static int read_and_act(struct active_array *a)
>  	a->curr_state =3D read_state(a->info.state_fd);
>  	a->curr_action =3D read_action(a->action_fd);
>  	a->info.resync_start =3D read_resync_start(a->resync_start_fd);
> +	a->info.component_size =3D read_component_size(a->component_size_fd) <<=
 1;
>  	sync_completed =3D read_sync_completed(a->sync_completed_fd);
>  	for (mdi =3D a->info.devs; mdi ; mdi =3D mdi->next) {
>  		mdi->next_state =3D 0;
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/UDdylkYMSKdVWY+YIo.fg/G
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFpx0jnsnt1WYoG5AQKuvQ/+JXZ0yjQIiC2z9UZtXXDrdN91IrKTN9bK
0cF3KCKIxGft5Yie9MqCYCJG2dir8Ts8oRNzcqluKK5zyBjT/dLzPM89+ZCnnCxb
8SVyDdjj9QB9zckYscuqet4fC4+d1aADeNEAGV96dasSHbNKoT7hrHkCAPun6Qz0
0T1MAzDI6/y8Tu0gqtJl8N2YJhZuxjiNoNVxr73SZ60KcaX0tgglW3AcUyxdRF8E
gZ9GxX3EMfw7YJVbdo59yJO8PQwhe+0SfVu7FP9HBTlhO6RDyAER2ZC+DoaamRag
xX2akMY/FuLoAVpsWq4GfthlLqFpaJaY4GkoBjr0Q8rZEzn5t5c3zJ37M+ZphO/u
HEPP10mxDouCPhq3KqTyRd3QYabgpvTP492MuCGikAgkkpzxTptPNtj1eYPH4//0
bInMBd9Cx6FnFDwnAw4lkjqkR98+M4HQ9zMkPr0QrQ94aL6YMI1wyr2JM/aX42dF
wc6kRIr3fIe9nvGDbpRnYET2U42lkzSxwumz0P3dKWIs7fxI/cpY7eUT2yh7/Sb+
iU7iSDdAbzMM05NdceqGd+/3Hkcv4X+TqlqT+MjSwTWcsQ996yM2pBPpskAqWkQe
AGlPcbm/mT+73cbX6/X3k6uqCia+7Zc7om4lNZ3CAw+vXQ1E73cLocYJScQasfxC
46bHXzCNElg=
=YkI3
-----END PGP SIGNATURE-----

--Sig_/UDdylkYMSKdVWY+YIo.fg/G--
