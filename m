From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH v3 3/9] md: superblock changes for PPL
Date: Wed, 8 Feb 2017 12:58:24 +0100
Message-ID: <1a070a30-0903-eb86-fa53-0c185ee2ddfd@intel.com>
References: <20170130185953.30428-1-artur.paszkiewicz@intel.com>
 <20170130185953.30428-4-artur.paszkiewicz@intel.com>
 <20170207212011.5aulcj3znldl6dry@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170207212011.5aulcj3znldl6dry@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com, jes.sorensen@gmail.com
List-Id: linux-raid.ids

On 02/07/2017 10:20 PM, Shaohua Li wrote:
> On Mon, Jan 30, 2017 at 07:59:47PM +0100, Artur Paszkiewicz wrote:
>> Include information about PPL location and size into mdp_superblock_1
>> and copy it to/from rdev. Because PPL is mutually exclusive with bitmap,
>> put it in place of 'bitmap_offset'. Add a new flag MD_FEATURE_PPL for
>> 'feature_map', analogically to MD_FEATURE_BITMAP_OFFSET. Add MD_HAS_PPL
>> to mddev->flags to indicate that PPL is enabled on an array.
>>
>> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
>> ---
>>  drivers/md/md.c                | 15 +++++++++++++++
>>  drivers/md/md.h                |  8 ++++++++
>>  drivers/md/raid0.c             |  3 ++-
>>  drivers/md/raid1.c             |  3 ++-
>>  include/uapi/linux/raid/md_p.h | 18 ++++++++++++++----
>>  5 files changed, 41 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 85ac98417a08..e96f73572e23 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -1566,6 +1566,12 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
>>  	} else if (sb->bblog_offset != 0)
>>  		rdev->badblocks.shift = 0;
>>  
>> +	if (le32_to_cpu(sb->feature_map) & MD_FEATURE_PPL) {
>> +		rdev->ppl.offset = (__s16)le16_to_cpu(sb->ppl.offset);
>> +		rdev->ppl.size = le16_to_cpu(sb->ppl.size);
>> +		rdev->ppl.sector = rdev->sb_start + rdev->ppl.offset;
>> +	}
>> +
>>  	if (!refdev) {
>>  		ret = 1;
>>  	} else {
>> @@ -1678,6 +1684,9 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
>>  
>>  		if (le32_to_cpu(sb->feature_map) & MD_FEATURE_JOURNAL)
>>  			set_bit(MD_HAS_JOURNAL, &mddev->flags);
>> +
>> +		if (le32_to_cpu(sb->feature_map) & MD_FEATURE_PPL)
>> +			set_bit(MD_HAS_PPL, &mddev->flags);
> 
> I think we should check wrong configuration and bail out. For example, both
> MD_FEATURE_PPL and MD_FEATURE_BITMAP_OFFSET set, or both MD_FEATURE_PPL and
> MD_FEATURE_JOURNAL set.

Makes sense. I will add it.

Thanks,
Artur
