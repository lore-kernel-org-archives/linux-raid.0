From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 3/3] Add new journal to array that does not have journal
Date: Tue, 22 Dec 2015 07:56:46 +1100
Message-ID: <878u4n4j1t.fsf@notabene.neil.brown.name>
References: <1450725823-1832511-1-git-send-email-songliubraving@fb.com> <1450725823-1832511-4-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1450725823-1832511-4-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: dan.j.williams@intel.com, shli@fb.com, hch@infradead.org, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 22 2015, Song Liu wrote:

I've applied the first two patches - thanks.

This one bothers me.

> This patch enables adding journal to an array that does not have journal =
before.
>
> To add the journal, the array should finish resync. Otherwise, mdadm comp=
lains:
>
> [root] mdadm --add-journal /dev/md0 /dev/sdb8 -vvv
> mdadm: /dev/md0 has active resync, please retry after resync is done.

I'm reasonably happy with not adding a journal while a resync is
happening (be nice if you could though).

However this should be an option in the --grow subcommand, for consistency.

>
> The array need to be restarted for the journal to work:
>
> [root] mdadm --add-journal /dev/md0 /dev/sdb8
> mdadm: Making /dev/md0 readonly before adding journal...
> mdadm: Added new journal to /dev/md0.
> mdadm: Please restart the array to make it live.

I'm not at all happy with adding a journal and it not really being
added.

The best case is to add the journal and have it be live straight away.
Why can't we do that.

The second best option is to add the journal as part of --assemble,
e.g. with --update=3Djournal

