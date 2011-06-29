From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Software RAID and TRIM
Date: Wed, 29 Jun 2011 10:02:49 -0300
Message-ID: <BANLkTi=y=qGk6B9mpGMCGk07jN+-d-OQhg@mail.gmail.com>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk>
	<BANLkTimswAVra6qnMS4g8WRzs=dhi_f7OQ@mail.gmail.com>
	<alpine.OSX.2.00.1106291133060.257@trogdor.csi.cam.ac.uk>
	<iuf6me$9us$1@dough.gmane.org>
	<alpine.OSX.2.00.1106291348430.257@trogdor.csi.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.00.1106291348430.257@trogdor.csi.cam.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Tom De Mulder <tdm27@cam.ac.uk>
Cc: David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

nice,
anyone know if freebsd or netbsd or other o.s. have this (raid trim)
to do some benchmarks without losing our time developing?

2011/6/29 Tom De Mulder <tdm27@cam.ac.uk>:
> On Wed, 29 Jun 2011, David Brown wrote:
>
>>> While you are mostly correct, over time even consumer SSDs will end=
 up
>>> in this state.
>>
>> I don't quite follow you here - what state will consumer SSDs end up=
 in?
>
> Sorry, I meant to say "SSDs in typical consumer desktop machines". Th=
e state
> where writes are very slow.
>
>> Have you tried any real-world benchmarking with realistic loads with=
 a
>> single SSD, ext4, and TRIM on and off? =A0Almost every article I've =
seen on
>> the subject is using very synthetic benchmarks, almost always on win=
dows,
>> few are done with current garbage-collecting SSDs. =A0It seems to be=
 accepted
>> wisdom from the early days of SSDs that TRIM makes a big difference =
- and
>> few people challenge that with real numbers or real thought, even th=
ough the
>> internal structure of the flash has changed dramatically (transparen=
t
>> compression, for example, gives a completely different effect).
>>
>> Of course, if you /do/ try it yourself and can show clear figures, t=
hen
>> I'm willing to change my mind :-) =A0If I had a spare SSD, I'd do th=
e testing
>> myself.
>
> I have a set of 4 Intel 510 SSDs purely for testing, and I have used =
these
> to simulate the kinds of workload I would expect them to experience i=
n a
> server environment (focused mainly on database access). So far, those=
 tests
> have focused on using single drives (ie. without RAID) on a variety o=
f
> controllers.
>
> Once the drives get fuller (something which does happen on servers) I=
 do
> indeed see write latencies that are in the order of several seconds (=
I saw
> from 1500=B5s to 6000=B5s), as the drive suddenly struggles to free e=
ntire
> blocks, where initially latency was in the single digits.
>
> I am hoping to get my hands on some Sandforce controller-based SSDs a=
s well,
> to compare, but even they show degradation as they get fuller in Anan=
dTech's
> tests (and those tests seem, IME, trustworthy).
>
> My current plan is to sacrifice half the capacity by partitioning, st=
ick 2
> of them in md RAID1 (so, without TRIM) and over the next few days to =
run
> benchmarks over them, to see what the end result is.
>
>
> Best,
>
> --
> Tom De Mulder <tdm27@cam.ac.uk> - Cambridge University Computing Serv=
ice
> +44 1223 3 31843 - New Museums Site, Pembroke Street, Cambridge CB2 3=
QH
> -> 29/06/2011 : The Moon is Waning Crescent (18% of Full)



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
