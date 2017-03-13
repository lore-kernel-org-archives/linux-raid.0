From: zhilong <zlliu@suse.com>
Subject: Re: [PATCH 3/4] mdadm:triggers core dump when stat2devnm return NULL
Date: Mon, 13 Mar 2017 13:34:27 +0800
Message-ID: <a1ede0d1-5b84-7444-03fc-1550eb5068d3@suse.com>
References: <20170308074831.24683-1-zlliu@suse.com>
 <20170308075221.24965-1-zlliu@suse.com>
 <8760jef6d4.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8760jef6d4.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 03/13/2017 07:00 AM, NeilBrown wrote:
> On Wed, Mar 08 2017, Zhilong Liu wrote:
>
>> ensure that the device should be a block device when uses
>> --wait parameter, such as the 'f' and 'd' type file would
>> be triggered core dumped.
>> ./mdadm --wait /dev/md/, happened core dump.
>>
>> Signed-off-by: Zhilong Liu <zlliu@suse.com>
>>
>> diff --git a/Monitor.c b/Monitor.c
>> index 802a9d9..1900db3 100644
>> --- a/Monitor.c
>> +++ b/Monitor.c
>> @@ -1002,6 +1002,10 @@ int Wait(char *dev)
>>   			strerror(errno));
>>   		return 2;
>>   	}
>> +	if ((S_IFMT & stb.st_mode) != S_IFBLK) {
>> +		pr_err("%s is not a block device.\n", dev);
>> +		return 2;
>> +	}
>>   	strcpy(devnm, stat2devnm(&stb));
> Surely it would be cleaner to do something like:
>
>    tmp = stat2devnm(&stb);
>    if (!tmp) {
>        pr_err("%s is not a block device.\n", dev);
>        return 2;
>    }
>    strcpy(devnm, tmp);
>
> This makes it more obvious how you have fixed the crash.

Yes, this method is much better than I did. Great thanks for your 
improvement.

>>   
>>   	while(1) {
>> diff --git a/lib.c b/lib.c
>> index b640634..7116298 100644
>> --- a/lib.c
>> +++ b/lib.c
>> @@ -89,9 +89,6 @@ char *devid2kname(int devid)
>>   
>>   char *stat2kname(struct stat *st)
>>   {
>> -	if ((S_IFMT & st->st_mode) != S_IFBLK)
>> -		return NULL;
>> -
>>   	return devid2kname(st->st_rdev);
>>   }
> Why are you removing this test?  It has nothing to do with the other
> part of the patch.

Yes, I would remove this part in next revision.

Thanks,
-Zhilong

> NeilBrown

