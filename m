From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: [ANNOUNCE][PATCH 2.6] md: persistent (file-backed) bitmap and async
 writes
Date: Wed, 28 Apr 2004 20:53:16 +0200 (MET DST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200404281853.i3SIrGw15815@oboe.it.uc3m.es>
References: <408FF39B.6070907@steeleye.com>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <408FF39B.6070907@steeleye.com> from Paul Clements at "Apr 28, 2004
 02:10:35 pm"
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@cse.unsw.edu.au>, ptb@it.uc3m.es, mingo@redhat.com, "james.bottomley" <james.bottomley@steeleye.com>
List-Id: linux-raid.ids

"Also sprach Paul Clements:"
> Since there hasn't been any negative feedback, I assume that this 
> version is acceptable for inclusion in mainline/-mm?

whew ... since I just got out of a %^&% grant appication spin, and can
breathe now, you prompted me to take a look.

First thing I notice is md.o is replaced with md-mod.o.  Why?  That's
gratuitous breakage of every poor admin's scripts that up till now has
been doing an insmod md, or has had a "md" in /etc/modules.

Owwww ....

Is the reason perhaps  that md.c is no longer the whole story? So that
there is extra linking? I guess so. Why not put the extra stuff in a
separate module and leave md.o be?

I'll not comment on the bitmap.c file (I still need to figure out ow it
can possibly work :-). But I like the comments in the file! Looks
comprehensible and very neat. Perhaps a summary of what's in it could
be put up top ... or is that likely to get out of step? Perhaps.

The changes to md.c ... look very benign. I see you add a function,
export a function previously static ... add bitmap sb update to the sb
update fn and export it.

I can't be sure from the diff alone, but it looks as though a
bitmap is always created with bitmap_create, and there is no way to
stop it? Is that right? I'd need to see more context in the diff
to figure it out. Perhaps the calls to bintmmap_create and
bitmap_destroy don't do anything unless the sb is marked as "wanting" 


get_bitmap_file seems to be intended to talk to a user, but it's
static! Are you going to use it in an ioctl? If so, surely the ioctl
part should do the copy_to_user, and this function should not?

It's also go a kmalloc of a buf inside, and I would have thought you
had loadsa potential bufferspace lying around in the superblocks you
have in memory ...  oh well, it's independent this way. 

There's a tiny change

  -       if (rdev->raid_disk >= 0)
  +       if (rdev->raid_disk >= 0 && !rdev->faulty)
                  goto busy;


which needs more context for me to judge! So we don't pretend we're
busy if what we're busy with is faulty? Where are we? It must be a
diskop of some kind.

The code following ...

   +
   +       /* check the sb on the new disk to see whether the bitmap can be used
   +        * to resync it (if not, we dirty the bitmap to cause a full resync) */
   +       if (mddev->bitmap) {
   +               int bitmap_invalidate = 1;
   +               mdk_rdev_t *rdev0 = list_entry(mddev->disks.next,
   +                       mdk_rdev_t, same_set);

looks entirely opaque to me! Loads of if's.

There's an addition of set_bitmap_file as an allowed diskop when we
aren't initialised yet - entirely harmless and correct.

Ah .. here I think we have the ioctl for get_bitmap_file. Yes, but I
would have prefered the copy_to_user here, not in the cllaed routine.

Maybe set_bitmap_file does the same "trick"?

There's some status report output reformatting which is hard to figure.
Maybe only a \n added? Probably because you follow with a bitmap status
report when there is one. Shouldn't this bitmap report be a function in
the bitmap.c file? Or would that be all cyclic in terms of
dependencies?

Here there is something I don't get:

  -       if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
  +       /* we don't use the checkpoint if there's a bitmap */
  +       if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) && !mddev->bitmap)

Are you trying to avoid the speed throttling problem here?  I guess the
checkpoints are where the speed is recalculated too.

When I patched md.c here to get around the throttle (it doesn't know
that some of the synced blocks are "virtual", thanks to the bitmap code),
I did it by adding an extra array of "discounted blocks" that the
sync code could increment every time it skipped something. Then I
changed the throttle speed calculation in md.c to discount the
discounted blocks each time, and only consider the remainder, which had
been "really" written. So the throttle acted on the real i/o speed, not
the virtual speed.

But for printout, I used the virtual speed.


Here's another bit that needs explanation:

  -               blk_run_queues();
  +               if (need_sync)
  +                       blk_run_queues();


And here ...

  +               /* don't worry about speed limits unless we do I/O */
  +               if (!need_sync)
  +                       continue;


Are you saying that in the corner case when the sync at since the
previous checkpoint has been entirely "virtual", we just dive right
back round again? What's this "need_sync" *exactly*? When do you think
we "need" a sync?


Hurrr .. I see changes to raid1.c next. I'll consider them after a
stiff drink.


In summary, the md.c changes look almost certainly benign to me,  with
just a couple of one-liners that I would need tolook at harder. I would
be grateful if you maybe comment on them here (or even in the code).

Perhaps commenting the patch would be appropriate? Can one add text
between hunks? One can do it before the diff starts. 







Peter
