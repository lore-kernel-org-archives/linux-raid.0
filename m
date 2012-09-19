From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Serious performance issues with mdadm RAID-5 partition exported through LIO (iSCSI)
Date: Wed, 19 Sep 2012 11:20:35 -0600
Message-ID: <D9B1133B-29BC-48C9-9859-26A376F75849@colorremedies.com>
References: <50588731.5050502@bananateam.nl> <1347997760.25356.16.camel@haakon2.linux-iscsi.org> <20568.58664.669085.313654@tree.ty.sabi.co.UK> <5059D465.9020802@bananateam.nl>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5059D465.9020802@bananateam.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
Cc: target-devel@vger.kernel.org
List-Id: linux-raid.ids


On Sep 19, 2012, at 8:19 AM, freaky wrote:
> 
> Sector size (logical/physical): 512B/4096B

Are all of the underlying drives 512e AF disks? At least one of the embedded GPTs (I'm uncertain how three layers of partitioning can be anything be complicated) defines an unaligned partition, but it's a tiny reserved partition. Everything else appears to be aligned to 4K sectors, but the two start sectors you provided are different which is also confusing why they don't start on 2048s which is the parted default.

On all of the physical devices are all of the partitions 4K aligned?


> Disk /dev/md4
> 1      1966080B

That's a start sector of 3840.

> 
> Disk /dev/md4p1
>  1      17408B

That's a start sector of 34, and not 4K divisible. 


Chris Murphy

