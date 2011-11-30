From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] imsm: fix: correct checking newly missing disks
Date: Tue, 29 Nov 2011 18:26:50 -0800
Message-ID: <CAA9_cmccLh=zYnqkpdhjkYZQQK26oUN4xqiMyycYHoLSr19zKg@mail.gmail.com>
References: <20111114145252.21148.62905.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111114145252.21148.62905.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Mon, Nov 14, 2011 at 6:52 AM, Lukasz Dorau <lukasz.dorau@intel.com> =
wrote:
> The problem occurs when RAID10 array under rebuild
> (after one disk fails) is assembled incrementally.
> Mdadm tries to start array just after adding the third disk
> and the volume is assembled incorrectly (in degraded state).
>
> The cause is that container_enough depends on
> newly missing disks which are checked incorrectly now.
> They should be checked using always the first map.
>
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
> =A0super-intel.c | =A0 =A04 ++--
> =A01 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/super-intel.c b/super-intel.c
> index 4ebee78..511a32a 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -2529,13 +2529,13 @@ static void getinfo_super_imsm(struct superty=
pe *st, struct mdinfo *info, char *
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0failed =3D imsm_count_failed(super, de=
v);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0state =3D imsm_check_degraded(super, d=
ev, failed);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 map =3D get_imsm_map(dev, dev->vol.migr=
_state);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 map =3D get_imsm_map(dev, 0);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* any newly missing disks?
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * (catches single-degraded vs double-=
degraded)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for (j =3D 0; j < map->num_members; j+=
+) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 ord =3D get_imsm_=
ord_tbl_ent(dev, i, -1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 ord =3D get_imsm_=
ord_tbl_ent(dev, i, 0);

This looks wrong.  I noticed this when looking over Przemyslaw's patch =
[1].

map[0] always contains the destination state of the migration so the
most reliable source for looking for out of sync disks is map[1].

--
Dan

[1]: http://marc.info/?l=3Dlinux-raid&m=3D132206766827484&w=3D2
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
