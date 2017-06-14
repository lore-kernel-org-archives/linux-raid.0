From: Lidong Zhong <lzhong@suse.com>
Subject: Re: [PATCH] md: change the initialization value for a spare device
 spot to MD_DISK_ROLE_SPARE
Date: Wed, 14 Jun 2017 11:16:43 +0800
Message-ID: <6e1c6747-f063-a99e-8358-9b994e2e8be2@suse.com>
References: <20170612024555.1120-1-lzhong@suse.com>
 <20170613171708.roims6ja6vtuwwlo@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170613171708.roims6ja6vtuwwlo@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 06/14/2017 01:17 AM, Shaohua Li wrote:
> On Mon, Jun 12, 2017 at 10:45:55AM +0800, Lidong Zhong wrote:
>> The value for spare spot of sb->dev_roles is changed from
>> MD_DISK_ROLE_FAULTY to MD_DISK_ROLE_SPARE to keep align
>> with the value when the superblock is firstly created in
>> userspace.
>
> Could you point out where mdadm does this?
>
Hi Shaohua,

It's done in init_super1() during initialization.
1615memset(sb->dev_roles,0xff, 
 

1616            MAX_SB_SIZE - sizeof(struct mdp_superblock_1));

> I'm wondering what's the impact here. If there is a disk, we will set correct
> role at the end of super_1_sync(), otherwise faulty sounds more reasonable.
>

Actually there is no impact if it works fine. I found the value for
spare slot in sb->dev_roles is changed while debugging a problem.
That's the reason I submit this patch.

Thanks,
Lidong

> Jes,
> Could you help check this?
>
> Thanks,
> Shaohua
>
>> Signed-off-by: Lidong Zhong <lzhong@suse.com>
>> ---
>>  drivers/md/md.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 87edc342ccb3..a9aacedefbca 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -1852,7 +1852,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
>>  		max_dev = le32_to_cpu(sb->max_dev);
>>
>>  	for (i=0; i<max_dev;i++)
>> -		sb->dev_roles[i] = cpu_to_le16(MD_DISK_ROLE_FAULTY);
>> +		sb->dev_roles[i] = cpu_to_le16(MD_DISK_ROLE_SPARE);
>>
>>  	if (test_bit(MD_HAS_JOURNAL, &mddev->flags))
>>  		sb->feature_map |= cpu_to_le32(MD_FEATURE_JOURNAL);
>> --
>> 2.12.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
