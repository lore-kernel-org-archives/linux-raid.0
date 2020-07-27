From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 12/23] initrd: switch initrd loading to struct file based
 APIs
Date: Mon, 27 Jul 2020 02:50:38 +0100
Message-ID: <20200727015038.GA795125@ZenIV.linux.org.uk>
References: <20200714190427.4332-1-hch@lst.de>
 <20200714190427.4332-13-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200714190427.4332-13-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 14, 2020 at 09:04:16PM +0200, Christoph Hellwig wrote:

>  static int __init
> -identify_ramdisk_image(int fd, int start_block, decompress_fn *decompressor)
> +identify_ramdisk_image(struct file *file, int start_block,
> +		decompress_fn *decompressor)
>  {
....
> -	ksys_lseek(fd, start_block * BLOCK_SIZE, 0);
>  	kfree(buf);
>  	return nblocks;
>  }

You do realize that you've changed behaviour of that thing if start_block != 0?
Old one used to leave the things for subsequent reads to start at start_block * 512;
new one will ignore that.  So after

> -	nblocks = identify_ramdisk_image(in_fd, rd_image_start, &decompressor);
> +	nblocks = identify_ramdisk_image(in_file, rd_image_start, &decompressor);

you'll have in_file->f_pos left at 0 instead of rd_image_start * 512.

... affecting this

> -		if (crd_load(in_fd, out_fd, decompressor) == 0)
> +		if (crd_load(in_file, out_file, decompressor) == 0)


... and this

> -		ksys_read(in_fd, buf, BLOCK_SIZE);
> -		ksys_write(out_fd, buf, BLOCK_SIZE);
> +		kernel_read(in_file, buf, BLOCK_SIZE, &in_file->f_pos);
> +		kernel_write(out_file, buf, BLOCK_SIZE, &out_file->f_pos);

FWIW, I would suggest *not* bothering with ->f_pos and using two global
(well, file-static, obviously) variables instead.  And kill 'pos' in
identify_ramdisk_image() as well - use the in_pos instead.
