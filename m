From: =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mru@kth.se>
Subject: Re: SATA chipset recomendations
Date: Wed, 09 Jun 2004 13:36:25 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <yw1xhdtl55fq.fsf@kth.se>
References: <200406082012.58968.linux_mail@rozpooh.com> <yw1xise1tdif.fsf@kth.se>
 <1086777225.40c6e789ade9f@www.tastycake.net>
 <40C6ECEE.8090706@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves <david@dgreaves.com> writes:

> Nick Maynard wrote:
>
>>M=E5ns Rullg=E5rd wrote:
>>
>>
>>>I'm using a Highpoint RocketRAID 1540 without any problems.  There
>>>have been reports on this list from others having strange problems
>>>with Rocket 1540 (no fakeraid) cards.  <snip>
>>>
>>>
>>Yup - that was me.  The basic Rocket (not RocketRAID) 1540 card gave
>>me /very/ serious problems with Linux.  Really - don't play with it.
>>I managed to get mine RMA'd, but... blech.
>>
>>The Promise TX4 SATA150, on the other hand, has been nothing but a
>>pleasure to work with.  It's been recommended by many on this list
>>in the past, and I will now recommend it to you.  Yes, it's more
>>expensive, but you get what you pay for.
>>
>>
> I have one too - fairly happy (just having some raid5 resync issues
> but I'm doing some diagnostics and I doubt it's the card) :)
>
> I have wondered whether I'd have been better off with 2x Promise TX2s=
?
> I don't know where the bottleneck is with 4xSATA disks on a single
> Promise/PCI slot
> Or is it a single pci bus in which case the TX4 is fine?

=46or PCI transfers all cards share the same bus, so one or two cards
should give the same total bandwidth.

The reason I stay away from Promise cards is that I only got trouble
when I bought an UltraTX2 aka pdc20268 in the days when it was new and
hot.  It just would not work any faster than ata-33 without getting
numerous crc errors.  Maybe it wasn't compatible with the Alpha
machine, I don't know.

--=20
M=E5ns Rullg=E5rd
mru@kth.se

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
