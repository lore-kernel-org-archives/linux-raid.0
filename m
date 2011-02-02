From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What's the typical RAID10 setup?
Date: Wed, 2 Feb 2011 14:13:52 -0200
Message-ID: <AANLkTinUMni5rNWKnc9CTH5rdaV83BQYHG=fikf9QqEV@mail.gmail.com>
References: <20110131203725.GB2283@www2.open-std.org>
	<AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com>
	<AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com>
	<AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com>
	<AANLkTi=kUGc8bjisn69BEEkZr6kcHUyfKnVZzNtgaJf3@mail.gmail.com>
	<20110131225235.GA11775@www2.open-std.org>
	<ii8lcv$3jg$1@dough.gmane.org>
	<AANLkTin1MPYZGMuL75c=_q+ndeiz0F5+eCRudpDdTwu9@mail.gmail.com>
	<4D4883A3.6030605@hardwarefreak.com>
	<AANLkTikcOA3hSwx29H++sayJ4PcY00_mQBw91TyYXO05@mail.gmail.com>
	<20110202092508.GA18517@cthulhu.home.robinhill.me.uk>
	<AANLkTikjKp0C6TnT7TeGRBayS=dYONWNrb-9NA71tDSe@mail.gmail.com>
	<AANLkTi=p_ke0pJhpGBgfbL8Mw9pPtAdKSRLa_AxncGWs@mail.gmail.com>
	<AANLkTink1BTeCCewZe-TywWLQAqhi0=aBF4wnSnGJh7y@mail.gmail.com>
	<AANLkTim5Y3E0=DwBRU2Tk31R-1XNXKv50ZAzpPg73Fy0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTim5Y3E0=DwBRU2Tk31R-1XNXKv50ZAzpPg73Fy0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

ssd time to make head positioning (latency): <0.1ms
hd max time to make head positioning (latency): 10ms

ssd rate of read: 270MB/s random/sequential read (excluding latency)
check that ssd is BLOCK (4kb mostly) oriented
hd rate of read? 130MB/s sequential read? check that hd is BIT oriented
write rate? random/sequencial?

with these answers we can make a simple 'time' model of read/write,
per device (use of raid0 (/dev/md0) is a device!, raid1 too
(/dev/md1), raid5 (/dev/md2) ,raid6 (/dev/md3)) any device have this
variables...
just make a model and use the model to optimize minimal time to
execute write/read

2011/2/2 Roberto Spadim <roberto@spadim.com.br>:
> pros against closest head:
> since we can use raid1 with identical disks (buyed at same time, with
> near serial numbers) we can have disks with same time to fail
> using closest head, the more used disk, will fail first
> failing first we have time to change it (while the second isn't as
> used as first device)
>
> but, think about it...
> it's like a write-mostly not?
>
>
> 2011/2/2 Roberto Spadim <roberto@spadim.com.br>:
>> check that, read balance is:
>> time based
>> closest head
>> round robin
>> algorithms
>>
>> plus....
>> failed device problem and write-mostly
>>
>> with time based we can drop write-mosty.... just make the time of th=
at
>> device very high
>>
>>
>> 2011/2/2 Roberto Spadim <roberto@spadim.com.br>:
>>> it's cpu/mem consuming if use a complex model, and less cpu/mem
>>> consuming if use a single model
>>>
>>> another idea....
>>> many algorithm....
>>>
>>> first execute time based
>>> it selected a bug (failed) device
>>> execute closest head
>>> if selected a bug (failed) device
>>> execute round robin
>>> if selected a bug (failed) device
>>> select first usable non write-mostly
>>> if selected a bug (failed) device
>>> select first usable write-mostly
>>> if end of devices, stop md raid
>>>
>>> to make this, today... we need a read_algorithm at
>>> /sys/block/md0/xxxxxx, to select what algorith to use, write algori=
thm
>>> is based on raid being used.. raid0 make linear and stripe, raid1 m=
ake
>>> mirror, there's no algorithm to use here...
>>> we need some files at /sys/block/md0/xxx to manage 'devices' time
>>> model (parameters)
>>> we need a adaptive algorithm to update parameters and make it close=
st
>>> possible to real model of 'devices'
>>> a raid0 have global parameters, inside raid0 devices have per devic=
e parameters
>>> a raid1 over raid0, should use raid0 parameters
>>> raid0 over devices, should use devices parameters
>>>
>>>
>>> 2011/2/2 Roberto Spadim <roberto@spadim.com.br>:
>>>> time based: is the time to:
>>>> HD:head positioning , SSD: time to send command to ROM chip
>>>> HD:read/write time (disk speed - rpm), SSD: time to write/read (ti=
me
>>>> to ssd rom chip receive bytes)
>>>> that's time based
>>>>
>>>> what is fast por read?
>>>> consider that time based must know that disk is doing a I/O and th=
at
>>>> you have a time to end, this time to end is another time in algori=
thm
>>>>
>>>> for example:
>>>> NBD (network block device)
>>>> time to send read message + time to send command to rom or head po=
sitioning
>>>> read/write time: time to nbd server return the read/write bytes
>>>>
>>>> what algorithm should do?
>>>> calculate all time or all mirrors, including time to end current
>>>> request (if only one request could be processed, or if allow more =
than
>>>> 1 request, the time spent to start our command)
>>>> after all time calculated, select the minimal value/device
>>>>
>>>> that's time based
>>>> it's not based on round robin
>>>> it's not based on closest head
>>>> it's based on device speed to:
>>>> *(1)position head/send rom command
>>>> *(2)read/write time (per total of bytes read/write)
>>>> *(3)time to start out request command (if don't allow more than 1
>>>> request per time, don't have a device queue)
>>>>
>>>> the total time per device will tell us the best device to read
>>>> if we mix, nbd + ssd + hdd (5000rpm) + hdd(7500rpm) + hdd(10000rpm=
) +
>>>> hdd(15000rpm)
>>>> we can get the best read time using this algorithm
>>>> the problem? we must run a constante benchmark to get this values =
*(1)
>>>> *(2) *(3) and calculate good values of time spent on each process
>>>>
>>>> resuming... whe need a model of each device (simple-constants or v=
ery
>>>> complex-neural network?), and calculate time spent per device
>>>> nice?
>>>>
>>>>
>>>> 2011/2/2 Robin Hill <robin@robinhill.me.uk>:
>>>>> On Tue Feb 01, 2011 at 09:12:11PM -0200, Roberto Spadim wrote:
>>>>>
>>>>>> but the best algorithm is time based (minimize time to access da=
ta)
>>>>>>
>>>>> And what do you think takes the time accessing the data? =A0In a =
rotating
>>>>> disk, it's moving the heads - that's why the current strategy is =
nearest
>>>>> head. =A0In an SSD there's no head movement, so access time shoul=
d be the
>>>>> same for accessing any data, making it pretty much irrelevant whi=
ch
>>>>> strategy is used.
>>>>>
>>>>> Cheers,
>>>>> =A0 =A0Robin
>>>>>
>>>>
>>>>
>>>>
>>>> --
>>>> Roberto Spadim
>>>> Spadim Technology / SPAEmpresarial
>>>>
>>>
>>>
>>>
>>> --
>>> Roberto Spadim
>>> Spadim Technology / SPAEmpresarial
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
