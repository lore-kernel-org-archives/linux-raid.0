From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Hi! Why having LSR's chunk size 2^n limitation?
Date: Tue, 18 Jan 2011 14:48:26 -0200
Message-ID: <AANLkTikSr3kpFzXKzmHZiKVAwA=141New=9Awqm5z2jW@mail.gmail.com>
References: <AANLkTi=Nk_4vNH5BpHj5fMJxOaSAGjuiSD8agbACdzaQ@mail.gmail.com>
	<AANLkTimUq41Ki7A8=KvsmNUhCw1D9PiOjyVqHME1UvEz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimUq41Ki7A8=KvsmNUhCw1D9PiOjyVqHME1UvEz@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: for.poige+linux@gmail.com
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

start at make you hardware faster with your linux
after
make your device faster with your filesystem (xfs, reiserfs, ext4???)
after
make you application faster with your filesystem (for mysql: myisam
with fixed table type is faster than dynamic table type and faster
than aria(mariadb) page table type)


2011/1/18 Roberto Spadim <roberto@spadim.com.br>:
> performace increase=3D
> =A0 =A0 good algorithm for minimal read/write time
> =A0 =A0 +high speed disks (latency and read / write
> time/unit(bit,byte,page), latency =3D time to head position at the ri=
ght
> sector, cilinder, etc etc, read/write speed =3D time to read/write a
> block of bits/bytes/pages)
> =A0 =A0 + fast filesystem (without many writes like journaling... but
> it=B4s not crash safe....)
> =A0 =A0 + faster memory caches (for read we could cache information t=
hat
> don=B4t change... if it change on next read it will be cached)
>
> see that:
> filesystem is a upper level (not device level)
> cache is a under level (operational system level, maybe raid cache,
> maybe filesystem cache, maybe another cache)
> high speed disk (a physical level)
> algorithm (the raid level)
>
> we could implement raid at filesystem (ok it=B4s not mdadm)... (brtfs=
 if
> i=B4m not wrong, and fuse raid system (a userspace raid software usin=
g
> diferent filesystems))
> since we want speed, get it closer to hardware (device) like md linux=
 do
> better than it just a dedicated hardware (faster than your cpu+memory=
+linux)
>
> the problems are: more secure (file system/checksums/jornaling) =3D m=
ore
> writes, more writes =3D more i/o, more i/o =3D more reads/writes =3D =
less
> usefull information (file).
> got?
>
>
>
> 2011/1/18 Igor Podlesny <for.poige+linux@gmail.com>:
>> =A0 I had experience of using FreeBSD's vinum (another software RAID=
).
>> Its author, Greg Lehey, stated in vinum's manual: "... A good
>> guideline for stripe size is between 256 kB and 512 kB. =A0Avoid pow=
ers
>> of 2, however: they tend to cause all superblocks to be placed on th=
e
>> first subdisk. ..."
>>
>> =A0 Meanwhile, with LSR we're given exactly 2^n choices, for e. g.,
>> neither 768 KiB, nor 387 KiB won't go: "mdadm: invalid chunk/roundin=
g
>> value: 387".
>>
>> =A0 So, why... ($Subj) and how complex would it be to abolish this
>> restriction? I think this could be a key to performance increase.
>>
>> =A0 P. S. Thanks a ton for LSR, Neil, BTW. :-)
>>
>> --
>> End of message. Next message?
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
