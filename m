From: =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mru@kth.se>
Subject: Re: Which raid card to buy for Sarge
Date: Fri, 16 Apr 2004 17:09:43 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <yw1x7jwg6jt4.fsf@kth.se>
References: <Pine.LNX.4.44.0403311442520.31572-100000@coffee.psychology.mcmaster.ca> <406B9F3E.4020701@wasp.net.au>
 <1082125542.407fece65df29@www.tastycake.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nick Maynard <nick.maynard@alumni.doc.ic.ac.uk> writes:

>> I used a pair of Highpoint Rocketraid 1540 cards with the Highpoint
>> driver (as it presented all 8 drives as 8 units on a scsi chain)
>> with linux md raid-5, and I have now moved onto 3 Promise
>> SATA150-TX4 units in an md raid-5.
> This is probably slightly off-topic, but has anyone heard of
> successful use of the Rocket 1540 (non-RAID, HPT374 based) card on
> Linux 2.6.x yet?

I'm running four disks off a RocketRAID 1540 SATA card with Linux
software RAID since kernel 2.6.0.  The driver included with the kernel
works just fine.  Any card using the hpt374 chip should work, whatever
the name on the box happens to be.

> Highpoint provides binary drivers for Redhat and SuSE, but no other
> distros and no source - anyone any idea where to get hold of
> functional drivers?

Perfectly good drivers are included with the kernel.

--=20
M=E5ns Rullg=E5rd
mru@kth.se

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
