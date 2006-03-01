From: Gentoopower <gentoopower@yahoo.de>
Subject: Re: NCQ general question
Date: Wed, 01 Mar 2006 16:56:15 +0100
Message-ID: <4405C41F.5060504@yahoo.de>
References: <5d96567b0602282304o558fb564jd72784bafdd289f5@mail.gmail.com> <440561CB.30201@yahoo.de> <4405A656.1030602@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4405A656.1030602@rtr.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

Mark Lord wrote:
> Gentoopower wrote:
>> Raz Ben-Jehuda(caro) wrote:
>>> i am thinking of buying a promise card sataII pcix.
>>> they have two types, a card which support NCQ
>>> and another that does not.
>>> What is the bennifit of buying  a card with NCQ tagging ?
>>>   
>> How about: http://en.wikipedia.org/wiki/Native_command_queueing
>
> Yuck.. what a lousy wiki entry.
>
> NCQ vs. TCQ:  NCQ has a much more efficient low-level protocol,
> making the host-side (controller, operating-system) quite a bit
> simpler than with NCQ.
>
> Both use 32-deep queue depths, and neither of them are worth a
> damn on Linux yet.  Except possibly in the libata ahci driver,
> or vendor-provided drivers (open source, even) for some chipsets.
>
> In theory, NCQ/TCQ can speed up a very busy fileserver that is
> handling mostly tiny I/O requests.  Practically no measurable
> benefit for single-user systems.
That's a lousy comment:-)

Single-User systems can have lots of I/O requests too.
If I compile something in the backround, listen to music, while copying
files from one drive to the other.
I also have lots of I/O while booting.
I have two seagates in my box a 160GB 7200.7 and 160GB 7200.9(SATAII
NCQ), using NFORCE4.
I can defintely feel the speed difference between the two drives.

P.S. Just waiting to see NCQ support for my nforce system in libata:-)
>
> Cheers
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



	

	
		
___________________________________________________________ 
Telefonate ohne weitere Kosten vom PC zum PC: http://messenger.yahoo.de

