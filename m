From: Alexander Afonyashin <a.afonyashin@madnet-team.ru>
Subject: Re: Fwd: Failed Raid6 Array.....want some guidance before attempting restart
Date: Mon, 21 Sep 2015 10:57:47 +0300
Message-ID: <CAETWcfuFzUO0aCX-YX_JYKH+iUDOAS6LJUrxu_TYT0g9x2Jqmg@mail.gmail.com>
References: <CAOS+5GGkLcN5RM7yq=D5NQ-DOBRf_+EwVsucoptfaiJPdU_nDQ@mail.gmail.com>
 <alpine.DEB.2.02.1509200731460.8750@uplift.swm.pp.se> <CAOS+5GEcpOV6dkkGYHjkA3ah88MXqyJ0AFS7T--qaCc-Z1-=uw@mail.gmail.com>
 <CAOS+5GHLFcbN=ROQ_YBLFYzw6iu+TZ4RcZvHdDbE+V3pqS_rCw@mail.gmail.com>
 <alpine.DEB.2.02.1509201153490.8750@uplift.swm.pp.se> <CAOS+5GHf1N6s9bsrveesuhm6cnxRVnb6XSjXoHoLVU7Np-i-Bw@mail.gmail.com>
 <CAOS+5GHtJAYdHEHnvb+Akfc+jkh5es8cb8z50YQwB23rnk+_Sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GHtJAYdHEHnvb+Akfc+jkh5es8cb8z50YQwB23rnk+_Sw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Another Sillyname <anothersname@googlemail.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

You may also try to increase rebuild rate by echo-ing min speed value:

echo 100000 > /sys/block/mdX/md/sync_speed_min

or via sysctl:

sysctl -w dev.raid.speed_limit_min=100000

Regards,
Alexander

On Mon, Sep 21, 2015 at 4:59 AM, Another Sillyname
<anothersname@googlemail.com> wrote:
> Ignore last...having thought about it for 10 minutes the obvious thing
> to do is to add the drives back and allow the array to rebuild
> offline......
>
> For the following reasons....
>
> 1.  e2fsck -f -n /dev/mdxx reports all the data appears intact and
> that was what I believed anyway based on the information available to
> me.
>
> 2.  To finish the backup will take 30+ hours, that's 30+ hours of risk
> time where a single drive failure will compromise the data set.
>
> 3.  To 'add' the missing drives back into the array and allow the
> rebuild will take about 10 hours (based on my previous experience
> building this array), therefore the lower 'risk' course of action is
> to rebuild the array, then and only then, to restart the backup.
> There's over 20 hours less risk doing it this way.
>
> I realise I could do the two concurrently but I'd rather keep the
> array 'destressed' as much as possible until I've got at least one
> level of resilience restored.
>
> Having now added the drives back in as 'spares' mdstat is telling me a
> little over 12 hours to do the rebuild so it's now finger crossing
> time time then.
>
> Thanks for the help and advice....and most of all the confirmation my
> approach was the correct one.
>
>
>
> On 21 September 2015 at 02:32, Another Sillyname
> <anothersname@googlemail.com> wrote:
>> OK
>>
>> The array has come back up...but showing two drives as missing.
>>
>> mdadm --query --detail /dev/md127/dev/md127:
>>         Version : 1.2
>>   Creation Time : Sun May 10 14:47:51 2015
>>      Raid Level : raid6
>>      Array Size : 29301952000 (27944.52 GiB 30005.20 GB)
>>   Used Dev Size : 5860390400 (5588.90 GiB 6001.04 GB)
>>    Raid Devices : 7
>>   Total Devices : 5
>>     Persistence : Superblock is persistent
>>
>>   Intent Bitmap : Internal
>>
>>     Update Time : Mon Sep 21 02:21:48 2015
>>           State : active, degraded
>>  Active Devices : 5
>> Working Devices : 5
>>  Failed Devices : 0
>>   Spare Devices : 0
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>            Name : arandomserver.arandomlan.com:1
>>            UUID : da29a06f:f8cf1409:bc52afb2:6945ba08
>>          Events : 285469
>>
>>     Number   Major   Minor   RaidDevice State
>>        0       8       97        0      active sync   /dev/sdg1
>>        1       8       49        1      active sync   /dev/sdd1
>>        2       8       65        2      active sync   /dev/sde1
>>        3       8       81        3      active sync   /dev/sdf1
>>        8       0        0        8      removed
>>       10       0        0       10      removed
>>        6       8      129        6      active sync   /dev/sdi1
>>
>> Data appears to be intact (haven't done a full analysis yet).
>>
>> Does this mean I should add the 'missing' drives back into the array
>> (one at a time obviously)!.
>>
>> Also doesn't this mean I'm horribly exposed to any writes now as this
>> would move the current 5+2 further out of 'sync' with each other thus
>> meaning any further short term fail could smash the data set totally.
>>
>> I'm minded to stop any writes to the array in the short term and
>> continue just doing the backup (this in itself will take about 30+
>> hours).
>>
>> Ideas and observations?
>>
>>
>>
>> On 20 September 2015 at 10:54, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
>>> On Sun, 20 Sep 2015, Another Sillyname wrote:
>>>
>>>> Thanks
>>>>
>>>> Would you.....
>>>>
>>>> mdadm --assemble --force --scan
>>>>
>>>> or
>>>>
>>>> mdadm --assemble --force /dev/mdxx /dev/sd[c-i]1
>>>
>>>
>>> This last one is what I use myself.
>>>
>>>
>>> --
>>> Mikael Abrahamsson    email: swmike@swm.pp.se
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
