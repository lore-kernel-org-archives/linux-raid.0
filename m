From: Neil Brown <neilb@suse.de>
Subject: Improving read performance on md/raid5
Date: Sat, 25 Mar 2006 20:48:28 +1100
Message-ID: <17445.4588.434149.623158@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Greetings all.

 This issue - improving read performance on md/raid5 - has come up a
 few times just recently, and I currently have two private emails on
 the topic waiting to be answered.  While I do plan to answer those, I
 generally prefer to have discussions about RAID openly on this
 mailing list, and as I have something useful to say, I thought I
 would post it to the list, and maybe refer to it the responses to
 those private emails.

 raid5 has a 'stripe cache' which is primarily used for synchronising
 multiple accesses to the one stripe.  This is particularly important
 for write (so the parity block can be updated correctly) and for
 resync/recovery (so that changes made by resync/recovery don't
 interfere with changes made by writing).  It is also important for
 reading when reading from a degraded array - as the parity is used
 for that, and so must be synchronised with parity updates.

 However the synchrony provided by the stripe cache isn't really
 needed for reads from a non-degraded array, or even for reads from a
 working drive on a degraded array.  And making all reads use the
 stripe cache has a performance impact.

 I was thinking about this while driving my son to his cricket match
 (we lost) and I realised that bypassing the cache would be a lot
 easier than I had previously imagined.  However I am not likely to
 have much time to give to it in the near future (plenty else to do)
 so I thought I would outline what needs to be done in case someone
 (or someones) else might like to give it a try.  If you do, I will be
 more than happy to provide further guidance and feed back as
 required.


 What is required is:

 1/ define a "mergeable_bvec" function modelled on
   raid0_mergeable_bvec.   This should restrict read requests to fit
   entirely on one disk if possible.  (It can allow write requests to
   be arbitrarily large).
   Note that we cannot force all read requests to be from exactly one
   device as a one-page request must always be allowed, even if it
   crosses a drive boundary.  But most is good enough.

 2/ modify make_request in raid5.c to check for read requests which
   fit entirely on a working device, and handle them differently
   (probably with a new function - make_request is rather complex and
   really needs to be split up).
   The alternate handling should:

    - use bio_clone to make a copy of the bio
    - set bi_end_io to a new function, and set bi_private to the
         original bio.
    - pass the new bio to generic_make_request
    - be careful to take a reference to the rdev (rdev->nr_pending)
      like handle_stripe does.

   This will bypass the cache and read directly into the buffers that
   were passed.
   The "new function" should check if the read succeeded and if it
   did, call bio_endio on the original bio (having bio_put the new bio
   first). 
   If the read failed.. we'll have to do something, but I'll get to
   that in a minute.

At this point you can test the new code for speed and make sure it
meets expectations.

  3/ We need to be able to retry a failed read.  This is done by
  attaching the bio to the stripe cache and letting the current code
  handle it.  So the "new function" in step 2 needs to find the
  mddev_t structure (start from bi_bdev) and put the failed bio on a
  new retry list (use bi_next for linkage).
  raid5d then needs to
       - check for entries on that list
       - take them off and perform a sequence of
           get_active_stripe/add_stripe_bio 
         just like make_request does. 
         It should also arrange to set the R5_ReadError flag so that
         handle_stripe will attempt the read-error-recovery that it
         can do.

Then you can test correct handling of read errors.

This should be developed and eventually presented as a sequence of
patches.

1- step one, the mergeable_bvec funtion
2- refactor make_request so that the code needed by raid5d will be
   readily available
3- introduce the new list and put appropriate code into raid5d
4- extend make_request to handle appropriate reads differently.


So: if anyone would like to do this and feels at all capable, please
give it a go and keep us informed of how it is going.

And if you wanted to do raid6 as well (should be identical code) that
would be excellent....

Thanks,
NeilBrown
