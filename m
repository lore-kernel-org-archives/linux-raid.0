From: Mark Lord <liml@rtr.ca>
Subject: Re: NCQ general question
Date: Wed, 01 Mar 2006 08:49:10 -0500
Message-ID: <4405A656.1030602@rtr.ca>
References: <5d96567b0602282304o558fb564jd72784bafdd289f5@mail.gmail.com> <440561CB.30201@yahoo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <440561CB.30201@yahoo.de>
Sender: linux-raid-owner@vger.kernel.org
To: Gentoopower <gentoopower@yahoo.de>
Cc: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

Gentoopower wrote:
> Raz Ben-Jehuda(caro) wrote:
>> i am thinking of buying a promise card sataII pcix.
>> they have two types, a card which support NCQ
>> and another that does not.
>> What is the bennifit of buying  a card with NCQ tagging ?
>>   
> How about: http://en.wikipedia.org/wiki/Native_command_queueing

Yuck.. what a lousy wiki entry.

NCQ vs. TCQ:  NCQ has a much more efficient low-level protocol,
making the host-side (controller, operating-system) quite a bit
simpler than with NCQ.

Both use 32-deep queue depths, and neither of them are worth a
damn on Linux yet.  Except possibly in the libata ahci driver,
or vendor-provided drivers (open source, even) for some chipsets.

In theory, NCQ/TCQ can speed up a very busy fileserver that is
handling mostly tiny I/O requests.  Practically no measurable
benefit for single-user systems.

Cheers
