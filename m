From: Neil Brown <neilb@suse.de>
Subject: Re: First RAID Setup
Date: Fri, 16 Dec 2005 12:53:58 +1100
Message-ID: <17314.7734.707554.88728@cse.unsw.edu.au>
References: <0481A62A3E95A044AC20A1A45899645C06B02F4B@glc-mail-1.tessco.com>
	<43A1D642.2010301@wasp.net.au>
	<43A1E0CE.7090805@medien.uni-weimar.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tobias Hofmann on Thursday December 15
Sender: linux-raid-owner@vger.kernel.org
To: Tobias Hofmann <tobias.hofmann@medien.uni-weimar.de>
Cc: Brad Campbell <brad@wasp.net.au>, "Callahan, Tom" <CallahanT@tessco.com>, 'Andargor The Wise' <andargor@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday December 15, tobias.hofmann@medien.uni-weimar.de wrote:
> <delurk>
> 
> On 15.12.2005 21:46, Brad Campbell wrote:
> > Callahan, Tom wrote:
> > 
> >> It is always wise to build in a spare however, that being said about all
> >> raid levels. In your configuration, if a disk fails in your RAID5, your
> >> array will go down. RAID5 is usually 3+ disks, with a mirror. So you 
> >> should
> >> have 3 disks at minimum, and then a 4th as a spare.
> > 
> > /me wonders in the days of reliable RAID-6 why we use RAID-5 + spare?
> 
> Me too. ;) So, with holidays ahead, two questions (as I might tackle 
> that soon and have not found it mentioned):
> 
> - How would one "switch" from the latter to the former? Is there 
> something like "grow_to_RAID_6"?

No... at least not yet....

> - Does RAID6 have disadvantages wrt write speed?

Probably.  I haven't done any measurements myself, but from a
theoretical standpoint, you would expect raid6 to impose more CPU load
(though that may not be noticeable) and as raid6 need to see the whole
stripe to update the P and Q blocks (it cannot do a subtract old, add
new update) there could well be more IO happening, particularly on
large arrays (>5 devices).

Of course, whether this caused noticeable reduction in throughput and
latency would be very workload-dependant.

NeilBrown

