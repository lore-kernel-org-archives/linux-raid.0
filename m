From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Questions answered by Neil Brown
Date: Mon, 24 Feb 2003 21:15:43 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302242015.h1OKFhA04699@oboe.it.uc3m.es>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here's part of offline conversation with Neil Brown. The answers should
go to the list to be archived, so I'm passing them on ...


----- Forwarded message from Neil Brown -----
On Monday February 24, ptb@it.uc3m.es wrote:
> 1) when is the events count written to the component disks
>    superblocks, and how can I force an update (at intervals)?

Whenever md_update_sb is called, which is normally:
   When the array starts
   When it stops
   When a drive fails
   When a drive is added
   When a drive is removed.

Just set mddev->sb_dirty and maybe kick the raid thread.

> 
>    I ask because I have seen a case when a disk that I know
>    had been taken out properly was rejected on reinsert as
>    a replacement candidate (bitmapped resync) because its
>    event count was too old compared to the one on the bitmap
>    that supposedly was set up when it was marked faulty,
>    and stamped on first attempted write afterwards.

I would have to look at the code.

> 
> 2) how can I know how many faulty or removed disks there
>    currently are in the array? I need to mark the bitmap on
>    write as soon as there are any. At the moment I search
>    in a certain range in the array for disks marked nonoperational.

The write fork for raid1_make_request iterrates through all devices
and ignores the non-operational ones.  When you come to the end of the
list, and before you actually submit the write request, you should
know if there are any faulty devices, so you should know what to do
with the bitmap.

Is that a suitable answer?

> 
> 3) it is not clear to me that I am doing accounting right on
>    async writes (or indeed when resyncing and skipping blocks).
> 
>    The last end_io always did
>    io_request_done(bh->b_rsector, conf,
>                           test_bit(R1BH_SyncPhase, &r1_bh->state));
>    and now this can be done on the first end_io (along with the
>    bh->b_end_io(bh, uptodate);) in  an async write. Is that right?

It's not enough.
Once you have called bh->b_end_io, you cannot touch that bh every
again, as it might not even exist.

Also, io_request_done is used to synchronise io request with resync
requests so they don't tread on each other's feet.  io_request_done
must come after all the io is complete, even if you find some way of
calling bh->b_end_io sooner.

> 
>    in resync I simulate having done n sectors by
> 
>                    md_sync_acct(mirror->dev, n);
>                    sync_request_done(sector_nr, conf);
>                    md_done_sync(mddev, n, 1);
> 
>                     wake_up(&conf->wait_ready);
> 
>    is that right?

It looks good.  I would have to spend a little while staring at the
code to be sure, but it is close enough that if it seems to work, then
it is probably right.

NeilBrown

----- End of forwarded message from Neil Brown -----
