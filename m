From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Wed, 29 Apr 2009 19:55:09 -0500
Message-ID: <20090430005510167.LLPB6143@cdptpa-omta03.mail.rr.com>
References: <49F83944.8030302@anonymous.org.uk>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49F83944.8030302@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> >  Is it possible, then to use the 1T drives
> > combined with a like number of 1.5T to create a number (say, 6 or so) of
> > 2.5T LVM volumes and then use mdadm to create a RAID 5 array assembled
> from
> > the virtual volumes?
> 
> Yes, you could do that, though I think I'd use md to create 6 linear
> sets, which are then combined into a RAID 5; I imagine md will perform
> better than LVM for this task.

I hadn't thought of that.

> What I'd be much more inclined to do is create 2 RAID 5 sets, one of 1T
> discs, and one of 1.5T discs, then combine the two using LVM. It just
> feels more natural to me that way. In addition, while both setups will
> tolerate one disc failure, yours will then only tolerate one particular
> one of the remaining 11 failing (the companion drive in the LVM/linear
> pair), and mine will tolerate a failure of any drive on the other RAID-5.

I had thought of this, but then replacing the 1T + 1.5T pairs with 3T
drives, which I expect to happen eventually, will be more difficult.  I do
of course realize it is a bit more frail, but once again, to be devastating
it would have to have two drives fail during a period (as now) when the data
on the main array is incomplete or the main array has failed.

> Hope this is of interest.

Oh, you bet!

