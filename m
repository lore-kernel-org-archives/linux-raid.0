From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: Best configuration for bcache/md cache or other cache using ssd
Date: Thu, 19 Sep 2013 19:50:33 -0300
Message-ID: <CAH3kUhGHa-PMu-mdWDRoMF8O-29=jYxbkt5cUC=Dd1aJVWC-qg@mail.gmail.com>
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
	<523B777F.4000907@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <523B777F.4000907@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Drew <drew.kay@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Stan!!

2013/9/19 Stan Hoeppner <stan@hardwarefreak.com>:
> On 9/19/2013 10:30 AM, Roberto Spadim wrote:
>
>> 1) Smart or other tool to diagnostics and access drives diagnostics
>
> See the '-d' option in smartctl(8).
nice i tryed this in a running machine, some cards don't work, others
work with smart


>> 2) Cache memory (if i have 512mb here, i could replace with 512mb or
>> more at linux side? instead of cache at raid board, why not add cach=
e
>> to linux kernel?)
>
> Because if the power goes out, or the kernel crashes, the contents of
> system RAM are lost, ergo you lose data and possibly corrupt your fil=
es
> and filesystem.
OK, cache at raid is better


>> 3) batery backup, how this really work? what kind of raid board real=
ly
>> work nice with this?
>
> A BBU, or battery backup unit, provides power to the DRAM and DRAM
> controller on the RAID card.  If the power goes out or kernel crashes
> the data is intact.  When power and operating state are restored, the
> controller flushes the cache contents to the drives.  Most BBUs will
> hold for about 72 hours before the batteries run out.
>
> A newer option is a flash backed cache.  Here there is no battery uni=
t,

In this case, it=B4s something similar to a SSD at raid card? this don'=
t
have write cicles limit? and problems with  flash being corrupt?

> and the data is truly non-volatile.  In the event of power loss or so=
me
> crash situations, the controller copies the contents of the write cac=
he
> to onboard flash memory.  When normal system state is restored, the
> flash is dumped to DRAM, then flushed to the drives.  This option is =
a
> little more expensive, but is preferred for obvious reasons.  There i=
s
> no 72 hour limit.  The data resides in flash indefinitely.  This can =
be
> valuable in the case of natural disasters that take out utility power
> and network links for days or weeks, but leave the facility and syste=
ms
> unharmed.  With flash backed write cache, you can wait it out, or
> relocate, and the data will hit disk after you power up.  With BBU, y=
ou
> have only ~3 days to get back online.
>
>> 4) support for news drivers (firmware updates)
>
> All of the quality RAID cards have pretty seamless firmware update
> mechanisms.  In the case of Linux the drivers are in mainline, so
> updating your kernel updates the driver.

Nice =3D)

>> 5) support for hot swap
>
> RAID cards supported hot swap long before Linus wrote the first lines=
 of
> code that became Linux, and more than a decade before the md driver w=
as
> written.  RAID cards typically handle hot swap better than md does.
Yes, but some Dell server (here) have a raid card and can't allow a
hot swap, i don't know if it's a problem about drive bays or not


>> 6) if i use ssd what should i consider? i have one raid card with ss=
d
>> and i don't know if it's runs nice or just do the job
>
> I'm not sure what you're asking here.
Well just to know if the raid card could be used with ssd...
i was thinking something like:

RAID CARD -> ssd
motherboard -> hdd

and a bcache or dmcache of md-raid1(hdds) with raidcard-raid1(ssds)


>
>> 7) anything else? costs =3D) ?
>
> I can't speak accurately to costs.  The last time we spoke of pricing=
,
> off list, you stated a 500GB SATA drive costs ~$500 USD in your local=
e.
>  That's radically out of line with pricing here in the US.
yes here is my problem, this time i=B4m considering some parts being im=
ported


> I can only say for comparison that I can obtain an LSI 9260-4i 512MB
> w/BBU for ~$470 USD.  I can obtain an Intel DC S3700 200GB enterprise
> SSD for $499.  But this isn't an apt comparison as neither device is =
a

:'( i will cry hahah it's very cheap for my country market

> direct replacement for the other.  It's the complete storage
> architecture and its overall capabilities that matters.  Using an SSD
> with one of the late kernel caching hacks doesn't give you the
> protection of BBU/flash cache on hardware RAID.  Nor does it give you
> the near zero latency fsync ACK of RAID cache.
Nice


