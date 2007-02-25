From: Mark Hahn <hahn@mcmaster.ca>
Subject: Re: PATA/SATA Disk Reliability paper
Date: Sun, 25 Feb 2007 18:58:56 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0702251827430.26920@coffee.psychology.mcmaster.ca>
References: <45D89FF5.3020303@sauce.co.nz> <200702252057.22963.a1426z@gawab.com>
 <Pine.LNX.4.64.0702251256060.21918@coffee.psychology.mcmaster.ca>
 <200702260007.10205.a1426z@gawab.com> <Pine.LNX.4.64.0702251643250.21918@coffee.psychology.mcmaster.ca>
 <45E211C7.7020800@monkeysushi.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45E211C7.7020800@monkeysushi.net>
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin Davenport <ben@monkeysushi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> | if a discrete resistor has a 1e9 hour MTBF, 1k of them are 1e6
>
> That's not actually true.  As a (contrived) example, consider two cases.

if you know nothing else, it's the best you can do.  it's also a 
conservative estimate (where conservative means to expect a failure sooner).

> distribution knowing only MTTF.  In fact, the recent papers on disk failure
> indicate that common assumptions about the shape of that distribution (either 
> a
> bathtub curve, or increasing failures due to wear-out after 3ish years) do 
> not hold.

the data in both the Google and Schroeder&Gibson papers are fairly noisy.
yes, the "strong bathtub hypthothesis" is apparently wrong (that infant
mortality is an exp decreasing failure rate over the first year, that
disks stay at a constant failure rate for the next 4-6 years, then have 
an exp increasing failure rate).

both papers, though, show what you might call a "swimming pool" curve:
a short period of high mortality (clock starts when the drive leaves 
the factory) with a minimum failure rate at about 1 year.  that's the 
deep end of the pool ;)  then increasing failures out to the end of 
expected service life (warranty period).  what happens after is probably
too noisy to conclude much, since most people prefer not to use disks 
which have already seen the death of ~25% of their peers.  (Google's 
paper has, halleluiah, error bars showing high variance at >3 years.)

both papers (and most people's experience, I think) agree that:
 	- there may be an infant mortality curve, but it depends on
 	when you start counting, conditions and load in early life, etc.
 	- failure rates increase with age.
 	- failure rates in the "prime of life" are dramatically higher
 	than the vendor spec sheets.
 	- failure rates in senescence (post warranty) are very bad.

after all, real bathtubs don't have flat bottoms!

as for models and fits, well, it's complicated.  consider that in a lot
of environments, it takes a year or two for a new disk array to fill.
so a wear-related process will initially be focused on a small area of 
disk, perhaps not even spread across individual disks.  or consider that
once the novelty of a new installation wears off, people get more worried
about failures, perhaps altering their replacement strategy...
