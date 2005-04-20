From: David Greaves <david@dgreaves.com>
Subject: Re: Questions about software RAID
Date: Wed, 20 Apr 2005 08:59:41 +0100
Message-ID: <42660BED.7000804@dgreaves.com>
References: <200504200415.j3K4FWm29946@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200504200415.j3K4FWm29946@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Frank Wittig' <fw@weisshuhn.de>, rv@eychenne.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy wrote:
> Well, I agree with KISS, but from the operator's point of view!
> 
> I want... <snip>

Fair enough.
But I think the point is - should you expect the mdadm command to do all 
that?
or do you think that it would make sense to stick with a layered 
approach that allows anything from my Zaurus PDA to an S390 mainframe to 
use basic md - with the S390 probably layering some management sw like 
EVMS over the top of md/mdadm.

The *nix command line tool philosophy has generally been "do one thing 
and do it well". It does provide some confusion for newbies when they 
see a collection of tools - but try running the one-liner - or numerous 
others like it - on OSes or tools that take the monolithic approach.

Also - should the LED control code be built into mdadm? And should Neil 
write it?
Is that for Dell controllers? or IBM ones? or SGI ones? what about my 
homemade parallel port one? What about controlling the LEDs on my PDA? 
Or should it be a seperate bit of code that needs a wrapper script and 
plugs in to a modular system like - you guessed it - EVMS.

And Guy, I know what *you* think :)
And I think the EVMS folk would accept patches for your suggestions - 
including any LED control ones.

I do think you would need to ask Neil to support
mdadm --sync-/dev/sdc-to-replace-/dev/sdg-even-though-/dev/sdg-is-fine
mdadm --use-/dev/sdc-and-make-/dev/sdg-spare

which would be especially useful if /dev/sdg were part of a shared 
spares pool.

David
