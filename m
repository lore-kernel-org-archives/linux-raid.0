From: Marc MERLIN <marc@merlins.org>
Subject: Re: mdadm create corrupted md data?
Date: Wed, 7 May 2008 08:08:14 -0700
Message-ID: <20080507150814.GB21697@merlins.org>
References: <20080506054819.GA6413@merlins.org> <20080506230800.GL31536@merlins.org> <e9c3a7c20805062238l36674d8akffda7ea9aec78371@mail.gmail.com> <20080507065657.GA21697@merlins.org> <48217680.10903@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <48217680.10903@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Dan Williams <dan.j.williams@gmail.com>, linux-raid@vger.kernel.org, richard@sauce.co.nz
List-Id: linux-raid.ids

On Wed, May 07, 2008 at 10:29:36AM +0100, David Greaves wrote:
> Marc MERLIN wrote:
> > After that, I get my pv back, and my VG.
> > 
> > I did try an e2fsck -f -n -C 0 /dev/dshelf2/space when in the configuration
> > with sdd1 (i.e. the drive I first tried to rebuild parity on, until I found
> > out it was sde1 that had bad sectors), and it is showing some pretty scary
> > errors that probably show that my fs is mostly toast if I elect to use sdd1
> > instead of sde1.
> > Considering that sde1 is the soon to be dead drive, I guess backups is where
> > I go next.
> 
> I would obtain a replacement drive for sde and use gnu ddrescue (dd with error
> retries) to create an image on a reliable drive. Then re-create the array using
> the replaced sde instead of sdd. You should have more luck that way.
 
True, I could do that too.
 
> If you still have fsck issues then I'd suggest that the futzing around may have
> caused corruption.

No, that should work fine. The array works fine with sde, I'm just surprised
that it is now half corrupted if I use sdd instead. I'm not sure I
understand why, but I guess that drives the point that I should be even
more careful about which drive I select after a double failure.

Anyway, thanks for the suggestions.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems & security ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
