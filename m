From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What's the typical RAID10 setup?
Date: Wed, 2 Feb 2011 14:00:15 -0200
Message-ID: <AANLkTikjKp0C6TnT7TeGRBayS=dYONWNrb-9NA71tDSe@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110202092508.GA18517@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

time based: is the time to:
HD:head positioning , SSD: time to send command to ROM chip
HD:read/write time (disk speed - rpm), SSD: time to write/read (time
to ssd rom chip receive bytes)
that's time based

what is fast por read?
consider that time based must know that disk is doing a I/O and that
you have a time to end, this time to end is another time in algorithm

for example:
NBD (network block device)
time to send read message + time to send command to rom or head positio=
ning
read/write time: time to nbd server return the read/write bytes

what algorithm should do?
calculate all time or all mirrors, including time to end current
request (if only one request could be processed, or if allow more than
1 request, the time spent to start our command)
after all time calculated, select the minimal value/device

that's time based
it's not based on round robin
it's not based on closest head
it's based on device speed to:
*(1)position head/send rom command
*(2)read/write time (per total of bytes read/write)
*(3)time to start out request command (if don't allow more than 1
request per time, don't have a device queue)

the total time per device will tell us the best device to read
if we mix, nbd + ssd + hdd (5000rpm) + hdd(7500rpm) + hdd(10000rpm) +
hdd(15000rpm)
we can get the best read time using this algorithm
the problem? we must run a constante benchmark to get this values *(1)
*(2) *(3) and calculate good values of time spent on each process

resuming... whe need a model of each device (simple-constants or very
complex-neural network?), and calculate time spent per device
nice?


2011/2/2 Robin Hill <robin@robinhill.me.uk>:
> On Tue Feb 01, 2011 at 09:12:11PM -0200, Roberto Spadim wrote:
>
>> but the best algorithm is time based (minimize time to access data)
>>
> And what do you think takes the time accessing the data? =A0In a rota=
ting
> disk, it's moving the heads - that's why the current strategy is near=
est
> head. =A0In an SSD there's no head movement, so access time should be=
 the
> same for accessing any data, making it pretty much irrelevant which
> strategy is used.
>
> Cheers,
> =A0 =A0Robin
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
