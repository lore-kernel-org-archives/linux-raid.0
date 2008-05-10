From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Has anyone compared SWRAID for (JBOD@HW-RAID) vs. (Regular Sata PCI-e cards)?
Date: Sun, 11 May 2008 00:28:17 +0200
Message-ID: <20080510222817.GA26706@rap.rap.dk>
References: <181601c8b2a7$12fe0489$5209f40a@exchange.rackspace.com> <alpine.DEB.1.10.0805101014200.1844@p34.internal.lan> <4825D7DA.2050608@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4825D7DA.2050608@garzik.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, David Lethe <david@santools.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, May 10, 2008 at 01:14:02PM -0400, Jeff Garzik wrote:
> 
> And of course, there are plenty of other factors to consider.  I wrote a 
> bit on this topic at http://linux.yyz.us/why-software-raid.html

So that is you writing this page! I think it is one of the more useful
pages on raid (many others are quite outdated). 

I have a suggestion for an advantage for SW raid, that you could
consider for your page:

- potential for increased performance, due to more intelligent layouts,
  for example the linux raid10,f2 has more than double the performance
  for both sequential reads and random reads compared to most hardware
  RAID1, and Linux SW RAID1.

- potential for better error handling, due to more intelligent drivers.
  Linux raid10 has better error handling than linux RAID1 and possibly
  also HW RAID1.

And then, if you could link to our HOWTO pages at
http://linux-raid.osdl.org/ that would improve the visibility for our
pages. It seems like not many are referencing our pages, so if people on
this list would make a link to http://linux-raid.osdl.org/ that would
increase the chance of our information to be seen.

Best regards
keld
