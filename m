From: Neil Brown <neilb@suse.de>
Subject: Re: paralellism of device use in md
Date: Wed, 18 Jan 2006 10:04:52 +1100
Message-ID: <17357.30740.574254.703987@cse.unsw.edu.au>
References: <20060117120927.GU7017@strugglers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andy Smith on Tuesday January 17
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@lug.org.uk>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday January 17, andy@lug.org.uk wrote:
> I'm wondering: how well does md currently make use of the fact there
> are multiple devices in the different (non-parity) RAID levels for
> optimising reading and writing?

It does the best it can.  Every request from the filesystem goes
directly to which device it should.  Ofcourse if all the blocks the
filesystem requests happen to be on the same drive, there isn't alot
that md can do...


> 
> For example, are *writes* to a 2 device RAID-0 approaching twice as
> fast as to a single device?  If not, are they any faster at all?
> Are reads from a 2 device RAID-1 twice as fast as from a single
> device?  If there are benefits, how quickly do they degrade to
> nothing as disks are added?

Yes.  For a reasonably heavy loads both read and write will be close to
twice as fast on a 2 device RAID-0 compared to a single device
(providing that the buss doesn't become a bottleneck).

> 
> What does the picture look like for reads and writes to a 4 device
> RAID-10?

Much the same.

> 
> Sorry if my subject line isn't clear, but I coudn't think of a
> better way to put it.

Clear enough.


NeilBrown
