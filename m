From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [ANNOUNCE][PATCH 2.6] md: persistent (file-backed) bitmap and async
 writes
Date: Fri, 5 Mar 2004 16:06:31 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16456.2775.641721.204171@notabene.cse.unsw.edu.au>
References: <40198E85.29EBC8E0@SteelEye.com>
	<16422.62911.755570.855200@notabene.cse.unsw.edu.au>
	<4027E342.D02202F1@SteelEye.com>
	<16424.8182.876520.280031@notabene.cse.unsw.edu.au>
	<402D3A86.97CF894F@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Friday February 13
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: linux-raid@vger.kernel.org, ptb@it.uc3m.es, mingo@redhat.com, "james.bottomley" <james.bottomley@SteelEye.com>
List-Id: linux-raid.ids

On Friday February 13, Paul.Clements@SteelEye.com wrote:
> And here is the next set of patches. Tested thoroughly against
> 2.6.2-rc2-bk3 and compile tested against 2.6.3-rc2.
> 
> I've split the kernel code into two patches. The async write patch is
> dependent on the bitmap patch. The bitmap patch includes the new
> GET/SET_EXTRA_ARRAY_INFO ioctls and a mempool for the bitmap_update
> structures (no more -ENOMEM in the I/O request path). 
> 
> bitmap patch vs. 2.6.3-rc2
> --------------------------
> http://parisc-linux.org/~jejb/md_bitmap/md_bitmap_2_30_2_6_3_RC2.diff 
> 
> async write patch vs. 2.6.3-rc2
> -------------------------------
> http://parisc-linux.org/~jejb/md_bitmap/md_async_2_30_2_6_3_RC2.diff
> 
> mdadm patch vs. 1.5.0
> ---------------------
> http://parisc-linux.org/~jejb/md_bitmap/mdadm_1_5_0-2.diff
> 
> 
> For simplicity's sake, the mdadm patch includes both the bitmap and
> async code (it's a fairly small patch anyway, and probably wouldn't have
> benefited much from a split).
> 


I finally had a chance to look at this properly -- or atleast at the
"bitmap" patch.

There is a lot in there that I don't like.  I was just going to rip
out the bits that I wasn't happy with and produce a minimal patch that
I was happy with and which did something useful, but I ran into
problems with the file io in bitmap.c.  It is just simply wrong, and
needs a substantial rewrite.

Using "generic_file_write" is wrong.  It is a service routine for
filesystems to call.  Not an interface for clients of a filesystem to
call.

You should look at loop.c.  It seems to be closer to correct.
You need to see the files as an "address_space" and use address_space
operations to access it.
  ->readpage to read a page
  ->prepare_write / ->commit_write to write a page (or maybe
		  write_page, I'm not sure)
  ->sync_page to sync a patch


Apart from that....

 The more I think about it, the less I like extra fields being added
 to the superblock.
 I think the bitmap file should have a header with 
   magic
   uuid (which must match raid array)
   events counter (which must also match)
   chunk size
   other configurables.

 Then to assemble an array with a bitmap you create the bitmap file,
 and pass it down with a new ioctl. 
 
 If the array has a persistent superblock, md check the header against
 the superblock, otherwise it just trusts you.

 You don't need any ioctls to get or set extra information about the
 array.  Just read the header off the bitmap file.


 I'm not 100% sure what R1BIO_NotUptodate is supposed to do, but I'm
 fairly sure it does it wrongly, and I don't like the name (as it
 seems similar to "R1BIO_Uptodate", but is clearly a lot different.

So, if you can produce a patch which *only* adds a persistent bitmap
in a file, uses it to record which blocks are not in-sync, and
optimises resync using the bitmap,  and which uses address_space
operations for fileio, then I will see if it is acceptable, and we can
then start adding bits like hot-repair and async-write etc on top of
that.

NeilBrown
