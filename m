From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH 2/2] md/r5cache: set journal mode according to log content
Date: Sun, 4 Dec 2016 20:11:04 +0000
Message-ID: <3C042EF3-9D5D-4CA9-BC9F-57DF51A84D91@fb.com>
References: <1480841097-21018-1-git-send-email-liuzhengyuan@kylinos.cn>
 <1480841097-21018-2-git-send-email-liuzhengyuan@kylinos.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1480841097-21018-2-git-send-email-liuzhengyuan@kylinos.cn>
Content-Language: en-US
Content-ID: <790BCA8BD7CE7044B1A12AC8AD1EBC91@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Cc: Shaohua Li <shli@fb.com>, JackieLiu <liuyun01@kylinos.cn>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I noticed this problem. This patch alone is not enough to fix it. I will se=
nd my patch=20
for this soon.=20

Thanks,
Song


> On Dec 4, 2016, at 12:44 AM, Zhengyuan Liu <liuzhengyuan@kylinos.cn> wrot=
e:
>=20
> Currently, we choice write-through mode as the default journal mode.
> If there is data-only stripes, we'd rewrite it and add it into raid5d
> release list. However, raid5d thread wouldn't put those stripes into
> cache(full/partial) list but inactive list instead since the journal
> mode is write-through. More futher, later read request would get data
> from raid disk directly instead of cache stripe, that's not we want too.
>=20
> Signed-off-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
> ---
> drivers/md/raid5-cache.c | 6 +++++-
> 1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 07bce0e..0473b33 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -2606,7 +2606,6 @@ int r5l_init_log(struct r5conf *conf, struct md_rde=
v *rdev)
>=20
> 	INIT_WORK(&log->deferred_io_work, r5l_submit_io_async);
>=20
> -	log->r5c_journal_mode =3D R5C_JOURNAL_MODE_WRITE_THROUGH;
> 	INIT_LIST_HEAD(&log->stripe_in_journal_list);
> 	spin_lock_init(&log->stripe_in_journal_lock);
> 	atomic_set(&log->stripe_in_journal_count, 0);
> @@ -2614,6 +2613,11 @@ int r5l_init_log(struct r5conf *conf, struct md_rd=
ev *rdev)
> 	if (r5l_load_log(log))
> 		goto error;
>=20
> +	if (log->last_checkpoint =3D=3D log->next_checkpoint)
> +		log->r5c_journal_mode =3D R5C_JOURNAL_MODE_WRITE_THROUGH;
> +	else
> +		log->r5c_journal_mode =3D R5C_JOURNAL_MODE_WRITE_BACK;
> +
> 	rcu_assign_pointer(conf->log, log);
> 	set_bit(MD_HAS_JOURNAL, &conf->mddev->flags);
> 	return 0;
> --=20
> 2.7.4
>=20
>=20
>=20

