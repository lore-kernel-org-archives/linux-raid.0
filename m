From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 write performance
Date: Mon, 3 Jul 2006 08:35:14 +1000
Message-ID: <17576.18978.563672.656847@cse.unsw.edu.au>
References: <5d96567b0607020702p25d66490i79445bac606e5210@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Raz Ben-Jehuda(caro) on Sunday July 2
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday July 2, raziebe@gmail.com wrote:
> Neil hello.
> 
> I have been looking at the raid5 code trying to understand why writes
> performance is so poor.

raid5 write performance is expected to be poor, as you often need to
pre-read data or parity before the write can be issued.

> If I am not mistaken here, It seems that you issue a write in size of
> one page an no more no matter what buffer size I am using .

I doubt the small write size would contribute more than a couple of
percent to the speed issue.  Scheduling (when to write, when to
pre-read, when to wait a moment) is probably much more important.

> 
> 1. Is this page is directed only to parity disk ?

No.  All drives are written with one page units.  Each request is
divided into one-page chunks, these one page chunks are gathered -
where possible - into strips, and the strips are handled as units
(Where a strip is like a stripe, only 1 page wide rather then one chunk
wide - if that makes sense).

> 2. How can i increase the write throughout ?

Look at scheduling patterns - what order are the blocks getting
written, do we pre-read when we don't need to, things like that.

The current code tries to do the right thing, and it certainly has
been worse in the past, but I wouldn't be surprised if it could still
be improved.

NeilBrown
