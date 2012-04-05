From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 3/4] imsm: avoid double change of serial number of missing device
Date: Thu, 5 Apr 2012 10:41:28 -0700
Message-ID: <CABE8wwtXAJa9de0CS9OqNUbR5rG3bLth0HP4jYG+M_sMu_FE6A@mail.gmail.com>
References: <20120405152553.19851.48052.stgit@linux.site>
	<20120405153054.19851.39398.stgit@linux.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120405153054.19851.39398.stgit@linux.site>
Sender: linux-raid-owner@vger.kernel.org
To: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Thu, Apr 5, 2012 at 8:30 AM, Przemyslaw Czarnowski
<przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:
> If degraded state is set in OROM, it do not set 'failed' flag for mis=
sing,
> device, just changes serial number, sets scsiId to 0xffff and sets hi=
ghest
> bit in ord table in map. When mdadm replaces missing disk, the one le=
ft
> there is marked as failed and missing again (changing already marked =
serial
> number).
>
> Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnows=
ki@intel.com>
> ---
> =A0super-intel.c | =A0 15 +++++++++------
> =A01 files changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/super-intel.c b/super-intel.c
> index f843997..b361b72 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -6908,12 +6908,15 @@ static int mark_failure(struct imsm_dev *dev,=
 struct imsm_disk *disk, int idx)
> =A0 =A0 =A0 =A0if (is_failed(disk) && (ord & IMSM_ORD_REBUILD))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
>
> - =A0 =A0 =A0 memcpy(buf, disk->serial, MAX_RAID_SERIAL_LEN);
> - =A0 =A0 =A0 buf[MAX_RAID_SERIAL_LEN] =3D '\000';
> - =A0 =A0 =A0 strcat(buf, ":0");
> - =A0 =A0 =A0 if ((len =3D strlen(buf)) >=3D MAX_RAID_SERIAL_LEN)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 shift =3D len - MAX_RAID_SERIAL_LEN + 1=
;
> - =A0 =A0 =A0 strncpy((char *)disk->serial, &buf[shift], MAX_RAID_SER=
IAL_LEN);
> + =A0 =A0 =A0 /* do not add ":0", OROM has already done it */
> + =A0 =A0 =A0 if (!(ord & IMSM_ORD_REBUILD)) {

What about the case where we are rebuilding to this disk and then get
a failure, doesn't this prevent the serial number from getting
updated?

The metadata expectation, as far as I can tell, is in-metadata-serial
!=3D serial-retrieved-from-disk.  So if it gets mutated twice what harm
does that cause?

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(buf, disk->serial, MAX_RAID_SERI=
AL_LEN);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 buf[MAX_RAID_SERIAL_LEN] =3D '\000';
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 strcat(buf, ":0");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((len =3D strlen(buf)) >=3D MAX_RAID=
_SERIAL_LEN)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 shift =3D len - MAX_RAI=
D_SERIAL_LEN + 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 strncpy((char *)disk->serial, &buf[shif=
t], MAX_RAID_SERIAL_LEN);
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0disk->status |=3D FAILED_DISK;
> =A0 =A0 =A0 =A0set_imsm_ord_tbl_ent(map, slot, idx | IMSM_ORD_REBUILD=
);
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
