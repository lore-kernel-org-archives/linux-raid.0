From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [ANNOUNCE][PATCH 2.6] md: persistent (file-backed) bitmap and async
 writes
Date: Tue, 10 Feb 2004 11:04:06 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16424.8182.876520.280031@notabene.cse.unsw.edu.au>
References: <40198E85.29EBC8E0@SteelEye.com>
	<16422.62911.755570.855200@notabene.cse.unsw.edu.au>
	<4027E342.D02202F1@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Monday February 9
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org, ptb@it.uc3m.es, mingo@redhat.com, "james.bottomley" <james.bottomley@SteelEye.com>
List-Id: linux-raid.ids

On Monday February 9, Paul.Clements@SteelEye.com wrote:
> Neil Brown wrote:
> > - The patch seems to add several separate, though related, pieces of
> >   functionality.  It would be a lot easier to review if they were
> >   separate.
> >   There is (at least):
> >      - "intent-loging" in the bitmaps.
> >      - optimising resync using the intents.
> >      - async writes to non-primary devices
> >      - 'hotrepair'
> 
> I can fairly easily split the bitmap code from the async write code.
> Splitting the smaller bitmap pieces from the rest of the bitmap code,
> however, is a little more difficult. Also, the "hotrepair" and "resync"
> parts would be so small, that I'm not sure it would be worth it. Would
> it be alright if I split it into two patches and see what that looks
> like?
>  

Two would certainly be better than 1.  
Splitting off the "resync" stuff probably isn't necessary, but the
'hotrepair' seems conceptually quite separate and it would help to see
the patch and the justification separately, but I won't push it.

> > - A question - can the bitmap be "rescaled" online, or only offline?
> >   (not that I particularly want on-line rescaling) How is it achieved?
> 
> The bitmap file can be rescaled offline by simply expanding or
> collapsing the bits as necessary, and then writing the enlarged or
> shrunken bitmap file. When the array is started (with a new bitmap chunk
> size), everything will work correctly. (The bitmap file can also be
> truncated, in which case the driver will assume all the bits to be dirty
> and perform a full resync).
> 

It would seem to make sense to store the "chunk size" in the bitmap
file.
In fact, if the bitmap file had a small header containing:
    magic number
    array uuid
    event count
    bitmap chunk size
Then you could rescale the bitmap without touching the superblock and
would at the same time solve the problem with possibly getting an
out-of-date bitmap.


> 
> > - ioctl - By changing the size of mdu_array_info_t you have changed
> >   the GET_ARRAY_INFO ioctl, so you lose backwards compatibility with
> >   user-space tools.
> 
> Yes, unfortunately...
> 
> >   If you want to return more info with
> >   GET_ARRAY_INFO (which is reasonable) we need to handle both the old
> >   and new mdu_array_info_t sizes. Ditto for SET_ARRAY_INFO
> 
> OK, I'll code this up and include it in the next patch. Some type of
> versioning scheme (like what you've done with the superblock) would
> probably do the trick.

When you change the structure size, you change the ioctl number so you
can differentiate requests based just on the ioctl.
so you would need to define a "struct mda_array_info_s_old" and  have
#define GET_ARRAY_INFO		_IOR (MD_MAJOR, 0x11, mdu_array_info_t)
#define GET_ARRAY_INFO_OLD	_IOR (MD_MAJOR, 0x11, struct mdu_array_info_s_old)

and handle each ioctl separately (or translate one into the other
early in md_ioctl).

> 
> > - Write requests tend to come in bursts.  So when you get a burst of
> >   write requests, it would be most efficient to set all the on-disk
> >   bits for all requests in the burst, flush all blocks which have
> >   changed and then release the burst of write requests.  If I read the
> >   code correctly, you do one bitmap-block-write for every bit that
> >   gets set.
> 
> That would be a very nice optimization. It would also be pretty
> involved. If you'd like I can look at doing this as a follow-on patch.
> 

You would need an "unplug" concept.
When make_request is given a write request, it puts the request on a
queue and schedules an bitmap update.  You set
mddev->queue->unplug_fn to a function which flushes the outstanding
bitmap updates, and then moves the queue of outstanding write requests
to somewhere that raid1d can pick them up and initiate them.

> 
> > - The bitmap_page structure is amusing.
> 
> I like to keep my readers entertained... :)
> 
> >   highjack the "*map" pointer to form 2 16bit counters, and spend a
> >   whole 32bit "unsigned int" to flag if this is the case or not.
> >   Would it be better to use one bit of "counter" as the highjack flag,
> >   and thereby save a substantial fraction of the size of 'bitmap_page'?
> 
> In all seriousness though, I opted for the extra flag because I didn't
> want to get into figuring out which bits of a pointer could be used as
> flags and which could not, across all the various 32 and 64 bit
> architectures...it was easier and less risky just to use a couple more
> bytes of memory. I suppose if pages are guaranteed to be aligned on some
> boundary, the lowest bit could be used as a flag without any risk of
> misinterpretation? At any rate, wasting 4 bytes per page didn't seem
> like a terrible loss.
> 

True it isn't a great loss.  It just seemed amusing that you squeezed
two 16bit counters into the pointer (seeming to make best use of
available memory) and then wasted 31 bits.
If you put the "highjacked" flag in the counter (not in the pointer)
as e.g. the lsb, doing all real counting by 2s, it should be straight
forward.


> 
> > - What is the relationship between the 'bitmap_fd' field in
> >   mdu_array_info_s, and the SET_BITMAP_FILE ioctl?  They both seem to
> >   set the bitmap file.
> 
> Yes, they are the same. mdadm opens the bitmap file and passes down a
> file descriptor (bitmap_fd). SET_BITMAP_FILE is used in the case of
> Assembling an array (where SET_ARRAY_INFO is called with a NULL array
> info pointer), while the bitmap_fd is simply passed down inside the
> array info struct in the Create case.
> 

Ahh, I see.  That's why you need both.
I guess you could create the array "the old way", stop it, and then
re-assemble it and pass down the fd then.
If you kept the bitmap parameters in the head of the bitmap file
rather than in the superblock, you could avoid having to change
kernel-side array-creation altogether.

I'm not actually a big fan of having the kernel create the array.
You might note that for new style superblocks, the kernel will not
create the array at all.
You have to have user-space write out the initial superblocks, and
then just have the kernel assemble the array.

I would advocate doing the same thing for the bitmap superblock (if
you choose to have one in the bitmap file) - i.e. userspace sets it up
and passes it to the kernel, and the kernel extracts the information
it needs.

NeilBrown
