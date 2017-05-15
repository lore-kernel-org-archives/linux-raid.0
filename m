From: Lidong Zhong <lzhong@suse.com>
Subject: Re: [PATCH] super1: fix sb->max_dev when adding a new disk in linear
 array
Date: Mon, 15 May 2017 19:33:44 +0800
Message-ID: <72a92868-468c-039b-bd03-b1fbed1db82c@suse.com>
References: <20170512015145.18542-1-lzhong@suse.com>
 <66dcee83-e0d3-be5f-d8c4-f06b342afea8@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66dcee83-e0d3-be5f-d8c4-f06b342afea8@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-raid@vger.kernel.org, Jes.Sorensen@gmail.com
List-Id: linux-raid.ids



On 05/12/2017 03:53 PM, Coly Li wrote:
> On 2017/5/12 上午9:51, Lidong Zhong wrote:
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
>> Signed-off-by: Lidong Zhong<lzhong@suse.com>

Hi Coly,

Thanks for your reply.

> The above description does not very well explain why this fix is necessary.
>
> For linear device, there was a race condition and got fixed already.
> There are users encountered such bug in old kernel, when they trying to
> add a hard disk into a linear device. After the kernel panic caused by
> the race issue in old md linear code, they reboot from the fixed kernel,
> and find 'R' or '?' marks from Array State output.
>
> After analyze the metadata, we found value of
> sb->dev_roles[sb->max_dev-1] is 0, but which should be
> MD_DISK_ROLE_FAULTY. The reason for the error is, when adding a disk
> into linear device, mdadm first increases sb->max_dev value, but not set
> its role value. So the corresponding role value keeps as 0, which is
> same as No.0 disk's role value in the linear device.
>
> So mdadm -E will find there are 2 same role value for No.0 disk, and the
> first state character of Array State is marked as 'R'. If such a panic
> happened multiple times, there are more bogus zero value at tail of
> dev_roles[], so the character of Array State is marked as '?'.
>
> Now the kernel part is fixed, but mdadm part is not fixed yet. This
> patch is an effort to avoid bogus dev_roles[] value if kernel panic
> happens in follow ioctl system call (although the possibility is quite
> low and who can tel ...).

Not exactly the kernel panic we met in another bug triggers the error value
of sb->max_dev. You can reproduce this problem easily by adding a new
disk into a linear array. Here is the original logic:

The super block written  to the new added device is read from the last disk
of the linear array. And it does some changes including max_dev and 
dev_roles,

1259     } else if (strcmp(update, "linear-grow-new") == 0) {
1260         unsigned int i;
1261         int fd;
1262         unsigned int max = __le32_to_cpu(sb->max_dev);
1263
1264         for (i = 0; i < max; i++)
1265             if (__le16_to_cpu(sb->dev_roles[i]) >=
1266 MD_DISK_ROLE_FAULTY)
1267 break;
1268         sb->dev_number = __cpu_to_le32(i);
1269         info->disk.number = i;
1270         if (max >= __le32_to_cpu(sb->max_dev))
1271             sb->max_dev = __cpu_to_le32(max+1);

But because max always equals to __le32_to_cpu(sb->max_dev)) in line 
1270, the
value of sb->max_dev is always increased by 1 for the new added device 
and the
sb->dev_roles[ sb->max_dev] is not initialized to 0xfffe. While the 
sb->max_dev in
the original disks are not changed

1295     } else if (strcmp(update, "linear-grow-update") == 0) {
1296         sb->raid_disks = __cpu_to_le32(info->array.raid_disks);
1297         sb->dev_roles[info->disk.number] =
1298             __cpu_to_le16(info->disk.raid_disk);
>> ---
>>   super1.c | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/super1.c b/super1.c
>> index 87a74cb..4fb655f 100644
>> --- a/super1.c
>> +++ b/super1.c
>> @@ -1184,8 +1184,10 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
>>   				break;
>>   		sb->dev_number = __cpu_to_le32(i);
>>   		info->disk.number = i;
>> -		if (max >= __le32_to_cpu(sb->max_dev))
>> +		if (i >= __le32_to_cpu(sb->max_dev)) {
>>   			sb->max_dev = __cpu_to_le32(max+1);
>> +			sb->dev_roles[sb->max_dev] = __cpu_to_le16(MD_DISK_ROLE_FAULTY);
>> +		}
>>
>>   		random_uuid(sb->device_uuid);
> The above part makes sense to me.
>
>
>
>>
>> @@ -1214,6 +1216,10 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
>>   		sb->raid_disks = __cpu_to_le32(info->array.raid_disks);
>>   		sb->dev_roles[info->disk.number] =
>>   			__cpu_to_le16(info->disk.raid_disk);
>> +		if (sb->raid_disks+1 >= __le32_to_cpu(sb->max_dev)) {
>> +			sb->max_dev = __cpu_to_le32(sb->raid_disks+1);
>> +			sb->dev_roles[sb->max_dev] = __cpu_to_le16(MD_DISK_ROLE_FAULTY);
>> +		}
>>   	} else if (strcmp(update, "resync") == 0) {
>>   		/* make sure resync happens */
>>   		sb->resync_offset = 0ULL;
>>
> Just a lazy question, could you please explain a little bit why you also
> modify here ? Thanks.

I didn't see the sb->max_dev and dev_roles value are correctly set when 
the disks in array
are really more than sb->max_dev, both in kernel and userspace.

Thanks,
Lidong

> Coly
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message tomajordomo@vger.kernel.org
> More majordomo info athttp://vger.kernel.org/majordomo-info.html
>


