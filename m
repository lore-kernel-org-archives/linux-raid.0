From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Adaptive throttling for RAID1 background resync
Date: Fri, 18 Mar 2011 18:02:32 -0300
Message-ID: <AANLkTi=hWoX5vJck6FQBKVZtAFzBnW0qO0BvcEznKQu5@mail.gmail.com>
References: <201103181549.20835.xavier@alternatif.org>
	<10FC03A59E498D4A90A45E4A105AD3ED02EE70F539@EXCH-MBX-2.vmware.com>
	<AANLkTimGL7kDBWSkVeDZSbc-JvnZmds-5a7UBHcv0iar@mail.gmail.com>
	<10FC03A59E498D4A90A45E4A105AD3ED02EE70F540@EXCH-MBX-2.vmware.com>
	<AANLkTikciXvH49wgn9QFmUY+Mby5QhEKQgUJQDLBvL1r@mail.gmail.com>
	<10FC03A59E498D4A90A45E4A105AD3ED02EE70F560@EXCH-MBX-2.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <10FC03A59E498D4A90A45E4A105AD3ED02EE70F560@EXCH-MBX-2.vmware.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hari Subramanian <hari@vmware.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

humm, let=B4s wait anothers ideas from list

2011/3/18 Hari Subramanian <hari@vmware.com>:
> Roberto, I still think the solution you point out has the potential f=
or throttling foreground IOs issued to MD from the filesystem as well a=
s the MD initiated background resyncs. So, I don't want to limit the IO=
 queues, esp since our foreground workload involves a LOT of small rand=
om IO.
>
> Thanks
> ~ Hari
>
> -----Original Message-----
> From: rspadim@gmail.com [mailto:rspadim@gmail.com] On Behalf Of Rober=
to Spadim
> Sent: Friday, March 18, 2011 4:36 PM
> To: Hari Subramanian
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Adaptive throttling for RAID1 background resync
>
> hum, it=B4s not a io queue size (very big ram memory queue) problem?
> maybe getting it smaller could help?
> resync is something like read here write there, if you have write
> problem, read should stop when async writes can=B4t work more (no ram
> memory)
> i=B4m right? if true, that=B4s why i think queue is a point to check
>
> 2011/3/18 Hari Subramanian <hari@vmware.com>:
>> Roberto, My use case involves both foreground and background resyncs=
 happening at the same time. So, by throttling it at the block or IO qu=
eues, I would be limiting my throughout for foreground IOs as well whic=
h is undesirable.
>>
>> ~ Hari
>>
>> -----Original Message-----
>> From: rspadim@gmail.com [mailto:rspadim@gmail.com] On Behalf Of Robe=
rto Spadim
>> Sent: Friday, March 18, 2011 4:29 PM
>> To: Hari Subramanian
>> Cc: linux-raid@vger.kernel.org
>> Subject: Re: Adaptive throttling for RAID1 background resync
>>
>> maybe this could be better solved at queue linux kernel area... at
>> elevators or block devices
>>
>> 2011/3/18 Hari Subramanian <hari@vmware.com>:
>>> I am hitting an issue when performing RAID1 resync from a replica h=
osted on a fast disk to one on a slow disk. When resync throughput is s=
et at 20Mbps min and 200Mbps max and we have enough data to resync, I s=
ee the kernel running out of memory quickly (within a minute). From the=
 crash dumps, I see that a whole lot (12,000+) of biovec-64s that are a=
ctive on the slab cache.
>>>
>>> Our guess is that MD is allowing data to be read from the fast disk=
 at a frequency much higher than what the slow disk is able to write to=
=2E This continues for a long time (> 1 minute) in an unbounded fashion=
 resulting in buildup of IOs that are waiting to be written to the disk=
=2E This eventually causes the machine to panic (we have panic on OOM s=
elected)
>>>
>>> From reading the MD and RAID1 resync code, I don't see anything tha=
t would prevent something like this from happening. So, we would like t=
o implement something to this effect that adaptively throttles the back=
ground resync.
>>>
>>> Can someone confirm or deny these claims and also the need for a ne=
w solution. Maybe I'm missing something that already exists that would =
give me the adaptive throttling. We cannot make do with the static thro=
ttling (sync_speed_max and min) since that would be too difficult to ge=
t right for varying IO throughputs form the different RAID1 replicas.
>>>
>>> Thanks
>>> ~ Hari
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
