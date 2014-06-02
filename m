From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/1] md: Do only necessary operations when adding device
 to RO array
Date: Mon, 2 Jun 2014 12:34:11 +1000
Message-ID: <20140602123411.4becb274@notabene.brown>
References: <84A53BEA6EAC69439B7E311E9B17A76F07918BF9@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/xATcL7zslM_AsVrNQ78JuvW"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <84A53BEA6EAC69439B7E311E9B17A76F07918BF9@IRSMSX105.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

--Sig_/xATcL7zslM_AsVrNQ78JuvW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 30 May 2014 13:17:14 +0000 "Baldysiak, Pawel"
<pawel.baldysiak@intel.com> wrote:

> Commit 8313b8e57f55b15e5b7f7fc5d1630bbf686a9a97 changed
> way of adding device to read-only array. Used routine
> md_reap_sync_thread() which also trigger finish_reshape(),
> can break reshape process, if it was restarted.

Exactly how can it break?

This is probably fixed by a couple of patches in my for-next branch which I
will be sending to Linus shortly.

NeilBrown


> This part of function should do only necessary operations, that is:
> 1) call ->spare_active
> 2) clear saved_raid_disk if array is no longer degraded
>=20
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
>=20
> ---
> drivers/md/md.c | 10 ++++++----
> 1 file changed, 6 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 237b7e0..cf073de2 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7820,11 +7820,13 @@ void md_check_recovery(struct mddev *mddev)
>                                                 * As we only add devices =
that are already in-sync,
>                                                 * we can activate the spa=
res immediately.
>                                                 */
> +                                             struct md_rdev *rdev;
>                                                remove_and_add_spares(mdde=
v, NULL);
> -                                              /* There is no thread, but=
 we need to call
> -                                              * ->spare_active and clear=
 saved_raid_disk
> -                                              */
> -                                              md_reap_sync_thread(mddev);
> +                                             mddev->pers->spare_active(m=
ddev);
> +                                             rdev_for_each(rdev, mddev)
> +                                                             if (!mddev-=
>degraded ||
> +                                                                 test_bi=
t(In_sync, &rdev->flags))
> +                                                                        =
     rdev->saved_raid_disk =3D -1;
>                                                clear_bit(MD_RECOVERY_NEED=
ED, &mddev->recovery);
>                                                goto unlock;
>                                }
> --
> 1.9.0


--Sig_/xATcL7zslM_AsVrNQ78JuvW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU4vioznsnt1WYoG5AQJgXw/9ExzeUsgFvJdiXgBTmRUJsEFc65vlyxaa
QZsjtaKLCdQbb7veIztS/xmxFB7EIQfwXk26MtqDEX98oISOWA37E0ioVPKgLhVH
7OTHMbDgoua0qEbzbElY990VDwlvov7BetC3pkCHoAUpqh6GRm6V6VyhPU6wrQor
5XfJHJw00/9bNwBBXs2j+7jhwDSEDIRzt02zLoSSjonuOeSscAFv7bI25oKEc0Qz
tFqdJ/lrrNsCHT/ONm6ALcDJj5U/NPAYl78m+wQgbMezWo6IPug2u56PMKIBZEoG
4Z2u35a41GvjEzTrXhnTGk1776w1I1xXlyMwKrlFkcVvOz0tdi+ur3Qwyuw3/Pkk
gXLnTF7s7bpCbR6h9KGZov8Rlsyeoo8HGg1BBis3ZTDnQ48zHBUW1wBYMwVk3Adm
snH7Xq3BSVP0CdiuTlrJp3Mzjfbga6IKCW0hwqHOZ0vxNKLT0RPzD3Iz8bisd1sM
SnJE70DvJDyMEqQM+3JEJQ+t7Ft5fErMdz8xHoo+pAK5Dxloy02UJfaFByVAxrb4
7/XBvKlBqzK3zDcpAc1HKN6PRszaYrbmIRasyZeGpPGfCURreMBXRuSpqFLDjbck
SkwGk3dBJ6oN+8fmNscqI0pyT4vfBTazWMrs9I7TiaUZzl3qM4joP94Jc5DPNQ8g
UML29LwbkTA=
=Se5W
-----END PGP SIGNATURE-----

--Sig_/xATcL7zslM_AsVrNQ78JuvW--
