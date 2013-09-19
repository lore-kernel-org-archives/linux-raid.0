From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: Best configuration for bcache/md cache or other cache using ssd
Date: Thu, 19 Sep 2013 13:23:03 -0300
Message-ID: <CAH3kUhF26nE7cro_Kkod6uZzLeEkhLtpDpbtF3ts2_F9hb4bYQ@mail.gmail.com>
References: <CAH3kUhHrK-TKJD1s_7SvtOz=YnpO82EvMGPv0X8rVAaDcuTO0Q@mail.gmail.com>
	<CACJz6QtVzR1bED939ZkesyXMWjv-2DmxZSrGH_enKX5dCuNEJw@mail.gmail.com>
	<CAH3kUhHin5PfjDCNFjD8eypNML=0YrkQp14DrCADc2StcODdaw@mail.gmail.com>
	<CAH3kUhFf11O8a-y5W40ogrKu_XsjGfmi6R4YUmxbYw-McrEvyA@mail.gmail.com>
	<CACJz6QtDt-5mgtpHr092AyFOxoSoY+V7F8QbiUcDuD5JN7TsMA@mail.gmail.com>
	<CAH3kUhGNeXbmR+2zk+3KCDSaBfsjLuZQA89tG_C776emw0nSSQ@mail.gmail.com>
	<523A60DF.5040702@hardwarefreak.com>
	<CAH3kUhFaXEwR8ym8Vvf3yEODLf6mXOWnCQbk4qgLk7bnaepV3g@mail.gmail.com>
	<523AAC1F.6050006@hardwarefreak.com>
	<CAH3kUhG8cKsuG=-aJOuzJOV+5fe46E+QdCMczxghuL-MbWK95Q@mail.gmail.com>
	<523B1D1C.2070807@mpstor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <523B1D1C.2070807@mpstor.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin ESTRABAUD <be@mpstor.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, Drew <drew.kay@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Ben! thanks a lot too, here in Brazil i don't have many options,
adaptec, lsi, dell are easy to find and buy, others brands i need to
search more and some times import, but no problem, since i have some
time to select and buy the equips

about bbu, yes what i found is the battery backed unit too, now i
understand... the raid board consume less power than the linux machine
and can wait more time (72h) to end writes with power loss than a ups
(~1h or more depends on how much money you expend on ups and baterry
here)

well thanks about informations
about the diagnostics... what i should look? smart information and
iostat are something that i use here, there's any problem with a raid
card in the middle? i have two cases that i can't access smart info,
but others raid cards can, does these cards support diagnostics?

