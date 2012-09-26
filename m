From: keld@keldix.com
Subject: Re: bug: 4-disk md raid10 far2 can be assembled clean with only two disks, causing silent data corruption
Date: Wed, 26 Sep 2012 11:08:03 +0200
Message-ID: <20120926090803.GA21499@www5.open-std.org>
References: <50606207.7040804@gooseman.cz> <20120925141959.0c22de7d@notabene.brown> <alpine.DEB.2.00.1209250658250.13902@uplift.swm.pp.se> <152edbf7bdad33717477f174f94116b7@192.168.93.35> <20120925223227.130ef8e3@notabene.brown> <50628B39.90205@gooseman.cz> <20120926154107.1568a115@notabene.brown> <20120926082848.GA18616@www5.open-std.org> <5062C3FE.7090906@yuiop.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5062C3FE.7090906@yuiop.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@yuiop.co.uk>
Cc: NeilBrown <neilb@suse.de>, Jakub Hus?k <jakub@gooseman.cz>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Sep 26, 2012 at 09:59:42AM +0100, John Robinson wrote:
> On 26/09/2012 09:28, keld@keldix.com wrote:
> [...]
> >I also understand it now, I think. raid10,f2 with 4 disks cannot in the 
> >current implementation
> >survive 2 failing disks.
> 
> It can, but only two non-adjacent discs. With 4 drives sda-sdd, than 
> means you can only lose both sda and sdc, or sdb and sdd.

Agree

> >We have discussed earlier how to implement raid10,far that would mean
> >better survival chances with more disks failing. This is not implemented 
> >yet.
> 
> No, but even if/when it is, there will still be some combinations of two 
> discs that you cannot afford to lose. The layout change to try to 
> improve redundancy will not be generic, as it doesn't work for an odd 
> number of discs, so the existing layout would have to be retained as an 
> option.

Well, at least for backward compatibility we need an option for the current layout.

For odd number of disks, I do think we can improve the chances for more failing disks, as
discussed earlier.


best regards
keld
