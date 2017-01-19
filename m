From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: HELP! RAID5 array disappeared after partitions deleted
Date: Thu, 19 Jan 2017 13:52:28 +0000
Message-ID: <5880C49C.5090508@youngman.org.uk>
References: <e3f5d5ff-cea5-8cdc-c235-768e73293283@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e3f5d5ff-cea5-8cdc-c235-768e73293283@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: kyle <kyle.upton.is@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19/01/17 08:57, kyle wrote:
> I have (had) a large RAID5 array (3x8TB) up and running on Ubuntu 16.04
> using the guide on the following page:
> 
> https://www.digitalocean.com/community/tutorials/how-to-create-raid-arrays-with-mdadm-on-ubuntu-16-04
> 
> 
> The array seemed to be running well, and was automatically loaded on
> re-boot etc, all good!
> 
> Today however, i was formatting some USB drives in gparted and it popped
> up some error about the partition table for the raid drives appearing
> corrupted, and using the backup. I didn't think much of this at the
> time, but it looks like that deleted the partition tables, and now i
> have no array.
> 
I need to write this stuff up - I keep saying this ...

Search for the following thread(s) and read them:

Please help RAID1 complete fail no superblock 22/11/16

RAID10 with 2 drives auto-assembled as RAID1 05/11/16

Dates are DMY European format. You want to hexdump the likely disk
locations and try and find partition superblocks, raid superblocks, etc
etc. If you can find anything like that and post it to the list, then
the experts can chime in and help you get it back.

There's probably a few more threads like that, but those are the ones
I've just found.

Cheers,
Wol
