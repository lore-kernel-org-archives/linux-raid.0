From: "Rev. Jeffrey Paul" <sneak@datavibe.net>
Subject: Re: 3ware escalade vs software raid, from a different jeff
Date: Thu, 19 Feb 2004 12:56:30 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040219175630.GA20790@datavibe.net>
References: <Pine.LNX.4.44.0402191118090.10623-100000@praktifix.dwd.de> <Pine.LNX.4.58.0402190704420.25541@chaos.egr.duke.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0402190704420.25541@chaos.egr.duke.edu>
To: Joshua Baker-LePain <jlb17@duke.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 19, 2004 at 07:06:32AM -0500, Joshua Baker-LePain wrote:
>
> I fully agree on avoiding cheap "hardware" RAID cards.  Regarding drivers 
> going away, though, the 3ware drivers are open source and have been in the 
> kernel for a long time.  If 3ware were to disappear (unlikely), I'd be 
> willing to bet that the drivers stay supported by the community.
> 

I have always avoided the promise fasttrak cards for exactly that 
reason ("hardware" being in quotes).  It's my understanding that 
they're not much more than their udma cards with drivers that do most 
of the RAIDing.

It was also my understanding that the 3ware cards are true hardware 
raid and are up to the task of something like this, which would also 
explain why they're 4x the cost.

I am looking at a four disk raid5 or raid10, and it seems like 
the interrupt load from four drives on four channels might be a bit 
excesive.  I'm going to be running critical services on the machine 
that the drives are in (namely mysql and nfs) and don't want to worry 
about performance.

Am I thinking about this the wrong way?

-j

--
--------------------------------------------------------
 Rev. Jeffrey Paul    -datavibe-     sneak@datavibe.net
   aim:x736e65616b   pgp:0x15FA257E   phone:8777483467
    70E0 B896 D5F3 8BF4 4BEE 2CCF EF2F BA28 15FA 257E
--------------------------------------------------------
