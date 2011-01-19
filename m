From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: support for external persistent cache
Date: Wed, 19 Jan 2011 14:16:08 -0200
Message-ID: <AANLkTimP0eTReK+UH4mm67tUckV+Q=DxNXgUgvqB=4zi@mail.gmail.com>
References: <4D365551.7090207@gmail.com>
	<AANLkTimTnaHEA0+==hs7Ew0Zzvdr1EOtxEqH=EfgdN-7@mail.gmail.com>
	<AANLkTim3BJVbHdtByAni2ObUf0Qjece9jkd1_MSkT56P@mail.gmail.com>
	<4D365BE2.9020300@gmail.com>
	<AANLkTi=5rNxQtNsixdSYZE_XBtQR+q=WpwA_BNXp5vpr@mail.gmail.com>
	<20110119155211.GA31671@erebus.underworld.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110119155211.GA31671@erebus.underworld.local>
Sender: linux-raid-owner@vger.kernel.org
To: Cory Coager <ccoager@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

ok, your hardware have:
cpu, memory, disk controller, disks

and you computer have:
cpu, memory, disk controler (your hardware)

if your computer cache don=B4t sync to your disk controller you will
lose information....

check that *memory, is the volatille memory and *disk controller is
the non volatille memory
if you tell me that you will never have a *memory, and you have always
a non volatille memory, no problem, you will never need a kernel
load... just a boot loader that read previous memory information and
start in that point... why don=B4t do this? non volatille memory is not
as fast as volatille memory
got the problem?


2011/1/19 Cory Coager <ccoager@gmail.com>:
> On Wed, Jan 19, 2011 at 01:19:18PM -0200, Roberto Spadim wrote:
>> ok,
>> but if you don?t sync file system (remove from memory and put in dis=
k
>> controller)
>> you will lost information with or without a batery
>>
>> how to don?t lose information?
>> don?t power down you memory,cpu, disk controller (sata controler, ra=
id
>> controller, or anyother) and disks (does it have a batery? a super
>> capacitor?)
>> if you power down, be sure that all memory was send to disk controll=
er
>> and that disk controller have energy (batery or capacitor) to send
>> information to disks (they need batery or capacitor too)
>>
>> right?
>> so, a ups can power cpu, memory, disk controller and disks with only
>> one batery (not a batery for each device cpu,memory,disk,disk
>> controller)
>> the best world could be a non volatile memory (250mb/s flash 4kb
>> block) with the speed of volatile memory (10000mb/s ddr3 i don?t kno=
w
>> the block size)
>
> It would have to work the same as a hardware RAID controller.
> Information is first written to the cache then synced to the
> disk. =A0If the data is in the cache but not on the disk, the
> machine loses power, next boot up the software raid would need a
> way to flush the data from the ram disk to the disk. =A0Of course
> this would require the battery be in working condition, as with
> any hardware.
>
> Hopefully I've explained that well enough. =A0Perhaps it will be
> better to see the hardware I'm talking about:
> http://techreport.com/articles.x/16255
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
