From: Jurriaan <thunder7@xs4all.nl>
Subject: Re: 3 disk raid-5 without parity
Date: Mon, 14 Jun 2004 14:42:08 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040614124208.GA5160@middle.of.nowhere>
References: <20040614111920.GA17785@middle.of.nowhere> <16589.36817.228645.72611@cse.unsw.edu.au>
Reply-To: Jurriaan <thunder7@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16589.36817.228645.72611@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Neil Brown <neilb@cse.unsw.edu.au>
Date: Mon, Jun 14, 2004 at 09:45:21PM +1000
> On Monday June 14, thunder7@xs4all.nl wrote:
> > I am trying to convince my boss our new database-server wants raid-0+1,
> > not raid-5, and I got an idea while reading endless articles about
> > raid-5 being slow when writing and management not listening.
> 
> You want numbers, not abstract arguments.
> 
> Configure your server with raid5 and do some performance measurements
> - preferably with your database suite.
> Then reconfigure with raid 0+1 and test again.
> 
> Show the numbers to your boss.  You get to choose which numbers to
> show :-)

yes - unfortunately, corporate IT gets to decide which hardware to test
on. Guess what? They just got a shiny new SAN with 140 Gb disks,
configured in raid-5. Not quite the raid-0+1 over 36 Gb disks I had in
mind :-(
Anyway, that was just an introduction - nu use regurgling that on the
list.

> I hope to release a "raid10" module for 2.6 within a couple of weeks.
> raid10 is basically a combination of raid1 and raid0 all in one module
> with some interesting geometry possibilities.  This particular
> geometry is one of the possibilities.
> 
I'm looking forward to that!

Kind regards,
Jurriaan
-- 
Anyone can build a fast processor. The trick is to build a fast system.
	Seymour Cray
Debian (Unstable) GNU/Linux 2.6.7-rc2-mm2 2x6078 bogomips load 2.49
