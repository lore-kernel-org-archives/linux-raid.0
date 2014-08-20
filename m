From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md: fix for wrong state in superblock issue in assemble
 process
Date: Wed, 20 Aug 2014 13:28:21 +1000
Message-ID: <20140820132821.02249d39@notabene.brown>
References: <CADhVsC7qcRtDzYs7ChghReihOYWAx+czwVoWi9+H7SuvT0iOgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_//eg1bBiP9t9S9xkG7p0ei+h"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADhVsC7qcRtDzYs7ChghReihOYWAx+czwVoWi9+H7SuvT0iOgQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thiruvadi Rajaraman <trajaraman@mvista.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_//eg1bBiP9t9S9xkG7p0ei+h
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Aug 2014 15:04:43 +0530 Thiruvadi Rajaraman
<trajaraman@mvista.com> wrote:

Hi,
 you sent this email as HTML.  That means you would have got an automatic
 message from the kernel.org mail server telling you that it wasn't
 accepted.  Yet you didn't bother to try sending it again as plain text....


> >From b3261f3d73e87ebcefd3951b0f8667c54f531360 Mon Sep 17 00:00:00 2001
> From: Thiruvadi Rajaraman <trajaraman@mvista.com>
> Date: Wed, 23 Jul 2014 06:46:22 +0530
> Subject: [PATCH] md: fix for wrong state in superblock issue
>=20
> This patch has created on top of linux stable kernel "v2.6.32".

I'm only really interested in patches based on current mainline kernel (3.1=
6)
or something reasonably recent.

>=20
> The multipath md array assemble process by,
>=20
> # mdadm -A /dev/mdx /dev/sdx /dev/sdy ...

I'm not very keen of fixing bugs in md/multipath.  I would really like to
remove it completely, but people might be using it.  If there a known bugs,
then people might stop  using it, and that would be good.

dm/multipath is much better and is actually supported.  Is there  a reason
you don't use that?  See the multipath-tools package.

>=20
> which showing "wrong state in superblock" message because of dev_roles[d]
> of disk in md array is not updated with individual disk number while
> adding the removed disk to md array in assemble process.
>=20
> Issue solved by updating the dev_roles[raid disk] superblock detail with
> specific raid disk number during the array add process.
>=20
> ---
>  drivers/md/md.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4ce6e2f..7ba2a0d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1460,6 +1460,9 @@ static void super_1_sync(mddev_t *mddev, mdk_rdev_t
> *rdev)
>                         sb->dev_roles[i] =3D cpu_to_le16(0xffff);
>         }
>=20
> +       if (sb->level =3D=3D cpu_to_le32(LEVEL_MULTIPATH))
> +               sb->dev_number =3D 0;
> +

So you are forcing the dev_number to always be zero on multipath.  That mak=
es
sense.  I'm surprised it isn't already zero... What code sets it to a
non-zero number?
It seems that the kernel doesn't set dev_number at all at present.  I think=
 it
is best to leave it that way.



>         sb->sb_csum =3D calc_sb_1_csum(sb);
>  }
>=20
> @@ -1643,10 +1646,15 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev,
> mddev_t * mddev)
>          */
>         if (rdev->desc_nr < 0) {
>                 int choice =3D 0;
> -               if (mddev->pers) choice =3D mddev->raid_disks;
> +               if (mddev->pers && mddev->level !=3D LEVEL_MULTIPATH)
> +                       choice =3D mddev->raid_disks;
>                 while (find_rdev_nr(mddev, choice))
>                         choice++;
>                 rdev->desc_nr =3D choice;
> +               if (mddev->level =3D=3D LEVEL_MULTIPATH) {
> +                       rdev->raid_disk =3D rdev->desc_nr;
> +                       set_bit(In_sync, &rdev->flags);
> +               }

This looks wrong.  It isn't the job of bind_rdev_to_array to set ->raid_dis=
k.
That is by by ->hot_add_disk.

>         } else {
>                 if (find_rdev_nr(mddev, rdev->desc_nr))
>                         return -EBUSY;
> @@ -4845,6 +4853,9 @@ static int add_new_disk(mddev_t * mddev,
> mdu_disk_info_t *info)
>                         if (err)
>                                 unbind_rdev_from_array(rdev);
>                 }
> +               if (!err && mddev->level =3D=3D LEVEL_MULTIPATH) {
> +                       err =3D mddev->pers->hot_add_disk(mddev, rdev);
> +               }
>                 if (err)
>                         export_rdev(rdev);
>                 else

This possibly makes sense, but I would rather modify the earlier condition
which called ->hot_add_disk of ->hot_remove_disk is missing.

But the real question is: why do you want to use md/multipath?  Can I
convince you not to?

Thanks,
NeilBrown


--Sig_//eg1bBiP9t9S9xkG7p0ei+h
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU/QV1Tnsnt1WYoG5AQIJUA//edsil38qumVIjFuk6XV/NuBfrjf9BUFz
7tDlmh0CnVLVZhG1ee9zOmVp8jI9iX+1jaqKJefUVJSnnD3JCyUY64UN/pGWiM2j
9vah5K4v6jk8T0OyMyNsP8soZonWQJfQGQWbFeYcbDKt3qmVT1so6vC9uAgxPrM5
7whoNgDqyI4yB+QrcvIK3elNYU6ZtbH5TApwhZCGJNIvelCjdmePvjiRkfT3FX7d
Lm4mQKha4HfrcQ5s7wTyt8Awvx01OBS3bldXp6cl2WsdzfLS+4+s4jfpsNH3wvx/
EIq7UcFOvxMb6SkclXB+PZvKXY/4UVbrJCIhCLhcskx2uqUqdTs8IJq3pyJ9FfIk
uMhS407Otr8y2WvJvLuK60DaS5qXG+k48Ftf/ZF0ifo+UpkEhHUP8iOuZZxov0KB
RqmJim7MKHgp5m8EDuYisM+gzN4pQdSv27/QipIuwPRqll3aHdwLJc9DFcFzp2fv
zHf8NOczgNCAVr7y/0XyvrK7eK09QN7mRmmC7VbU57JP/uMkspPtrq2DHaHOh5K5
bgB6b8/yo47ksdDszdvT+CXAVkYXhyJWlFQXsWiuxU3UJP/axz66voDBKPrtg+f9
NafODa5/oFPW2FhgIYNJSbcXFGmxFbjoezKqJJVRrw6R+ZhnDuhMtCyND5E8OkUm
11rwQlKFo+c=
=fC1v
-----END PGP SIGNATURE-----

--Sig_//eg1bBiP9t9S9xkG7p0ei+h--
