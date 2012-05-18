From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Creating a 3-disk RAID6 array
Date: Thu, 17 May 2012 21:36:12 -0500
Message-ID: <4FB5B59C.2070402@hardwarefreak.com>
References: <4FB4534A.5070608@volatilevoid.net>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FB4534A.5070608@volatilevoid.net>
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Martin <oliver@volatilevoid.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/16/2012 8:24 PM, Oliver Martin wrote:
> Hi,
> 
> is there any specific reason why md refuses to create a RAID6 array with
> 3 disks? My (probably naive) understanding suggests it should be the
> same as a 3-disk RAID1, similar to a 2-disk RAID5.
> 
> The reason I'm asking is that I currently have space on three disks for
> a new array, and would like to expand it when I add a fourth. I tried
> this scenario with a few loopback devices, but the only way to go from a
> 3-disk RAID1 to a 4-disk RAID6 seems to be via an intermediate 3-disk
> RAID5, requiring two reshapes. I'd like to avoid one of them, if at all
> possible.

Make a 3 partition (seems you're using partitions) md RAID 10 (RAID 1E)
array with what you have now.  When you add a disk down the road, backup
your filesystem, create your 4 disk md RAID 6 array, format, restore.

Now for my $0.02:  You're better served all around with a 4 partition
RAID 10 or 1+0, than a 4 partition RAID 6.  Random write performance is
greatly superior, rebuild time is significantly lower, etc.  Sure it
would be nice if mdadm could reshape a 3 disk RAID10 into a 4 disk
RAID10, but it can't.  But since you should be doing a backup/restore
anyway, it doesn't matter.

-- 
Stan
