From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Mon, 3 Jan 2005 17:41:16 +1100
Message-ID: <16856.59660.57838.440787@cse.unsw.edu.au>
References: <m3is6k4oeu.fsf@reason.gnu-hamburg>
	<m38y7fn4ay.fsf@reason.gnu-hamburg>
	<v3rda2-hjn.ln1@news.it.uc3m.es>
	<41D45C1F.5030307@tls.msk.ru>
	<u59ea2-4qr.ln1@news.it.uc3m.es>
	<20050102194240.GE99565@caffreys.strugglers.net>
	<5h1ma2-asq.ln1@news.it.uc3m.es>
	<20050103003005.GG99565@caffreys.strugglers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andy Smith on Monday January 3
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@strugglers.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday January 3, andy@strugglers.net wrote:
> 
> I have no idea which of you to believe now. :(

Well, how about I wade in.....

(almost*) No block storage device will guarantee that write ordering
is maintained.  Neither will read requests necessarily be ordered.

Any SCSI, IDE, or similar disc drive in Linux (or any other non-toy
OS) will have requests managed by an "elevator algorithm" which
coalesces adjacent blocks and  tries to re-order requests to make
optimal use of the device.

A RAID controller, whether software, firmware, or hardware, will also
re-order requests to make best use of the devices.

Any filesystem that assumes that requests will not be re-ordered is
broken, as the assumption is wrong.
I would be *very* surprised if Reiserfs makes this assumption.

Until relatively recently, the only assumption that could be made is
that a write request will be handled sometime between when it is made,
and when the request completes (i.e. the end_io callback is called).
If several requests are concurrent they could commit in any order.

With only this guarantee, the simplest approach for a journalling
filesystem is to write the content of a journal entry, wait for the
writes to complete, and then write a single block "header" which
describes and hence commits that journal entry.  The journal entry is
not "safe" until this second write completes.

This is equally applicable for IDE drives, SCSI drives, software
RAID1, software RAID5, hardware RAID etc.

More recently (2.6 only) Linux has had support for "write barriers".
The idea here is that you submit a number of write requests, then a
"barrier", then some more write requests. (The "barrier" might be a
flag on the last request of a list, I'm not sure of that detail).  The
meaning is that no write request submitted after the barrier will be
attempted until all requests submitted before the barrier are
complete.  Some drives support this concept natively so Linux simply
does not re-order requests across a barrier, and sends the barrier at
the appropriate time.  Drives can do their own re-ordering but will
not reorder across a barrier (if they support the barrier concept).

If Linux needs to write a barrier to a device that doesn't support
barriers (as the md/raid currently doesn't) it will (should) submit
all requests before the barrier, flush them out, wait for them to
complete, then allow other requests to be forwarded.

In short, md/raid provides the same guarantees as normal drives, and
any filesystem that expects more is broken.

Definitely put your journal on RAID  with at least as much redundancy
as your main filesystem (I put my filesystem on raid5 and my journal
on raid1).

NeilBrown


* I happen to know that the "umem" NVRAM driver will never re-order
  requests, as there is no value in re-ordering requests to RAM.  But
  it is the exception, not the rule.
