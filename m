From: David Greaves <david@dgreaves.com>
Subject: Re: SATA chipset recomendations
Date: Wed, 09 Jun 2004 11:56:46 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40C6ECEE.8090706@dgreaves.com>
References: <200406082012.58968.linux_mail@rozpooh.com> <yw1xise1tdif.fsf@kth.se> <1086777225.40c6e789ade9f@www.tastycake.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1086777225.40c6e789ade9f@www.tastycake.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nick Maynard wrote:

>M=E5ns Rullg=E5rd wrote:
> =20
>
>>I'm using a Highpoint RocketRAID 1540 without any problems.  There
>>have been reports on this list from others having strange problems
>>with Rocket 1540 (no fakeraid) cards.  <snip>
>>   =20
>>
>Yup - that was me.  The basic Rocket (not RocketRAID) 1540 card gave m=
e /very/
>serious problems with Linux.  Really - don't play with it.  I managed =
to get
>mine RMA'd, but... blech.
>
>The Promise TX4 SATA150, on the other hand, has been nothing but a ple=
asure to
>work with.  It's been recommended by many on this list in the past, an=
d I will
>now recommend it to you.  Yes, it's more expensive, but you get what y=
ou pay
>for.
> =20
>
I have one too - fairly happy (just having some raid5 resync issues but=
=20
I'm doing some diagnostics and I doubt it's the card) :)

I have wondered whether I'd have been better off with 2x Promise TX2s?
I don't know where the bottleneck is with 4xSATA disks on a single=20
Promise/PCI slot
Or is it a single pci bus in which case the TX4 is fine?

David

>Cheers,
>
>--
>
>Nick Maynard
>nick.maynard@alumni.doc.ic.ac.uk
> =20
>
You too :)
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
