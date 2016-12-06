From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH v2 6/7] Allow changing the RWH policy for a running array
Date: Tue, 06 Dec 2016 09:30:22 -0500
Message-ID: <wrfj1sxl870h.fsf@redhat.com>
References: <20161205153204.7343-1-artur.paszkiewicz@intel.com>
        <20161205153204.7343-7-artur.paszkiewicz@intel.com>
        <wrfjd1h69hbn.fsf@redhat.com>
        <5c74d40c-36c4-97ae-9a67-be533d6abfb1@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5c74d40c-36c4-97ae-9a67-be533d6abfb1@intel.com> (Artur
        Paszkiewicz's message of "Tue, 6 Dec 2016 08:43:40 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Artur Paszkiewicz <artur.paszkiewicz@intel.com> writes:
> On 12/05/2016 10:50 PM, Jes Sorensen wrote:
>> Artur Paszkiewicz <artur.paszkiewicz@intel.com> writes:
>>> This extends the --rwh-policy parameter to work also in Misc mode. Using
>>> it changes the currently active RWH policy in the kernel driver and
>>> updates the metadata to make this change permanent. Updating metadata is
>>> not yet implemented for super1, so this is limited to IMSM for now.
>>>
>>> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
>> 
>> Hi Artur,
>> 
>> It looked good all the way up until 6/7, but there is a nit here:
>> 
>>> ---
>>>  Manage.c | 79
>>> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>  mdadm.c       |  9 +++++++
>>>  mdadm.h       |  1 +
>>>  super-intel.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++-
>>>  4 files changed, 153 insertions(+), 1 deletion(-)
>> [snip]
>>> diff --git a/super-intel.c b/super-intel.c
>>> index e524ef0..3b40429 100644
>>> --- a/super-intel.c
>>> +++ b/super-intel.c
>>> @@ -448,6 +448,7 @@ enum imsm_update_type {
>>>  	update_general_migration_checkpoint,
>>>  	update_size_change,
>>>  	update_prealloc_badblocks_mem,
>>> +	update_rwh_policy,
>>>  };
>>>  
>>>  struct imsm_update_activate_spare {
>>> @@ -540,6 +541,12 @@ struct imsm_update_prealloc_bb_mem {
>>>  	enum imsm_update_type type;
>>>  };
>>>  
>>> +struct imsm_update_rwh_policy {
>>> +	enum imsm_update_type type;
>>> +	int new_policy;
>>> +	int dev_idx;
>>> +};
>>> +
>>>  static const char *_sys_dev_type[] = {
>>>  	[SYS_DEV_UNKNOWN] = "Unknown",
>>>  	[SYS_DEV_SAS] = "SAS",
>>> @@ -3175,7 +3182,6 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
>>>  	info->custom_array_size   <<= 32;
>>>  	info->custom_array_size   |= __le32_to_cpu(dev->size_low);
>>>  	info->recovery_blocked = imsm_reshape_blocks_arrays_changes(st->sb);
>>> -	info->journal_clean = dev->rwh_policy;
>>>  
>>>  	if (is_gen_migration(dev)) {
>>>  		info->reshape_active = 1;
>>> @@ -3347,6 +3353,8 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
>>>  			info->rwh_policy = RWH_POLICY_PPL;
>>>  		else
>>>  			info->rwh_policy = RWH_POLICY_UNKNOWN;
>>> +
>>> +		info->journal_clean = info->rwh_policy == RWH_POLICY_PPL;
>>>  	}
>>>  }
>> 
>> This part doesn't make sense, first you set info->rwh_policy based on
>> sb->feature_map to RWH_POLICY_PPL or RWH_POLICY_UNKNOWN and then right
>> after you hard set it to RWH_POLICY_PPL.
>> 
>> In general I really would prefer not to see any of those double
>> assignments if it can be avoided.
>
> This isn't a double assignment, there is a '==' there. I'm setting
> info->journal_clean to true only if the policy is PPL. I'm not sure how
> this change ended up in this patch, it was supposed to go to 5/7. I must
> have overlooked it.

Argh you're right, code obfuscation at it's finest - if this is meant to
be in 5/7 do you want to respin the two?

In addition why not put the info->journal_clean assignments up together
with the info->rhw_policy assignments? Would make it a lot easier to
read without making my mistake :)

cheers,
Jes
