From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: support for external persistent cache
Date: Wed, 19 Jan 2011 14:57:25 -0200
Message-ID: <AANLkTikCUkESU8zNLRgmDpz_wdKfDFC3YTG0R4O+5eVi@mail.gmail.com>
References: <4D365551.7090207@gmail.com>
	<AANLkTimTnaHEA0+==hs7Ew0Zzvdr1EOtxEqH=EfgdN-7@mail.gmail.com>
	<AANLkTim3BJVbHdtByAni2ObUf0Qjece9jkd1_MSkT56P@mail.gmail.com>
	<4D365BE2.9020300@gmail.com>
	<AANLkTi=5rNxQtNsixdSYZE_XBtQR+q=WpwA_BNXp5vpr@mail.gmail.com>
	<20110119155211.GA31671@erebus.underworld.local>
	<AANLkTimP0eTReK+UH4mm67tUckV+Q=DxNXgUgvqB=4zi@mail.gmail.com>
	<20110119162941.GA32537@erebus.underworld.local>
	<AANLkTikZmu3uNjv_PehWOx6JWcTP60nVVLR_UeS_0wJi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikZmu3uNjv_PehWOx6JWcTP60nVVLR_UeS_0wJi@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Cory Coager <ccoager@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

if /dev/sdb get full, /dev/sda must be sync before continue...
it=B4s a background thread
but it works like linux memory cache, but linux use ram (volatille)
you want a volatille (ssd)

it=B4s like this:
http://www.seagate.com/www/en-us/products/laptops/laptop-hdd

2011/1/19 Roberto Spadim <roberto@spadim.com.br>:
> yes, a jornaling but using ssd first and sata after
> it=B4s not raid feature...
> it=B4s per disk filesystem feature...
> we could implement jornaling in raid too...
> but=B4s more inteligent (easy) at application level (filesystem)
> you could write first at network (if it=B4s faster than sata) and aft=
er
> at sata (if it=B4s slower than network)
>
> it=B4s not a raid feature... it=B4s a per device feature got it?
> maybe a device (not raid..) for a cache division on devices
> for example
>
>
> /dev/sda (sata 1terabyte 100mb/s)
> /dev/sdb (ssd 1gigabyte 1000mb/s)
>
> /dev/cache_a (a mix of sata and ssd with sata size 1terabyte, and
> mixed speed (memory, ssd, sata))
>
> cache_a device should know that
> early reads/write should be writen to sdb
> time in time it should sync at sda
>
> the same happens with memory (ram memory) but it=B4s volatille (difer=
ent
> than ssd that=B4s not volatille)
>
> /dev/sdb should be sync
> /dev/sda should be async (since /dev/sdb make it safe to use async)
>
>
> that=B4s you intention? i don=B4t know if linux have it, anyone know?
>
>
> 2011/1/19 Cory Coager <ccoager@gmail.com>:
>> On Wed, Jan 19, 2011 at 02:16:08PM -0200, Roberto Spadim wrote:
>>> ok, your hardware have:
>>> cpu, memory, disk controller, disks
>>>
>>> and you computer have:
>>> cpu, memory, disk controler (your hardware)
>>>
>>> if your computer cache don?t sync to your disk controller you will
>>> lose information....
>>>
>>> check that *memory, is the volatille memory and *disk controller is
>>> the non volatille memory
>>> if you tell me that you will never have a *memory, and you have alw=
ays
>>> a non volatille memory, no problem, you will never need a kernel
>>> load... just a boot loader that read previous memory information an=
d
>>> start in that point... why don?t do this? non volatille memory is n=
ot
>>> as fast as volatille memory
>>> got the problem?
>>
>> Sorry, we're still not on the same page. =A0I would use both a ramdi=
sk
>> and sata disk. =A0The ramdisk would act as a persistent cache
>> (with the battery) for the sata disks. =A0Enabling write through
>> would write to the cache first then sync to the sata disks.
>>
>> Understand what I'm getting at now?
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
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
