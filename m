From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 5/9] imsm: fix reserved sectors for spares
Date: Fri, 26 Aug 2011 12:51:18 -0700
Message-ID: <CABE8wwv08oPwU4maaBULCoy993v=uhGny0_gTWFdYHDsoYLvEg@mail.gmail.com>
References: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
	<20110826021424.28015.2342.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110826021424.28015.2342.stgit@localhost6.localdomain6>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Anna Czarnowska <anna.czarnowska@intel.com>, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Thu, Aug 25, 2011 at 7:14 PM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> Different OROMs reserve different amounts of space for the migration =
area.
> When activating a spare minimize the reserved space otherwise a valid=
 spare
> can be prevented from joining an array with a migration area smaller =
than
> IMSM_RESERVED_SECTORS.
>
> This may result in an array that cannot be reshaped, but that is less
> surprising than not being able to rebuild a degraded array.
> imsm_reserved_sectors() already reports the minimal value which adds =
to
> the confusion when trying rebuild an array because mdadm -E indicates
> that the device has enough space.
>
> Cc: Anna Czarnowska <anna.czarnowska@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> =A0super-intel.c | =A0 11 ++++++++++-
> =A01 files changed, 10 insertions(+), 1 deletions(-)
>
> diff --git a/super-intel.c b/super-intel.c
> index 0347183..193e0d0 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -833,7 +833,16 @@ static struct extent *get_extents(struct intel_s=
uper *super, struct dl *dl)
> =A0 =A0 =A0 =A0struct extent *rv, *e;
> =A0 =A0 =A0 =A0int i;
> =A0 =A0 =A0 =A0int memberships =3D count_memberships(dl, super);
> - =A0 =A0 =A0 __u32 reservation =3D MPB_SECTOR_CNT + IMSM_RESERVED_SE=
CTORS;
> + =A0 =A0 =A0 __u32 reservation;
> +
> + =A0 =A0 =A0 /* trim the reserved area for spares, so they can join =
any array
> + =A0 =A0 =A0 =A0* regardless of whether the OROM has assigned sector=
s from the
> + =A0 =A0 =A0 =A0* IMSM_RESERVED_SECTORS region
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (dl->index =3D=3D -1)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 reservation =3D MPB_SECTOR_CNT;

Anna rightly points out that this could probably be safely made
bigger.  As it stands this applies to too broad an array of disks.  I
think a happy medium (until we can nail down the forward compatibility
of older oroms, v8 in this case) is to detect the case where the disk
is being activated for rebuild and if it is at least as large as one
of the existing members truncate the reserved region to the same size
as the other member.  That way we are at least compatible with
whatever agent created the array in the first instance.

But this also comes back to the problem of duplicating the array
configuration.  It becomes difficult to make things the same size
unless the orom version (reserved region layout) is specified.

--
Dan

>
> =A0 =A0 =A0 =A0rv =3D malloc(sizeof(struct extent) * (memberships + 1=
));
> =A0 =A0 =A0 =A0if (!rv)
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
