From: Neil Brown <neilb@suse.de>
Subject: Re: [patch] md: bitmap read_page error
Date: Tue, 23 Jan 2007 09:55:40 +1100
Message-ID: <17845.16620.741319.612842@notabene.brown>
References: <34781ae60701220003v76bd43c8h79c59b2b474b3c57@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from yang yin on Monday January 22
Sender: linux-raid-owner@vger.kernel.org
To: yang yin <yinyang801120@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Monday January 22, yinyang801120@gmail.com wrote:
> If the bitmap size is less than one page including super_block and
> bitmap and the inode's i_blkbits is also small, when doing the
> read_page function call to read the sb_page, it may return a error.
> For example, if the device is 12800 chunks, its bitmap file size is
> about 1.6KB include the bitmap super block. But the inode i_blkbits
> value of the bitmap file is 10,  the read_page will submit 4 bh to
> load the sb_page. Because the size of bitmap is only 1.6KB, in the
> while loop, the error will ocurr when do bmap operation for the block
> 2, which will  return 0. Then the bitmap can't be initated because of
> ther read sb page fail.
> 
> Another error is in the bitmap_init_from_disk function.  Before doing
> read_page,. calculating the count value misses the size of super
> block. When the bitmap just needs one page, It will read two pages
> adding the super block. But at the second read, the count value will
> be set to 0, and not all the bitmap will be read from the disk and
> some bitmap will missed at the second page.
> 
> I give a patch as following:

Thanks a lot for this.
Rather than checking the file size in read_page, I would like to make
sure the 'count' that is passed in never exceeds the size of the
file.  This should have the same effect.

So this is that patch I plan to submit.

Thanks again,
NeilBrown


------------------
Avoid reading past the end of a bitmap file.

In most cases we check the size of the bitmap file before
reading data from it.  However when reading the superblock,
we always read the first PAGE_SIZE bytes, which might not 
always be appropriate.  So limit that read to the size of the
file if appropriate.

Also, we get the count of available bytes wrong in one place,
so that too can read past the end of the file.

Cc:  "yang yin" <yinyang801120@gmail.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/bitmap.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff .prev/drivers/md/bitmap.c ./drivers/md/bitmap.c
--- .prev/drivers/md/bitmap.c	2007-01-23 09:44:11.000000000 +1100
+++ ./drivers/md/bitmap.c	2007-01-23 09:44:59.000000000 +1100
@@ -479,9 +479,12 @@ static int bitmap_read_sb(struct bitmap 
 	int err = -EINVAL;
 
 	/* page 0 is the superblock, read it... */
-	if (bitmap->file)
-		bitmap->sb_page = read_page(bitmap->file, 0, bitmap, PAGE_SIZE);
-	else {
+	if (bitmap->file) {
+		loff_t isize = i_size_read(bitmap->file->f_mapping->host);
+		int bytes = isize > PAGE_SIZE ? PAGE_SIZE : isize;
+
+		bitmap->sb_page = read_page(bitmap->file, 0, bitmap, bytes);
+	} else {
 		bitmap->sb_page = read_sb_page(bitmap->mddev, bitmap->offset, 0);
 	}
 	if (IS_ERR(bitmap->sb_page)) {
@@ -877,7 +880,8 @@ static int bitmap_init_from_disk(struct 
 			int count;
 			/* unmap the old page, we're done with it */
 			if (index == num_pages-1)
-				count = bytes - index * PAGE_SIZE;
+				count = bytes + sizeof(bitmap_super_t)
+					- index * PAGE_SIZE;
 			else
 				count = PAGE_SIZE;
 			if (index == 0) {
