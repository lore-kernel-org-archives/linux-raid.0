From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: [ANNOUNCE][PATCH 2.6] md: persistent (file-backed) bitmap and async
 writes
Date: Mon, 09 Feb 2004 14:45:06 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4027E342.D02202F1@SteelEye.com>
References: <40198E85.29EBC8E0@SteelEye.com> <16422.62911.755570.855200@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org, ptb@it.uc3m.es, mingo@redhat.com, "james.bottomley" <james.bottomley@SteelEye.com>
List-Id: linux-raid.ids

Neil Brown wrote:
> 
> On Thursday January 29, Paul.Clements@SteelEye.com wrote:
> > Description
> > ===========
> > This patch provides the md driver with the ability to track
> > resync/rebuild progress with a bitmap. It also gives the raid1 driver
> > the ability to perform asynchronous writes (i.e., writes are
> > acknowledged before they actually reach the secondary disk). The bitmap
> > and asynchronous write capabilities are primarily useful when raid1 is
> > employed in data replication (e.g., with a remote disk served over nbd
> > as the secondary device). However, the bitmap is also useful for
> > reducing resync/rebuild times with ordinary (local) raid1, raid5, and
> > raid6 arrays.
> >
> 
> Thanks for this.

...and thanks for your feedback. There are some really good
ideas/suggestions in here. A couple of them I had thought about, but
wavered on which way to implement them. I'll respond to each of your
points below...


> - The patch seems to add several separate, though related, pieces of
>   functionality.  It would be a lot easier to review if they were
>   separate.
>   There is (at least):
>      - "intent-loging" in the bitmaps.
>      - optimising resync using the intents.
>      - async writes to non-primary devices
>      - 'hotrepair'

I can fairly easily split the bitmap code from the async write code.
Splitting the smaller bitmap pieces from the rest of the bitmap code,
however, is a little more difficult. Also, the "hotrepair" and "resync"
parts would be so small, that I'm not sure it would be worth it. Would
it be alright if I split it into two patches and see what that looks
like?
 

> - bitmap storage.  I gather these are stored on a separate device
>   (in a separate filesystem). 

Yes.

>   It would be nice to be able to store
>   them on the raid array directly so the optimised-resync works on a
>   root-filesytem device as well.  There is nearly 64k after the
>   superblock  that can be used.  I think there should be an option to
>   store the bitmap on all the (primary) devices after the superblock.
>   (This could be added later - a separate patch)

Yes, that would be nice. I'll think about this some and maybe submit it
as a follow-on patch.


> - A question - can the bitmap be "rescaled" online, or only offline?
>   (not that I particularly want on-line rescaling) How is it achieved?

The bitmap file can be rescaled offline by simply expanding or
collapsing the bits as necessary, and then writing the enlarged or
shrunken bitmap file. When the array is started (with a new bitmap chunk
size), everything will work correctly. (The bitmap file can also be
truncated, in which case the driver will assume all the bits to be dirty
and perform a full resync).


> - ioctl - By changing the size of mdu_array_info_t you have changed
>   the GET_ARRAY_INFO ioctl, so you lose backwards compatibility with
>   user-space tools.

Yes, unfortunately...

>   If you want to return more info with
>   GET_ARRAY_INFO (which is reasonable) we need to handle both the old
>   and new mdu_array_info_t sizes. Ditto for SET_ARRAY_INFO

OK, I'll code this up and include it in the next patch. Some type of
versioning scheme (like what you've done with the superblock) would
probably do the trick.


> - superblock.  If you have an array with a bitmap attached, boot an
>   old kernel that doesn't understand bitmaps, use the array for a
>   while (after a full sync) have an unclean shutdown, and then boot
>   back into the new kernel, the out-of-date bitmap will be used to
>   optimise resync - incorrectly.  Is this possibility handled at all?

No, I guess I was assuming that a persistent bitmap could always be
trusted, but in this particular situation, that's not the case. I guess
I'll have to add bitmap event counters to the superblock?


> - I don't see the point of the new "array_size" personality method.
>   Surely the size of the bitmap depends on the device size
>   (mddev->size), rather than the array_size - after all, that is what
>   md_do_sync iterates over.

Yikes...thanks for catching that. It got lost in the translation between
2.4 and 2.6 (size no longer comes directly from the superblock). I'll be
happy to get rid of that bit of ugliness from the patch.


> - I don't think it is right for "stop" to return EBUSY if there are
>   outstanding async writes.  It should either wait for the writes to
>   complete, or abort them (or both, with a timeout).

I'll see what I can do about this. Should be easy enough to wait for the
writes either to complete or error out.


> - Write requests tend to come in bursts.  So when you get a burst of
>   write requests, it would be most efficient to set all the on-disk
>   bits for all requests in the burst, flush all blocks which have
>   changed and then release the burst of write requests.  If I read the
>   code correctly, you do one bitmap-block-write for every bit that
>   gets set.

That would be a very nice optimization. It would also be pretty
involved. If you'd like I can look at doing this as a follow-on patch.


> - returning -ENOMEM in the make_request function is a no-no.  You need
>   to either cope with a kmalloc failure, or use a mempool or similar
>   to guarantee some memory either now or soon.

Yes, I opted for the simple route here, but I think you're right; a
mempool really is required. I'll code that up and include it in the next
patch.


> - The bitmap_page structure is amusing.

I like to keep my readers entertained... :)

>   highjack the "*map" pointer to form 2 16bit counters, and spend a
>   whole 32bit "unsigned int" to flag if this is the case or not.
>   Would it be better to use one bit of "counter" as the highjack flag,
>   and thereby save a substantial fraction of the size of 'bitmap_page'?

In all seriousness though, I opted for the extra flag because I didn't
want to get into figuring out which bits of a pointer could be used as
flags and which could not, across all the various 32 and 64 bit
architectures...it was easier and less risky just to use a couple more
bytes of memory. I suppose if pages are guaranteed to be aligned on some
boundary, the lowest bit could be used as a flag without any risk of
misinterpretation? At any rate, wasting 4 bytes per page didn't seem
like a terrible loss.


> - What is the relationship between the 'bitmap_fd' field in
>   mdu_array_info_s, and the SET_BITMAP_FILE ioctl?  They both seem to
>   set the bitmap file.

Yes, they are the same. mdadm opens the bitmap file and passes down a
file descriptor (bitmap_fd). SET_BITMAP_FILE is used in the case of
Assembling an array (where SET_ARRAY_INFO is called with a NULL array
info pointer), while the bitmap_fd is simply passed down inside the
array info struct in the Create case.

 
> Finally, do you have any measurements of the performance impact of the
> intent logging on various workloads?

No, I don't have any exact numbers, but I haven't observed a slowdown in
the tests I've performed. However, most of my tests were data
replication setups using async writes, which tends to mitigate any
slowdown caused by the bitmap.

--
Paul
