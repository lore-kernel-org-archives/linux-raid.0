From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: [ANNOUNCE][PATCH 2.6] md: persistent (file-backed) bitmap and async
 writes
Date: Wed, 31 Mar 2004 13:38:28 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <406B1024.7BF88C@SteelEye.com>
References: <40198E85.29EBC8E0@SteelEye.com>
			<16422.62911.755570.855200@notabene.cse.unsw.edu.au>
			<4027E342.D02202F1@SteelEye.com>
			<16424.8182.876520.280031@notabene.cse.unsw.edu.au>
			<402D3A86.97CF894F@SteelEye.com> <16456.2775.641721.204171@notabene.cse.unsw.edu.au> <4048F9AA.1BBD67F@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org, ptb@it.uc3m.es, mingo@redhat.com, "james.bottomley" <james.bottomley@SteelEye.com>
List-Id: linux-raid.ids

Paul Clements wrote:
> Neil Brown wrote:
> > So, if you can produce a patch which *only* adds a persistent bitmap
> > in a file, uses it to record which blocks are not in-sync, and
> > optimises resync using the bitmap,  and which uses address_space
> > operations for fileio, then I will see if it is acceptable, and we can
> > then start adding bits like hot-repair and async-write etc on top of
> > that.
> 
> I'll work on that and get it out as soon as I can...

OK, so here it is. The changes from the previous patch are, basically:

1) The patch is a little less intrusive now. The diffs against md/raid1
are smaller as more of the bitmap handling code is now isolated in the
bitmap.c and bitmap.h files. Also, the diff against mdadm, while now a
little larger, is less intrusive as I've created a bitmap.c file in the
mdadm sources, as well.

2) The bitmap file I/O routines have been totally rewritten and are now
much simpler. We now use read_cache_page, prepare_write/commit_write (to
extend the file at init time, if necessary), and bmap/submit_bh (to
"sync" the file pages). The use of bmap and submit_bh is due to a
limitation in jbd that allows only one ongoing transaction per process
(see comment in bitmap.c regarding current->journal_info).

3) The bitmap file now has a superblock containing various configuration
information. The bitmap superblock is checked against the md superblock
when the array is assembled. 

Options have been added to mdadm to create and examine bitmap files, and
also to specify the bitmap file to be used with an array:

Create a bitmap file:
--------------------

# mdadm --create-bitmap=65536,3,580480 /tmp/bitmap --force

(this creates a bitmap file with a chunksize of 64KB, a 3 second bitmap
daemon sleep period, and a bitmap (initially dirtied) which is
appropriate for use with an array of 580480 blocks)

Examine a bitmap file:
---------------------

# mdadm --examine-bitmap /tmp/bitmap (or just: mdadm -X /tmp/bitmap)
        Filename : /tmp/bitmap
           Magic : 6d746962
         Version : 2
            UUID : 997cb579.99d31d20.3014cae8.4bb4bf9d
          Events : 5
           State : OK
       Chunksize : 4 KB
          Daemon : 5s flush period
      Array Size : 580480 (566.88 MiB 594.41 MB)
          Bitmap : 145120 bits (chunks), 145120 dirty (100.0%)

(in addition, mdadm -D <array> gives the bitmap information if a bitmap
is attached to the array)


Create or Assemble array using a bitmap:
---------------------------------------

# mdadm -C /dev/md2 -n 2 -l 1 --bitmap=/tmp/bitmap /dev/sda5 missing

# mdadm -A /dev/md2 --bitmap=/tmp/bitmap /dev/sda5 /dev/sdb5



Patch Location:
--------------

Patch vs. linux 2.6.5-rc2
=========================
http://parisc-linux.org/~jejb/md_bitmap/md_bitmap_2_31_2_6_5_RC2.diff

Patch vs. mdadm 1.5.0
=====================
http://parisc-linux.org/~jejb/md_bitmap/mdadm_1_5_0-bitmap.diff

(no async write patch has been generated, these patches contain only the
bitmap code)


Notes:
-----

1) an is_create flag was added to do_md_run to tell bitmap_create
whether we are creating or just assembling the array -- this is
necessary since 0.90 superblocks do not have a UUID until one is
generated randomly at array creation time, therefore, we must set the
bitmap UUID equal to this newly generated array UUID when the array is
created

2) bitmap.h was not included in the mdadm patch, but a link (or copy)
must be made to the kernel's include/linux/raid/bitmap.h file in order
to build mdadm now

3) code was added to mdadm to allow creation of arrays with
non-persistent superblocks (also, device size calculation with
non-persistent superblocks was fixed)

4) a fix was made to the hot_remove code to allow a faulty device to be
removed

5) various typo and minor bug fixes were also included in the patches
