From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: how to set stride / raid-howto still up to date?
Date: Mon, 25 Sep 2006 00:40:43 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0609241829100.17345@coffee.psychology.mcmaster.ca>
References: <200609241503.09808.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200609241503.09808.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> "stride=stripe-size
>                          Configure  the  filesystem  for  a  RAID  array with
>                          stripe-size filesystem blocks per stripe."

my understanding (hey, I even had a quick look at the source) is that
you want blocksize * stripe-size = raid-stripe-size, where the latter 
is chunksize * num-data-elements.

> So, what is stripe size anyway? The same as chunk size?

I don't know whether there's any agreed-on terminology.  mke2fs wants to know
how many fs-blocks it'll take to span a whole set of raid chunks.  that is, 
a write of X will hit all the disks in parallel.  writes that are full-stripe
(and aligned) don't require the read-mod-write cycle.

> So going with -b 4096 for the ext3 with a 32k chunk size still comes down to a
> stride of 8, correct?

no, I don't think so - I think it should be chunksize*ndatadisks/fsblocksize...
