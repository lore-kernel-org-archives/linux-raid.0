From: Neil Brown <neilb@suse.de>
Subject: Re: First RAID Setup
Date: Mon, 19 Dec 2005 12:02:30 +1100
Message-ID: <17318.1702.810296.329634@cse.unsw.edu.au>
References: <0481A62A3E95A044AC20A1A45899645C06B02F4B@glc-mail-1.tessco.com>
	<43A1D642.2010301@wasp.net.au>
	<43A1E0CE.7090805@medien.uni-weimar.de>
	<17314.7734.707554.88728@cse.unsw.edu.au>
	<43A275EA.9020104@medien.uni-weimar.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tobias Hofmann on Friday December 16
Sender: linux-raid-owner@vger.kernel.org
To: Tobias Hofmann <tobias.hofmann@medien.uni-weimar.de>
Cc: Brad Campbell <brad@wasp.net.au>, "Callahan, Tom" <CallahanT@tessco.com>, 'Andargor The Wise' <andargor@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday December 16, tobias.hofmann@medien.uni-weimar.de wrote:
> >>
> >>- How would one "switch" from the latter to the former? Is there 
> >>something like "grow_to_RAID_6"?
> > 
> > 
> > No... at least not yet....
> 
> Hm. :) Around here, it is pretty much Christmas time, with all the 
> "wishing" going on - hint, hint? ;)
> 

Growing a raid5 to a raid6 with the same amount of data is only really
achievable if we use a modified raid6 layout with the Q syndrome all
on the one drive (a bit like raid4 which has parity all on the one
drive).
This gives you the better redundancy, but you have a hot-spot for
writes and don't distribute the reads any better.

This sort of conversion may be available in a couple of months.


Rearranging the data blocks is impractical as you need a temporary
storage:
    copy to blocks somewhere else and be sure they are safe
    there.  Then copy them back and be sure they are safe in the new
    place. 
Without this it is not possible to be sure to survive a crash.

Converting a raid5 to a raid6 with 2 extra drives (thus having more
space as well as more redundancy) is a possibility as the extra space
can be effectively used to keep to old copy of a stripe safe while
writing the new copy.

This sort of conversion is planned, but will take somewhat longer.

NeilBrown
