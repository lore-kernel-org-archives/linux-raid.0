From: Jens Axboe <axboe@suse.de>
Subject: Re: NCQ general question
Date: Wed, 1 Mar 2006 19:53:13 +0100
Message-ID: <20060301185312.GI4816@suse.de>
References: <5d96567b0602282304o558fb564jd72784bafdd289f5@mail.gmail.com> <440561CB.30201@yahoo.de> <4405A656.1030602@rtr.ca> <4405C41F.5060504@yahoo.de> <20060301160554.GD4816@suse.de> <4405C9CA.9020500@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4405C9CA.9020500@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Gentoopower <gentoopower@yahoo.de>, Mark Lord <liml@rtr.ca>, "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Mar 01 2006, Jeff Garzik wrote:
> Jens Axboe wrote:
> >On Wed, Mar 01 2006, Gentoopower wrote:
> >>P.S. Just waiting to see NCQ support for my nforce system in libata:-)
> >
> >
> >Don't hold your breath, it's unlikely to get supported as nvidia wont
> >open the specs. ahci is a really really nice controller, if you want ncq
> >I suggest going with that. sil is probably the next in line for ncq
> >support.
> 
> 
> Actually.....
> 
> * Old-nvidia is ADMA, and I have docs under NDA
> 
> * nvidia themselves say they are uninterested in NCQ support for their 
> older ADMA controllers, though they don't mind if I implement it

So it's up to you if it'll happen or not. I'm sure people would
appreciate nforce NCQ support :-)

> * New-nvidia is AHCI, and thus will support NCQ when AHCI does

Great! The sane choice, for both producer and consumer.

> * slight correction to the above:  sil24 will do NCQ, I don't think sil does

Ok, it was more of an umbrella sil label, I haven't looked into specific
models.

-- 
Jens Axboe

