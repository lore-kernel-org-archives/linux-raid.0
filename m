From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: Fast (intelligent) raid1
Date: Fri, 14 Feb 2003 12:33:06 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302141133.h1EBX6D22963@oboe.it.uc3m.es>
References: <200302112305.h1BN5nu16695@oboe.it.uc3m.es>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200302112305.h1BN5nu16695@oboe.it.uc3m.es> from "Peter T. Breuer"
 at "Feb 12, 2003 00:05:49 am"
To: ptb@it.uc3m.es
Cc: Ross Vandegrift <ross@willow.seitz.com>, Ingo Molnar <mingo@redhat.com>, neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'll compress this down to an even more abstract summary ...

"Peter T. Breuer wrote:"
> "Peter T. Breuer wrote:"
> > Have a look at the patch in the .tgz. I tried to make it as clean as I
> > could. Every change I made in the md.c code is commented. There are 4
> > "hunks" of changes to md.c, to allow hotadd after setfaulty, and about
> > ten significant hunks of changes to raid1.c, inserting the extra
> > technology. There is some extra debugging code in that, which I can
> 
> In fact - I'll publish and go through the patch here. Here we go.

  1) change hotadd function in md.c with the objective of permitting
     hotadd after setfaulty ("hotrepair") which should preserve a
     bitmap which has been previously added to the disk metadata in
     the main array (during setfaulty).

  2) change write code in raid1.c to mark the bitmap of every mirror
     component disk which is marked not operational, if it has a bitmap.
  
  3) change mark_disk_bad code in raid1.c to add a bitmap to the disk
     metadata in the full raid array. This is called by setfaulty, and
     also on error from below, I think.

  4) at the point where a spare disk is marked active in the diskop
     function in raid1.c (state SPARE_ACTIVE), remove any bitmap
     associated with the disk metadata in the full raid array.
     This is called after a successful resync, somehow, and possibly
     on other occasions.

  5) in the resync function in raid1.c, for each resync block or
     blocks, find all the spare mirror components which are marked
     nonoperational but writable ("write_only"), and if they have a
     bitmap and it is clean for the blocks we are interested in, then
     cheat for that device - report and account for having written
     to it when it fact we have not. This means calling md_sync_acct
     and sync_request_done and md_done_sync and possibly signalling
     on the wait_ready wait queue for the raid device.  If we don't
     cheat then fall through and do the normal thing, which is to launch
     a write request for some blocks, do a bit of accounting and leave
     the done functions and signalling for its end_io.

I would be deeply obliged if somebody could indicate to me where to
make some further changes. What I want to do is allow an underlying
block device to notify the raid code when the block device has "fixed
itself".

My plan is to

  a) get the raid code to signal the underlying block device during
     a hotadd, presumably at the end, what the major and minor of the
     raid device it has become part of is. This will be via an extra
     ioctl which I will declare for all block devices. Possibly it
     would be nice to actually pass the file system inode for the
     special device node of md0 or whatever, if we have it.

  b) when the block device feels well again, then it will signal
     the raid code via the inode or more directly via the block_ops
     array and a new ioctl that it has come back up, and the raid
     code will then do a hotadd.

and I would like pointers as to where to insert this in the current
raid codes.

Peter