>> i will search about this boards you told, and about features (i don'=
t
>> know what bbu means yet, but will check... any good raid boards
>> literarture to read? maybe wikipedia?)
>
> So you've never used a hardware RAID controller?  Completely new to y=
ou?
+- i don't know with details, i have a supperficial experience only,
not a technical view of raid cards yet

>  Wow...  Start with these.  Beware.  This is a few hundred pages of
> material.
>
> http://www.lsi.com/downloads/Public/MegaRAID%20SAS/MegaRAID%20SAS%209=
260-4i/MR_SAS9260-4i_PB_FIN_071212.pdf
> http://www.lsi.com/downloads/Public/MegaRAID%20SAS/41450-04_RevC_6Gbs=
_MegaRAID_SAS_UG.pdf
> http://www.lsi.com/downloads/Public/MegaRAID%20Common%20Files/51530-0=
0_RevK_MegaRAID_SAS_SW_UG.pdf
!!! wow! very nice, i will read :)
Thanks a lot!


>
>
>
>> thanks a lot!! :)
>>
>> 2013/9/19 Stan Hoeppner <stan@hardwarefreak.com>:
>>> On 9/18/2013 10:42 PM, Roberto Spadim wrote:
>>>> nice, in other words, is better spend money with hardware raid car=
ds
>>>> right?
>>>
>>> If it's my money, yes, absolutely.  RAID BBWC will run circles arou=
nd an
>>> SSD with a random write workload.  The cycle time on DDR2 SDRAM is =
10s
>>> of nanoseconds.  Write latency on flash cells is 50-100 microsecond=
s.
>>> Do the math.
>>>
>>> Random write apps such as transactional databases rarely, if ever,
>>> saturate the BBWC faster than it can flush and free pages, so the
>>> additional capacity of an SSD yields no benefit.  Additionally, goo=
d
>>> RAID firmware will take some of the randomness out of the write pat=
tern
>>> by flushing nearby LBA sectors in a single IO to the drives, increa=
sing
>>> the effectiveness of TCQ/NCQ, thereby reducing seeks.  This in esse=
nce
>>> increases the random IO throughput of the drives.
>>>
>>> In summary, yes, a good caching RAID controller w/BBU will yield va=
stly
>>> superior performance compared to SSD for most random write workload=
s,
>>> simply due to instantaneous ACK to fsync and friends.
>>>
>>>> any special card that i should look?
>>>
>>> If this R420 is the 4x3.5" model then the LSI 9260-4i is suitable. =
 If
>>> it's the 8x2.5" drive model then the LSI 9260-8i is suitable.  Both=
 have
>>> 512MB of cache DRAM.  In both cases you'd use the LSI00161/ LSIiBBU=
07
>>> BBU for lower cost instead of the flash option.  These two models h=
ave
>>> the lowest MSRP of the LSI RAID cards having both large cache and B=
BU
>>> support.
>>>
>>> In the 8x2.5" case you could also use the Dell PERC 710, which has =
built
>>> in FBWC.  Probably more expensive than the LSI branded cards.  All =
of
>>> Dell's RAID cards are rebranded LSI cards, or OEM produced by LSI f=
or
>>> Dell with Dell branded firmware.  I.e. it's the same product, same
>>> performance, just a different name on it.
>>>
>>> Adaptec also has decent RAID cards.  The bottom end doesn't support=
 BBU
>>> so steer clear of those, i.e. 6405e/6805e, etc.
>>>
>>> Don't use Areca, HighPoint, Promise, etc.  They're simply not in th=
e
>>> same league as the enterprise vendors above.  If you have problems =
with
>>> optimizing their cards, drivers, firmware, etc for a specific workl=
oad,
>>> their support is simply non existent.  You're on your own.
>>>
>>>> 2013/9/18 Stan Hoeppner <stan@hardwarefreak.com>:
>>>>> On 9/18/2013 12:33 PM, Roberto Spadim wrote:
>>>>>> Well the internet link here is 100mbps, i think the workload wil=
l be a
>>>>>> bit more than only 100 users, it's a second webserver+database s=
erver
>>>>>> He is trying to use a cheaper server with more disk performace, =
Brazil
>>>>>> costs are too high to allow a full ssd system or 15k rpm sas har=
ddisks
>>>>>> For mariadb server i'm studing if the thread-pool scheduler will=
 be
