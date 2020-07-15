From: antlists <antlists@youngman.org.uk>
Subject: Re: Reshape using drives not partitions, RAID gone after reboot
Date: Wed, 15 Jul 2020 01:24:07 +0100
Message-ID: <730bb16a-235d-9186-a486-7ed0018121ab@youngman.org.uk>
References: <b551920e-ddad-c627-d75a-e99d32247b6d@gmail.com>
 <0b857b5f-20aa-871d-a22d-43d26ad64764@youngman.org.uk>
 <CAAMCDec22wshoG8eb9aM4su-EBdJRbh_LyVtaskR9FbYc4f=gw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDec22wshoG8eb9aM4su-EBdJRbh_LyVtaskR9FbYc4f=gw@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: Adam Barnett <adamtravisbarnett@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 15/07/2020 00:27, Roger Heflin wrote:
> Did you create the partition before you added the disk to mdadm or
> after?  If after was it a dos or a gpt?  Dos should have only cleared
> the first 512byte block.  If gpt it will have written to the first
> block and to at least 1 more location on the disk, possibly causing
> data loss.
> 
> If before then you at least need to get rid of the partition table
> completely.   Having a partition on a device will often cause a number
> of things to ignore the whole disk.  I have debugged "lost" pv's where
> the partition effectively "blocked" lvm from even looking at the
> entire device that the pv was one.

If an explicit assemble works, then if you can get hold of a temporary 
spare/loan disk, I'd slowly move the new disks across to partitions by 
doing a --replace, not a --remove / --add. A replace will both keep the 
array protected against failure, and also not stress the array because 
it will just copy the old disk to the new, rather than rebuilding the 
new disk from all the others.

I'm not sure about the commands, but iirc mdadm has a --wipe-superblock 
command or something, as does fdisk have something to wipe a gpt, so 
make sure you clear that stuff out before re-initialising a disk.

Cheers,
Wol
