From: Neil Brown <neilb@suse.de>
Subject: Re: [BUG/PATCH] md bitmap broken on big endian machines
Date: Thu, 28 Sep 2006 16:34:28 +1000
Message-ID: <17691.27892.571457.628971@cse.unsw.edu.au>
References: <4512F55D.5030907@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Thursday September 21
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday September 21, paul.clements@steeleye.com wrote:
> Neil,
> 
> We just discovered this problem on a 64-bit IBM POWER (ppc64) system. 
> The symptom was this BUG():
> 
> Sep 20 20:55:51 caspian kernel: kernel BUG in sync_request at 
> drivers/md/raid1.c:1743!

groan....

> 
> I traced the problem back to a bad value in bitmap->chunkshift (the 
> value was 8, instead of 16, with a chunksize of 64K). I think this means 
> that bitmaps are broken on all big endian systems. It looks like we 
> should be using ffs instead of find_first_bit. Patch has been compile 
> tested only.

Does this mean we need to up the superblock version number?  When
reading a version-4 (or earlier) bitmap you cannot be sure if the
correct chunk_shift was used so you cannot trust it.
But I don't like the idea of forcing everyone to upgrade their
bitmap... 
Maybe it doesn't matter too much.  If there does turn out to be a
problem - which there won't be for the little-endian majority - a
simple 'repair' process will resolve everything.

> 
> Thanks,
> Paul
> --- ./drivers/md/bitmap.c.orig	2006-09-21 16:10:17.000000000 -0400
> +++ ./drivers/md/bitmap.c	2006-09-21 16:12:16.000000000 -0400
> @@ -1578,8 +1578,7 @@ int bitmap_create(mddev_t *mddev)
>  	if (err)
>  		goto error;
>  
> -	bitmap->chunkshift = find_first_bit(&bitmap->chunksize,
> -					sizeof(bitmap->chunksize));
> +	bitmap->chunkshift = ffs(bitmap->chunksize) - 1;

bitmap->chunksize is 'unsigned long'. ffs takes an 'int'.
So there are type issues there.
ffz takes an 'unsigned long', so it is probably safer to use that.
See below.

Thanks,
NeilBrown

--------------------

Use ffz instead of find_first_set to convert multiplier to shift.

From: Paul Clements <paul.clements@steeleye.com>

find_first_set doesn't find the least-significant bit on bigendian
machines, so it is really wrong to use it.

ffs is closer, but takes an 'int' and we have a 'unsigned long'.
So use ffz(~X) to convert a chunksize into a chunkshift.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2006-09-28 16:30:51.000000000 +1000
+++ ./drivers/md/bitmap.c	2006-09-28 16:31:04.000000000 +1000
@@ -1444,8 +1444,7 @@ int bitmap_create(mddev_t *mddev)
 	if (err)
 		goto error;
 
-	bitmap->chunkshift = find_first_bit(&bitmap->chunksize,
-					sizeof(bitmap->chunksize));
+	bitmap->chunkshift = ffz(~bitmap->chunksize);
 
 	/* now that chunksize and chunkshift are set, we can use these macros */
  	chunks = (blocks + CHUNK_BLOCK_RATIO(bitmap) - 1) /

