From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: async writes in raid1
Date: Mon, 14 Apr 2003 16:58:58 +0200 (MET DST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200304141458.h3EEwww16546@oboe.it.uc3m.es>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
To: Paul.Clements@SteelEye.com
Cc: neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I simply went ahead and implemented async writes by

 1) in make_request:
    duplicating the bh->b_data from the original request into a local
    buffer obtained via kmalloc (if kmalloc fails, don't set the flag
    in the rh1_bh for async writes). Then point all the mirrored bh's
    mbh->b_data at this.

 2) in the mirrored bh's end_request:
    if we're the first mbh and async flag is set, ack the original bh.
    if we're the last  mbh and async flag is set, kfree the mbh->b_data
    that we kmalloc'ed earlier.

I've done a few million async writes and haven't died yet. Of course I
don't know if this procedure works always.

Doubts: do I have to point mbh->b_page at something new too? There are
occasional tests scattered in the code (on read, as far as I can see)
to make sure it corresponds correctly to the b_data field.

This is all in the fr1 driver.

  ftp://oboe.it.uc3m.es/pub/Programs/fr1-2.14.tgz

fr1.o needs to be loaded with async=1 to activate async writes.

There's still a couple of debugging printks, but you can kill them
yourself.

  raid1: async end i/o on sectors 3956-3957
  raid1: async end i/o on sectors 3958-3959
  raid1: async end i/o on sectors 3960-3961
  raid1: async end i/o on sectors 3962-3963
  raid1: async end i/o on sectors 3964-3965
  raid1: async end i/o on sectors 3966-3967
  bitmap: free page enters with page count 6
  bitmap: free page exits with page count 7

Async writes "can work" because of the bitmap support architecture in
fr1.  The bitmap is marked before the async write and cleared when the
last mirrored bh completes.

It all degrades nicely in out of memory conditions.

Peter
