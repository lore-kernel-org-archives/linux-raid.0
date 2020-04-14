From: Zhong Lidong <lidong.zhong@suse.com>
Subject: Re: [PATCH] Detail: adding sync status for cluster device
Date: Tue, 14 Apr 2020 16:03:16 +0800
Message-ID: <5c7b0055-917c-87ee-237f-1deaeb6fc575@suse.com>
References: <20200413144128.26177-1-lidong.zhong@suse.com>
 <bcd5713f-d2e8-d358-17c9-323f9c125d1b@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bcd5713f-d2e8-d358-17c9-323f9c125d1b@cloud.ionos.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, jes@trained-monkey.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 4/14/20 3:25 PM, Guoqing Jiang wrote:
> On 13.04.20 16:41, Lidong Zhong wrote:
>> On the node with /proc/mdstat is
>>
>> Personalities : [raid1]
>> md0 : active raid1 sdb[4] sdc[3] sdd[2]
>>        1046528 blocks super 1.2 [3/2] [UU_]
>>          recover=REMOTE
>>        bitmap: 1/1 pages [4KB], 65536KB chunk
>>
>> the 'State' of 'mdadm -Q -D' is accordingly
> 
> Maybe rephrase it a little bit, something like.
> 
> "Let's change the 'State' of 'mdadm -Q -D' accordingly "
> 
> Just FYI .
> 

Thank you for your suggestion, Guoqing. I'll send the
patch again.

Regards,
Lidong
>> State : clean, degraded
>> With this patch, it will be
>> State : clean, degraded, recovering (REMOTE)
>>
>> Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
>> ---
>>   Detail.c | 9 ++++++---
>>   mdadm.h  | 3 ++-
>>   mdstat.c | 2 ++
>>   3 files changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/Detail.c b/Detail.c
>> index 832485f..03d5e04 100644
>> --- a/Detail.c
>> +++ b/Detail.c
>> @@ -496,17 +496,20 @@ int Detail(char *dev, struct context *c)
>>               } else
>>                   arrayst = "active";
>>   -            printf("             State : %s%s%s%s%s%s \n",
>> +            printf("             State : %s%s%s%s%s%s%s \n",
>>                      arrayst, st,
>>                      (!e || (e->percent < 0 &&
>>                          e->percent != RESYNC_PENDING &&
>> -                       e->percent != RESYNC_DELAYED)) ?
>> +                       e->percent != RESYNC_DELAYED &&
>> +                       e->percent != RESYNC_REMOTE)) ?
>>                      "" : sync_action[e->resync],
>>                      larray_size ? "": ", Not Started",
>>                      (e && e->percent == RESYNC_DELAYED) ?
>>                      " (DELAYED)": "",
>>                      (e && e->percent == RESYNC_PENDING) ?
>> -                   " (PENDING)": "");
>> +                   " (PENDING)": "",
>> +                   (e && e->percent == RESYNC_REMOTE) ?
>> +                   " (REMOTE)": "");
>>           } else if (inactive && !is_container) {
>>               printf("             State : inactive\n");
>>           }
>> diff --git a/mdadm.h b/mdadm.h
>> index d94569f..399478b 100644
>> --- a/mdadm.h
>> +++ b/mdadm.h
>> @@ -1815,7 +1815,8 @@ enum r0layout {
>>   #define RESYNC_NONE -1
>>   #define RESYNC_DELAYED -2
>>   #define RESYNC_PENDING -3
>> -#define RESYNC_UNKNOWN -4
>> +#define RESYNC_REMOTE  -4
>> +#define RESYNC_UNKNOWN -5
>>     /* When using "GET_DISK_INFO" it isn't certain how high
>>    * we need to check.  So we impose an absolute limit of
>> diff --git a/mdstat.c b/mdstat.c
>> index 7e600d0..20577a3 100644
>> --- a/mdstat.c
>> +++ b/mdstat.c
>> @@ -257,6 +257,8 @@ struct mdstat_ent *mdstat_read(int hold, int start)
>>                       ent->percent = RESYNC_DELAYED;
>>                   if (l > 8 && strcmp(w+l-8, "=PENDING") == 0)
>>                       ent->percent = RESYNC_PENDING;
>> +                if (l > 7 && strcmp(w+l-7, "=REMOTE") == 0)
>> +                    ent->percent = RESYNC_REMOTE;
>>               } else if (ent->percent == RESYNC_NONE &&
>>                      w[0] >= '0' &&
>>                      w[0] <= '9' &&
> 
> Acked-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> 
> Thanks,
> Guoqing