2013/9/19 Benjamin ESTRABAUD <be@mpstor.com>:
> On 19/09/13 16:30, Roberto Spadim wrote:
>>
>> Hi Stan!
>
> Hi Roberto,
>
> Just a few things:
>
>> thanks a lot about your experience
>> I have some doubts about raid boards, what you look when you buy one?
>> i bought some raid boards (most perc from dell, others adaptec and
>> others lsi) and don't know if it's really a good feature... check if
>> i'm wrong about things i most look before buying one:
>> 1) Smart or other tool to diagnostics and access drives diagnostics
>> 2) Cache memory (if i have 512mb here, i could replace with 512mb or
>> more at linux side? instead of cache at raid board, why not add cache
>> to linux kernel?)
>
> You could, but your Linux box is unlikely battery backed. The advantage of
> these card's memory is that in the event of a power failure, the contents of
> memory is kept and flushed later on. This is especially important because
> here we are talking about "fast" writes: the RAID card tells the IO
> requester that the IO has been flushed even though it hasn't (at least not
> on the drive). If this was a Linux box and you lacked battery backing, the
> client would assume some data was written while it was actually lost,
> causing silent failure (the worst kind of it).
>
>> 3) batery backup, how this really work? what kind of raid board really
>> work nice with this?
>
> As Stan mentioned, some LSI controllers support this. You can lookup the LSI
> website to find out about it. Sometimes the BBU (battery unit) comes
> separately.
>
>> 4) support for news drivers (firmware updates)
>
> LSI is quite good when it comes to Linux drivers. They are updated directly
> in the official kernel so no need to update .ko files or anything like that.
>
>> 5) support for hot swap
>
> These cards usually support hot swap very well, with less downtime between
> pulling/pushing drives. (sometimes MD can take a few seconds to remove/add a
> drive in an array).
>
>> 6) if i use ssd what should i consider? i have one raid card with ssd
>> and i don't know if it's runs nice or just do the job
>> 7) anything else? costs =) ?
>
> The costs, as Stan mentioned also, are fairly reasonable, in the order of a
> good quality SSD drive.
>
>>
>> i will search about this boards you told, and about features (i don't
>> know what bbu means yet, but will check... any good raid boards
>> literarture to read? maybe wikipedia?)
>
>
> BBU means "battery backed unit" as far as I know.
>>
>>
>> thanks a lot!! :)
>
> One note: This is not an LSI promotional response, I just know about LSI
> cards more than their counterpart, so I gave insight on what I knew.
>
> Regards,
> Ben.
>
>>
>> 2013/9/19 Stan Hoeppner <stan@hardwarefreak.com>:
>>>
>>> On 9/18/2013 10:42 PM, Roberto Spadim wrote:
>>>>
>>>> nice, in other words, is better spend money with hardware raid cards
>>>> right?
>>>
>>> If it's my money, yes, absolutely.  RAID BBWC will run circles around an
>>> SSD with a random write workload.  The cycle time on DDR2 SDRAM is 10s
>>> of nanoseconds.  Write latency on flash cells is 50-100 microseconds.
>>> Do the math.
>>>
>>> Random write apps such as transactional databases rarely, if ever,
>>> saturate the BBWC faster than it can flush and free pages, so the
>>> additional capacity of an SSD yields no benefit.  Additionally, good
>>> RAID firmware will take some of the randomness out of the write pattern
>>> by flushing nearby LBA sectors in a single IO to the drives, increasing
>>> the effectiveness of TCQ/NCQ, thereby reducing seeks.  This in essence
>>> increases the random IO throughput of the drives.
>>>
>>> In summary, yes, a good caching RAID controller w/BBU will yield vastly
>>> superior performance compared to SSD for most random write workloads,
>>> simply due to instantaneous ACK to fsync and friends.
>>>
>>>> any special card that i should look?
>>>
>>> If this R420 is the 4x3.5" model then the LSI 9260-4i is suitable.  If
>>> it's the 8x2.5" drive model then the LSI 9260-8i is suitable.  Both have
>>> 512MB of cache DRAM.  In both cases you'd use the LSI00161/ LSIiBBU07
>>> BBU for lower cost instead of the flash option.  These two models have
>>> the lowest MSRP of the LSI RAID cards having both large cache and BBU
>>> support.
>>>
>>> In the 8x2.5" case you could also use the Dell PERC 710, which has built
>>> in FBWC.  Probably more expensive than the LSI branded cards.  All of
>>> Dell's RAID cards are rebranded LSI cards, or OEM produced by LSI for
>>> Dell with Dell branded firmware.  I.e. it's the same product, same
>>> performance, just a different name on it.
>>>
>>> Adaptec also has decent RAID cards.  The bottom end doesn't support BBU
>>> so steer clear of those, i.e. 6405e/6805e, etc.
>>>
>>> Don't use Areca, HighPoint, Promise, etc.  They're simply not in the
>>> same league as the enterprise vendors above.  If you have problems with
>>> optimizing their cards, drivers, firmware, etc for a specific workload,
>>> their support is simply non existent.  You're on your own.
>>>
>>>> 2013/9/18 Stan Hoeppner <stan@hardwarefreak.com>:
>>>>>
>>>>> On 9/18/2013 12:33 PM, Roberto Spadim wrote:
>>>>>>
>>>>>> Well the internet link here is 100mbps, i think the workload will be a
>>>>>> bit more than only 100 users, it's a second webserver+database server
>>>>>> He is trying to use a cheaper server with more disk performace, Brazil
>>>>>> costs are too high to allow a full ssd system or 15k rpm sas harddisks
>>>>>> For mariadb server i'm studing if the thread-pool scheduler will be
>>>>>> used instead of one thread per connection but "it's not my problem"
>>>>>> the final user will select what is better for database scheduler
>>>>>> In other words i think the work load will not be a simple web server
>>>>>> cms/blog, i don't know yet how it will work, it's a black/gray box to
>>>>>> me, today he have sata enterprise hdd 7200rpm at servers (dell server
>>>>>> r420 if i'm not wrong) and is studing if a ssd could help, that's my
>>>>>> 'job' (hobby) in this task
>>>>>
>>>>> Based on the information provided it sounds like the machine is seek
>>>>> bound.  The simplest, and best, solution to this problem is simply
>>>>> installing a [B|F]BWC RAID card w/512KB cache.  Synchronous writes are
>>>>> acked when committed to RAID cache instead of the platter.  This will
>>>>> yield ~130,000 burst write TPS before hitting the spindles, or ~130,000
>>>>> writes in flight.  This is far more performance than you can achieve
>>>>> with a low end enterprise SSD, for about the same cost.  It's fully
>>>>> transparent and performance is known and guaranteed, unlike the recent
>>>>> kernel based block IO caching hacks targeting SSDs as fast read/write
>>>>> buffers.
>>>>>
>>>>> You can use the onboard RAID firmware to create RAID1s or a RAID10, or
>>>>> you can expose each disk individually and use md/RAID while still
>>>>> benefiting from the write caching, though for only a handful of disks
>>>>> you're better off using the firmware RAID.  Another advantage is that
>>>>> you can use parity RAID (controller firmware only) and avoid some of
>>>>> the
>>>>> RMW penalty, as the read blocks will be in controller cache.  I.e. you
>>>>> can use three 7.2K disks, get the same capacity as a four disk RAID10,
>>>>> with equal read performance and nearly the same write performance.
>>>>>
>>>>> Write heavy DB workloads are a post child for hardware caching RAID
>>>>> devices.
>>>>>
>>>>> --
>>>>> Stan
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>> 2013/9/18 Drew <drew.kay@gmail.com>:
>>>>>>>
>>>>>>> On Wed, Sep 18, 2013 at 8:51 AM, Roberto Spadim
>>>>>>> <roberto@spadim.com.br> wrote:
>>>>>>>>
>>>>>>>> Sorry guys, this time i don't have a full knowledge about the
>>>>>>>> workload, but from what he told me, he want fast writes with hdd but
>>>>>>>> i
>>>>>>>> could check if small ssd devices could help
>>>>>>>> After install linux with raid1 i will install apache mariadb and php
>>>>>>>> at this machine, in other words it's a database and web server load,
>>>>>>>> but i don't know what size of app and database will run yet
>>>>>>>>
>>>>>>>> Btw, ssd with bcache or dm cache could help hdd (this must be
>>>>>>>> enterprise level) writes, right?
>>>>>>>> Any idea what the best method to test what kernel drive could give
>>>>>>>> superior performace? I'm thinking about install the bcache, and
>>>>>>>> after
>>>>>>>> make a backup and install dm cache and check what's better, any
>>>>>>>> other
>>>>>>>> idea?
>>>>>>>
>>>>>>> We still need to know what size datasets are going to be used. And
>>>>>>> also given it's a webserver, how big of a pipe does he have?
>>>>>>>
>>>>>>> Given a typical webserver in a colo w/ 10Mbps pipe, I think the
>>>>>>> suggested config is overkill. For a webserver the 7200 SATA's should
>>>>>>> be able to deliver enough data to keep apache happy.
>>>>>>>
>>>>>>> In the database side, depends on how intensive the workload is. I see
>>>>>>> a lot of webservers where the 7200's are just fine because the I/O
>>>>>>> demands from the database are low. Blog/CMS systems like wordpress
>>>>>>> will be harder on the database but again it depends on how heavy the
>>>>>>> access is to the server. How many visitors/hour does he expect to
>>>>>>> serve?
>>>>>>>
>>>>>>>
>>>>>>> --
>>>>>>> Drew
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-raid"
>>>>>>> in
>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>
>>>>>>
>>>>>>
>>>>
>>>>
>>
>>
>



-- 
Roberto Spadim
