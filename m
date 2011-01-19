From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: RAID0 - cache
Date: Wed, 19 Jan 2011 19:41:32 -0200
Message-ID: <AANLkTi=rbEP8+sd=nwbzk=XHZ8qHg0cVQHdcf=XZ5rom@mail.gmail.com>
References: <AANLkTik7xBOYVgZJC0sStpK=oPHdX53XzwYC5CVDKy_v@mail.gmail.com>
	<20110120072016.1b2162c8@notabene.brown>
	<AANLkTimGp+P1kkq0UQKQ7FHiGi7vwGiGnBZvEoOMWeVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimGp+P1kkq0UQKQ7FHiGi7vwGiGnBZvEoOMWeVA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

very nice i think that bcache is the solution
another question (ok i know...) could we improve read/write performace
on raid1 for ssd? round robin is better than near head (since ssd
don=B4t have head) i think there=B4s a patch for it just test it and pu=
t
at linux kernel (ok it will have a time to be on stable linux kernel)
thanks neil!

2011/1/19 Roberto Spadim <roberto@spadim.com.br>:
> there=B4s a forum (linux kernel) for ideas?
>
> 2011/1/19 NeilBrown <neilb@suse.de>:
>> On Wed, 19 Jan 2011 18:13:23 -0200 Roberto Spadim <roberto@spadim.co=
m.br>
>> wrote:
>>
>>> Hi guys, from a long email i will start this one: (the last one was=
n=B4t send)
>>>
>>> think about this:
>>>
>>> /dev/sda (sata disk 1000gb size, latency of 1ms to move head, 100mb=
/s
>>> to write/read)
>>> /dev/sdb (ssd 1gb size, latency of <100us to find what flash and
>>> position, 500mb/s to write/read)
>>> ram memory (8gb size, with 1gb not used)
>>> /dev/mdxxx (the new device i=B4m calling it as raid0-cache)
>>>
>>> how raid0-cache work?
>>>
>>>
>>> how to create raid?
>>> tell what the sequencial read cache estrategy:
>>> memory(tell fixed memory size) - /dev/sdb - /dev/sda - another devi=
ce
>>> (maybe just 2 is suficiente /dev/sdb and /dev/sda)...
>>>
>>>
>>> how to read?
>>> first, read from the first read device (memory)
>>> if information not there -> read from second read device (/dev/sdb)=
,
>>> update information at first read device, return the read value
>>> if information not there -> read from third read device (/dev/sda),
>>> update information at second and first read device, return the read
>>> value
>>>
>>> how to write?
>>> flush space from first read device to second read device
>>> write to first read device, return OK
>>>
>>> background thread:
>>> sync from first write device (memory) to second write device (/dev/=
sdb)
>>> flush from second write device (/dev/sdb) to third write device (/d=
ev/sda)
>>>
>>> startup:
>>> using cache:
>>> =A0flush everythink from first write device (memory) to second writ=
e
>>> device (/dev/sdb)
>>> =A0flush everythink from second write device (/dev/sdb) to second w=
rite
>>> device (/dev/sda)
>>> =A0since memory is volatille, at startup it can=B4be flushed...
>>> without cache:
>>> =A0make first write device unusable (memory)
>>> =A0make second write device unusable
>>> =A0here we can have write problems, since a wrong power off, can lo=
st
>>> information from cache (first and second write device)
>>>
>>>
>>>
>>> anyidea who can make it?
>>
>> "Hey, I've got this clever idea, I wish someone would implement it" =
almost
>> always results in ... nothing.
>> People with the ability to implement are much more interested in imp=
lementing
>> their own ideas.
>>
>> But see also "bcache".
>>
>> NeilBrown
>>
>>> thanks
>>> --
>>> Roberto Spadim
>>> Spadim Technology / SPAEmpresarial
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>
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
