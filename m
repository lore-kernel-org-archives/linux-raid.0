From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What's the typical RAID10 setup?
Date: Sun, 6 Feb 2011 12:30:17 -0200
Message-ID: <AANLkTimRuE=TbifcGjytdem+L503nfAH+GSiSRASGN+b@mail.gmail.com>
References: <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com>
	<4D475AB5.10600@hardwarefreak.com>
	<20110203110428.GA26762@www2.open-std.org>
	<4D4B3DAE.3070502@hardwarefreak.com>
	<20110204070613.GA3788@www2.open-std.org>
	<4D4BB87A.30800@hardwarefreak.com>
	<iigobc$n0n$2@dough.gmane.org>
	<20110204135343.GC4808@www2.open-std.org>
	<AANLkTikxybDGW3tOHvoy4tBTo1+OpLAUizno=VMp_exm@mail.gmail.com>
	<AANLkTimJaAXkWNDdjQ3E1fS01Cu9xx+=Vod7cx6DQKjp@mail.gmail.com>
	<20110206075816.GA32205@www2.open-std.org>
	<20110206170319.66306ed5@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110206170319.66306ed5@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>, Drew <drew.kay@gmail.com>, hansbkk@gmail.com, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

heehhee nice

guys i have changed raid1.c and raid1.h code
added new read_balance ffunctions
could every body test?
kernel 2.6.37
code at:
http://www.spadim.com.br/raid1/

2011/2/6 Roman Mamedov <rm@romanrm.ru>:
> On Sun, 6 Feb 2011 08:58:16 +0100
> Keld J=F8rn Simonsen <keld@keldix.com> wrote:
>
>> On Sat, Feb 05, 2011 at 08:02:02PM -0800, Drew wrote:
>> > > If you want to investigate further, here are the main brands, I
>> > > imagine most are running on Linux/mdadm-based firmware:
>> > >
>> > > Thecus, Qnap, Synology, Dlink, Buffalo, NetGear (was Infrant)
>> >
>> > I can confirm Buffalo & QNAP are both Linux based. Neither support
>> > RAID 10, just 0, 1, 5, and in the QNAP's case, 6.
>>
>> Do they have a ssh mode, where you can log in and do as you please?
>
> Most likely not in the stock configuration, but on some devices you c=
an
> replace the original firmware with something more advanced. For examp=
le, I
> have installed complete Debian Squeeze on my D-Link DNS-323 box, foll=
owing
> these instructions: http://www.cyrius.com/debian/orion/d-link/dns-323=
/
> It has a 500 MHz ARM CPU and 64 MB of RAM.
>
> --
> With respect,
> Roman
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
