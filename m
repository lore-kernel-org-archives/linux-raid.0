From: Lidong Zhong <lzhong@suse.com>
Subject: Re: [PATCH v4] super1: fix sb->max_dev when adding a new disk in
 linear array
Date: Tue, 23 May 2017 11:55:28 +0800
Message-ID: <20e71aa6-e9e0-312f-747a-d25b872d2af8@suse.com>
References: <20170522061612.29410-1-lzhong@suse.com>
 <87d1b1jgju.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d1b1jgju.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
Cc: colyli@suse.com, Jes.Sorensen@gmail.com
List-Id: linux-raid.ids



On 05/22/2017 07:07 PM, NeilBrown wrote:
> On Mon, May 22 2017, Lidong Zhong wrote:
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
>>  super1.c | 9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/super1.c b/super1.c
>> index 2fcb814..03cea72 100644
>> --- a/super1.c
>> +++ b/super1.c
>> @@ -1267,8 +1267,10 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
>>  				break;
>>  		sb->dev_number = __cpu_to_le32(i);
>>  		info->disk.number = i;
>> -		if (max >= __le32_to_cpu(sb->max_dev))
>> +		if (i >= max) {
>> +			sb->dev_roles[max] = __cpu_to_le16(MD_DISK_ROLE_SPARE);
>

Hi Neil,

> Why do you assign to dev_roles[max]?

I meant to assure there will always be a spare spot in dev_roles[],
that is sb->max_dev at least is at lease 1 more than raid_disks.
Now I see what you mean in your reply to my last version patch.

> max must equal i here, and a few lines later:
> 		sb->dev_roles[i] = __cpu_to_le16(info->disk.raid_disk);
>
> your assignment is over-written.  So it is pointless.
> If i was greater than max (which should be impossible), you assignment
> here would corrupt the dev_roles table.
>
> Please drop this assignment.

Yes, just increase the max_dev value is enough.

>
>>  			sb->max_dev = __cpu_to_le32(max+1);
>> +		}
>>
>>  		random_uuid(sb->device_uuid);
>>
>> @@ -1293,9 +1295,14 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
>>  			}
>>  		}
>>  	} else if (strcmp(update, "linear-grow-update") == 0) {
>> +		unsigned int max = __le32_to_cpu(sb->max_dev);
>>  		sb->raid_disks = __cpu_to_le32(info->array.raid_disks);
>>  		sb->dev_roles[info->disk.number] =
>>  			__cpu_to_le16(info->disk.raid_disk);
>> +		if (info->array.raid_disks >= max) {
>
> if raid_disks == max there is no need to change anything.
> It is only when raid_disks > max that you need to increase max.
>

Yes, the max_dev should only be updated when raid_disks > max.

>> +			sb->dev_roles[max] = __cpu_to_le16(MD_DISK_ROLE_SPARE);
>
> When you increase max, you do need to assign MD_DISK_ROLE_SPARE to the
> new element, but you need to do that *before* disk.raid_disk is
> assigned, in case info->disk.number == max (as it could be for the
> recently added device).
>
I think it's also pointless to assign MD_DISK_ROLE_SPARE
since there is no SPARE in dev_roles when we need to update
sb->max_dev. The newly added device will not meet the condition
as max_dev has already been updated, that's saying, we only
need to update the max_dev value for original disks.
The following code should work

1297     } else if (strcmp(update, "linear-grow-update") == 0) {
1298         unsigned int max = __le32_to_cpu(sb->max_dev);
1299         sb->raid_disks = __cpu_to_le32(info->array.raid_disks);
1300         sb->dev_roles[info->disk.number] =
1301             __cpu_to_le16(info->disk.raid_disk);
1302         if (info->array.raid_disks > max) { 
 

1303             sb->max_dev = __cpu_to_le32(max+1);
1304         }

Thank you for your patient review.

Lidong

> NeilBrown
>
>
>> +			sb->max_dev = __cpu_to_le32(max+1);
>> +		}
>>  	} else if (strcmp(update, "resync") == 0) {
>>  		/* make sure resync happens */
>>  		sb->resync_offset = 0ULL;
>> --
>> 2.12.0
