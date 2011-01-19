From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: RAID0 - cache
Date: Wed, 19 Jan 2011 19:35:57 -0200
Message-ID: <AANLkTimGp+P1kkq0UQKQ7FHiGi7vwGiGnBZvEoOMWeVA@mail.gmail.com>
References: <AANLkTik7xBOYVgZJC0sStpK=oPHdX53XzwYC5CVDKy_v@mail.gmail.com>
	<20110120072016.1b2162c8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110120072016.1b2162c8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

there=B4s a forum (linux kernel) for ideas?

2011/1/19 NeilBrown <neilb@suse.de>:
> On Wed, 19 Jan 2011 18:13:23 -0200 Roberto Spadim <roberto@spadim.com=
=2Ebr>
> wrote:
>
>> Hi guys, from a long email i will start this one: (the last one wasn=
=B4t send)
>>
>> think about this:
>>
>> /dev/sda (sata disk 1000gb size, latency of 1ms to move head, 100mb/=
s
>> to write/read)
>> /dev/sdb (ssd 1gb size, latency of <100us to find what flash and
>> position, 500mb/s to write/read)
>> ram memory (8gb size, with 1gb not used)
>> /dev/mdxxx (the new device i=B4m calling it as raid0-cache)
>>
>> how raid0-cache work?
>>
>>
>> how to create raid?
>> tell what the sequencial read cache estrategy:
>> memory(tell fixed memory size) - /dev/sdb - /dev/sda - another devic=
e
>> (maybe just 2 is suficiente /dev/sdb and /dev/sda)...
>>
>>
>> how to read?
>> first, read from the first read device (memory)
>> if information not there -> read from second read device (/dev/sdb),
>> update information at first read device, return the read value
>> if information not there -> read from third read device (/dev/sda),
>> update information at second and first read device, return the read
>> value
>>
>> how to write?
>> flush space from first read device to second read device
>> write to first read device, return OK
>>
>> background thread:
>> sync from first write device (memory) to second write device (/dev/s=
db)
>> flush from second write device (/dev/sdb) to third write device (/de=
v/sda)
>>
>> startup:
>> using cache:
>> =A0flush everythink from first write device (memory) to second write
>> device (/dev/sdb)
>> =A0flush everythink from second write device (/dev/sdb) to second wr=
ite
>> device (/dev/sda)
>> =A0since memory is volatille, at startup it can=B4be flushed...
>> without cache:
>> =A0make first write device unusable (memory)
>> =A0make second write device unusable
>> =A0here we can have write problems, since a wrong power off, can los=
t
>> information from cache (first and second write device)
>>
>>
>>
>> anyidea who can make it?
>
> "Hey, I've got this clever idea, I wish someone would implement it" a=
lmost
> always results in ... nothing.
> People with the ability to implement are much more interested in impl=
ementing
> their own ideas.
>
> But see also "bcache".
>
> NeilBrown
>
>> thanks
>> --
>> Roberto Spadim
>> Spadim Technology / SPAEmpresarial
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
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
