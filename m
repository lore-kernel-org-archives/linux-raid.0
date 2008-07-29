From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: 64k Page size + ext3 errors
Date: Mon, 28 Jul 2008 19:33:34 -0500
Message-ID: <488E655E.1070408@gmail.com>
References: <153154.27693.qm@web81301.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <153154.27693.qm@web81301.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

tirumalareddy marri wrote:
> Hi Roger,
>    I did sync after I copied the 128MB data. Isn't that should guarantee data is flushed to disk ? I am using "sum" command to check if data file is copied to Disk is valid or not. 

It means it will be flushed to disk, it does not mean that when you read it back 
that will come off disk, if it is still in memory then it will come out of 
memory, and still be wrong on disk.    If you won't want to to more complicated 
test it might be best to create the file, csum it and if it is ok umount the 
device and remount it and csum it again and see, this should at least force it 
to come off of disk again.

How much memory does your test machine have?


> Here is more information.
> setup: Created /dev/md0 of 30GB size , created ext3 files system. Then started SAMBA server to export mountded /dev/md0 to a windows machine to run IO and copy files.
> 4K Page size:
> -------------------
> 1. IO Meter Test: Works just fine.

None of the benchmarks I am familiar with actually confirm that the data is 
good, the only way one of the benchmarks will fail is if the file table gets 
corrupted, and they may run in cache.

> 2. Copied 1.8 GB file and check sum is good.
> 3. Performance is not good because of small page size.
> 16k Page size:
> ---------------------
> 1. RAID-5 fails some times with " Attempt to access beyond the end of device"
> 2. Copied 128MB and 385MB file. Checked check sum, they are matching check sum.
> 3. Copied 1.8 GB file , this failed checksum test using "sum" command. I see "EXT3-fs errors".
> 64K Page size:
> ----------------------
> 1. RAID-5 failes some times with "Attempt to access beyond the end of device"
> 2. Able to copy 128MB data and check sum test passed.
> 3. Copying 385MB and 1.8 GB file with EXT3-fs errors.
> Thanks,
> Marri

I would write directly to the /dev/mdx a specific pattern (a stream of binary 
numbers from 1 ... whatever works fine), and then read that back and see how 
things match or don't.   csum *can* fail, and if you have enough memory then any 
corruption actually on disk *WON'T* be found until somethings causes it to be 
ejected from cache, and then later re-read from disk.

                               Roger
