From: Christopher Smith <csmith@nighthawkrad.net>
Subject: Re: Recommendations for supported 4-port SATA PCI card ?
Date: Fri, 31 Mar 2006 23:38:37 +1100
Message-ID: <442D22CD.3010602@nighthawkrad.net>
References: <442BFB2B.6090903@stams.strath.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <442BFB2B.6090903@stams.strath.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ian Thurlbeck wrote:
> 
> Dear All
> 
> I have 4x500GB Maxtor SATA drives and I want to attach
> these to a 4-port SATA PCI card and RAID5 them using "md"
> 
> Could anybody recommend a card that will have out of
> box support on a Fedora system ?

I have had a lot of success with Promise TX4 cards, with the caveat that 
  more than two controllers can't be in the same box (or couldn't as of 
a few months ago - this may have been fixed).  They're fairly cheap and 
run on a 66Mhz PCI bus, if you've got one, whereas most of the other 
cheap cards are only regular 33Mhz.  Mine (with 4x250G 7200rpm drives) 
can sustain about 200MB/sec if configured in a RAID0.

I haven't seen a better card from a price/performance perspective if 
you're going to use md.

CS
