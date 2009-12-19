From: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Subject: Re: Typical RAID5 transfer speeds
Date: Sat, 19 Dec 2009 02:05:04 +0100
Message-ID: <200912190205.04407.bs_lists@aakef.fastmail.fm>
References: <B26AD6F5-45F6-4CC6-AE63-E4253E60076C@mac.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B26AD6F5-45F6-4CC6-AE63-E4253E60076C@mac.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Tehonica <matt.tehonica@mac.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday 19 December 2009, Matt Tehonica wrote:
> I have a 4 disk RAID5 using a 2048K chunk size and using XFS

4 disks is a bad idea. You should have 2^n data disks, but you have 2^1 + 1 = 
3 data disks. As parity information are calculated in the power of two and 
blocks are written in the power of two, you probably have read operations, 
when you only want to write.

> filesystem.  Typical file size is about 2GB-5GB. I usually get around
> 50MB/sec transfer speed when writting files to the array. Is this
> typcial or is it below normal?  A friend has a 20 disk RAID6 using the
> same filesystem and chunk size and gets around 150MB/sec. Any input on
> this??

I would remove two disks, to get 16 + 2 drives (2^4). Performance probably 
would be limited by CPU speed then. 150MB/s for 18 drives is also bad, this is 
only the performance of two single raid0 drives. 


Cheers,
Bernd
