From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] imsm: fix: correct calculation of UUID
Date: Wed, 4 Jan 2012 02:05:09 -0800
Message-ID: <CABE8wwtjQG5Zo6rd-7T+oQp3qBG-_hjbXoLy4zO2aRXNi8zPnw@mail.gmail.com>
References: <20120104094035.14727.94117.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120104094035.14727.94117.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Wed, Jan 4, 2012 at 1:40 AM, Lukasz Dorau <lukasz.dorau@intel.com> w=
rote:
> The UUID is calculated from two numbers and two strings stored in arr=
ays.
> Whole arrays of chars are taken to calculation (not only the used par=
t).
> This is wrong, because the unused part of arrays can be changed accid=
entally.
> For example it can sometimes happen when degraded raid is being rebui=
lt in OROM.
> Such accidental change of UUID causes that system installed on raid
> does not boot due to not recognized booting device (raid with changed=
 UUID).
>
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
> =A0super-intel.c | =A0 =A07 +++++--
> =A01 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/super-intel.c b/super-intel.c
> index 0e9269f..7f34542 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -1820,6 +1820,7 @@ static void uuid_from_super_imsm(struct superty=
pe *st, int uuid[4])
> =A0 =A0 =A0 =A0struct sha1_ctx ctx;
> =A0 =A0 =A0 =A0struct imsm_dev *dev =3D NULL;
> =A0 =A0 =A0 =A0__u32 family_num;
> + =A0 =A0 =A0 size_t len;
>
> =A0 =A0 =A0 =A0/* some mdadm versions failed to set ->orig_family_num=
, in which
> =A0 =A0 =A0 =A0 * case fall back to ->family_num. =A0orig_family_num =
will be
> @@ -1829,14 +1830,16 @@ static void uuid_from_super_imsm(struct super=
type *st, int uuid[4])
> =A0 =A0 =A0 =A0if (family_num =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0family_num =3D super->anchor->family_n=
um;
> =A0 =A0 =A0 =A0sha1_init_ctx(&ctx);
> - =A0 =A0 =A0 sha1_process_bytes(super->anchor->sig, MPB_SIG_LEN, &ct=
x);
> + =A0 =A0 =A0 len =3D strnlen((const char *)super->anchor->sig, MPB_S=
IG_LEN);
> + =A0 =A0 =A0 sha1_process_bytes(super->anchor->sig, len, &ctx);
> =A0 =A0 =A0 =A0sha1_process_bytes(&family_num, sizeof(__u32), &ctx);
> =A0 =A0 =A0 =A0if (super->current_vol >=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev =3D get_imsm_dev(super, super->cur=
rent_vol);
> =A0 =A0 =A0 =A0if (dev) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u32 vol =3D super->current_vol;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sha1_process_bytes(&vol, sizeof(vol), =
&ctx);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 sha1_process_bytes(dev->volume, MAX_RAI=
D_SERIAL_LEN, &ctx);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D strnlen((const char *)dev->volu=
me, MAX_RAID_SERIAL_LEN);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sha1_process_bytes(dev->volume, len, &c=
tx);

Can't do this.  It will break the UUIDs of existing arrays in the field=
=2E

When can the unused portion of anchor->sig and dev->volume be "changed
accidentally", as you mention, during a rebuild?  That is what needs
to be fixed.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
