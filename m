From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: Fast (intelligent) raid1
Date: Wed, 19 Feb 2003 12:29:55 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302191129.h1JBTtY06965@oboe.it.uc3m.es>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: From "(env:" "ptb)" at "Feb 18, 2003 11:13:25 pm"
To: ptb@it.uc3m.es
Cc: Neil Brown <neilb@cse.unsw.edu.au>, Ross Vandegrift <ross@willow.seitz.com>, Ingo Molnar <mingo@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"A month of sundays ago ptb wrote:"
>  ftp://oboe.it.uc3m.es/pub/Programs/fr1-2.2.tgz

I'll now try and provide an abstract summary of the code changes
introduced by the patch.

  1) change hotadd in md.c to detect a previously known disk via
     its superblock uuid (which must match the raid array's) and
     signal "hotrepair" if the events count in the disk sb
     indicates that it separated from us after the current bitmap was
     first set up (first dirtied), which indicates that te bitmap
     contains all the changes that are pending for it. We have saved
     the events counter at the time the bitmap was set up (first
     dirtied) in the reserved area of the array superblock.

     If hotrepair is signalled, record that also in the array
     superblock reserved area.

     If it's not a hotrepair that we're doing in the hotadd, then we
     will eventually ditch the bitmap during the resync. For the moment
     we just signal it via the flag in the array superblock reserved
     area.

  2) change make_request in raid1.c so as to mark the bitmap when 
     there are some nonoperational elements in the array. On dirtying
     the bitmap for the first time, write the current md device
     superblock events value to the reserved area of the md device
     superblock, and set the bitmap dirty flag.

     The bitmap itself is kept in the private raid1 metadata struct
     along with a flag to indicate if it's dirty or not.

  3) in the mark_disk_bad function in raid1.c, activate (or set up)
     a bitmap, flagged not dirty.

  4) In the diskop function in raid1.c, in the SPARE_ACTIVE case
     we remove the bitmap, or disactivate it. Whatever. This is
     called at the end of a successful resync.

  5) In the resync_block function in raid1.c, we check on handling
     the first sector if we are doing a hotrepair or not, by looking
     in the reserved area of the md device superblock. If we are not,
     we remove any bitmap, or disactivate it, and will then proceed to
     do a full resync afterwards. If we are doing hotrepair, we zero
     the hotrepair flag and keep any bitmap that happens to be there.

     In the rest of the function, if there is a bitmap (active), we
     use it to decide which blocks to really sync and which not.

I've since also started to make the ordinary mirror bh writes
asynchronous, by marking the bitmap on submitting the bh i/o, saying the
i/o is complete when one of the sub-bh's completes, and clearing the
bitmap for those blocks when all the sub-bh's complete. An error in i/o
should fault a component offline so we will know to which the bitmap
refers later.

I hope linux-raid is archived. Just my luck if I lose these summaries
..

Peter
