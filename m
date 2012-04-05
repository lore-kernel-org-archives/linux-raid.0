From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/4] imsm: monitor: do not finish migration if there are
 no failed disks
Date: Thu, 5 Apr 2012 10:56:45 -0700
Message-ID: <CABE8wwvW6QGsdHh2A9ivL+ZVowgPRfJWwrhwu=Kr1NZCLpxqwg@mail.gmail.com>
References: <20120405152553.19851.48052.stgit@linux.site>
	<20120405152948.19851.16491.stgit@linux.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120405152948.19851.16491.stgit@linux.site>
Sender: linux-raid-owner@vger.kernel.org
To: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Thu, Apr 5, 2012 at 8:29 AM, Przemyslaw Czarnowski
<przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:
> Transition from "degraded" to "recovery" made in OROM is slightly dif=
ferent
> than the same transision in mdadm. Missing disk is not removed from l=
ist of
> raid devices, but just from map. Therefore mdadm should not end migra=
tion
> basing on existence of list of missing disks but should rely on count=
 of
> failed disks.
>
> Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnows=
ki@intel.com>
> ---
> =A0super-intel.c | =A0 =A09 ++++++++-
> =A01 files changed, 8 insertions(+), 1 deletions(-)
>
> diff --git a/super-intel.c b/super-intel.c
> index dad4c4d..e1cd9b8 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -6953,6 +6953,12 @@ static void handle_missing(struct intel_super =
*super, struct imsm_dev *dev)
> =A0 =A0 =A0 =A0if (!super->missing)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
>
> + =A0 =A0 =A0 /* When orom adds replacement for missing disk it does
> + =A0 =A0 =A0 =A0* not remove entry of missing disk, but just updates=
 map with
> + =A0 =A0 =A0 =A0* new added disk. So it is not enough just to test i=
f there is
> + =A0 =A0 =A0 =A0* any missing disk, we have to look if there are any=
 failed disks
> + =A0 =A0 =A0 =A0* in map to stop migration */
> +
> =A0 =A0 =A0 =A0dprintf("imsm: mark missing\n");
> =A0 =A0 =A0 =A0/* end process for initialization and rebuild only
> =A0 =A0 =A0 =A0 */
> @@ -6963,7 +6969,8 @@ static void handle_missing(struct intel_super *=
super, struct imsm_dev *dev)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0failed =3D imsm_count_failed(super, de=
v, MAP_0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0map_state =3D imsm_check_degraded(supe=
r, dev, failed, MAP_0);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 end_migration(dev, super, map_state);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (failed)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 end_migration(dev, supe=
r, map_state);

Doesn't this need to be something like "failed >=3D max_degraded" since
some recovery scenarios can continue in the presence of failed disks
like raid10, raid6.  Can you describe a bit more what the user visible
behavior is when the OROM leaves these stale entries?

This may be the right thing to do, but handle_missing is also called
in the case where we know a disk we had previously has been removed
and in that case we certainly want to restart recovery, right?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
