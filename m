From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: fix: rebuild does not continue after reboot
Date: Mon, 23 Apr 2012 09:52:05 +1000
Message-ID: <20120423095205.40cdacde@notabene.brown>
References: <20120420114502.2484.68027.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1li+zgVRWLEg5+=W8V0UYTD"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120420114502.2484.68027.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

--Sig_/1li+zgVRWLEg5+=W8V0UYTD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 20 Apr 2012 13:45:02 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> If system is rebooted during rebuild, md driver changes sync_action
> from 'recover' to 'idle' (during stopping all md devices).
> If mdmon is still running then, it detects the change of sync_action stat=
e,
> finishes rebuild and writes metadata to disks. After computer's restart
> the RAID volume is in Normal state in OROM and rebuild seems to be finish=
ed.
> After system's start-up RAID volume is in auto-read-only state
> and metadata is in Dirty state. Rebuild seems to be finished but it is no=
t.
> Data is inconsistent (out-of-sync).
>=20
> When mdmon detects the change of sync_action from 'recover' to 'idle',
> it has to check if rebuild is really finished. Appropriate test was added.
> Now mdmon examines each volume's member if it is being rebuilt.
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  super-intel.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index e405d97..1ad5e47 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -7273,6 +7273,8 @@ static void imsm_set_disk(struct active_array *a, i=
nt n, int state)
>  	struct imsm_dev *dev =3D get_imsm_dev(super, inst);
>  	struct imsm_map *map =3D get_imsm_map(dev, MAP_0);
>  	struct imsm_disk *disk;
> +	struct mdinfo *mdi;
> +	int recovery_not_finished =3D 0;
>  	int failed;
>  	__u32 ord;
>  	__u8 map_state;
> @@ -7313,6 +7315,21 @@ static void imsm_set_disk(struct active_array *a, =
int n, int state)
>  		dprintf("normal: ");
>  		if (is_rebuilding(dev)) {
>  			dprintf("while rebuilding");
> +			/* check if recovery is really finished */
> +			for (mdi =3D a->info.devs; mdi ; mdi =3D mdi->next)
> +				if (mdi->recovery_start !=3D MaxSector) {
> +					recovery_not_finished =3D 1;
> +					break;
> +				}
> +			if (recovery_not_finished) {
> +				dprintf("\nimsm: Rebuild has not finished yet, "
> +						"state not changed");
> +				if (a->last_checkpoint < mdi->recovery_start) {
> +					a->last_checkpoint =3D mdi->recovery_start;
> +					super->updates_pending++;
> +				}
> +				break;
> +			}
>  			end_migration(dev, super, map_state);
>  			map =3D get_imsm_map(dev, MAP_0);
>  			map->failed_disk_num =3D ~0;


Applied, thanks.

NeilBrown

--Sig_/1li+zgVRWLEg5+=W8V0UYTD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5SZpTnsnt1WYoG5AQLR8xAAjqPLsNg+mW+/yXlNMidufWXSATXoaAPD
b3Z/L3TOyzO9bpwdd/T1vKVstW72YcJndR/SSLsYO3821UG4k042417eDIt53VaZ
333okqIPg/8SOw67uoTj3MmXzcs++sv48NoLRm1/WOC2Fzn4A9veAlKbiTpMZ4H1
Si4tPb2EpKt9F4i9ZmBuPPczHQzPQV+sOdTpPFrI32te/Lqg1NEytgWLausrGJQj
T0zGibDAVkbWxYZBqYpTaRaBtDry62Pn2bO28nWm5lIXSfLr937WknaPaJiHJ+MI
xjjSddl/kbnBRk9mqu6GJRhyjR7vAJ9xwAjCeUeTHOmDGSZVgRBVi5XsXHrabwhF
IwJQ0va5fnEyX2amOfpeLgpprtFVgTGEPx3KtBfxZmdYbWHrxyw83aWCOYNh4IAw
RTrHY4O/Tmps/lYT58oGI4IPrKfp+KneJTea/cObaBENLZ4JDYU98Tw9CmcElB0U
DsdNGxvsy6hwk7Y1Z3IkQ0InCAmUW9VqH9PCFFuj+Ksv9tQRn4HQH1/6q9vvTlty
X+5zJcspG+HGsv+wiAmniGVIuhZlrOzvXX0TcVKVpNADfahVrsC+jvHsTMDSCF0H
dU1hSI9QhRKlQXRV04yYwHL7pjHOBvFRe6Quh3fyPT3H76AzZd+xb4erFXnP/Cwn
6DodEfv6RBk=
=+ku6
-----END PGP SIGNATURE-----

--Sig_/1li+zgVRWLEg5+=W8V0UYTD--
