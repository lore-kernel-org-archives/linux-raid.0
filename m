From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [ANNOUNCE][PATCH 2.6] md: persistent (file-backed) bitmap and async
 writes
Date: Mon, 9 Feb 2004 13:51:43 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16422.62911.755570.855200@notabene.cse.unsw.edu.au>
References: <40198E85.29EBC8E0@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Thursday January 29
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: linux-raid@vger.kernel.org, ptb@it.uc3m.es, mingo@redhat.com, "james.bottomley" <james.bottomley@SteelEye.com>
List-Id: linux-raid.ids

On Thursday January 29, Paul.Clements@SteelEye.com wrote:
> Description
> ===========
> This patch provides the md driver with the ability to track
> resync/rebuild progress with a bitmap. It also gives the raid1 driver
> the ability to perform asynchronous writes (i.e., writes are
> acknowledged before they actually reach the secondary disk). The bitmap
> and asynchronous write capabilities are primarily useful when raid1 is
> employed in data replication (e.g., with a remote disk served over nbd
> as the secondary device). However, the bitmap is also useful for
> reducing resync/rebuild times with ordinary (local) raid1, raid5, and
> raid6 arrays.
> 

Thanks for this.

There is obviously some good functionality here, but I do have a few
issues with the patch and the code that I would like to see addressed
first.

- The patch seems to add several separate, though related, pieces of
  functionality.  It would be a lot easier to review if they were
  separate.
  There is (at least):
     - "intent-loging" in the bitmaps.
     - optimising resync using the intents.
     - async writes to non-primary devices
     - 'hotrepair'

- bitmap storage.  I gather these are stored on a separate device
  (in a separate filesystem).  It would be nice to be able to store
  them on the raid array directly so the optimised-resync works on a
  root-filesytem device as well.  There is nearly 64k after the
  superblock  that can be used.  I think there should be an option to
  store the bitmap on all the (primary) devices after the superblock.
  (This could be added later - a separate patch)
- A question - can the bitmap be "rescaled" online, or only offline?
  (not that I particularly want on-line rescaling) How is it achieved?
- ioctl - By changing the size of mdu_array_info_t you have changed
  the GET_ARRAY_INFO ioctl, so you lose backwards compatibility with
  user-space tools.  If you want to return more info with
  GET_ARRAY_INFO (which is reasonable) we need to handle both the old
  and new mdu_array_info_t sizes. Ditto for SET_ARRAY_INFO
- superblock.  If you have an array with a bitmap attached, boot an
  old kernel that doesn't understand bitmaps, use the array for a
  while (after a full sync) have an unclean shutdown, and then boot
  back into the new kernel, the out-of-date bitmap will be used to
  optimise resync - incorrectly.  Is this possibility handled at all?
- I don't see the point of the new "array_size" personality method. 
  Surely the size of the bitmap depends on the device size
  (mddev->size), rather than the array_size - after all, that is what
  md_do_sync iterates over.
- I don't think it is right for "stop" to return EBUSY if there are
  outstanding async writes.  It should either wait for the writes to
  complete, or abort them (or both, with a timeout).
- Write requests tend to come in bursts.  So when you get a burst of
  write requests, it would be most efficient to set all the on-disk
  bits for all requests in the burst, flush all blocks which have
  changed and then release the burst of write requests.  If I read the
  code correctly, you do one bitmap-block-write for every bit that
  gets set. 
- returning -ENOMEM in the make_request function is a no-no.  You need
  to either cope with a kmalloc failure, or use a mempool or similar
  to guarantee some memory either now or soon.
- The bitmap_page structure is amusing.  On memory failure, you
  highjack the "*map" pointer to form 2 16bit counters, and spend a
  whole 32bit "unsigned int" to flag if this is the case or not.
  Would it be better to use one bit of "counter" as the highjack flag,
  and thereby save a substantial fraction of the size of 'bitmap_page'?
- What is the relationship between the 'bitmap_fd' field in
  mdu_array_info_s, and the SET_BITMAP_FILE ioctl?  They both seem to
  set the bitmap file.

Finally, do you have any measurements of the performance impact of the
intent logging on various workloads?


That'll do for now.

NeilBrown
