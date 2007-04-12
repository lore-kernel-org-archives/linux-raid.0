From: Rich <rich@pcfusion.co.uk>
Subject: Re: LINEAR RAID, little help
Date: Thu, 12 Apr 2007 08:58:00 +0100
Message-ID: <461DE688.4070808@pcfusion.co.uk>
References: <46177DD8.9080707@pcfusion.co.uk>	<20070407173352.GA23645@gmail.com>	<4617E5E2.2090609@pcfusion.co.uk> <17948.6604.619118.556382@notabene.brown> <461DE4CA.9020406@pcfusion.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <461DE4CA.9020406@pcfusion.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Rich <rich@pcfusion.co.uk>
Cc: gmccullagh@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I forgot to ask something, sorry. With RAID0 and all the odd size drives 
I have I'd get a lot of left over unused space. Is there anyway to make 
use of this slack?

Thanks,

Rich

Rich wrote:
> Neil Brown wrote:
>> (This is maybe sort of off topic since this list about raid and not
>> filesystems and virtual such either.)
>>
>> Maybe you just want the appearance of things being as one volume? I
>> might recommend you looking into unionfs:
>>
>> http://www.filesystems.org/project-unionfs.html
>>
>> It's actually quite useful. You might have some logical division of the
>> data. Put TV stuff on one disk, Movies on another. The unionfs overlay
>> maps everything together into a virtual bigdisk. It's also very simple
>> and no superblocks or headers needed either.
> Thanks I shall take a look into it :)
>>
>> Linux raid0 works with varying sized drives without problem.   
> Ah, kewl.. I might do, depends how much drive space I loose. Speed 
> wise I don't find linear to bad I can read and write over gigabit 
> network at around 30mb/sec.
>>
>> If you lose one drive, you should consider that you have lost the
>> whole array.  You might be able to recover some data, if you are lucky
>> and spend a lot of time hunting for it.  But it is quite unlikely that
>> you will get much that is useful.
>>
>>   
> Ah right, well for the time being A lot of my friends have the same 
> data so loosing it is just inconvenient rather than a major no-go.
>>
>> The man page is out of date.  With reasonably recent kernel/mdadm you
>> can
>>   mdadm --grow /dev/mdX --add /dev/sdY
>>
>> To add a drive to a linear array.  You then need to grow the
>> filesystem of course.
>>
>> But yes:  A big linear array is good for scratch space, but I wouldn't
>> want to store data that I couldn't afford to lose.
>>
>> NeilBrown
>>   
> Cheers Neil, Once I can find enough hdd space else where to backup I 
> might play around with RAID0 etc I do plan to replace my odd size 
> drives with 500GB ones and RAID5 but I can't afford that at the moment.
>
>
> Thanks,
>
> Rich
>
>
>
>
>

