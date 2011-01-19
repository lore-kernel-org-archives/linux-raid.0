From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: support for external persistent cache
Date: Wed, 19 Jan 2011 15:20:10 -0200
Message-ID: <AANLkTi=9Fu+AdMRqD5J=fZM9wkb5OV7W3N7jRgJ2j2Xd@mail.gmail.com>
References: <4D365551.7090207@gmail.com>
	<AANLkTimTnaHEA0+==hs7Ew0Zzvdr1EOtxEqH=EfgdN-7@mail.gmail.com>
	<AANLkTim3BJVbHdtByAni2ObUf0Qjece9jkd1_MSkT56P@mail.gmail.com>
	<4D365BE2.9020300@gmail.com>
	<AANLkTi=5rNxQtNsixdSYZE_XBtQR+q=WpwA_BNXp5vpr@mail.gmail.com>
	<20110119155211.GA31671@erebus.underworld.local>
	<AANLkTimP0eTReK+UH4mm67tUckV+Q=DxNXgUgvqB=4zi@mail.gmail.com>
	<20110119162941.GA32537@erebus.underworld.local>
	<AANLkTikZmu3uNjv_PehWOx6JWcTP60nVVLR_UeS_0wJi@mail.gmail.com>
	<20110119170252.GA891@erebus.underworld.local>
	<AANLkTinG9LeZOevLM1WRT-H_fgk5wTY8tmGkadrzS0pH@mail.gmail.com>
	<AANLkTimAETFguk3iThXBRt5+Kr-KkyDfBcwOphz4NeOZ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimAETFguk3iThXBRt5+Kr-KkyDfBcwOphz4NeOZ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Cory Coager <ccoager@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

maybe it=B4s the intention of  'mcachefs'
http://sourceforge.net/apps/mediawiki/fuse/index.php?title=3DFileSystem=
s



2011/1/19 Roberto Spadim <roberto@spadim.com.br>:
> hummm....
> thinking again.....
>
> what=B4s the today raid1 problem?
> it=B4s based on minimal disk size
> for example...
> /dev/sda 1gb
> /dev/sdb 1tb
> we can have a 1gb raid only
>
> what you want is:
> 1tb raid0
> with a automatic /dev/sda to /dev/sdb write
>
>
> could we call this raid0-cache?
> i think we could implement it in raid....
>
> check this fuse (filesystem) implementation: http://www.furquim.org/c=
hironfs/
> it=B4s based on filesystem (ok it=B4s a raid1, not a cache like, but=B4=
s
> limited to max filesystem size, not the minimal filesystem size... ok
> it=B4s not secure to use it since small filesystem don=B4t have all
> information, but=B4s nice)
>
> anyone want to make raid0-cache implementation?
>
>
> 2011/1/19 Roberto Spadim <roberto@spadim.com.br>:
>> i think we could make it
>> but not a raid feature
>> a linux feature
>> for example
>>
>> we could get ramdisk, nbd (network block device), ssd, hd, scsi, rai=
d
>> and select what is first cache, and what is real value
>>
>> after this device is created we could use it with raid...
>>
>>
>> but.... the problem persist
>> if we lost energy, we can=B4t confirm that ram memory is sync to dis=
k,
>> just if we don=B4t use memory cache... in other words we will work w=
ith
>> the best cache disk speed)
>>
>> since ram can get 32GB on big home computer
>> and ssd can get 1terabyte on big home computer
>> and hdd can get more than 1terabyte on big home computer
>>
>> we just need time to sync 32GB from memory to ssd
>> what=B4s the ssd speed? 300mb/s? we need 106,6666666666667 seconds t=
o
>> sync memory to ssd, can you buy a ups with 107 seconds of life with =
a
>> serial cable (usb maybe) that inform that we are without energy?
>>
>>
>>
>>
>>
>> 2011/1/19 Cory Coager <ccoager@gmail.com>:
>>> On Wed, Jan 19, 2011 at 02:44:31PM -0200, Roberto Spadim wrote:
>>>> yes, a jornaling but using ssd first and sata after
>>>> it?s not raid feature...
>>>> it?s per disk filesystem feature...
>>>> we could implement jornaling in raid too...
>>>> but?s more inteligent (easy) at application level (filesystem)
>>>> you could write first at network (if it?s faster than sata) and af=
ter
>>>> at sata (if it?s slower than network)
>>>>
>>>> it?s not a raid feature... it?s a per device feature got it?
>>>> maybe a device (not raid..) for a cache division on devices
>>>> for example
>>>>
>>>>
>>>> /dev/sda (sata 1terabyte 100mb/s)
>>>> /dev/sdb (ssd 1gigabyte 1000mb/s)
>>>>
>>>> /dev/cache_a (a mix of sata and ssd with sata size 1terabyte, and
>>>> mixed speed (memory, ssd, sata))
>>>>
>>>> cache_a device should know that
>>>> early reads/write should be writen to sdb
>>>> time in time it should sync at sda
>>>>
>>>> the same happens with memory (ram memory) but it?s volatille (dife=
rent
>>>> than ssd that?s not volatille)
>>>>
>>>> /dev/sdb should be sync
>>>> /dev/sda should be async (since /dev/sdb make it safe to use async=
)
>>>>
>>>>
>>>> that?s you intention? i don?t know if linux have it, anyone know?
>>> I would use a physical ramdisk over a ssd but thats besides the poi=
nt.
>>> They are still disk drives to the OS.
>>>
>>> Yes, I guess it would be similar to journaling but done in RAID
>>> itself. =A0I don't believe it exists yet, thats why I'm asking if
>>> we could add support for this?
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
