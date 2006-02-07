From: Hans Kristian Rosbach <hk@isphuset.no>
Subject: Re: Hard drive lifetime: wear from spinning up or rebooting vs
	running
Date: Tue, 07 Feb 2006 09:44:17 +0100
Message-ID: <1139301857.10590.55.camel@linux>
References: <Pine.LNX.4.44.0602022119380.12829-100000@firewall2.tmr.com>
	 <43E68D62.4080704@cogweb.net>
	 <Pine.GSO.4.62.0602061105300.14030@shaka.acc.umu.se>
	 <43E77D35.1040905@cogweb.net>  <fd8d0180602060912q6181d52bs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180602060912q6181d52bs@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2006-02-06 at 18:12 +0100, Francois Barre wrote:
> 2006/2/6, David Liontooth <liontooth@cogweb.net>:
> > how long do modern hard drives last in cold storage?
> Demagnetation ?
> A couple of years back in time, there were some tools to read and then
> rewrite floppy contents to remagnet the floppy content. I guess it
> shall be the same for the drive : periodically re-read and re-write
> each and every sector of the drive to grant a good magnetation of the
> surface.
> I would not give more than 100 years for a drive to lose all its
> content by demagnetation... Anyway, in 100 years, no computer will
> have the controllers to plug a sata nor a scsi :-p.
> I guess a long-living system should not stay cool, and
> re-activate/check its content periodically...

A program called Spinrite can fix such floppies (have done several
times for me. Even floppies I formatted just 15min ago and suddenly
cannot be read in another computer. One swipe with spinrite and it
worked 100%.

It also can remagnetise and even exercise bad sectors on HDDs.
I have tried this on about 20 working disks now, and it has found
blocks that were hard to read on 4 of them. These were fixed using
statistical recovery. After running it again a week later it found
nothing wrong with the disk.

http://grc.com/spinrite.htm
PS: The website looks a bit suspect, but the program actually does
work as advertised as far as I have found.

PS: Seems it does not like some adaptec scsi cards, no matter what
    disk I tested it got read errors on every sector. Both disks and
    controllers works fine for booting Linux/Windows so I guess it's
    the scsi bios/dos interaction that is making problems for Spinrite.

> > we now know home-made CDs last a couple of years.
> I thought it was said to be at least a century... But with the
> enormous cost reduction operated in this area, it's no surprise the
> lifetime decreased so much.

I've seen cd's be destroyed just because of morning moisture. The
up-side (reflective side) is often unprotected and _very_ sensitive
to moisture. Imagine sprinklers going off in your offices, how much
valuable data is on those cds you do not store in a safe?

I have heard that some recovery companies can recover data from
such damaged cds since the data is not stored in the reflective layer.
But I imagine it is a very costly experience.

