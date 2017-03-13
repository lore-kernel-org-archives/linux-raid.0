From: zhilong <zlliu@suse.com>
Subject: Re: [PATCH 0/4] mdadm:checking level once mode has been set
Date: Mon, 13 Mar 2017 11:22:44 +0800
Message-ID: <65454fe3-6165-5d02-eecd-02f8aac8f422@suse.com>
References: <20170308074831.24683-1-zlliu@suse.com>
 <878toaf6me.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <878toaf6me.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 03/13/2017 06:54 AM, NeilBrown wrote:
> On Wed, Mar 08 2017, Zhilong Liu wrote:
>
>> mdadm: it would be better to check --level ealier,
>> because it would fall to different prompt if user
>> forgets to specify the --level. such as:
>> ./mdadm -CR /dev/md0 -b internal -n2 -x1 /dev/loop[0-2]
> When I run that command I get:
>
>    mdadm: a RAID level is needed to create an array.
>
>
> What do you get?

I'm sorry I have provided the wrong command, for this scenario,
issues "mdadm --build /dev/md0 -n2 /dev/loop[0-1]" should be
proper. it's the purpose to check --level earlier.

If this patch is useful, I would send the v1 patch for it, correct the
comments.

Thanks,
-Zhilong
> NeilBrown
>
>
>> Signed-off-by: Zhilong Liu <zlliu@suse.com>
>>
>> diff --git a/Create.c b/Create.c
>> index 9a951b0..beec29f 100644
>> --- a/Create.c
>> +++ b/Create.c
>> @@ -125,10 +125,6 @@ int Create(struct supertype *st, char *mddev,
>>   	memset(&info, 0, sizeof(info));
>>   	if (s->level == UnSet && st && st->ss->default_geometry)
>>   		st->ss->default_geometry(st, &s->level, NULL, NULL);
>> -	if (s->level == UnSet) {
>> -		pr_err("a RAID level is needed to create an array.\n");
>> -		return 1;
>> -	}
>>   	if (s->raiddisks < 4 && s->level == 6) {
>>   		pr_err("at least 4 raid-devices needed for level 6\n");
>>   		return 1;
>> diff --git a/mdadm.c b/mdadm.c
>> index 19a06db..ad24bdf 100644
>> --- a/mdadm.c
>> +++ b/mdadm.c
>> @@ -350,6 +350,12 @@ int main(int argc, char *argv[])
>>   				pr_err("Must give -a/--add for devices to add: %s\n", optarg);
>>   				exit(2);
>>   			}
>> +			if (devs_found > 0 && s.level == UnSet && !devmode) {
>> +				if (mode == CREATE || mode == BUILD) {
>> +					pr_err("a RAID level is needed to create or build an array.\n");
>> +					exit(2);
>> +				}
>> +			}
>>   			dv = xmalloc(sizeof(*dv));
>>   			dv->devname = optarg;
>>   			dv->disposition = devmode;
>> -- 
>> 2.10.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

