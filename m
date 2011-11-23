From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH] imsm: incorrect incremental behavior because of wrong
 index used
Date: Wed, 23 Nov 2011 10:56:21 -0800
Message-ID: <CABE8wwtdDLoggFJev-BSB94VGz+3Y_7fU1o5GJxR53-UU+asGg@mail.gmail.com>
References: <20111123165943.25613.20161.stgit@gklab-154-231>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111123165943.25613.20161.stgit@gklab-154-231>
Sender: linux-raid-owner@vger.kernel.org
To: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

On Wed, Nov 23, 2011 at 8:59 AM, Przemyslaw Czarnowski
<przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:
> Incremental in some cases prematurely assembles degraded arrays due t=
o
> wrong index used in code which counts missing disks
>
> Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnows=
ki@intel.com>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

> ---
> =A0super-intel.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/super-intel.c b/super-intel.c
> index 360c4cc..a0672bf 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -2539,7 +2539,7 @@ static void getinfo_super_imsm(struct supertype=
 *st, struct mdinfo *info, char *
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * (catches single-degraded vs double-=
degraded)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for (j =3D 0; j < map->num_members; j+=
+) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 ord =3D get_imsm_=
ord_tbl_ent(dev, i, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 ord =3D get_imsm_=
ord_tbl_ent(dev, j, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u32 idx =3D ord_to_i=
dx(ord);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!(ord & IMSM_ORD_R=
EBUILD) &&
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
