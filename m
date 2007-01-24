From: Neil Brown <neilb@suse.de>
Subject: Re: [patch] md: bitmap read_page error
Date: Wed, 24 Jan 2007 13:39:59 +1100
Message-ID: <17846.50943.624833.922264@notabene.brown>
References: <34781ae60701220003v76bd43c8h79c59b2b474b3c57@mail.gmail.com>
	<17845.16620.741319.612842@notabene.brown>
	<34781ae60701221731k508d8e97yed69929de5a38977@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from yang yin on Tuesday January 23
Sender: linux-raid-owner@vger.kernel.org
To: yang yin <yinyang801120@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday January 23, yinyang801120@gmail.com wrote:
> I think your patch is not enough to slove the read_page error
> completely. I think in the bitmap_init_from_disk we also need to check
> the 'count' never exceeds the size of file before calling the
> read_page function. How do your think about it.
> Thanks your reply.

bitmap_init_from_disk already has a test:

	if (file && i_size_read(file->f_mapping->host) < bytes + sizeof(bitmap_super_t)) {
		printk(KERN_INFO "%s: bitmap file too short %lu < %lu\n",
			bmname(bitmap),
			(unsigned long) i_size_read(file->f_mapping->host),
			bytes + sizeof(bitmap_super_t));
		goto out;
	}

so 'bytes' of the bitmap must fit entirely within the file, and count
is set:
			if (index == num_pages-1)
				count = bytes + sizeof(bitmap_super_t)
					- index * PAGE_SIZE;
			else
				count = PAGE_SIZE;
which ensures that it will not go beyond the end of the file.

So I don't think count can ever exceed the size of the file in this
case. 

Can you still see a problem?

Thanks,
NeilBrown
