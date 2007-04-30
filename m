From: David Greaves <david@dgreaves.com>
Subject: Re: RAID rebuild on Create
Date: Mon, 30 Apr 2007 21:12:21 +0100
Message-ID: <46364DA5.3070409@dgreaves.com>
References: <Pine.LNX.4.61.0704301958530.29151@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0704301958530.29151@yvahk01.tjqt.qr>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jan Engelhardt wrote:
> Hi list,
> 
> 
> when a user does `mdadm -C /dev/md0 -l <any> -n <whatever fits> 
> <devices>`, the array gets rebuilt for at least RAID1 and RAID5, even if 
> the disk contents are most likely not of importance (otherwise we would 
> not be creating a raid array right now). Could not this needless resync 
> be skipped - what do you think?
> 
> 
> Jan

This is an FAQ - and I'll put it there RSN :)

Here's one answer from Neil from the archives (google "avoiding the initial
resync on --create"):

Otherwise I agree.  There is no real need to perform the sync of a
raid1 at creation.
However it seems to be a good idea to regularly 'check' an array to
make sure that all blocks on all disks get read to find sleeping bad
blocks early.  If you didn't sync first, then every check will find
lots of errors.  Ofcourse you could 'repair' instead of 'check'.  Or
do that once.  Or something.

For raid6 it is also safe to not sync first, though with the same
caveat as raid1.  Raid6 always updates parity by reading all blocks in
the stripe that aren't known and calculating P and Q.  So the first
write to a stripe will make P and Q correct for that stripe.
This is current behaviour.  I don't think I can guarantee it will
never changed.

For raid5 it is NOT safe to skip the initial sync.  It is possible for
all updates to be "read-modify-write" updates which assume the parity
is correct.  If it is wrong, it stays wrong.  Then when you lose a
drive, the parity blocks are wrong so the data you recover using them
is wrong.

In summary, it is safe to use --assume-clean on a raid1 or raid1o,
though I would recommend a "repair" before too long.  For other raid
levels it is best avoided.

