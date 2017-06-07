From: Marc MERLIN <marc@merlins.org>
Subject: Re: 9 second recovery when re-adding a drive that got kicked out?
Date: Tue, 6 Jun 2017 20:03:25 -0700
Message-ID: <20170607030325.p6xrklioralqxqis@merlins.org>
References: <e70502a2-8bef-f771-6063-df0b0accc090@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e70502a2-8bef-f771-6063-df0b0accc090@turmel.org>
 <87r2yxdazc.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Phil Turmel <philip@turmel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jun 06, 2017 at 01:57:27PM +1000, NeilBrown wrote:
> > The first bitmap line shows 3 pages totallying 12KB, so each page
> > contains 4KB, or 2048 chunks per page.
> > Did the above say that I had 6144 chunks that needed to be synced?
> 
> No.  It said that of the 44 pages of space that might be needed to store
> 16-bit counters that each represent 1 bitmap-chunk, only 3 of those
> pages would contain non-zero counters, so only 3 had been allocated.
> 
> There could be as few as 3 chunks that need to be recovered, or there
> could be as many a 3*2048 chunks, or any number in between.
 
Ah, I see. I wasn't clear about that part, thanks.

> Had you run "mdadm --examine-bitmap /dev/sdk1" before the re-add, it
> would have told you how many bits were set at that time.

Noted for next time, thanks.

> > The part I'm not too clear about is 44 pages of intent isn't enough to
> > cover all my data.
> 
> 44 pages means 90112 16 bit counters, one for each 64M on each device.
> 90112 * 64M = 5632 GiB or 5905GB.
> That is the size of each device.

Ah, so it's not based on the 512k chunk size, I see. 

> One bit in the bitmap (one counter in the internal bitmap) corresponds
> to "a set of data the might be out of sync" which, in your case, is a
> 64MB wide stripe across all devices.

I got that part now, just now where the 64MB came from, or how I ended
up with 44 pages of intent maps if it's not based on my chunk size.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
