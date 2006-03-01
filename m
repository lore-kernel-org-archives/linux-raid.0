From: Jens Axboe <axboe@suse.de>
Subject: Re: NCQ general question
Date: Wed, 1 Mar 2006 17:05:54 +0100
Message-ID: <20060301160554.GD4816@suse.de>
References: <5d96567b0602282304o558fb564jd72784bafdd289f5@mail.gmail.com> <440561CB.30201@yahoo.de> <4405A656.1030602@rtr.ca> <4405C41F.5060504@yahoo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4405C41F.5060504@yahoo.de>
Sender: linux-ide-owner@vger.kernel.org
To: Gentoopower <gentoopower@yahoo.de>
Cc: Mark Lord <liml@rtr.ca>, "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Mar 01 2006, Gentoopower wrote:
> I have two seagates in my box a 160GB 7200.7 and 160GB 7200.9(SATAII
> NCQ), using NFORCE4.
> I can defintely feel the speed difference between the two drives.

Well that can't be because of NCQ, since it isn't active :-)

> P.S. Just waiting to see NCQ support for my nforce system in libata:-)

Don't hold your breath, it's unlikely to get supported as nvidia wont
open the specs. ahci is a really really nice controller, if you want ncq
I suggest going with that. sil is probably the next in line for ncq
support.

-- 
Jens Axboe

