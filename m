From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Mon, 14 Mar 2005 21:22:57 +1100
Message-ID: <16949.26113.68948.938529@cse.unsw.edu.au>
References: <422F7621.8090602@steeleye.com>
	<16949.5768.392061.95882@cse.unsw.edu.au>
	<20050314094454.GK3858@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Lars Marowsky-Bree on Monday March 14
Sender: linux-raid-owner@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: Paul Clements <paul.clements@steeleye.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday March 14, lmb@suse.de wrote:
> On 2005-03-14T15:43:52, Neil Brown <neilb@cse.unsw.edu.au> wrote:
> 
> Hi there, just a question about how the bitmap stuff works with
> 1++-redundancy, say RAID1 with 2 mirrors, or RAID6.

I assume you mean RAID1 with 3 drives (there isn't really one main
drive and all the others are mirrors - all drives are nearly equal).

We haven't put any significant work into bitmap intent logging for
levels other than raid1, so some of the answer may be pure theory.

> 
> One disk fails and is replaced/reattached, and resync begins. Now
> another disk fails and is replaced. Is the bitmap local to each
> disk?

Bitmap is for the whole array, not per-disk.
If there are any failed drives, bits are not cleared from the bitmap.
If a drive fails then any active resync is aborted and restarted
(possibly this is not optimal...).

If a failed disk is re-attached, then only the blocks changed since
that the array was known-good are resynced.  If a new drive is added, all
blocks are synced.

> 
> And in case of RAID1, with 4 disks (and two of them resyncing), could
> disk3 be rebuild from disk1 and disk4 from disk2 (as to optimize disk
> bandwidth)?

If two are resyncing, they will resync in step with each other so
there is no point in reading from disk2 as well as disk1.  Just read
from disk 1 and write to disks 3 and 4.

Does that answer your questions?

NeilBrown
