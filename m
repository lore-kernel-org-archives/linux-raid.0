From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: mdadm cannot open devices
Date: Mon, 29 Dec 2008 12:35:15 +1300
Message-ID: <49580D33.9010600@sauce.co.nz>
References: <4956CBB2.7030805@sauce.co.nz> <f1ba3787cda05ba24f9f60e7b058cb5d.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f1ba3787cda05ba24f9f60e7b058cb5d.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown wrote:

> This typically happens because /dev/sda and /dev/sdb have md superblocks
> on them and mdadm attempts to assemble an array from those and in the
> process tell the kernel to forget about the partitions.
> Can you:
> 
>   blockdev --rereadpt /dev/sda
>   blockdev --rereadpt /dev/sdb
>   mdadm -E /dev/sda* /dev/sdb*
> 
> and report the result?

Hi Neil,

Thanks for the reply, but due to time constraints I have had to abandon 
this, although I would be interested in your comments on what I found 
after this my mail and before giving up.

The 2 1TB Seagate drives were taken directly from a 4 drive Windows 
Vista striped (RAID0) array - they have never had md RAID installed.

I discovered that for whatever reason /proc/partitions, although it 
showed entries for sda and sdb, it did not have entries for the 
partitions sda1 and sda2 and I guess this is why mdadm had trouble.

Thinking it might have been an fdisk limitation, I tried partitioning 
using parted - same result.

I then tried building using sda and sdb, instead of partitions and this 
time the mdadm errors were along the lines of "device busy" for both 
drives - even after rebooting.

At this point I gave up. The drives were attached to an Adaptec PCI SATA 
card, which along with 2 SATA drives on the onboard controller and a 
PCI-X SCSI adapter with 2 drives attached, seemed to cause much 
shuffling of sd devices during bootup, so I am wondering if this 
contributed.

Regards,

Richard
