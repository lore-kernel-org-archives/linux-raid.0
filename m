From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH 0/3] md bitmap-based asynchronous writes
Date: Tue, 22 Mar 2005 09:09:53 +1100
Message-ID: <16959.17969.933940.657178@cse.unsw.edu.au>
References: <422F7621.8090602@steeleye.com>
	<16949.5768.392061.95882@cse.unsw.edu.au>
	<4239EDCA.4030502@steeleye.com>
	<16958.19415.701152.371199@cse.unsw.edu.au>
	<423EF6F7.2040201@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Paul Clements on Monday March 21
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday March 21, paul.clements@steeleye.com wrote:
> 
> > However I would like to leave them until I'm completely happy with the
> > bitmap resync, including
> >   - storing bitmap near superblock  (I have this working)
> 
> Great. I assume you're using the 64k after the superblock for this 

Yes.  There is guaranteed to be at least 60K after the 4K superblock.
The default is to choose a bitmap_chunk size to use between 30K and
60K of the bitmap.  My test machine with 35Gig drives uses a 128KB
chunk size.

> (well, with v1 supers, I guess the bitmap could be just about 
> anywhere?). 

Yes, which makes hot-adding a bit awkward... I think the default
--create should leave a bit of space just in case.

>             So does this mean there would be multiple copies of the 
> bitmap, or are you simply choosing one disk to which the bitmap is written?

Multiple copies, on all active drives (not on spares).

> 
> >   - hot-add bitmap                  (I've started on this)
> 
> I assume this means the ability to add a bitmap to an active array that 
> has no bitmap? Might it also include the ability to modify the bitmap 
> (from userland) while the array is active, as this functionality is 
> desirable to have (perhaps you followed the thread where this was 
> discussed?).

It would definitely include the ability to remove a bitmap and then
add a new one which would nearly achieve the same thing (just a small
window of no bitmap).   I guess for file-backed bitmaps, an atomic
switch should be possible and desirable.  I'll see what I can do.

> 
> >   - support for raid5/6 and hopefully raid10.  (still to come)
> 
> That would be nice too.
> 
> > and I would really like
> >    only-kick-drives-on-write-errors-not-read-errors
> 
> Perhaps I can help out with this. I've seen the recent 
> discussions/patches for this, but so far it doesn't look like we have a 
> completely up-to-date/working/tested patch against the latest kernel, do 
> we? So maybe I could do this (unless someone else is already)?

I cannot remember what I thought of those patches.  I would definitely
go back and review them before starting on this functionality for
raid1.
However I want to do raid5 first.  I think it would be much easier
because of the stripe cache.  Any 'stripe' with a bad read would be
flagged, kept in the cache and just get processed a different way to
other stripes.  For raid1, you need some extra data structure to keep
track of which blocks have seen bad reads, so I would rather leave
that until I have familiarity with other issues through raid5.

NeilBrown
