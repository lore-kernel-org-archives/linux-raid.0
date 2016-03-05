From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: RAID6 Array crash during reshape.....now will not re-assemble.
Date: Sat, 5 Mar 2016 11:47:55 +0100
Message-ID: <20160305104755.GA3541@EIS>
References: <CAOS+5GEd4E2wzYhw0rPdrZnjK6UwAUdKCQLLTxXrdPO8d7hS7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOS+5GEd4E2wzYhw0rPdrZnjK6UwAUdKCQLLTxXrdPO8d7hS7w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Another Sillyname <anothersname@googlemail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Mar 02, 2016 at 03:46:48AM +0000, Another Sillyname wrote:
> As all the drives are showing Reshape pos'n 0 I'm assuming the reshape
> never got started (even though cat /proc/mdstat showed the array
> reshaping)?

I fixed such a thing by editing RAID metadata to no longer be in 
reshape state... incomplete instructions: 

https://bpaste.net/show/2231e697431d

The example above used 1.0 superblock I think; in order to adapt this 
successfully to your situation you should refer to

https://raid.wiki.kernel.org/index.php/RAID_superblock_formats#The_version-1_superblock_format_on-disk_layout

If current mdadm/kernel has a way to get out of this ditch directly of 
course that would be so much better...

Apart from that, the other alternative that comes to mind is using 
--create but for that to be successful, you have to be sure to get all 
variables right (superblock version, data offset, raid level, chunk 
size, disk order, ...) and use --assume-clean and/or missing disks 
to prevent resyncs and verify the results in read-only mode.

Regards
Andreas
