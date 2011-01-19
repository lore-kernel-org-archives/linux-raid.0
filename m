From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: support for external persistent cache
Date: Wed, 19 Jan 2011 15:04:09 -0200
Message-ID: <AANLkTinhFAiYYV=cm7UuYHeOsDLwSP_yVsbMPTCwcNee@mail.gmail.com>
References: <4D365551.7090207@gmail.com>
	<AANLkTimTnaHEA0+==hs7Ew0Zzvdr1EOtxEqH=EfgdN-7@mail.gmail.com>
	<AANLkTim3BJVbHdtByAni2ObUf0Qjece9jkd1_MSkT56P@mail.gmail.com>
	<4D365BE2.9020300@gmail.com>
	<AANLkTi=5rNxQtNsixdSYZE_XBtQR+q=WpwA_BNXp5vpr@mail.gmail.com>
	<20110119155211.GA31671@erebus.underworld.local>
	<AANLkTimP0eTReK+UH4mm67tUckV+Q=DxNXgUgvqB=4zi@mail.gmail.com>
	<20110119162941.GA32537@erebus.underworld.local>
	<AANLkTikZmu3uNjv_PehWOx6JWcTP60nVVLR_UeS_0wJi@mail.gmail.com>
	<AANLkTikCUkESU8zNLRgmDpz_wdKfDFC3YTG0R4O+5eVi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikCUkESU8zNLRgmDpz_wdKfDFC3YTG0R4O+5eVi@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Cory Coager <ccoager@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

check:
Key Specifications

    * 500GB, 320GB and 250GB hard drive capacity options   (hard disk
like, maybe 100mb/s with 7200rpm   - it=B4s you hd disk (/dev/sda in my
example) )
    * 7200-RPM spindle speed
    * 4GB SLC NAND solid state memory   (SSD like, maybe 300mb/s   -
it=B4s you ssd cache disk (/dev/sdb in my example) )
    * 32MB of drive-level cache  (is it ddr3? ddr3 is 10000mb/s, maybe
less, sata is 3gb/s    - it=B4s the linux/computer ram memory)
    * SATA 3Gb/s with Native Command Queuing (3000mb/s)

what this disk do?

operational system write to (hd) and read from (hd)

hd:
write/read in memory
if not in memory, read from ssd
if not in ssd, read from hd

write can be async
when loser energy, save memory to ssd, 32mb is fast to write, with
300mb/s ssd speed you can use a super capacitor and have 1 second of
life...
after write to ssd, write to hd





2011/1/19 Roberto Spadim <roberto@spadim.com.br>:
> if /dev/sdb get full, /dev/sda must be sync before continue...
> it=B4s a background thread
> but it works like linux memory cache, but linux use ram (volatille)
> you want a volatille (ssd)
>
> it=B4s like this:
> http://www.seagate.com/www/en-us/products/laptops/laptop-hdd
>
> 2011/1/19 Roberto Spadim <roberto@spadim.com.br>:
>> yes, a jornaling but using ssd first and sata after
>> it=B4s not raid feature...
>> it=B4s per disk filesystem feature...
>> we could implement jornaling in raid too...
>> but=B4s more inteligent (easy) at application level (filesystem)
>> you could write first at network (if it=B4s faster than sata) and af=
ter
>> at sata (if it=B4s slower than network)
>>
>> it=B4s not a raid feature... it=B4s a per device feature got it?
>> maybe a device (not raid..) for a cache division on devices
>> for example
>>
>>
>> /dev/sda (sata 1terabyte 100mb/s)
>> /dev/sdb (ssd 1gigabyte 1000mb/s)
>>
>> /dev/cache_a (a mix of sata and ssd with sata size 1terabyte, and
>> mixed speed (memory, ssd, sata))
>>
>> cache_a device should know that
>> early reads/write should be writen to sdb
>> time in time it should sync at sda
>>
>> the same happens with memory (ram memory) but it=B4s volatille (dife=
rent
>> than ssd that=B4s not volatille)
>>
>> /dev/sdb should be sync
>> /dev/sda should be async (since /dev/sdb make it safe to use async)
>>
>>
>> that=B4s you intention? i don=B4t know if linux have it, anyone know=
?
>>
>>
>> 2011/1/19 Cory Coager <ccoager@gmail.com>:
>>> On Wed, Jan 19, 2011 at 02:16:08PM -0200, Roberto Spadim wrote:
>>>> ok, your hardware have:
>>>> cpu, memory, disk controller, disks
>>>>
>>>> and you computer have:
>>>> cpu, memory, disk controler (your hardware)
>>>>
>>>> if your computer cache don?t sync to your disk controller you will
>>>> lose information....
>>>>
>>>> check that *memory, is the volatille memory and *disk controller i=
s
>>>> the non volatille memory
>>>> if you tell me that you will never have a *memory, and you have al=
ways
>>>> a non volatille memory, no problem, you will never need a kernel
>>>> load... just a boot loader that read previous memory information a=
nd
>>>> start in that point... why don?t do this? non volatille memory is =
not
>>>> as fast as volatille memory
>>>> got the problem?
>>>
>>> Sorry, we're still not on the same page. =A0I would use both a ramd=
isk
>>> and sata disk. =A0The ramdisk would act as a persistent cache
>>> (with the battery) for the sata disks. =A0Enabling write through
>>> would write to the cache first then sync to the sata disks.
>>>
>>> Understand what I'm getting at now?
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>>
>>
>> --
>> Roberto Spadim
>> Spadim Technology / SPAEmpresarial
>>
>
>
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
