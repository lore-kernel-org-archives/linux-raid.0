From: Lidong Zhong <lzhong@suse.com>
Subject: Re: [PATCH] super1: fix sb->max_dev when adding a new disk in linear
 array
Date: Fri, 19 May 2017 13:31:15 +0800
Message-ID: <4b01d20c-be52-eaa1-6809-909fb375b274@suse.com>
References: <20170516045129.21815-1-lzhong@suse.com>
 <87pof5laxm.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87pof5laxm.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
Cc: colyli@suse.com, Jes.Sorensen@gmail.com
List-Id: linux-raid.ids



On 05/19/2017 12:36 PM, NeilBrown wrote:
> On Tue, May 16 2017, Lidong Zhong wrote:
>
>> The value of sb->max_dev will always be increased by 1 when adding
>> a new disk in linear array. It causes an inconsistence between each
>> disk in the array and the "Array State" value of "mdadm --examine DISK"
>> is wrong. For example, when adding the first new disk into linear array
>> it will be:
>>
>> Array State : RAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
>> ('A' == active, '.' == missing, 'R' == replacing)
>>
>> Adding the second disk into linear array it will be
>>
>> Array State : .AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
>> ('A' == active, '.' == missing, 'R' == replacing)
>>
>> Signed-off-by: Lidong Zhong <lzhong@suse.com>
>> ---
>>  super1.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/super1.c b/super1.c
>> index 87a74cb..3d49bee 100644
>> --- a/super1.c
>> +++ b/super1.c
>> @@ -1184,8 +1184,10 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
>>  				break;
>>  		sb->dev_number = __cpu_to_le32(i);
>>  		info->disk.number = i;
>> -		if (max >= __le32_to_cpu(sb->max_dev))
>> +		if (i >= __le32_to_cpu(sb->max_dev)) {
>
> This change is correct - thanks.  Though
>     if (i >= max) {
>
> might be clearer and simpler.
>
>
>>  			sb->max_dev = __cpu_to_le32(max+1);
>> +			sb->dev_roles[sb->max_dev] = __cpu_to_le16(MD_DISK_ROLE_SPARE);
>
> This change is wrong.
> At the very least, the dev_roles[] array needs to be indexed by a
> host-order number, not a little-endian number.
> But the change is not needed because dev_roles[max_dev] is never used.
> See role_from_sb().
> dev_rols[max_dev - 1] does need to be set, but the line
>
> 		sb->dev_roles[i] = __cpu_to_le16(info->disk.raid_disk);
>
> almost certainly does that.
Hi Neil,

The reason I set all the dev_roles[0~max_dev-1] is because
the following code

  552     printf("   Array State : ");
  553     for (d = 0; d < __le32_to_cpu(sb->raid_disks) + delta_extra; 
d++) {
  554         int cnt = 0;
  555         unsigned int i;
  556         for (i = 0; i < __le32_to_cpu(sb->max_dev); i++) {
  557             unsigned int role = __le16_to_cpu(sb->dev_roles[i]); 

  558             if (role == d) 

  559                 cnt++; 

  560         }


> It might be better to do
>   if (i >= max) {
>      while (max <= i) {
>         sb->dev_roles[max] = __cpu_to_le16(MD_DISK_ROLE_SPARE);
>         max += 1;
>      }
>      sb->max_dev = __cpu_to_le32(max);
>   }
>


Thanks for the advice.

>> +		}
>>
>>  		random_uuid(sb->device_uuid);
>>
>> @@ -1214,6 +1216,10 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
>>  		sb->raid_disks = __cpu_to_le32(info->array.raid_disks);
>>  		sb->dev_roles[info->disk.number] =
>>  			__cpu_to_le16(info->disk.raid_disk);
>> +		if (sb->raid_disks+1 >= __le32_to_cpu(sb->max_dev)) {
>> +			sb->max_dev = __cpu_to_le32(sb->raid_disks+1);
>> +			sb->dev_roles[sb->max_dev] = __cpu_to_le16(MD_DISK_ROLE_SPARE);
>
> Again, max_dev is little-endian, so cannot be used as an index.
> And I think you are updating the wrong element in the dev_roles array.

Yes, I didn't realized the valude is conversed to little-endian and the
index is wrong too. Thank you for pointing this out. I will submit
another version patch.

Thanks,
Lidong
>
> Thanks,
> NeilBrown
>
>
>> +		}
>>  	} else if (strcmp(update, "resync") == 0) {
>>  		/* make sure resync happens */
>>  		sb->resync_offset = 0ULL;
>> --
>> 2.12.0
