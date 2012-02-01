From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: rebuild raid6 after two failures
Date: Tue, 31 Jan 2012 20:42:28 -0800
Message-ID: <kesmv8xc66.ln2@goaway.wombat.san-francisco.ca.us>
References: <8eekv8xpcn.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2012-01-31, Keith Keller <kkeller@wombat.san-francisco.ca.us> wrote:
>
> I recently had a RAID6 lose two drives in quick succession, with one
> spare already in place.  The rebuild started fine with the spare, but
> now that I've replaced the failed disks, should I expect the current
> rebuild to finish, then rebuild on another spare?

[snip]

Well, for better or worse, this is now a moot question--I had another
drive kicked out of the array, I believe prematurely by the controller.
I was able to --assemble --force the array, and it is now rebuilding
two spares instead of one.  AFAIR there was no activity on the
filesystem at the time, so I am optimistic that the filesystem should be
fine after an fsck.  Thanks to the advice from last time which suggested
--assemble --force instead of --assume-clean in this situation.

Could it have been the older version of mdadm that didn't tell the
kernel to start rebuilding the added spare?  I have made 3.2.3 my
default mdadm, which I hope alleviates some of the issues I've had with
rebuilds not starting.  (As an aside, I've also bitten the bullet and
decided to swap out all the WD-EARS drives for real RAID drives; ideally
I'd replace the controller, but I don't want to invest the time needed
to replace and test all the components properly.)

--keith


-- 
kkeller@wombat.san-francisco.ca.us


