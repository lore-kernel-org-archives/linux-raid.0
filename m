From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: Typical RAID5 transfer speeds
Date: Sat, 19 Dec 2009 01:30:42 -0700
Message-ID: <200912190130.42585.tfjellstrom@shaw.ca>
References: <B26AD6F5-45F6-4CC6-AE63-E4253E60076C@mac.com> <200912190205.04407.bs_lists@aakef.fastmail.fm>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200912190205.04407.bs_lists@aakef.fastmail.fm>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Cc: Matt Tehonica <matt.tehonica@mac.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri December 18 2009, Bernd Schubert wrote:
> On Saturday 19 December 2009, Matt Tehonica wrote:
> > I have a 4 disk RAID5 using a 2048K chunk size and using XFS
> 
> 4 disks is a bad idea. You should have 2^n data disks, but you have 2^1 +
>  1 = 3 data disks. As parity information are calculated in the power of
>  two and blocks are written in the power of two, you probably have read
>  operations, when you only want to write.
> 
> > filesystem.  Typical file size is about 2GB-5GB. I usually get around
> > 50MB/sec transfer speed when writting files to the array. Is this
> > typcial or is it below normal?  A friend has a 20 disk RAID6 using the
> > same filesystem and chunk size and gets around 150MB/sec. Any input on
> > this??
> 
> I would remove two disks, to get 16 + 2 drives (2^4). Performance
>  probably would be limited by CPU speed then. 150MB/s for 18 drives is
>  also bad, this is only the performance of two single raid0 drives.

I'd have to agree. My 5 disk raid5 array gets me 200-400MB/s, depending on 
the kernel. I'm using a 512K chunk size, formatted with XFS, with 32 AGs, 
and xfs_info reporting: sunit=128 swidth=512 blks (which should be 
right...), and mounted with: 
noatime,nodiratime,logbufs=8,allocsize=512m,largeio,swalloc

oh, not quite 200MB/s, iozone is showing 112MB/s write, and 300MB/s read. 
I'm pretty sure that has something to do with the writeback stuff though, 
and aught to be improved in 2.6.32+ (I have yet to find a good time to 
upgrade my server). I know I have seen the SAS card, and an initial array 
handle more throughput than that when I was first testing stuff months and 
months ago. It was more like 200-350 write, and 400-550 read.

But yeah, 50MB/s is pretty bad for a raid array. The individual disks in my 
array are all capable of more than that each.  (Yes, I know raid5 will not 
give a linear improvement when adding more drives, but it aught to be a heck 
of a lot better than a decrease in performance)

> 
> Cheers,
> Bernd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
