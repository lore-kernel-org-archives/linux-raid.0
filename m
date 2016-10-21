From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v5 7/8] md/r5cache: r5c recovery
Date: Fri, 21 Oct 2016 21:12:58 +0000
Message-ID: <3F2550E2-584B-495F-BD65-F25BC1C18BFC@fb.com>
References: <20161013054944.1038806-1-songliubraving@fb.com>
 <20161013054944.1038806-8-songliubraving@fb.com>
 <87vawnwwlq.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87vawnwwlq.fsf@notabene.neil.brown.name>
Content-Language: en-US
Content-ID: <CDB1B39EAA886844A1EEC61D913FB91C@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>, "liuzhengyuang521@gmail.com" <liuzhengyuang521@gmail.com>, "liuzhengyuan@kylinos.cn" <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids


> On Oct 19, 2016, at 8:03 PM, NeilBrown <neilb@suse.com> wrote:
>=20
> On Thu, Oct 13 2016, Song Liu wrote:
>=20
>> This is the recovery part of raid5-cache.
>>=20
>> With cache feature, there are 2 different scenarios of recovery:
>> 1. Data-Parity stripe: a stripe with complete parity in journal.
>> 2. Data-Only stripe: a stripe with only data in journal (or partial
>>   parity).
>>=20
>> The code differentiate Data-Parity stripe from Data-Only stripe with
>> flag (STRIPE_R5C_WRITTEN).
>>=20
>> For Data-Parity stripes, we use the same procedure as raid5 journal,
>> where all the data and parity are replayed to the RAID devices.
>>=20
>> For Data-Only strips, we need to finish complete calculate parity and
>> finish the full reconstruct write or RMW write. For simplicity, in
>> the recovery, we load the stripe to stripe cache. Once the array is
>> started, the stripe cache state machine will handle these stripes
>> through normal write path.
>>=20
>> r5c_recovery_flush_log contains the main procedure of recovery. The
>> recovery code first scans through the journal and loads data to
>> stripe cache. The code keeps tracks of all these stripes in a list
>> (use sh->lru and ctx->cached_list), stripes in the list are
>> organized in the order of its first appearance on the journal.
>> During the scan, the recovery code assesses each stripe as
>> Data-Parity or Data-Only.
>>=20
>> During scan, the array may run out of stripe cache. In these cases,
>> the recovery code will also call raid5_set_cache_size to increase
>> stripe cache size.
>>=20
>> At the end of scan, the recovery code replays all Data-Parity
>> stripes, and sets proper states for Data-Only stripes. The recovery
>> code also increases seq number by 10 and rewrites all Data-Only
>> stripes to journal. This is to avoid confusion after repeated
>> crashes. More details is explained in raid5-cache.c before
>> r5c_recovery_rewrite_data_only_stripes().
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>=20
>=20
> This patch seems to do a number of different things.
> I think it re-factors the journal reading code.
> It adds code to write a new "empty" journal metadata block
> and it adds support for recovery of cached data.
>=20
> All this together makes it hard to review.  I'd rather more smaller
> patches.
>=20

I will try to split the patch into meaningful smaller patches.=20
>=20
>> +	/* stripes only have parity are already flushed to RAID */
>> +	if (data_count =3D=3D 0)
>> +		goto out;
>=20
> Can you explain why that is?  When were they flushed to the RAID, and
> how was the parity determined?

It happens like this: say two stripes on journal: 100 and 200. The data (D)
and parity (P) pages are store in journal as:

      --->  D100   D200   P100  P200 ---->  newer data

Before we flush D100, journal_start points as D100. Then we flush D100,=20
and new journal_start points as D200. Now the system fails, so next=20
recovery starts from D200. Recovery code will find stripe 100 only has
parity. This means, stripe 100 is already flushed to raid. so we can ignore=
 it.=20

>=20
>> +/* returns 0 for match; 1 for mismtach */
>=20
> No, please don't do that.
> You can return an negative error if you like, and call it as
>   function_name() < 0
> or
>   function_name() =3D=3D 0
>=20
> or give the function a name that describes what it tests
> i.e.
>   r5l_data_checksum_is_correct()
> or
>   r5l_data_checksum_does_not_match()
>=20
> and then return 0 if the test fails and 1 if it succeeds.
>=20
>> +static int
>> +r5l_recovery_verify_data_checksum(struct r5l_log *log, struct page *pag=
e,
>> +				  sector_t log_offset, __le32 log_checksum)

I will fix this.=20

Thanks,
Song=