>
> [root] mdadm --stop /dev/md*
> mdadm: stopped /dev/md0
>
> [root] mdadm -A /dev/md0 /dev/sdb[12358]
> mdadm: device 8 in /dev/md0 has wrong state in superblock, but /dev/sdb8 =
seems ok
> mdadm: /dev/md0 has been started with 4 drives and 1 journal.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  Assemble.c |  5 +----
>  Manage.c   | 32 ++++++++++++++++++++++++++------
>  2 files changed, 27 insertions(+), 10 deletions(-)
>
> diff --git a/Assemble.c b/Assemble.c
> index a7cd163..4ddd650 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1556,10 +1556,7 @@ try_again:
>  		 */
>  		if (content->array.level !=3D LEVEL_MULTIPATH) {
>  			if (devices[j].i.disk.state & (1<<MD_DISK_JOURNAL)) {
> -				if (content->journal_device_required)
> -					journalcnt++;
> -				else	/* unexpected journal, mark as faulty */
> -					devices[j].i.disk.state |=3D (1<<MD_DISK_FAULTY);
> +				journalcnt++;
>  			} else if (!(devices[j].i.disk.state & (1<<MD_DISK_ACTIVE))) {
>  				if (!(devices[j].i.disk.state
>  				      & (1<<MD_DISK_FAULTY))) {
> diff --git a/Manage.c b/Manage.c
> index 7e1b94b..da14b99 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -740,6 +740,7 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  	struct supertype *dev_st =3D NULL;
>  	int j;
>  	mdu_disk_info_t disc;
> +	int new_journal =3D 0;
>=20=20
>  	if (!get_dev_size(tfd, dv->devname, &ldsize)) {
>  		if (dv->disposition =3D=3D 'M')
> @@ -935,19 +936,33 @@ int Manage_add(int fd, int tfd, struct mddev_dev *d=
v,
>  	if (dv->disposition =3D=3D 'j') {
>  		struct mdinfo mdi;
>  		struct mdinfo *mdp;
> +		struct mdstat_ent *mds, *m;
> +		int percent =3D -1;
> +
> +		mds =3D mdstat_read(0, 0);
> +		for (m =3D mds; m; m =3D m->next)
> +			if (strcmp(m->devnm, fd2devnm(fd)) =3D=3D 0)
> +				percent =3D m->percent;
> +		free_mdstat(mds);
> +
> +		if (percent > 0) {
> +			pr_err("%s has active resync, please retry after resync is done.\n", =
devname);
> +			return -1;
> +		}

This is a rather clumsy way to test if a resync is happening.  It is all
we could manage years ago, but today we can just read the sync_action
file from sysfs.  If that isn't "idle", then assume some
resync/recovery/reshape is happening.

>=20=20
>  		mdp =3D sysfs_read(fd, NULL, GET_ARRAY_STATE);
>=20=20
>  		if (strncmp(mdp->sysfs_array_state, "readonly", 8) !=3D 0) {
> -			pr_err("%s is not readonly, cannot add journal.\n", devname);
> -			return -1;
> +			pr_err("Making %s readonly before adding journal...\n", devname);
> +			if (Manage_ro(devname, fd, 1)) {
> +				pr_err("Please retry.\n");
> +				return -1;
> +			}

??  Why does the array have to be read-only to add a journal?
That would prevent you adding a journal to an array with a mounted
filesystem.


Thanks,
NeilBrown

>  		}
>=20=20
>  		tst->ss->getinfo_super(tst, &mdi, NULL);
> -		if (mdi.journal_device_required =3D=3D 0) {
> -			pr_err("%s does not support journal device.\n", devname);
> -			return -1;
> -		}
> +		if (mdi.journal_device_required =3D=3D 0)
> +			new_journal =3D 1;
>  		disc.raid_disk =3D 0;
>  	}
>=20=20
> @@ -1064,6 +1079,11 @@ int Manage_add(int fd, int tfd, struct mddev_dev *=
dv,
>  		close(container_fd);
>  	} else {
>  		tst->ss->free_super(tst);
> +		if (new_journal) {
> +			pr_err("Added new journal to %s. \n", devname);
> +			pr_err("Please restart the array to make it live.\n");
> +			return 1;
> +		}
>  		if (ioctl(fd, ADD_NEW_DISK, &disc)) {
>  			if (dv->disposition =3D=3D 'j')
>  				pr_err("Failed to hot add %s as journal, "
> --=20
> 2.4.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWeGeOAAoJEDnsnt1WYoG5GlkP/idMXgdJLgmsb1vIPiPfs6s0
uIxHLOrkF7W8/7XHmUmEZHxsKEIxeymCPqocbDigHG5PjAHydaKncZaaOxex44be
0Ff+GiBAufLmK65zh+llAGPg5oKIZpWK9fgIVIZYbbPU7qlR89nj8DrbnIHNRjbp
mS7fRfqrdPLcve78cqsRxR7mEMYo7X2L15kH9v9EAhtjWw+GYw128ZHG3HNZWZ2u
UD1/x4ZOwW7Nk+HwSJYlPELy4D0pUt+C/rZpQSrKxwk29YKo09cDD8iZlHThhvQ3
ptOKPv2memWP97i9WAwBR+Xfsx8+RuR3X3ah6WD6fLZixzS+GiWeb+mV/bY/7Qz1
Er21N9DEa4CKJP/G+zXQ5NAQIoUR/xb8dEnvxp8hLzEhiRS3vsADMmRgPUWt3AY1
bxL241e9wdjCtVYGK4dD0bnD+c7UbFDVstGHauUFwRoZbQ16REDpvbj+PXV/b1wF
jpzuu10mvriSuiij2y2hMNgnxPVyLCO6LknY5582lS1j+mn7yRJMlQk6Hh54Ou5D
ZfkgkbkRcewW6sR+GhGWiEUgbi+An3gyg55x0K5vfCvneMbklY9khcbAyIkE7dP+
4WHyqtFIXEtmUpYyMq/llkQb+lF6etHacp2COfPi56i5lldw6td2cct1LZtZKe+5
5jK1XnrT9yhXF2e+VlFR
=LGhb
-----END PGP SIGNATURE-----
--=-=-=--
