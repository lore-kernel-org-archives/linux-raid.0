From: Veljko <veljko3@gmail.com>
Subject: Re: Linear device of two arrays
Date: Fri, 14 Jul 2017 15:40:40 +0200
Message-ID: <1eefd627-1aba-a795-05f0-d2106d3a62a3@gmail.com>
References: <CALee7hZYgLNO2siDJNtFge_BoocTXX-9BSgRHmMJH8MaH6V3LA@mail.gmail.com>
 <20170705214250.0ea99538@natsu> <595D2ADA.8010907@youngman.org.uk>
 <CALee7hZqmLK19tSEEFBgSWMKm9TRoUqLBCxUmbNJpwmM45BjTQ@mail.gmail.com>
 <df053262-9334-1070-c24a-5d2f91402716@hardwarefreak.org>
 <CALee7haowPD0DKPtEQUN8M8LDCNOq62SDrk5VNMO5C+5iUqtrQ@mail.gmail.com>
 <5afd5cea-06b8-8524-e4f5-8534f23bd714@hardwarefreak.org>
 <87van15j9b.fsf@notabene.neil.brown.name>
 <e394625b-18d7-d141-3957-3c16c9bc6e44@gmail.com>
 <87o9sn232n.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87o9sn232n.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/14/2017 03:57 AM, NeilBrown wrote:
>
> Presumably you also have an md3 raid10 which you want to attach to the
> end of md2?

Yes, I just created it. It's resyncing.


> md2 is 5761631232 sectors.
>   2880815616 kilobytes
>   2813296.5 (binary)megabytes.
>
> When you include that into a "linear" you will lose a few K from the
> end.
> It might be sensible to cause the "linear" to use whole stripes from
> the raid10, where a stripe is 1M (2 512K chunks).
> If you did that, you would lose a little over 1M.
> So backup the last 3.5 M of the raid10.  This is much more than you need.
>
> ie.
>
>   dd if=/dev/md2 of=SOMEWHERE/SAFE bs=1M skip=2813293

I'm little confused. What I'm backuping is last 3.5M of used space, 
right? How is that only ~2.7T? df shows 4.8T of used space.

Rest of the instructions are clear and I'll try it as soon as md3 is 
synced.

Thanks Neil!

> (dd treats 'M' as 1024*1024, MB is 1000*1000)
>
> If the file this creates is not 3.5M, then something went wrong.  Stop
> here.
>
> Just to be safe you might want to backup the first few megabytes.  You
> won't need this unless something goes wrong
>   dd if=/dev/md2 of=SOMEWHERE/ELSE bs=1M count=10
>
> Now create the linear from /dev/md2 and /dev/md3(?).  Be sure to use
> "-e 1.0 --data-offset=0".  This creates /dev/md4
>
> Now restore the first backup
>
>  dd if=SOMEWHERE/SAFE of=/dev/md4 bs=1M seek=2813293
>
> Be sure to use the same bs= and seek= as you did the first time.
> Be sure it is copying from the back and to the new linear raid.
>
> You should now be done. Check your xfs filesystem, and maybe even mount
> it and use it.
>
> NeilBrown
>
>>
>> # mdadm --detail /dev/md2
>> /dev/md2:
>>          Version : 1.2
>>    Creation Time : Fri Sep 14 12:40:13 2012
>>       Raid Level : raid10
>>       Array Size : 5761631232 (5494.72 GiB 5899.91 GB)
>>    Used Dev Size : 2880815616 (2747.36 GiB 2949.96 GB)
>>     Raid Devices : 4
>>    Total Devices : 4
>>      Persistence : Superblock is persistent
>>
>>      Update Time : Mon Jul 10 12:32:51 2017
>>            State : clean
>>   Active Devices : 4
>> Working Devices : 4
>>   Failed Devices : 0
>>    Spare Devices : 0
>>
>>           Layout : near=2
>>       Chunk Size : 512K
>>

