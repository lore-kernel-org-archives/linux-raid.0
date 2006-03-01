From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: NCQ general question
Date: Wed, 01 Mar 2006 11:20:26 -0500
Message-ID: <4405C9CA.9020500@pobox.com>
References: <5d96567b0602282304o558fb564jd72784bafdd289f5@mail.gmail.com> <440561CB.30201@yahoo.de> <4405A656.1030602@rtr.ca> <4405C41F.5060504@yahoo.de> <20060301160554.GD4816@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060301160554.GD4816@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Gentoopower <gentoopower@yahoo.de>, Mark Lord <liml@rtr.ca>, "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

Jens Axboe wrote:
> On Wed, Mar 01 2006, Gentoopower wrote:
>>P.S. Just waiting to see NCQ support for my nforce system in libata:-)
> 
> 
> Don't hold your breath, it's unlikely to get supported as nvidia wont
> open the specs. ahci is a really really nice controller, if you want ncq
> I suggest going with that. sil is probably the next in line for ncq
> support.


Actually.....

* Old-nvidia is ADMA, and I have docs under NDA

* nvidia themselves say they are uninterested in NCQ support for their 
older ADMA controllers, though they don't mind if I implement it

* New-nvidia is AHCI, and thus will support NCQ when AHCI does

* slight correction to the above:  sil24 will do NCQ, I don't think sil does

	Jeff


