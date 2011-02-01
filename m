From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Performance question, RAID5
Date: Tue, 1 Feb 2011 11:53:25 -0200
Message-ID: <AANLkTim6+skZphsQSYYDPWS1iwYekvb6ATKkzsV+0EDw@mail.gmail.com>
References: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com>
	<20110130035352.1d72e8d1@natsu>
	<AANLkTi=ii-iLybJBS8ncajwXWZnkwLY=u0AcQiBJKPUf@mail.gmail.com>
	<20110130015231.GA1435@www2.open-std.org>
	<AANLkTimw6CTP66FZdbH07kjMmHoxoFRF6Eq9WDR_LYt8@mail.gmail.com>
	<20110130055616.GA13022@www2.open-std.org>
	<AANLkTi=CdiOjA15umaaO9ORDQ9StoesC2eD5q0_e3Bb0@mail.gmail.com>
	<4D47F086.9000308@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D47F086.9000308@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

if money isn=B4t a problem, buy only ssd =3D) they have ecc, faster
read/write, less latency, and a bigger MTBF (they are better!) and
they broken too, replace every 5 years to don=B4t have problems with
loose of information

2011/2/1 John Robinson <john.robinson@anonymous.org.uk>:
> On 30/01/2011 12:12, Mathias Bur=E9n wrote:
> [...]
>>
>> Ah, good point. The sda is a 60GB SSD, I should definitely move that
>> to the PCI-E card, as it doesn't do heavy IO (just small random r/w)=
=2E
>> Then i can have 4 RAID HDDs on the onboard ctrl, and 2 on the PCI-E
>> shared with the SSD. If the SSD is idle then I should get ideal
>> throughputs.
>
> Hmm, if you have an SSD, you might look at using bcache to speed up w=
rite
> access to your array. On the other hand, with only one SSD you potent=
ially
> lose redundancy - do SSDs crash and burn like hard drives do?
>
> If the SSD is only being used as a boot/OS drive - so near idle in no=
rmal
> use - I'd swap it for a cheap small laptop hard drive and find somewh=
ere
> else to put the SSD to better use.
>
> Cheers,
>
> John.
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
