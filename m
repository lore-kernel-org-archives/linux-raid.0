From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: Looking for some help with device options
Date: Wed, 26 May 2004 22:12:09 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <878yffcrqe.fsf@enki.rimspace.net>
References: <AF4CBD49C827BA4F9BDD00E297CD804802624917@adsms01.dyn.datasys.swri.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26 May 2004, Ewan R. Grantham wrote:
> Am setting up a test machine for some writing I am doing, and the idea
> is to do some RAID things without messing up my main machine and array
>
> For the test machine I have three external firewire drives. The
> "opportunity" here is that two of them are 200 Gigs, and the other one
> is 80 Gigs.

[...]

> I thought about mixing RAID types on the drives so that I would have a
> RAID-5 of 80 Gig partitions, and then RAID-1 the remaining 120 Gig on
> the two 200 Gig drives. But that strikes me as going particularly far
> out on the limb.

Actually, that is the setup I would chose for this. It provides the
greatest degree of protection against drive failure possible for each
chunk of space, and provides the largest effective storage space for
each MD device.

The many 40GB partitions idea seems ... more complex, and less useful.

    Daniel
-- 
We live in a hallucination of our own devising.
        -- Alan Kay

