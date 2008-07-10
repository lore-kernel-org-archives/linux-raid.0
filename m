From: Neil Brown <neilb@suse.de>
Subject: Re: 2.6.25.6 raid5 resync oops
Date: Thu, 10 Jul 2008 11:07:58 +1000
Message-ID: <18549.24814.313777.410346@notabene.brown>
References: <200807092019.20090.arekm@maven.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Arkadiusz Miskiewicz on Wednesday July 9
Sender: linux-raid-owner@vger.kernel.org
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Wednesday July 9, arekm@maven.pl wrote:
> 
> While kernel was resyncing raid5 array on 4 sata disks this happened

Thanks for the report.
> 
> ------------[ cut here ]------------
> kernel BUG at drivers/md/raid5.c:2398!

So in handle_parity_checks5, s->uptodate is not == disks.
Not good (obviously).

We only get into handle_parity_checks5 if:
  STRIPE_OP_CHECK or STRIPE_OP_MODE_REPAIR_PD
    are set in sh->ops.pending
or
  s.syncing and s.locked == 0 (and some other stuff).

The first two bits only get set inside handle_parity_checks5,
so the first time handle_parity_checks5 was called on this
stripe_head, s.syncing was true and s.locked == 0.

If s.syncing, and s.uptodate < disks, then we will have already
called handle_issuing_new_read_requests5 which will have tried to read
all disks that aren't uptodate, so 
    s.uptodate + s.locked == disks
which makes the BUG impossible .... except.....

If we already have uptodate == disks-1, then it doesn't read
the missing block and falls straight down to the BUG.

Dan:  I think this is your code.  In 
  __handle_issuing_new_read_requests5
the
		} else if ((s->uptodate < disks - 1) &&
			test_bit(R5_Insync, &dev->flags)) {

looks wrong.  We at least want a test on s->syncing in there, maybe:
		} else if (((s->uptodate < disks - 1) || s->syncing) &&
			test_bit(R5_Insync, &dev->flags)) {

and given that we only compute blocks when a device is failed, (see 15
lines earlier) I think we probably just want
		} else if (test_bit(R5_Insync, &dev->flags)) {

I notice that is was it in linux-next (though the functions are
renamed - it is fetch_block5 there).

I wonder if there is still time for 2.6.26 .. probably not.  It'll be
released immediately after lwn.net release their weekly edition :-)

Arkadiusz: a reboot (which you have probably done already) is all you
  can do here. Your array will resync, and almost certainly won't hit
  the bug again.  There should be no data loss.

NeilBrown
