From: "Scott T. Smith" <scott@gelatinous.com>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Fri, 30 Jul 2004 01:14:15 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1091175254.12588.341.camel@tinny.home.foo>
References: <b476569a04072920533b757574@mail.gmail.com>
	 <200407300815.18296.mrwatts@fast24.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200407300815.18296.mrwatts@fast24.co.uk>
To: Mark Watts <mrwatts@fast24.co.uk>
Cc: Adam Hunt <kinema@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2004-07-30 at 00:15, Mark Watts wrote:
> > I'm looking at building what I guess you could call a budget NAS
> > array.  I'm looking to start with four 250MB SATA drives on 3ware
> > 8506-4LP controller.  I eventually want to move to eight drives in the
> > box.  Is there any reason to expect that the performance of eight
> > drives spread across two 8506-4LP controllers is going to be any worse
> > then the same eight drives all on one 8506-8?

oh one thing I forgot -- are you going to use software RAID or hardware
RAID?  Because with hardware RAID, I don't think you can spread a RAID
across two controllers.  That might affect your decision.

> With the performance issues I'm seeing with the 8506-4LP's I have, I wouldn't 
> recommend them to anyone currently...
> 
> The thread on LKML from a few days ago about mke2fs -j and 8506-4LP says it 
> all, but basically and reasonable amount of I/O brings a Dual Opteron system 
> to its knees.
> And by reasonable I mean copying ISO images from a usb2 drive to a raid 5 (4 x 
> 250GB maxtor) or even just formatting a 600MB partition.

I've been able to get nearly 1.5 Gbits/sec off of an 8506-8, with 8
250GB disks...  of course those are all 1 megabyte reads (but from
random locations).  Is your problem related to # of IO's, or size of
transfer?

	Scott


