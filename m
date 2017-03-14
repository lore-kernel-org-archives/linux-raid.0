From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH] md/r5cache: flush data in memory during journal device
 failure
Date: Tue, 14 Mar 2017 22:40:14 +0000
Message-ID: <5FFE3F62-D87A-46C5-B9D7-7A7501A32B90@fb.com>
References: <20170313233626.2109293-1-songliubraving@fb.com>
 <20170314175048.rjyaufwgaclsmhdz@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170314175048.rjyaufwgaclsmhdz@kernel.org>
Content-Language: en-US
Content-ID: <73656782F9F6AA469EAE597C08000F57@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, NeilBrown <neilb@suse.com>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>
List-Id: linux-raid.ids


> On Mar 14, 2017, at 10:50 AM, Shaohua Li <shli@kernel.org> wrote:
>=20
> On Mon, Mar 13, 2017 at 04:36:26PM -0700, Song Liu wrote:
>> For the raid456 with writeback cache, when journal device failed during
>> normal operation, it is still possible to persist all data, as all
>> pending data is still in stripe cache. However, the stripe will be
>> marked as fail with s.log_failed. Thus, the write out from stripe cache
>> cannot make progress.
>>=20
>> To unblock the write out in journal failures, this patch allows stripes
>> with data injournal to make progress.
>=20
> what about the parity part? if log failed, we should skip journaling the =
parity.
>=20
> Thanks,
> Shaohua
>=20

For stripes with data in journal (not flushed yet), the state machine=20
can flush them out. The behavior is just like when there are no journal=20
at all.=20

On the other hand, other writes will be gated by the log_failed flags,=20
so the array appears to be read-only to upper layers.=20

Thanks,
Song

>> The array should be read-only in journal failures. Therefore, pending
>> writes (in dev->towrite) are excluded in this write (in delay_towrite).
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> drivers/md/raid5.c | 10 +++++++++-
>> 1 file changed, 9 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 3233975..447d9dd 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -3069,6 +3069,10 @@ sector_t raid5_compute_blocknr(struct stripe_head=
 *sh, int i, int previous)
>>  *      When LOG_CRITICAL, stripes with injournal =3D=3D 0 will be sent =
to
>>  *      no_space_stripes list.
>>  *
>> + *   3. during journal failure
>> + *      In journal failure, we try to flush all cached data to raid dis=
ks
>> + *      based on data in stripe cache. The array is read-only to upper
>> + *      layers, so we would skip all pending writes.
>>  */
>> static inline bool delay_towrite(struct r5conf *conf,
>> 				 struct r5dev *dev,
>> @@ -3082,6 +3086,9 @@ static inline bool delay_towrite(struct r5conf *co=
nf,
>> 	if (test_bit(R5C_LOG_CRITICAL, &conf->cache_state) &&
>> 	    s->injournal > 0)
>> 		return true;
>> +	/* case 3 above */
>> +	if (s->log_failed && s->injournal)
>> +		return true;
>> 	return false;
>> }
>>=20
>> @@ -4721,7 +4728,8 @@ static void handle_stripe(struct stripe_head *sh)
>> 	/* check if the array has lost more than max_degraded devices and,
>> 	 * if so, some requests might need to be failed.
>> 	 */
>> -	if (s.failed > conf->max_degraded || s.log_failed) {
>> +	if (s.failed > conf->max_degraded ||
>> +	    (s.log_failed && s.injournal =3D=3D 0)) {
>> 		sh->check_state =3D 0;
>> 		sh->reconstruct_state =3D 0;
>> 		break_stripe_batch_list(sh, 0);
>> --=20
>> 2.9.3
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

