From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2 05/12] raid5-ppl: Partial Parity Log implementation
Date: Wed, 07 Dec 2016 12:17:43 +1100
Message-ID: <87a8c84jwo.fsf@notabene.neil.brown.name>
References: <20161205153113.7268-1-artur.paszkiewicz@intel.com> <20161205153113.7268-6-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161205153113.7268-6-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 06 2016, Artur Paszkiewicz wrote:

> This implements the write logging functionality, using the policy logic
> introduced in previous patches.
>
> PPL is a distributed log - data is stored on all RAID member drives in
> the metadata area. PPL is written to the parity disk of a particular
> stripe. Distributed log is implemented by using one r5l_log instance per
> each array member. They are grouped in child_logs array in struct
> ppl_conf, which is assigned to a common parent log. This parent log
> serves as a proxy and is used in raid5 personality code - it is assigned
> as _the_ log in r5conf->log. The child logs are where all the real work
> is done.
>
> The PPL consists of a 4KB header (struct ppl_header), and at least 128KB
> for partial parity data. It is stored right after the array data (for
> IMSM) or in the bitmap area (super 1.1 and 1.2) and can be overwritten
> even at each array write request.
>
> Attach a page for holding the partial parity data to each stripe_head.
> Allocate it only if mddev has the MD_HAS_PPL flag set.
>
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  drivers/md/raid5-cache.c |  12 +-
>  drivers/md/raid5-cache.h |   6 +
>  drivers/md/raid5-ppl.c   | 594 +++++++++++++++++++++++++++++++++++++++++=
+++++-
>  drivers/md/raid5.c       |  15 +-
>  drivers/md/raid5.h       |   1 +
>  5 files changed, 620 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index fa82b9a..be534d8 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -119,8 +119,8 @@ static bool r5l_has_free_space(struct r5l_log *log, s=
ector_t size)
>  	return log->device_size > used_size + size;
>  }
>=20=20
> -static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
> -				    enum r5l_io_unit_state state)
> +void __r5l_set_io_unit_state(struct r5l_io_unit *io,
> +			     enum r5l_io_unit_state state)
>  {
>  	if (WARN_ON(io->state >=3D state))
>  		return;
> @@ -340,7 +340,7 @@ static void r5c_finish_cache_stripe(struct stripe_hea=
d *sh)
>  	}
>  }
>=20=20
> -static void r5l_io_run_stripes(struct r5l_io_unit *io)
> +void r5l_io_run_stripes(struct r5l_io_unit *io)
>  {
>  	struct stripe_head *sh, *next;
>=20=20
> @@ -935,7 +935,7 @@ static sector_t r5l_reclaimable_space(struct r5l_log =
*log)
>  				 r5c_calculate_new_cp(conf));
>  }
>=20=20
> -static void r5l_run_no_mem_stripe(struct r5l_log *log)
> +void r5l_run_no_mem_stripe(struct r5l_log *log)
>  {
>  	struct stripe_head *sh;
>=20=20
> @@ -1039,7 +1039,7 @@ static void r5l_log_flush_endio(struct bio *bio)
>   * only write stripes of an io_unit to raid disks till the io_unit is th=
e first
>   * one whose data/parity is in log.
>   */
> -static void __r5l_flush_stripe_to_raid(struct r5l_log *log)
> +void __r5l_flush_stripe_to_raid(struct r5l_log *log)
>  {
>  	bool do_flush;
>=20=20
> @@ -1359,7 +1359,7 @@ bool r5l_log_disk_error(struct r5conf *conf)
>  	if (!log)
>  		ret =3D test_bit(MD_HAS_JOURNAL, &conf->mddev->flags);
>  	else
> -		ret =3D test_bit(Faulty, &log->rdev->flags);
> +		ret =3D log->rdev && test_bit(Faulty, &log->rdev->flags);
>  	rcu_read_unlock();
>  	return ret;
>  }
> diff --git a/drivers/md/raid5-cache.h b/drivers/md/raid5-cache.h
> index 4ba11d3..0446100 100644
> --- a/drivers/md/raid5-cache.h
> +++ b/drivers/md/raid5-cache.h
> @@ -157,4 +157,10 @@ extern int r5l_handle_flush_request(struct r5l_log *=
log, struct bio *bio);
>  extern void r5l_quiesce(struct r5l_log *log, int state);
>  extern bool r5l_log_disk_error(struct r5conf *conf);
>=20=20
> +extern void __r5l_set_io_unit_state(struct r5l_io_unit *io,
> +				    enum r5l_io_unit_state state);
> +extern void r5l_io_run_stripes(struct r5l_io_unit *io);
> +extern void r5l_run_no_mem_stripe(struct r5l_log *log);
> +extern void __r5l_flush_stripe_to_raid(struct r5l_log *log);
> +
>  #endif /* _RAID5_CACHE_H */
> diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
> index 263fad7..2d4c90f 100644
> --- a/drivers/md/raid5-ppl.c
> +++ b/drivers/md/raid5-ppl.c
> @@ -14,7 +14,599 @@
>=20=20
>  #include <linux/kernel.h>
>  #include <linux/blkdev.h>
> +#include <linux/slab.h>
> +#include <linux/crc32c.h>
> +#include <linux/module.h>
> +#include <linux/raid/md_p.h>
> +#include "md.h"
>  #include "raid5.h"
>  #include "raid5-cache.h"
>=20=20
> -struct r5l_policy r5l_ppl;
> +static bool ppl_debug;
> +module_param(ppl_debug, bool, 0644);
> +MODULE_PARM_DESC(ppl_debug, "Debug mode for md raid5 PPL");
> +
> +#define dbg(format, args...)						\
> +do {									\
> +	if (ppl_debug)							\
> +		printk(KERN_DEBUG"[%d] %s() "format,			\
> +			current->pid, __func__, ##args);		\
> +} while (0)

Please don't do this.  Just use pr_debug(), and use
 /sys/kernel/debug/dynamic_debug/control
to turn them on and off.

> +
> +struct ppl_conf {
> +	int count;
> +	struct r5l_log **child_logs;
> +};
> +
> +struct ppl_header_entry {
> +	__le64 data_sector;	/* Raid sector of the new data */
> +	__le32 pp_size;		/* Length of partial parity */
> +	__le32 data_size;	/* Length of data */
> +	__u8 parity_disk;	/* Member disk containing parity */
> +	__le32 checksum;	/* Checksum of this entry */
> +} __packed;

Really?  "checksum" is 32bits but not aligned?
I *think* you should be using get_unaligned_le32() to access this
and put_unaligned_le32() to set it.

> +
> +#define PPL_HEADER_SIZE PAGE_SIZE
> +#define PPL_HDR_RESERVED 512
> +#define PPL_HDR_ENTRY_SPACE \
> +	(PPL_HEADER_SIZE - PPL_HDR_RESERVED - 3 * sizeof(u32) - sizeof(u64))
> +#define PPL_HDR_MAX_ENTRIES \
> +	(PPL_HDR_ENTRY_SPACE / sizeof(struct ppl_header_entry))
> +#define PPL_ENTRY_SPACE_IMSM (128 * 1024)
> +
> +struct ppl_header {
> +	__u8 reserved[PPL_HDR_RESERVED];/* Reserved space */
> +	__le32 signature;		/* Signature (family number of volume) */
> +	__le64 generation;		/* Generation number of PP Header */

This probably needs to use the 'unaligned' macros too.

> +	__le32 entries_count;		/* Number of entries in entry array */
> +	__le32 checksum;		/* Checksum of PP Header */
> +	struct ppl_header_entry entries[PPL_HDR_MAX_ENTRIES];
> +} __packed;

ppl_header_entry doesn't seem to be a multiple of 4 bytes long.
This means all the fields in it could be unaligned...

Maybe we should make this code refuse to compile except on x86 ???


NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhHYzcACgkQOeye3VZi
gbngkQ/+OITca1t0hZ5zmAbrJmu/AkRkx/kHRDFnwjfevhTePTMvadr2lrMBZ/ZM
xvpqgHqEUI9Qc3iGWA40yL6R4SaDSl+BQx4rMmnd+CfBgCfAHCiSYMo4ADpk5gwU
ZPJmt5jUHK9lNMAnxnCySfidbgZiOovFmLoD3GMSjJXaNeVE9Ya1s45wzI5OG2bB
4PJ3WxYoa3rtzx1hcmfa8RVmVeznq+vtLqJuAAM/xB+pXwL8WpQhZsBa9/lyqMXh
pTo969Sa1Nn7ZbOzQD+5YdjcZDyJz+zl+fJn9z0Qmo0ld1OeDJFuTLZF9xVfqi/c
2DbTEWYXj8HDQuhQeHhbURD4K0CJi+zAVw+pMz8adFhMuG2CXoyZh8bzXpl0TLI3
bSuZY2mYokEh2TlR21e3RbfafkEPh50WY0A5EsmMpTMF0L6WaMBIrGjgEtUldCLc
H0LMI6UhnLPHeSVsxqzDdEmFqRx6w4Nyql5wJu1svriN9uUPJfvxec1ZnBz3A8Ct
HodSzy10onIKuOKMhe6NqBs3ArCLvVjgep05igIjMPxj/0y/oa2P8KwFwGPZC3uF
ibjz790eRdEwPcCjRwhb4VbWrKsm9XSFfvy/Sf4l5Q+sEGav67Bw7O4NBXDC6V8c
mWX6+DsutYJ8y74CAb/eXI6JdQj4BnvrHPZmY1f65tjhd5BUHcE=
=oUJ7
-----END PGP SIGNATURE-----
--=-=-=--
