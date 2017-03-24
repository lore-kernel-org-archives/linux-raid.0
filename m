From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH v2 1/2] md/raid5: Add change_consistency_policy to raid4
 and raid6
Date: Fri, 24 Mar 2017 16:17:16 +0100
Message-ID: <8acaaf1e-7e67-2c9b-fc1f-7c9237131260@intel.com>
References: <20170316221409.3283344-1-songliubraving@fb.com>
 <20170324144535.chk4jgktism4mvlu@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170324144535.chk4jgktism4mvlu@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids

On 03/24/2017 03:45 PM, Shaohua Li wrote:
> On Thu, Mar 16, 2017 at 03:14:08PM -0700, Song Liu wrote:
>> Add change_consistency_policy to raid6_personality and
>> raid4_personality.
>>
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>>  drivers/md/raid5.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 88cc898..7a6e7ea 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -8408,6 +8408,7 @@ static struct md_personality raid6_personality =
>>  	.quiesce	= raid5_quiesce,
>>  	.takeover	= raid6_takeover,
>>  	.congested	= raid5_congested,
>> +	.change_consistency_policy = raid5_change_consistency_policy,
>>  };
>>  static struct md_personality raid5_personality =
>>  {
>> @@ -8456,6 +8457,7 @@ static struct md_personality raid4_personality =
>>  	.quiesce	= raid5_quiesce,
>>  	.takeover	= raid4_takeover,
>>  	.congested	= raid5_congested,
>> +	.change_consistency_policy = raid5_change_consistency_policy,
>>  };
> sorry for the late reply.
> 
> the change_consistency_policy is only for raid5 for a reason, ppl is only for
> raid5. I think you need to filter out raid 4/6 in
> raid5_change_consistency_policy for ppl.

Not necessarily. There is a check in ppl_init_log() that won't allow
starting ppl if it's not raid5. But it certainly wouldn't hurt.

Thanks,
Artur
