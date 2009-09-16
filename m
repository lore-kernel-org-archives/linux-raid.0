From: Tom Carlson <twigathy@gmail.com>
Subject: Re: Port Multipliers
Date: Wed, 16 Sep 2009 19:02:07 +0100
Message-ID: <1f0f1a960909161102m62185206s3e8b3172e24054bc@mail.gmail.com>
References: <c268e4660909100556x14b48207w32017a59be889f@mail.gmail.com>
	 <4AAFFDC4.5090806@sauce.co.nz>
	 <72dbd3150909151452r38087573od156a1965dc0eba1@mail.gmail.com>
	 <D88C9CE6-0F7D-4E8D-B972-75A5012B921C@redhat.com>
	 <70ed7c3e0909151801y7fe7bbcap872af6c4f9f76590@mail.gmail.com>
	 <4D899658-EEA4-4511-87FF-9338E681D956@redhat.com>
	 <70ed7c3e0909151845r5903f0e4w4750b406c4f5d216@mail.gmail.com>
	 <1f0f1a960909160411r3489fddcrfe1e52350245fe60@mail.gmail.com>
	 <20C809AA-01E5-4402-928C-84F46F2489B9@redhat.com>
	 <87f94c370909160751i7319ca29x15198e7a5ae1a648@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370909160751i7319ca29x15198e7a5ae1a648@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>, "Majed B." <majedb@gmail.com>, David Rees <drees76@gmail.com>, Richard Scobie <richard@sauce.co.nz>, Drew <drew.kay@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> The wiki at <http://ata.wiki.kernel.org/index.php/Hardware,_driver_st=
atus#Hardware_support>
> has at least a couple comments about PMP throughput.

Well, the JMB360/362 are, according to that wiki page, AHCI-flavour
devices. Perhaps somebody else with another AHCI-driven PM capable
controller could do some tests too?

I have had a quick scout around the internet, a 2-port eSATA sii 3132
(PCI-e x1) seems to cost around =C2=A320. If it can do 120MB instead of=
 20
then I think it really would be worth getting :)

T
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
