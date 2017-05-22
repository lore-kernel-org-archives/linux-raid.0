From: Lidong Zhong <lzhong@suse.com>
Subject: Re: [PATCH v3] super1: fix sb->max_dev when adding a new disk in
 linear array
Date: Mon, 22 May 2017 11:28:25 +0800
Message-ID: <86430c3a-73ed-4c9b-3386-c76b0ee82e82@suse.com>
References: <20170519060638.4470-1-lzhong@suse.com>
 <87lgppkcrn.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87lgppkcrn.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
Cc: colyli@suse.com, Jes.Sorensen@gmail.com
List-Id: linux-raid.ids



On 05/22/2017 07:31 AM, NeilBrown wrote:
> On Fri, May 19 2017, Lidong Zhong wrote:
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
>>  super1.c | 13 +++++++++++--
>>  1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/super1.c b/super1.c
>> index 2fcb814..811923f 100644
>> --- a/super1.c
>> +++ b/super1.c
>> @@ -1267,8 +1267,13 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
>>  				break;
>>  		sb->dev_number = __cpu_to_le32(i);
>>  		info->disk.number = i;
>> -		if (max >= __le32_to_cpu(sb->max_dev))
>> -			sb->max_dev = __cpu_to_le32(max+1);
>> +		if (i >= max) {
>> +			while (max <= i) {
>> +				sb->dev_roles[max] = __cpu_to_le16(MD_DISK_ROLE_SPARE);
>> +				max += 1;
>> +			}
>> +			sb->max_dev = __cpu_to_le32(max);
>> +		}
>
> This part of the patch is OK....
>
>>
>>  		random_uuid(sb->device_uuid);
>>
>> @@ -1296,6 +1301,10 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
>>  		sb->raid_disks = __cpu_to_le32(info->array.raid_disks);
>>  		sb->dev_roles[info->disk.number] =
>>  			__cpu_to_le16(info->disk.raid_disk);
>> +		if (sb->raid_disks+1 >= __le32_to_cpu(sb->max_dev)) {
>
> sb->raid_disks is an le32 number, not a cpu number.  So adding 1 to
> it is clearly wrong.
>

Really sorry for the careless...I mean info->array.raid_disks here.

> Why do you think you need a change here at all?
>

The first part of this patch is dealing with the newly added disk
when the disk number is greater than sb->max_dev.
While updating the superblock on the original disks of the linear
array, shouldn't I also check if the disk numbers is greater
than sb->max_dev?


  254         info.array.raid_disks = nd+1;
  255         info.array.nr_disks = nd+1;
  256         info.array.active_disks = nd+1;
  257         info.array.working_disks = nd+1;
  258
  259         st->ss->update_super(st, &info, "linear-grow-update", dv,
  260                      0, 0, NULL);
  261
  262         if (st->ss->store_super(st, fd2)) {
  263             pr_err("Cannot store new superblock on %s\n", dv);
  264             close(fd2);
  265             return 1;
  266         }


Thanks,
Lidong
> NeilBrown
>
>
>> +			sb->dev_roles[sb->raid_disks] = __cpu_to_le16(MD_DISK_ROLE_SPARE);
>> +			sb->max_dev = __cpu_to_le32(sb->raid_disks+1);
>> +		}
>>  	} else if (strcmp(update, "resync") == 0) {
>>  		/* make sure resync happens */
>>  		sb->resync_offset = 0ULL;
>> --
>> 2.12.0