>>>>>> used instead of one thread per connection but "it's not my probl=
em"
>>>>>> the final user will select what is better for database scheduler
>>>>>> In other words i think the work load will not be a simple web se=
rver
>>>>>> cms/blog, i don't know yet how it will work, it's a black/gray b=
ox to
>>>>>> me, today he have sata enterprise hdd 7200rpm at servers (dell s=
erver
>>>>>> r420 if i'm not wrong) and is studing if a ssd could help, that'=
s my
>>>>>> 'job' (hobby) in this task
>>>>>
>>>>> Based on the information provided it sounds like the machine is s=
eek
>>>>> bound.  The simplest, and best, solution to this problem is simpl=
y
>>>>> installing a [B|F]BWC RAID card w/512KB cache.  Synchronous write=
s are
>>>>> acked when committed to RAID cache instead of the platter.  This =
will
>>>>> yield ~130,000 burst write TPS before hitting the spindles, or ~1=
30,000
>>>>> writes in flight.  This is far more performance than you can achi=
eve
>>>>> with a low end enterprise SSD, for about the same cost.  It's ful=
ly
>>>>> transparent and performance is known and guaranteed, unlike the r=
ecent
>>>>> kernel based block IO caching hacks targeting SSDs as fast read/w=
rite
>>>>> buffers.
>>>>>
>>>>> You can use the onboard RAID firmware to create RAID1s or a RAID1=
0, or
>>>>> you can expose each disk individually and use md/RAID while still
>>>>> benefiting from the write caching, though for only a handful of d=
isks
>>>>> you're better off using the firmware RAID.  Another advantage is =
that
>>>>> you can use parity RAID (controller firmware only) and avoid some=
 of the
>>>>> RMW penalty, as the read blocks will be in controller cache.  I.e=
=2E you
>>>>> can use three 7.2K disks, get the same capacity as a four disk RA=
ID10,
>>>>> with equal read performance and nearly the same write performance=
=2E
>>>>>
>>>>> Write heavy DB workloads are a post child for hardware caching RA=
ID devices.
>>>>>
>>>>> --
>>>>> Stan
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>> 2013/9/18 Drew <drew.kay@gmail.com>:
>>>>>>> On Wed, Sep 18, 2013 at 8:51 AM, Roberto Spadim <roberto@spadim=
=2Ecom.br> wrote:
>>>>>>>> Sorry guys, this time i don't have a full knowledge about the
>>>>>>>> workload, but from what he told me, he want fast writes with h=
dd but i
>>>>>>>> could check if small ssd devices could help
>>>>>>>> After install linux with raid1 i will install apache mariadb a=
nd php
>>>>>>>> at this machine, in other words it's a database and web server=
 load,
>>>>>>>> but i don't know what size of app and database will run yet
>>>>>>>>
>>>>>>>> Btw, ssd with bcache or dm cache could help hdd (this must be
>>>>>>>> enterprise level) writes, right?
>>>>>>>> Any idea what the best method to test what kernel drive could =
give
>>>>>>>> superior performace? I'm thinking about install the bcache, an=
d after
>>>>>>>> make a backup and install dm cache and check what's better, an=
y other
>>>>>>>> idea?
>>>>>>>
>>>>>>> We still need to know what size datasets are going to be used. =
And
>>>>>>> also given it's a webserver, how big of a pipe does he have?
>>>>>>>
>>>>>>> Given a typical webserver in a colo w/ 10Mbps pipe, I think the
>>>>>>> suggested config is overkill. For a webserver the 7200 SATA's s=
hould
>>>>>>> be able to deliver enough data to keep apache happy.
>>>>>>>
>>>>>>> In the database side, depends on how intensive the workload is.=
 I see
>>>>>>> a lot of webservers where the 7200's are just fine because the =
I/O
>>>>>>> demands from the database are low. Blog/CMS systems like wordpr=
ess
>>>>>>> will be harder on the database but again it depends on how heav=
y the
>>>>>>> access is to the server. How many visitors/hour does he expect =
to
>>>>>>> serve?
>>>>>>>
>>>>>>>
>>>>>>> --
>>>>>>> Drew
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux=
-raid" in
>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.h=
tml
>>>>>>
>>>>>>
>>>>>>
>>>>>
>>>>
>>>>
>>>>
>>>
>>
>>
>>
>



--=20
Roberto Spadim
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
