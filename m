From: Tim Small <tim@seoss.co.uk>
Subject: Re: Device kicked from raid too easilly
Date: Tue, 08 Jun 2010 07:59:54 +0100
Message-ID: <4C0DEA6A.8070107@seoss.co.uk>
References: <1275702714.3740.55.camel@sibyl.beware.dropbear.id.au>	 <4C09FB3E.1090302@stud.tu-ilmenau.de> <1275974154.4313.72.camel@sibyl.beware.dropbear.id.au> <4C0DDB77.1070907@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C0DDB77.1070907@stud.tu-ilmenau.de>
Sender: linux-raid-owner@vger.kernel.org
To: st0ff@npl.de
Cc: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?= <stefan.huebner@stud.tu-ilmenau.de>, Ian Dall <ian@beware.dropbear.id.au>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/06/10 06:56, Stefan /*St0fF*/ H=FCbner wrote:
> But I wouldn't want to subject it to the cabling, because (well, I'm =
not
> 100% sure if that's right) slot #1's cable is the shortest.
>   =20

There are some scenarios where a shorter cable could show up a design=20
fault, when a longer cable wouldn't.  I'm not an expert by any means,=20
and just off the top of my head, perhaps:

Over-saturated inputs
Stronger signal reflections
Auto-termination problems

I've certainly heard of badly designed Ethernet devices not working wit=
h=20
very short cable lengths....

Tim.

--=20
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
