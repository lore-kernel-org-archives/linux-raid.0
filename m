From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: support for external persistent cache
Date: Wed, 19 Jan 2011 13:19:18 -0200
Message-ID: <AANLkTi=5rNxQtNsixdSYZE_XBtQR+q=WpwA_BNXp5vpr@mail.gmail.com>
References: <4D365551.7090207@gmail.com>
	<AANLkTimTnaHEA0+==hs7Ew0Zzvdr1EOtxEqH=EfgdN-7@mail.gmail.com>
	<AANLkTim3BJVbHdtByAni2ObUf0Qjece9jkd1_MSkT56P@mail.gmail.com>
	<4D365BE2.9020300@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D365BE2.9020300@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Cory Coager <ccoager@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

ok,
but if you don=B4t sync file system (remove from memory and put in disk
controller)
you will lost information with or without a batery

how to don=B4t lose information?
don=B4t power down you memory,cpu, disk controller (sata controler, rai=
d
controller, or anyother) and disks (does it have a batery? a super
capacitor?)
if you power down, be sure that all memory was send to disk controller
and that disk controller have energy (batery or capacitor) to send
information to disks (they need batery or capacitor too)

right?
so, a ups can power cpu, memory, disk controller and disks with only
one batery (not a batery for each device cpu,memory,disk,disk
controller)
the best world could be a non volatile memory (250mb/s flash 4kb
block) with the speed of volatile memory (10000mb/s ddr3 i don=B4t know
the block size)


2011/1/19 Cory Coager <ccoager@gmail.com>:
> On 01/18/2011 10:17 PM, Roberto Spadim wrote:
>>
>> reading again... should you use a good ups system with information
>> about % of batery, like a notebook?
>> read/write cache can be change with async or sync options on filesys=
tem
>> mount
>> batery support is done with ups system
>> maybe with some time of use (10 years) the baterry of you ramdisk
>> should be replaced, will you replace it? is easier replace a ups
>> batery or a ramdisk specific batery?
>> check at internet about 12vdc atx power supply, and use a charger an=
d
>> a car batery to supply power to your computer, it's a very nice
>> solution =3D)
>
> Sure, I'll replace the battery in the ram disk. =A0Not much different=
 than a
> hardware raid card with a battery in it.
>
> I think you're missing my point. =A0A UPS isn't going to save your fi=
le system
> if the machine dies mid-write.
>
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
