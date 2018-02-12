From: Marc MERLIN <marc@merlins.org>
Subject: Re: force remapping a pending sector in sw raid5 array
Date: Mon, 12 Feb 2018 09:30:38 -0800
Message-ID: <20180212173038.GB15015@merlins.org>
References: <20180206181416.amo6geclrvc6ylrf@merlins.org> <1934212.TzpEgCIeIR@matkor-lenovo> <fae4eb2a-59dc-9788-31ff-2b90d24328b9@turmel.org> <3275011.qXpCPUrKDu@matkor-lenovo> <0780e95c-ae84-4b2b-0222-f59df368a2ee@turmel.org> <20180212164933.GA15015@merlins.org> <6c416847-23d2-93c5-0512-c24751959eea@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6c416847-23d2-93c5-0512-c24751959eea@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Mateusz Korniak <mateusz-lists@ant.gliwice.pl>, Kay Diederichs <kay.diederichs@uni-konstanz.de>, Andreas Klauer <Andreas.Klauer@metamorpher.de>, Adam Goryachev <mailinglists@websitemanagers.com.au>, Roger Heflin <rogerheflin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 12, 2018 at 12:16:15PM -0500, Phil Turmel wrote:
> On 02/12/2018 11:49 AM, Marc MERLIN wrote:
> > On Mon, Feb 12, 2018 at 10:29:20AM -0500, Phil Turmel wrote:
> >>> Is there any option for mdadm --monitor to send warning e-mail when bbl entry 
> >>> is added? (I can't see anything regarding bbl in mdadm --monitor section) ?
> >>
> >> No.  The feature is incomplete.  The only mitigation is to turn it off.
> > 
> > I had a quick look but didn't really find how to turn it off after the fact
> > (not at array creation time, but after it's already been created).
> > 
> > Can you suggest how?
> 
> mdadm --assemble --update=no-bbl
 
Thanks.

> There's another (undocumented?) option required when there are entries
> in the list -- you'll have to dig that out for your situation.

That situation is gone, I was not able to clear the pending sectors even by
re-writing every block of the drive with badblocks, so I returned the drives
and got some better ones. 
Bad blocks on a "new" drive is bad enough, but then having the drive refuse
to remap them, or apparently in my case fail to update the smart counters
once the blocks were overwritten with good known data, is not ok.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
