From: Sean Fu <fxinrong@gmail.com>
Subject: Re: [PATCH 3/3] md: bitmap: Support circular buffer list.
Date: Tue, 2 Jan 2018 15:34:36 +0800
Message-ID: <20180102073435.GA12496@linux-zmni.apac.novell.com>
References: <cover.1514867850.git.fxinrong@gmail.com>
 <694be2a2fa9aba6955a11c9ce5556705431d4528.1514867850.git.fxinrong@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <694be2a2fa9aba6955a11c9ce5556705431d4528.1514867850.git.fxinrong@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: shli@kernel.org, viro@zeniv.linux.org.uk, anton@tuxera.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net
List-Id: linux-raid.ids

On Tue, Jan 02, 2018 at 02:54:49PM +0800, Sean Fu wrote:
> Modify write_page free_buffers and read_page to support circular buffer
> list.
> 
> Signed-off-by: Sean Fu <fxinrong@gmail.com>
> ---
>  drivers/md/md-bitmap.c | 36 +++++++++++++++++++-----------------
>  1 file changed, 19 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 239c7bb..b8412c2 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -286,7 +286,7 @@ static void bitmap_file_kick(struct bitmap *bitmap);
>   */
>  static void write_page(struct bitmap *bitmap, struct page *page, int wait)
>  {
> -	struct buffer_head *bh;
> +	struct buffer_head *bh, *head;
>  
>  	if (bitmap->storage.file == NULL) {
>  		switch (write_sb_page(bitmap, page, wait)) {
> @@ -295,15 +295,16 @@ static void write_page(struct bitmap *bitmap, struct page *page, int wait)
>  		}
>  	} else {
>  
> -		bh = page_buffers(page);
> +		bh = head = page_buffers(page);
>  
> -		while (bh && bh->b_blocknr) {
> -			atomic_inc(&bitmap->pending_writes);
> -			set_buffer_locked(bh);
> -			set_buffer_mapped(bh);
> -			submit_bh(REQ_OP_WRITE, REQ_SYNC, bh);
> -			bh = bh->b_this_page;
> -		}
> +		do {
> +			if (bh && bh->b_blocknr) {
> +				atomic_inc(&bitmap->pending_writes);
> +				set_buffer_locked(bh);
> +				set_buffer_mapped(bh);
> +				submit_bh(REQ_OP_WRITE, REQ_SYNC, bh);
> +			}
> +		} while ((bh = bh->b_this_page) != head);
>  
>  		if (wait)
>  			wait_event(bitmap->write_wait,
> @@ -333,17 +334,18 @@ __clear_page_buffers(struct page *page)
>  }
>  static void free_buffers(struct page *page)
>  {
> -	struct buffer_head *bh;
> +	struct buffer_head *bh, *head;
>  
>  	if (!PagePrivate(page))
>  		return;
>  
> -	bh = page_buffers(page);
> -	while (bh) {
> +	bh = head = page_buffers(page);
> +	do {
>  		struct buffer_head *next = bh->b_this_page;
>  		free_buffer_head(bh);
>  		bh = next;
> -	}
> +	} while (bh != head);
> +
>  	__clear_page_buffers(page);
>  	put_page(page);
>  }
> @@ -362,20 +364,20 @@ static int read_page(struct file *file, unsigned long index,
>  {
>  	int ret = 0;
>  	struct inode *inode = file_inode(file);
> -	struct buffer_head *bh;
> +	struct buffer_head *bh, *head;
>  	sector_t block;
>  
>  	pr_debug("read bitmap file (%dB @ %llu)\n", (int)PAGE_SIZE,
>  		 (unsigned long long)index << PAGE_SHIFT);
>  
> -	bh = alloc_page_buffers(page, 1<<inode->i_blkbits, false);
> +	bh = head = alloc_page_buffers(page, 1<<inode->i_blkbits, false);
>  	if (!bh) {
>  		ret = -ENOMEM;
>  		goto out;
>  	}
>  	attach_page_buffers(page, bh);
>  	block = index << (PAGE_SHIFT - inode->i_blkbits);
> -	while (bh) {
> +	do {
>  		if (count == 0)
>  			bh->b_blocknr = 0;
>  		else {
> @@ -400,7 +402,7 @@ static int read_page(struct file *file, unsigned long index,
>  		}
>  		block++;
>  		bh = bh->b_this_page;
> -	}
> +	} while (bh != head);
>  	page->index = index;
>  
>  	wait_event(bitmap->write_wait,
> -- 
> 2.6.2
>
Before
sean@linux-zmni:~/sda5/source/linus_repo/linux> size fs/buffer.o
   text	   data	    bss	    dec	    hex	filename
  33693	   1466	     16	  35175	   8967	fs/buffer.o
sean@linux-zmni:~/sda5/source/linus_repo/linux> size drivers/md/md-bitmap.o
   text	   data	    bss	    dec	    hex	filename
  28149	   2168	      0	  30317	   766d	drivers/md/md-bitmap.o
sean@linux-zmni:~/sda5/source/linus_repo/linux> size fs/ntfs/mft.o 
   text	   data	    bss	    dec	    hex	filename
   2133	     36	      0	   2169	    879	fs/ntfs/mft.o
sean@linux-zmni:~/sda5/source/linus_repo/linux> size fs/ntfs/aops.o
   text	   data	    bss	    dec	    hex	filename
   6125	    168	      0	   6293	   1895	fs/ntfs/aops.o
sean@linux-zmni:~/sda5/source/linus_repo/linux> size vmlinux
   text	   data	    bss	    dec	    hex	filename
11480260	5730762	1646084	18857106	11fbc92	vmlinux
sean@linux-zmni:~/sda5/source/linus_repo/linux> size ./arch/x86/boot/bzImage
size: ./arch/x86/boot/bzImage: Warning: Ignoring section flag IMAGE_SCN_MEM_NOT_PAGED in section .bss
   text	   data	    bss	    dec	    hex	filename
6571744	      0	16975648	23547392	1674e00	./arch/x86/boot/bzImage


After
sean@linux-zmni:~/sda5/source/linus_repo/linux> size fs/buffer.o 
   text	   data	    bss	    dec	    hex	filename
  33687	   1466	     16	  35169	   8961	fs/buffer.o
sean@linux-zmni:~/sda5/source/linus_repo/linux> size drivers/md/md-bitmap.o 
   text	   data	    bss	    dec	    hex	filename
  28221	   2168	      0	  30389	   76b5	drivers/md/md-bitmap.o
sean@linux-zmni:~/sda5/source/linus_repo/linux> size fs/ntfs/mft.o 
   text	   data	    bss	    dec	    hex	filename
   2133	     36	      0	   2169	    879	fs/ntfs/mft.o
sean@linux-zmni:~/sda5/source/linus_repo/linux> size fs/ntfs/aops.o
   text	   data	    bss	    dec	    hex	filename
   6125	    168	      0	   6293	   1895	fs/ntfs/aops.o
sean@linux-zmni:~/sda5/source/linus_repo/linux> size vmlinux
   text	   data	    bss	    dec	    hex	filename
11480270	5730762	1646084	18857116	11fbc9c	vmlinux
sean@linux-zmni:~/sda5/source/linus_repo/linux> size ./arch/x86/boot/bzImage
size: ./arch/x86/boot/bzImage: Warning: Ignoring section flag IMAGE_SCN_MEM_NOT_PAGED in section .bss
   text	   data	    bss	    dec	    hex	filename
6571488	      0	16975904	23547392	1674e00	./arch/x86/boot/bzImage

Only patch #3 increases the text section size of drivers/md/md-bitmap.o
The actual text section increment should be several bytes. Duo to compiler align-functions option, the total increment is increased to 72 bytes.

Why is circular list traversal more complex than linear list traversal in this situation?  
How to optimize it? 
