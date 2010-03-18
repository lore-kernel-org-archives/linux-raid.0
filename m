From: Neil Brown <neilb@suse.de>
Subject: Re: Possibility for a parallel relaxed RAID?
Date: Fri, 19 Mar 2010 08:54:14 +1100
Message-ID: <20100319085414.6cdddd29@notabene.brown>
References: <4BA27898.4010907@panix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BA27898.4010907@panix.com>
Sender: linux-raid-owner@vger.kernel.org
To: Berkey B Walker <berk@panix.com>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 18 Mar 2010 15:01:44 -0400
Berkey B Walker <berk@panix.com> wrote:

> There maybe many folks out there who want to use RAID on their personal, 
> non-production systems.  Assuming access and thru-put values are not 
> critical a problem might be "You can't use Desktop drives for RAID".  
> Which, I think, most of us know is not really true, but - - If the 
> timing issues were to be relaxed, allowing the drive to fix itself, 
> before being kicked by the md process, might not the average Joe be 
> better served?  There is a big difference between going a mile and 
> buying a commodity drive, and being "up" in an hour vs. finding a 
> working system, going online, paying price+, and getting/paying fast 
> shipping. Which might resolve the issue in days instead of hours.
> 
> Any possibility of a parallel, less critical to drive response, release 
> of md?  Or a patch to allow same?

This is not a function of 'md'.  md has no timeouts for drives responding.
It just submits a request and waits for a success/fail reply.

It may be a function of the lower level SATA/SCSI/FC/whatever driver.  You
would do better to ask the developers of those drivers, maybe start with the
maintainer of libata.

NeilBrown
