From: jimbob palmer <jimbobpalmer@gmail.com>
Subject: Re: Growing a raid array online with different capacity disks
Date: Thu, 10 Mar 2011 14:24:24 +0100
Message-ID: <AANLkTikPK+GZp9p1Z6wXio6tAQneQyp_EcE2j+HA2KXo@mail.gmail.com>
References: <AANLkTinpcNHZYTnhzv=61e_KAuNHm1j9dp4mQqcKOE_d@mail.gmail.com>
	<alpine.DEB.1.10.1103101356210.7942@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1103101356210.7942@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2011/3/10 Mikael Abrahamsson <swmike@swm.pp.se>:
> On Thu, 10 Mar 2011, jimbob palmer wrote:
>
>> i.e. 4x1tb disks, take out 1x1tb replace with 1x3tb disk, array grow=
s
>>
>> Does mdadm support this?
>
> No.
>
>> I searched the official faq and debian faq for expand and grow and
>> didn't find anything.
>
> How do you propose that a 4 drive RAID5 (giving you 3 tb usage) would
> redundantly give you more usable space by swapping out one drive for =
a
> larger one and still be fully redundant?

Oh I'm not proposing it, I'm asking if mdadm can do it, like the other
products can.

How do the others products manage it? x-raid I think one of them calls =
it.

>
> --
> Mikael Abrahamsson =A0 =A0email: swmike@swm.pp.se
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
