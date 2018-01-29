From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH mdadm] Subdevs can't be all missing when create raid
 device
Date: Mon, 29 Jan 2018 10:50:30 +0800
Message-ID: <cb22394d-c540-db5c-cdd7-83607d8e1093@redhat.com>
References: <1516956136-4803-1-git-send-email-xni@redhat.com>
 <86b0a965-0a6b-6490-1279-eee6246994f1@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <86b0a965-0a6b-6490-1279-eee6246994f1@gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 01/27/2018 02:51 AM, Jes Sorensen wrote:
> On 01/26/2018 03:42 AM, Xiao Ni wrote:
>> Signed-off-by: Xiao Ni <xni@redhat.com>
>> ---
>>   Create.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/Create.c b/Create.c
>> index 239545f..50142d8 100644
>> --- a/Create.c
>> +++ b/Create.c
>> @@ -475,6 +475,10 @@ int Create(struct supertype *st, char *mddev,
>>   			close(fd);
>>   		}
>>   	}
>> +	if (missing_disks == dnum) {
>> +		pr_err("Subdevs can't be all missing\n");
>> +		return 1;
>> +	}
>>   	if (s->raiddisks + s->sparedisks > st->max_devs) {
>>   		pr_err("Too many devices: %s metadata only supports %d\n",
>>   			st->ss->name, st->max_devs);
>>
> Applied!
>
> Thanks,
> Jes
>
> PS: This looks like a great candidate for a unit test :)
Hi Jes

I'll add this to test suite later.

Regards
Xiao
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

