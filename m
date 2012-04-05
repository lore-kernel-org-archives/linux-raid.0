From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/4] imsm: clean up missing disks if there are any left
 after migration
Date: Thu, 5 Apr 2012 10:06:16 -0700
Message-ID: <CABE8wwvqupNW4kpVFriedqST6M_JVbi0ccCZkbHMqecCT0Eiug@mail.gmail.com>
References: <20120405152553.19851.48052.stgit@linux.site>
	<20120405153021.19851.74528.stgit@linux.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120405153021.19851.74528.stgit@linux.site>
Sender: linux-raid-owner@vger.kernel.org
To: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Thu, Apr 5, 2012 at 8:30 AM, Przemyslaw Czarnowski
<przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:
> It is for compatibility with OROM way to set "recovery" state.
>
> Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnows=
ki@intel.com>
> ---
> =A0super-intel.c | =A0 =A09 +++++++--
> =A01 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/super-intel.c b/super-intel.c
> index e1cd9b8..f843997 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -7211,6 +7211,8 @@ skip_mark_checkpoint:
> =A0 =A0 =A0 =A0return consistent;
> =A0}
>
> +static void imsm_delete(struct intel_super *super, struct dl **dlp, =
unsigned index);
> +
> =A0static void imsm_set_disk(struct active_array *a, int n, int state=
)
> =A0{
> =A0 =A0 =A0 =A0int inst =3D a->info.container_member;
> @@ -7260,6 +7262,11 @@ static void imsm_set_disk(struct active_array =
*a, int n, int state)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dprintf("while rebuild=
ing");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0end_migration(dev, sup=
er, map_state);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0map =3D get_imsm_map(d=
ev, MAP_0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* sweep list of missin=
g disks, OROM might leave
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* some residuals fro=
m old members */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 while (super->missing) =
{
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 imsm_de=
lete(super, &super->missing, super->missing->index);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }

No, the expectation is that the list of disks is only mutated by the
monitor from imsm_process_update() where we can be sure that the
manager thread is not walking the disk list.  I.e. we get away from
needing locks by just making sure the monitor can't race with the
manager.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
