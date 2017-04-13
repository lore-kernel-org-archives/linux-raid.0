From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: disk initialize priority
Date: Thu, 13 Apr 2017 12:05:03 +0200
Message-ID: <3f487a90-36ff-a319-977c-62d18ae65589@thelounge.net>
References: <CAC6SzHJAM-AbCiK7rqhgk4CJcyZ4C-yW0kt_rr3hgk+F-WMCiQ@mail.gmail.com>
 <43e44c4b-37d6-9734-b323-5b432ef27d52@thelounge.net>
 <CAC6SzHKWeLMSn1Z3W0KyBaUw+5MLmnMxLbh130gxM071t8VeFw@mail.gmail.com>
 <fc31c172-f988-32a4-c9b2-93bc7f3bfc90@thelounge.net>
 <CAC6SzHKhn5j6f8DOcebFT2H5zRgnBbpJsnsncQocWRVS7DLWXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC6SzHKhn5j6f8DOcebFT2H5zRgnBbpJsnsncQocWRVS7DLWXg@mail.gmail.com>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: d tbsky <tbskyd@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 13.04.2017 um 11:58 schrieb d tbsky:
> 2017-04-13 17:47 GMT+08:00 Reindl Harald <h.reindl@thelounge.net>:
>>
>>
>> Am 13.04.2017 um 11:44 schrieb d tbsky:
>>>
>>> 2017-04-13 17:09 GMT+08:00 Reindl Harald <h.reindl@thelounge.net>:
>>>>
>>>>
>>>>
>>>> Am 13.04.2017 um 10:13 schrieb d tbsky:
>>>>>
>>>>>
>>>>> Hi:
>>>>>         I just tried to install rhel 7.3 on a 4 disk raid6. it's a
>>>>> minimal install but took 3 hours to finish. I found the disk
>>>>> initialize speed is around 150MB/sec. in past the disk initialize
>>>>> speed will down to slow speed when there are other disk IO, but it
>>>>> seems not the case in rhel 7.3.
>>>>>
>>>>>        I have check the below parameter:
>>>>>        cat /proc/sys/dev/raid/speed_limit_min  -> 1000
>>>>>        cat /proc/sys/dev/raid/speed_limit_max -> 200000
>>>>>
>>>>>        when the system is idle, the init speed is also about 150M/sec, so
>>>>> the system is use all the power to init when there are other disk IO.
>>>>>
>>>>>         is it normal? where should I check?
>>>>
>>>>
>>>>
>>>> sysctl.conf:
>>>> dev.raid.speed_limit_min = 10000
>>>> dev.raid.speed_limit_max = 50000
>>>>
>>>> sysctl -p
>>>>
>>>> and it will adjust itself within seconds - the same works if that values
>>>> are
>>>> too low and raid-check would take forever
>>>
>>>
>>> hi: my problem is the speed is too high, not too low...
>>
>> and?
>>
>> you said it is at 200000
>> i showed you how to reduce it to 50000 or whatever you want
> 
> hi:
> sorry I didn't understand you correctly. thanks for the hint. I
> will try to resolve the root cause of the problem

the root cause is a default which is too large for your disks wqhile on 
the other hand if someone has a RAID10 with SSD disks it's even too low 
and you should just configure that for your needs and workload

it's not only about how fast are your disks, it's also about your 
workload, there are times where i set it to 500000 to get the weekly 
raid-scrub as fast as possible when i don't heavily use the machine and 
on other days i slow it down dramatically because i need performance and 
don't care when the background task is finished

it's also a difference between RAID1 or RAID10 when concurrency reads 
can be served by the other disk and the impact is not so big than on a RAID1
