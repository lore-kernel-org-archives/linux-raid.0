From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: write only raid1
Date: Wed, 10 Nov 2004 11:13:18 -0500
Message-ID: <1100103198.3190.68.camel@localhost.localdomain>
References: <1100096418.3190.4.camel@localhost.localdomain>
	 <41922E3E.7050206@steeleye.com>
	 <1100101541.3190.51.camel@localhost.localdomain>
	 <41923A34.5000709@steeleye.com>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41923A34.5000709@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i now understand what you mean. i saw that async write operation and i
do not realize that is what u think write only.

so base on the patch, since i already know exactly that one device will
never be read. a simpler way might be

1) modify mdadm to allow one device to be configured as write only
2) add a write only flag in device info and check the flag when do read
balance.

so no need to update the time at all if no persistent bitmap purpose.

i saw the 2.4.x kernel raid has write only flag while dropped in 2.6.x.
i guess that is for reconstruction. but we can make use of that for this
purpose as well.

"write only" can be part of the async write or async replication. but i
think raid1 code should be able to allow write only to be a standalone
feature so others may have their own async write solution.

ming



On Wed, 2004-11-10 at 10:56, Paul Clements wrote:
> Ming Zhang wrote:
> > On Wed, 2004-11-10 at 10:05, Paul Clements wrote:
> > 
> >>Ming Zhang wrote:
> >>
> >>
> >>>is there any technical issue that lead not to be implemented?
> >>
> >>No. In fact, it has been implemented. Both Peter T. Breuer and I have 
> >>come up with slightly different patches to implement the write only 
> >>functionality.
> >>
> > 
> > can u send me the patch then i can have a look?
> 
> my patches are here:
> 
> http://parisc-linux.org/~jejb/md_bitmap/
> 
> you're looking for the async write portion of the code, which has the 
> write-only functionality in it (later patches do not contain that code, 
> so look at the older ones)
> 
> check the mailing list archives for discussion
> 
> Peter's patch is here:
> 
> http://marc.theaimsgroup.com/?l=linux-raid&m=109238533827986&w=2
> 
> 
> --
> Paul

