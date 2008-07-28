From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: 64k Page size + ext3 errors
Date: Sun, 27 Jul 2008 21:10:07 -0500
Message-ID: <488D2A7F.9080902@gmail.com>
References: <576234.24141.qm@web81307.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <576234.24141.qm@web81307.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

tirumalareddy marri wrote:
> I am using HW accelerated XOR engine for RAID-5 . I am seeing EXT3-fs errors when I use 64K page size. When I use 4K page size I don't see any issue. As many of you know, we will get better performance when we store bigger files like videos.
>  
> When I copy 128MB size files using 64k page size no issues seen. When I tried to copy 1.8 GB file with 64KB page size support I am seeing the following errors. Any clue what could be wrong. 
>  
> Errors 1:
> EXT3-fs error (device md0): ext3_new_block: Allocating block in system zone - blocks from 65533, length 1
> EXT3-fs error (device md0): ext3_new_block: Allocating block in system zone - blocks from 65534, length 1
>  
>  
> Errors2:
> EXT3-fs error (device md0): ext3_readdir: bad entry in directory #2: rec_len % 4 != 0 - offset=0, inode=3040
> 


All that error means is that something screwed up the filesystem stuff when you 
copied the large file.

The lack of an error in the first case does not mean that the correct stuff was 
written to the filesystem, just that nothing screwed up the internal filesystem 
data, or that the cache saved you.

I would suggest setting up a simple test using no filesystem and all, and make 
sure that the correct data can be read and written (and a large enough amount of 
data that you are not reading out of cache) from the MD device directly, write a 
  specific pattern that would have lots of unique data.   If you don't do enough 
data then things *WILL* be coming from cache and still could be screwed up on 
disk, and this may be what is going on in the case of the 128MB  vs 1.8GB case, 
in both cases it may be wrong on disk, but with the 128MB case is coming from 
cache, and in the 1.8GB case is coming off disk.

                                  Roger
