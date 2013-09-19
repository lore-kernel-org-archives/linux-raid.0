From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: Best configuration for bcache/md cache or other cache using ssd
Date: Thu, 19 Sep 2013 00:42:14 -0300
Message-ID: <CAH3kUhFaXEwR8ym8Vvf3yEODLf6mXOWnCQbk4qgLk7bnaepV3g@mail.gmail.com>
References: <CAH3kUhHrK-TKJD1s_7SvtOz=YnpO82EvMGPv0X8rVAaDcuTO0Q@mail.gmail.com>
	<CACJz6QtVzR1bED939ZkesyXMWjv-2DmxZSrGH_enKX5dCuNEJw@mail.gmail.com>
	<CAH3kUhHin5PfjDCNFjD8eypNML=0YrkQp14DrCADc2StcODdaw@mail.gmail.com>
	<CAH3kUhFf11O8a-y5W40ogrKu_XsjGfmi6R4YUmxbYw-McrEvyA@mail.gmail.com>
	<CACJz6QtDt-5mgtpHr092AyFOxoSoY+V7F8QbiUcDuD5JN7TsMA@mail.gmail.com>
	<CAH3kUhGNeXbmR+2zk+3KCDSaBfsjLuZQA89tG_C776emw0nSSQ@mail.gmail.com>
	<523A60DF.5040702@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <523A60DF.5040702@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Drew <drew.kay@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

nice, in other words, is better spend money with hardware raid cards
right? any special card that i should look?

2013/9/18 Stan Hoeppner <stan@hardwarefreak.com>:
> On 9/18/2013 12:33 PM, Roberto Spadim wrote:
>> Well the internet link here is 100mbps, i think the workload will be a
>> bit more than only 100 users, it's a second webserver+database server
>> He is trying to use a cheaper server with more disk performace, Brazil
>> costs are too high to allow a full ssd system or 15k rpm sas harddisks
>> For mariadb server i'm studing if the thread-pool scheduler will be
>> used instead of one thread per connection but "it's not my problem"
>> the final user will select what is better for database scheduler
>> In other words i think the work load will not be a simple web server
>> cms/blog, i don't know yet how it will work, it's a black/gray box to
>> me, today he have sata enterprise hdd 7200rpm at servers (dell server
>> r420 if i'm not wrong) and is studing if a ssd could help, that's my
>> 'job' (hobby) in this task
>
> Based on the information provided it sounds like the machine is seek
> bound.  The simplest, and best, solution to this problem is simply
> installing a [B|F]BWC RAID card w/512KB cache.  Synchronous writes are
> acked when committed to RAID cache instead of the platter.  This will
> yield ~130,000 burst write TPS before hitting the spindles, or ~130,000
> writes in flight.  This is far more performance than you can achieve
> with a low end enterprise SSD, for about the same cost.  It's fully
> transparent and performance is known and guaranteed, unlike the recent
> kernel based block IO caching hacks targeting SSDs as fast read/write
> buffers.
>
> You can use the onboard RAID firmware to create RAID1s or a RAID10, or
> you can expose each disk individually and use md/RAID while still
> benefiting from the write caching, though for only a handful of disks
> you're better off using the firmware RAID.  Another advantage is that
> you can use parity RAID (controller firmware only) and avoid some of the
> RMW penalty, as the read blocks will be in controller cache.  I.e. you
> can use three 7.2K disks, get the same capacity as a four disk RAID10,
> with equal read performance and nearly the same write performance.
>
> Write heavy DB workloads are a post child for hardware caching RAID devices.
>
> --
> Stan
>
>
>
>
>> 2013/9/18 Drew <drew.kay@gmail.com>:
>>> On Wed, Sep 18, 2013 at 8:51 AM, Roberto Spadim <roberto@spadim.com.br> wrote:
>>>> Sorry guys, this time i don't have a full knowledge about the
>>>> workload, but from what he told me, he want fast writes with hdd but i
>>>> could check if small ssd devices could help
>>>> After install linux with raid1 i will install apache mariadb and php
>>>> at this machine, in other words it's a database and web server load,
>>>> but i don't know what size of app and database will run yet
>>>>
>>>> Btw, ssd with bcache or dm cache could help hdd (this must be
>>>> enterprise level) writes, right?
>>>> Any idea what the best method to test what kernel drive could give
>>>> superior performace? I'm thinking about install the bcache, and after
>>>> make a backup and install dm cache and check what's better, any other
>>>> idea?
>>>
>>> We still need to know what size datasets are going to be used. And
>>> also given it's a webserver, how big of a pipe does he have?
>>>
>>> Given a typical webserver in a colo w/ 10Mbps pipe, I think the
>>> suggested config is overkill. For a webserver the 7200 SATA's should
>>> be able to deliver enough data to keep apache happy.
>>>
>>> In the database side, depends on how intensive the workload is. I see
>>> a lot of webservers where the 7200's are just fine because the I/O
>>> demands from the database are low. Blog/CMS systems like wordpress
>>> will be harder on the database but again it depends on how heavy the
>>> access is to the server. How many visitors/hour does he expect to
>>> serve?
>>>
>>>
>>> --
>>> Drew
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>



-- 
Roberto Spadim
