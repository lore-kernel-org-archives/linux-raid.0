From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: My MD is too big to resize ext4.
Date: Sat, 8 Jul 2017 15:34:28 +0800
Message-ID: <02786811-5d00-af90-adfd-82ae3f9f0781@fnarfbargle.com>
References: <6c827d07-19d8-017b-ca95-5e6f84b7821a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6c827d07-19d8-017b-ca95-5e6f84b7821a@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/07/17 08:41, Ram Ramesh wrote:
> Hi,
>
> I asked in other linux forums and did not get enough info. So I come
> here even though this is not mdadm/RAID issue.
>
> I replaced 3TB disks in my 6-disk RAID6 with 6TB and now my md0 is 24TB.
> I had 32bit version of ext4 on it which can only be grown to 16TB. Any
> one had this issue before and any _/inplace/_ good solution to grow ext4
> to full 24TB? It is unlikely that I will be able to back up and recreate
> file system.

Ignore this first suggestion if you are absolutely reliant on data 
integrity and don't have backups of any critical data.

Take 2 of the 6TB drives, create a 12TB RAID0 or Linear and copy all 
your data to that.

Create the 6 drive RAID6 with 2 disks missing, copy all the data back, 
then add the disks you used in the first copy back to the array.


I had this issue a few years ago and decided buying some extra disks to 
use as scratch was a better move for me. In your shoes I would have 
found 6 extra SATA ports on a machine (any machine), created the new 
filesystem and rsynced the data across, then swapped the disks into the 
production machine.

In fact I've just done that migrating from 14x2TB drives to 8x6TB 
drives, but I keep a staging machine around for testing that has 15 
drive bays for just this sort of migration.

This is the 4th time I've done it in 13 years. 15x250GB -> 8x1TB -> 
14x2TB -> 8x6TB. The advantage is you never lose data integrity or 
redundancy, and you can keep the old drives around in a box until you 
are sure the new build is reliable.

Alternatively, find a machine with 6 slots, build a RAID6 from the 
drives you already have. Copy the data across, re-format the new array 
and copy the data back. A bit of double handling, but no loss of 
redundancy or integrity. Run md5 or something over all the files to make 
sure it's all good, or use rsync with the "always checksum" option, 
although this is slow.

Brad
