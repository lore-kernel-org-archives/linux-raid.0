From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v5 3/8] md/r5cache: State machine for raid5-cache write back mode
Date: Fri, 14 Oct 2016 17:13:28 +1100
Message-ID: <87oa2nzcdz.fsf@notabene.neil.brown.name>
References: <20161013054944.1038806-1-songliubraving@fb.com> <20161013054944.1038806-4-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161013054944.1038806-4-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuang521@gmail.com, liuzhengyuan@kylinos.cn, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 13 2016, Song Liu wrote:

> The raid5-cache write back mode as 2 states for each stripe: write state
> and reclaim state. This patch adds bare state machine for these two
> states.
>
> 2 flags are added to sh->state for raid5-cache states:
>  - STRIPE_R5C_FROZEN
>  - STRIPE_R5C_WRITTEN
>
> STRIPE_R5C_FROZEN is the key flag to differentiate write state
> and reclaim state.
>
> STRIPE_R5C_WRITTEN is a helper flag to bring the stripe back from
> reclaim state back to write state.
>
> In write through mode, every stripe also goes between write state
> and reclaim state (in r5c_handle_stripe_dirtying() and
> r5c_handle_stripe_written()).
>
> Please note: this is a "no-op" patch for raid5-cache write through
> mode.
>
> The following detailed explanation is copied from the raid5-cache.c:
>
> /*
>  * raid5 cache state machine
>  *
>  * The RAID cache works in two major states for each stripe: write state
>  * and reclaim state. These states are controlled by flags STRIPE_R5C_FRO=
ZEN
>  * and STRIPE_R5C_WRITTEN

Hi,
 It would really help at this point to understand exactly what it is
 that is "FROZEN".  I guess the contents of the stripe_head are frozen?
 so that nothing changes between writing to the journal and writing to
 the RAID?  Making that explicit would help.

 Only... the stripe_head gets "frozen" before that.  It gets frozen
 before the parity is calculated, and not released until the data and
 parity is written to the RAID.  This new "FROZEN" state is a subset of
 that - yes?

 Given that STRIPE_R5C_FROZEN is set when the stripe is in "reclaim
 state", I wonder why you didn't call it "STRIPE_R5C_RECLAIM"
 .... though I'm not sure "reclaim" is a good word.  Reclaim is
 something that happens to the journal after the data has been written
 to the RAID.

 Maybe STRIPE_R5C_CACHED  which means that the data is cached in the
 journal, but not safe in the RAID.... only that describes the
 STRIPE_R5C_WRITTEN flag.

 Choosing names is hard, I understand that.  I think improving these
 names would help a lot though.

>  *
>  * STRIPE_R5C_FROZEN is the key flag to differentiate write state and rec=
laim
>  * state. The write state runs w/ STRIPE_R5C_FROZEN =3D=3D 0. While the r=
eclaim
>  * state runs w/ STRIPE_R5C_FROZEN =3D=3D 1.
>  *
>  * STRIPE_R5C_WRITTEN is a helper flag to bring the stripe back from recl=
aim
>  * state to write state. Specifically, STRIPE_R5C_WRITTEN triggers clean =
up
>  * process in r5c_handle_stripe_written. STRIPE_R5C_WRITTEN is set when d=
ata
>  * and parity of a stripe is all in journal device; and cleared when the =
data
>  * and parity are all in RAID disks.
>  *
>  * The following is another way to show how STRIPE_R5C_FROZEN and
>  * STRIPE_R5C_WRITTEN work:
>  *
>  * write state: STRIPE_R5C_FROZEN =3D 0 STRIPE_R5C_WRITTEN =3D 0
>  * reclaim state: STRIPE_R5C_FROZEN =3D 1
>  *
>  * write =3D> reclaim: set STRIPE_R5C_FROZEN in r5c_freeze_stripe_for_rec=
laim
>  * reclaim =3D> write:
>  * 1. write parity to journal, when finished, set STRIPE_R5C_WRITTEN
>  * 2. write data/parity to raid disks, when finished, clear both
>  *    STRIPE_R5C_FROZEN and STRIPE_R5C_WRITTEN
>  *
>  * In write through mode (journal only) the stripe still goes through the=
se
>  * state change, except that STRIPE_R5C_FROZEN is set on write in
>  * r5c_handle_stripe_dirtying().
>  */
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5-cache.c | 125 +++++++++++++++++++++++++++++++++++++++++=
++++--
>  drivers/md/raid5.c       |  20 ++++++--
>  drivers/md/raid5.h       |  10 +++-
>  3 files changed, 148 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 7557791b..9e05850 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -40,6 +40,47 @@
>   */
>  #define R5L_POOL_SIZE	4
>=20=20
> +enum r5c_state {
> +	R5C_STATE_NO_CACHE =3D 0,
> +	R5C_STATE_WRITE_THROUGH =3D 1,
> +	R5C_STATE_WRITE_BACK =3D 2,
> +	R5C_STATE_CACHE_BROKEN =3D 3,

How is CACHE_BROKEN different from NO_CACHE??
Maybe a latter patch will tell me, but I'd rather know now :-)

As this state is stored in the r5l_log, and as we don't allocate that
when there is no cache, why have a NO_CACHE state?

> +};
> +
> +/*
> + * raid5 cache state machine
> + *
> + * The RAID cache works in two major states for each stripe: write state=
 and
> + * reclaim state. These states are controlled by flags STRIPE_R5C_FROZEN=
 and
> + * STRIPE_R5C_WRITTEN
> + *
> + * STRIPE_R5C_FROZEN is the key flag to differentiate write state and re=
claim
> + * state. The write state runs w/ STRIPE_R5C_FROZEN =3D=3D 0. While the =
reclaim
> + * state runs w/ STRIPE_R5C_FROZEN =3D=3D 1.
> + *
> + * STRIPE_R5C_WRITTEN is a helper flag to bring the stripe back from rec=
laim
> + * state to write state. Specifically, STRIPE_R5C_WRITTEN triggers clean=
 up
> + * process in r5c_handle_stripe_written. STRIPE_R5C_WRITTEN is set when =
data
> + * and parity of a stripe is all in journal device; and cleared when the=
 data
> + * and parity are all in RAID disks.
> + *
> + * The following is another way to show how STRIPE_R5C_FROZEN and
> + * STRIPE_R5C_WRITTEN work:
> + *
> + * write state: STRIPE_R5C_FROZEN =3D 0 STRIPE_R5C_WRITTEN =3D 0
> + * reclaim state: STRIPE_R5C_FROZEN =3D 1
> + *
> + * write =3D> reclaim: set STRIPE_R5C_FROZEN in r5c_freeze_stripe_for_re=
claim
> + * reclaim =3D> write:
> + * 1. write parity to journal, when finished, set STRIPE_R5C_WRITTEN
> + * 2. write data/parity to raid disks, when finished, clear both
> + *    STRIPE_R5C_FROZEN and STRIPE_R5C_WRITTEN
> + *
> + * In write through mode (journal only) the stripe also goes through the=
se
> + * state change, except that STRIPE_R5C_FROZEN is set on write in
> + * r5c_handle_stripe_dirtying().
> + */
> +
>  struct r5l_log {
>  	struct md_rdev *rdev;
>=20=20
> @@ -96,6 +137,9 @@ struct r5l_log {
>  	spinlock_t no_space_stripes_lock;
>=20=20
>  	bool need_cache_flush;
> +
> +	/* for r5c_cache */
> +	enum r5c_state r5c_state;
>  };
>=20=20
>  /*
> @@ -133,6 +177,11 @@ enum r5l_io_unit_state {
>  	IO_UNIT_STRIPE_END =3D 3,	/* stripes data finished writing to raid */
>  };
>=20=20
> +bool r5c_is_writeback(struct r5l_log *log)
> +{
> +	return (log !=3D NULL && log->r5c_state =3D=3D R5C_STATE_WRITE_BACK);
> +}
> +
>  static sector_t r5l_ring_add(struct r5l_log *log, sector_t start, sector=
_t inc)
>  {
>  	start +=3D inc;
> @@ -168,12 +217,44 @@ static void __r5l_set_io_unit_state(struct r5l_io_u=
nit *io,
>  	io->state =3D state;
>  }
>=20=20
> +/*
> + * Freeze the stripe, thus send the stripe into reclaim path.
> + *
> + * In current implementation, STRIPE_R5C_FROZEN is also set in write thr=
ough
> + * mode (in r5c_handle_stripe_dirtying). This does not change the behavi=
or of
> + * for write through mode.
> + */
> +void r5c_freeze_stripe_for_reclaim(struct stripe_head *sh)

"freeze_stripe_for_reclaim" seems an odd name.  How does "reclaim" fit?
You are freezing the stripe so it can be written to the journal, and
then eventually to the RAID are you not?
Or are you freezing it so the space used in the journal cannot be reclaimed?

Maybe I misunderstand the "FROZEN" concept still.


> +{
> +	struct r5conf *conf =3D sh->raid_conf;
> +	struct r5l_log *log =3D conf->log;
> +
> +	if (!log)
> +		return;
> +	WARN_ON(test_bit(STRIPE_R5C_FROZEN, &sh->state));
> +	set_bit(STRIPE_R5C_FROZEN, &sh->state);
> +}
> +
> +static void r5c_finish_cache_stripe(struct stripe_head *sh)

A comment just before this function saying when it is called would help.
"Call when a stripe_head is safe in the journal, but has not yet been
written to the RAID" ??

> +{
> +	struct r5l_log *log =3D sh->raid_conf->log;
> +
> +	if (log->r5c_state =3D=3D R5C_STATE_WRITE_THROUGH) {
> +		BUG_ON(!test_bit(STRIPE_R5C_FROZEN, &sh->state));
> +		set_bit(STRIPE_R5C_WRITTEN, &sh->state);
> +	} else
> +		BUG(); /* write back logic in next patch */
> +}
> +
>  static void r5l_io_run_stripes(struct r5l_io_unit *io)
>  {
>  	struct stripe_head *sh, *next;
>=20=20
>  	list_for_each_entry_safe(sh, next, &io->stripe_list, log_list) {
>  		list_del_init(&sh->log_list);
> +
> +		r5c_finish_cache_stripe(sh);
> +
>  		set_bit(STRIPE_HANDLE, &sh->state);
>  		raid5_release_stripe(sh);
>  	}
> @@ -412,18 +493,19 @@ static int r5l_log_stripe(struct r5l_log *log, stru=
ct stripe_head *sh,
>  		r5l_append_payload_page(log, sh->dev[i].page);
>  	}
>=20=20
> -	if (sh->qd_idx >=3D 0) {
> +	if (parity_pages =3D=3D 2) {
>  		r5l_append_payload_meta(log, R5LOG_PAYLOAD_PARITY,
>  					sh->sector, sh->dev[sh->pd_idx].log_checksum,
>  					sh->dev[sh->qd_idx].log_checksum, true);
>  		r5l_append_payload_page(log, sh->dev[sh->pd_idx].page);
>  		r5l_append_payload_page(log, sh->dev[sh->qd_idx].page);
> -	} else {
> +	} else if (parity_pages =3D=3D 1) {
>  		r5l_append_payload_meta(log, R5LOG_PAYLOAD_PARITY,
>  					sh->sector, sh->dev[sh->pd_idx].log_checksum,
>  					0, false);
>  		r5l_append_payload_page(log, sh->dev[sh->pd_idx].page);
> -	}
> +	} else
> +		BUG_ON(parity_pages !=3D 0);


Why this change?  I don't think it is wrong, but I don't see why it
belongs here.  How does it help?


>=20=20
>  	list_add_tail(&sh->log_list, &io->stripe_list);
>  	atomic_inc(&io->pending_stripe);
> @@ -455,6 +537,8 @@ int r5l_write_stripe(struct r5l_log *log, struct stri=
pe_head *sh)
>  		return -EAGAIN;
>  	}
>=20=20
> +	WARN_ON(!test_bit(STRIPE_R5C_FROZEN, &sh->state));
> +
>  	for (i =3D 0; i < sh->disks; i++) {
>  		void *addr;
>=20=20
> @@ -1101,6 +1185,39 @@ static void r5l_write_super(struct r5l_log *log, s=
ector_t cp)
>  	set_bit(MD_CHANGE_DEVS, &mddev->flags);
>  }
>=20=20
> +int r5c_handle_stripe_dirtying(struct r5conf *conf,
> +			       struct stripe_head *sh,
> +			       struct stripe_head_state *s,
> +			       int disks)
> +{
> +	struct r5l_log *log =3D conf->log;
> +
> +	if (!log || test_bit(STRIPE_R5C_FROZEN, &sh->state))
> +		return -EAGAIN;
> +
> +	if (conf->log->r5c_state =3D=3D R5C_STATE_WRITE_THROUGH ||
> +	    conf->mddev->degraded !=3D 0) {

Why do you disable write-back when the array is degraded?

> +		/* write through mode */
> +		r5c_freeze_stripe_for_reclaim(sh);
> +		return -EAGAIN;
> +	}
> +	BUG();  /* write back logic in next commit */
> +	return 0;
> +}
> +
> +/*
> + * clean up the stripe (clear STRIPE_R5C_FROZEN etc.) after the stripe is
> + * committed to RAID disks
> +*/
> +void r5c_handle_stripe_written(struct r5conf *conf,
> +			       struct stripe_head *sh)
> +{
> +	if (!test_and_clear_bit(STRIPE_R5C_WRITTEN, &sh->state))
> +		return;
> +	WARN_ON(!test_bit(STRIPE_R5C_FROZEN, &sh->state));
> +	clear_bit(STRIPE_R5C_FROZEN, &sh->state);
> +}
> +
>  static int r5l_load_log(struct r5l_log *log)
>  {
>  	struct md_rdev *rdev =3D log->rdev;
> @@ -1236,6 +1353,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rde=
v *rdev)
>  	INIT_LIST_HEAD(&log->no_space_stripes);
>  	spin_lock_init(&log->no_space_stripes_lock);
>=20=20
> +	log->r5c_state =3D R5C_STATE_WRITE_THROUGH;
> +
>  	if (r5l_load_log(log))
>  		goto error;
>=20=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 67d4f49..2e3e61a 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3506,6 +3506,9 @@ static void handle_stripe_dirtying(struct r5conf *c=
onf,
>  	int rmw =3D 0, rcw =3D 0, i;
>  	sector_t recovery_cp =3D conf->mddev->recovery_cp;
>=20=20
> +	if (r5c_handle_stripe_dirtying(conf, sh, s, disks) =3D=3D 0)
> +		return;
> +
>  	/* Check whether resync is now happening or should start.
>  	 * If yes, then the array is dirty (after unclean shutdown or
>  	 * initial creation), so parity in some stripes might be inconsistent.
> @@ -4396,13 +4399,23 @@ static void handle_stripe(struct stripe_head *sh)
>  	    || s.expanding)
>  		handle_stripe_fill(sh, &s, disks);
>=20=20
> -	/* Now to consider new write requests and what else, if anything
> -	 * should be read.  We do not handle new writes when:
> +	/*
> +	 * When the stripe finishes full journal write cycle (write to journal
> +	 * and raid disk), this is the clean up procedure so it is ready for
> +	 * next operation.
> +	 */
> +	r5c_handle_stripe_written(conf, sh);
> +
> +	/*
> +	 * Now to consider new write requests, cache write back and what else,
> +	 * if anything should be read.  We do not handle new writes when:
>  	 * 1/ A 'write' operation (copy+xor) is already in flight.
>  	 * 2/ A 'check' operation is in flight, as it may clobber the parity
>  	 *    block.
> +	 * 3/ A r5c cache log write is in flight.
>  	 */
> -	if (s.to_write && !sh->reconstruct_state && !sh->check_state)
> +	if ((s.to_write || test_bit(STRIPE_R5C_FROZEN, &sh->state)) &&
> +	    !sh->reconstruct_state && !sh->check_state && !sh->log_io)
>  		handle_stripe_dirtying(conf, sh, &s, disks);

OK, I'm definitely confused now.
If the stripe is FROZEN, surely you don't want to call
handle_stripe_dirtying().


>=20=20
>  	/* maybe we need to check and possibly fix the parity for this stripe
> @@ -5122,6 +5135,7 @@ static void raid5_make_request(struct mddev *mddev,=
 struct bio * bi)
>  	 * data on failed drives.
>  	 */
>  	if (rw =3D=3D READ && mddev->degraded =3D=3D 0 &&
> +	    !r5c_is_writeback(conf->log) &&
>  	    mddev->reshape_position =3D=3D MaxSector) {
>  		bi =3D chunk_aligned_read(mddev, bi);
>  		if (!bi)
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 46cfe93..8bae64b 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -345,7 +345,9 @@ enum {
>  	STRIPE_BITMAP_PENDING,	/* Being added to bitmap, don't add
>  				 * to batch yet.
>  				 */
> -	STRIPE_LOG_TRAPPED, /* trapped into log */
> +	STRIPE_LOG_TRAPPED,	/* trapped into log */
> +	STRIPE_R5C_FROZEN,	/* r5c_cache frozen and being written out */
> +	STRIPE_R5C_WRITTEN,	/* ready for r5c_handle_stripe_written() */
>  };
>=20=20
>  #define STRIPE_EXPAND_SYNC_FLAGS \
> @@ -712,4 +714,10 @@ extern void r5l_stripe_write_finished(struct stripe_=
head *sh);
>  extern int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio=
);
>  extern void r5l_quiesce(struct r5l_log *log, int state);
>  extern bool r5l_log_disk_error(struct r5conf *conf);
> +extern bool r5c_is_writeback(struct r5l_log *log);
> +extern int
> +r5c_handle_stripe_dirtying(struct r5conf *conf, struct stripe_head *sh,
> +			   struct stripe_head_state *s, int disks);
> +extern void
> +r5c_handle_stripe_written(struct r5conf *conf, struct stripe_head *sh);
>  #endif
> --=20
> 2.9.3


Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYAHeIAAoJEDnsnt1WYoG5EUkP/3x5a3udwWWdVQICPwPGKMjj
wRn/5Fdc6ACLe6sNGyGmKjxodR2ZCm3Vdj4Wvxjk0hajqo+ot+D1ak1CwrmE1jnc
+dhTygjr7oWyVn7xqIZ4JP+Lqii4uL9LTsYaRzHJNzIZSxrLokh1YvHBzYydmI22
tpCkdbySLv3iL9pb38h3BzuFqzQUoTloM/c8YVtgYaRYBX2/s1HB1FbK0bQ74Iob
aWbZzzT3mukVGbOUEwY1hPLPioSXXvLV6QRs66/ToZgkgmViQHZC0YmLd61HzuIv
xZEa8iXu4Q1Q1VbKeZPcS0b2V3SwZMoaeQOCa+vIsABVbp9gTFBhcX3hcAf6Qa9d
RUYfwgZWu+EMVWPSYo16Usn6FNnvZ8eJYqYvTCyxaRwdyxBLQ/Tse/rHHG0To5as
4a170ub5kAlmEp3a5q9ZHK7/K38XC7KZAvfkxUUUR892TJ23zRnkmlaWn4lMdh7V
AAvsbiAf167cSlYz/XWJ+e+Eu/crZhBLqkU1t3z8nhEA4rzwSMjyhJMUnud9If6I
pD4K+iOrs2rfKk/1fnohB46gH5BoYUThqOYGcOL36HgwVJEbyeuJj2YihjIYcyLU
M2NvcERiY8bdD00vy3h9/cKzsXxG3uKkPTmNz4F77rftKcBoEC9GIfPlio7MPnGH
2cI+nW6THUYeHyPAlAxT
=v6zg
-----END PGP SIGNATURE-----
--=-=-=--
