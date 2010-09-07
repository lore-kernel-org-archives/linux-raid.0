From: Iordan Iordanov <iordan@cdf.toronto.edu>
Subject: Re: 3-way mirrors
Date: Tue, 07 Sep 2010 12:07:48 -0400
Message-ID: <4C866354.3050904@cdf.toronto.edu>
References: <20100907141904.3696.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100907141904.3696.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi George,

Due to the widely reported mismatch problems with RAID5, we also went 
with a 3-way mirror design. We have not yet developed a good way of 
dealing with the inevitable mismatches which will occur with some drive 
in a 3-way mirror, but we have some (crude) ideas.

George Spelvin wrote:
> Anyway, one nice property of a 2-drive redundancy (3+-way mirror or
> RAID-6) is error detection: in case of a mismatch, it's possible to
> finger the offending drive.

When we see a mismatch_cnt > 0, we would run a dd/cmp script which would 
detect the drive and sector which is mismatched (i.e. we would craft a 
script which runs three dd processes in parallel, reading from each 
drive, and compares the data).

When an inconsistency is discovered, we would have the sector which 
doesn't match, and which drive it's on. However, even at 60MB/s, this 
would take 5 hours to perform with our 1TB drives. So, it would be much 
better if we could do this while we are up, somehow.

Once we have the drive and sector, we can take the array down, and 
quickly dd the sector from one of the drives onto the one with the mismatch.

> My understanding of the current code is that it just copies one mirror
> (the first readable?) to the others.  Does someone have a patch to vote
> on the data?  If not, can someone point me at the relevant bit of code
> and orient me enough that I can create it?

Resyncing an entire drive is probably not necessary with a mismatch, 
because you already know the rest of the drive is synced and can simply 
manually force a particular sector to match.

> (The other thing I'd love is a more advanced that can accept a
> block number found by "check" as a parameter to "repair" so I don't have
> to wait while the array is re-scanned.  Um... I suppose this depends on
> a local patch I have that logs the sector numbers of mismatches.)

Yes, but don't you run the risk of syncing the "bad" data from the 
mismatch drive to the other two drives if you do this automatically? 
Don't you also need a parameter to specify which drive to sync from?

At any rate, if the mismatch sector(s) are also logged during the array 
check, then resyncing this sector by hand would be easy and fast with 
minimal downtime. It would be great to have this functionality to start 
with.

Cheers!
Iordan
