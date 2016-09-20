From: Anthony DeRobertis <anthony@derobert.net>
Subject: Re: 95a05b3 broke mdadm --add on my superblock 1.0 array
Date: Tue, 20 Sep 2016 13:12:24 -0400
Message-ID: <20160920171223.n7t3wa673qopky4c@derobert.net>
References: <20160919163229.uccdr6bxiwetqvwo@derobert.net>
 <57E0CB6C.2040000@suse.com>
 <63417807-ae42-ed60-8c8b-3b699994c34c@derobert.net>
 <57E10311.7040601@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57E10311.7040601@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, 837964@bugs.debian.org
List-Id: linux-raid.ids

On Tue, Sep 20, 2016 at 05:36:17AM -0400, Guoqing Jiang wrote:

> The md-cluster code should only work raid1 with 1.2 metadata, and your array
> (/dev/md/pv0) is raid10 with
> 1.0 metadata (if I read bug correctly),

Correct, it's 1.0 metadata and raid10.

> I assume it only happens with existed array,  a new created one doesn't have
> the problem, right? And I can't
> reproduce it from my side.

yeah, I made a 1.0 raid10 with 4 LVs, and couldn't trigger the bug. Of
course, that array was also much smaller.

> 
> Which kernel version are you used to created the array in case the kernel
> was updated?

I've had the array for a while (the superblocks with -E show a creation
time of Wed Jun 16 14:25:08 2010). If I had to take a guess, I'd guess
it was created with the Debian squeeze alpha1 installer... So probably
2.6.30 or 2.6.32.

> Also pls show the
> output of "mdadm -X $DISK", and your bitmap is a little weird (but I don't
> try with 10 level before, so maybe
> it is correct).

I'd guess it was created by doing 'mdadm --grow --bitmap internal' at
some point after the array was created, but I'm not sure. Could have
been created with the array.

# ./mdadm -X /dev/sd[abde]3 
        Filename : /dev/sda3
           Magic : 6d746962
         Version : 4
            UUID : c840d0de:0626d783:3f1b28dc:c5ec649a
          Events : 1124478
  Events Cleared : 1124478
           State : OK
       Chunksize : 2 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 1953005568 (1862.53 GiB 1999.88 GB)
          Bitmap : 953616 bits (chunks), 54 dirty (0.0%)
        Filename : /dev/sdb3
           Magic : 6d746962
         Version : 4
            UUID : c840d0de:0626d783:3f1b28dc:c5ec649a
          Events : 1124478
  Events Cleared : 1124478
           State : OK
       Chunksize : 2 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 1953005568 (1862.53 GiB 1999.88 GB)
          Bitmap : 953616 bits (chunks), 54 dirty (0.0%)
        Filename : /dev/sdd3
           Magic : 6d746962
         Version : 4
            UUID : c840d0de:0626d783:3f1b28dc:c5ec649a
          Events : 1124478
  Events Cleared : 1124478
           State : OK
       Chunksize : 2 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 1953005568 (1862.53 GiB 1999.88 GB)
          Bitmap : 953616 bits (chunks), 54 dirty (0.0%)
        Filename : /dev/sde3
           Magic : 6d746962
         Version : 4
            UUID : c840d0de:0626d783:3f1b28dc:c5ec649a
          Events : 1124478
  Events Cleared : 1124478
           State : OK
       Chunksize : 2 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 1953005568 (1862.53 GiB 1999.88 GB)
          Bitmap : 953616 bits (chunks), 84 dirty (0.0%)

