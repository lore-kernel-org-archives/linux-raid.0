From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: [ANNOUNCE][PATCH 2.6] md: persistent (file-backed) bitmap and async
 writes
Date: Fri, 05 Mar 2004 17:05:30 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4048F9AA.1BBD67F@SteelEye.com>
References: <40198E85.29EBC8E0@SteelEye.com>
		<16422.62911.755570.855200@notabene.cse.unsw.edu.au>
		<4027E342.D02202F1@SteelEye.com>
		<16424.8182.876520.280031@notabene.cse.unsw.edu.au>
		<402D3A86.97CF894F@SteelEye.com> <16456.2775.641721.204171@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org, ptb@it.uc3m.es, mingo@redhat.com, "james.bottomley" <james.bottomley@SteelEye.com>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Friday February 13, Paul.Clements@SteelEye.com wrote:

> I finally had a chance to look at this properly -- or atleast at the
> "bitmap" patch.

Thanks for looking this over...

 
> Using "generic_file_write" is wrong.  It is a service routine for
> filesystems to call.  Not an interface for clients of a filesystem to
> call.

Agreed. I'm pretty unfamiliar with some of these interfaces, so I was
not sure which ones were the correct ones to use. After looking over the
interfaces a bit more and with some guidance from a couple of experts, I
have a much better idea about what to do...
 
> You should look at loop.c.  It seems to be closer to correct.
> You need to see the files as an "address_space" and use address_space
> operations to access it.
>   ->readpage to read a page

I'm already using read_cache_page(). Didn't realize that it would
actually extend the file for me automatically. Given that it can do
that, the generic read and write stuff can just be thrown out
completely.

>   ->prepare_write / ->commit_write to write a page 

Yes, these combined with read_cache_page are all I need...


>  The more I think about it, the less I like extra fields being added
>  to the superblock.

OK, fair enough. I'll look at adding a header to the bitmap file and
I'll axe the superblock fields and the new ioctl I created.


>  I think the bitmap file should have a header with
>    magic
>    uuid (which must match raid array)
>    events counter (which must also match)
>    chunk size
>    other configurables.

...and maybe a version field and some padding to allow for future
changes.

This all means no more in-memory-only bitmaps, but I think that's not
really a critical feature anyway.

 
>  Then to assemble an array with a bitmap you create the bitmap file,
>  and pass it down with a new ioctl.

Right. Probably a lot simpler than the existing method.

 
>  If the array has a persistent superblock, md check the header against
>  the superblock, otherwise it just trusts you.

Yep.

 
>  You don't need any ioctls to get or set extra information about the
>  array.  Just read the header off the bitmap file.

Yep.

 
>  I'm not 100% sure what R1BIO_NotUptodate is supposed to do, but I'm
>  fairly sure it does it wrongly, and I don't like the name (as it
>  seems similar to "R1BIO_Uptodate", but is clearly a lot different.

Yes, looking back at this, there were a couple of errors in the way that
bit was handled. I've corrected those and renamed the bit to
R1BIO_Degraded. I think this is a better name as it's closer to what the
bit really signifies. If the bit is set, it means:

1) either we've got a degraded array (only 1 disk), or 
2) we've gotten a write failure (and we're about to degrade the array)

In either case, we will not clear the bitmap.

 
> So, if you can produce a patch which *only* adds a persistent bitmap
> in a file, uses it to record which blocks are not in-sync, and
> optimises resync using the bitmap,  and which uses address_space
> operations for fileio, then I will see if it is acceptable, and we can
> then start adding bits like hot-repair and async-write etc on top of
> that.

I'll work on that and get it out as soon as I can...

Thanks again,
Paul
