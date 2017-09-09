From: Marc MERLIN <marc@merlins.org>
Subject: Re: mismatch sector in range, kernel 4.13
Date: Sat, 9 Sep 2017 10:42:30 -0700
Message-ID: <20170909174230.fs5a5yhf66mucnlq@merlins.org>
References: <alpine.DEB.2.20.1709050824290.29378@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1709050824290.29378@uplift.swm.pp.se>
 <2e77897c-d111-ed9b-1319-2cc2bddceb76@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Howdy,

Thanks both for the answer.

On Mon, Sep 04, 2017 at 11:49:44PM -0400, Phil Turmel wrote:
> > Given this, what is the suggested course of action?
> 
> Do a "repair" scrub (once) instead of a check scrub to fix the parity.
> The data blocks themselves (the ones you care about) must be OK since
> btrfs is happy.
> 
> If future check scrubs keep running into this, investigate if the ranges
> reported are all falling on a particular disk, and look for hardware issues.

On Tue, Sep 05, 2017 at 08:25:58AM +0200, Mikael Abrahamsson wrote:
> If the data section is fine (which it seems to be because btrfs is happy),
> then you should issue "repair" to correct parity.
> 
> "echo repair > /sys/block/mdX/md/sync_action"

So you're both saying the same thing on how to fix it, but do we agree
that somehow it's my parity data that went wrong since the filesystem
seems fine?

Do we also agree that "mistmatch sector" means that the parity does not
add up, and that in a raid5 scenario, the md layer has no idea which of
the drives has bad data, just that things don't add up?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
