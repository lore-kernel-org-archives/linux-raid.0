From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: My MD is too big to resize ext4.
Date: Sat, 8 Jul 2017 21:44:27 +0200
Message-ID: <20170708194427.GA15208@metamorpher.de>
References: <6c827d07-19d8-017b-ca95-5e6f84b7821a@gmail.com>
 <20170708065040.GA3682@metamorpher.de>
 <ae47b321-07d1-2157-c217-844447e51ce2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ae47b321-07d1-2157-c217-844447e51ce2@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Jul 08, 2017 at 01:12:11PM -0500, Ram Ramesh wrote:
>     1. My MD uses partitions sd{b,c,d,e,f,g}1 instead of full disks. So 
> I can create partitions on the drive instead of on the MD.
>     2. This means I need to shrink my current md device to smaller size 
> (say 12TB-14TB) - need to check my current
>           active ext4 data size. It is definitely less than 16TB.
>     3. Repartition the disks to create sd{b-g}2 for the reamining unused 
> 6xnTB area.
>     4. Created md1 with sd{b-g]2 to get md1.
>     5. Mount and use md1.

Should work; you have to shrink the filesystem first, (or stick to 
whatever size it has now), then the md, then the partition.

What makes this risky is that you have to pick the correct sizes. 
When growing you can't go wrong. When shrinking, you have to be 
careful not to shrink too much. Filesystems don't like it at all 
if their end is missing, and md doesn't like it if the block device 
is smaller than what it says in the metadata.

So you have to determine the exact filesystem size (tune2fs -l), 
and take mdadm data offsets into account.

Not necessary if you know what you're doing but if in doubt,
you can leave a safety margin with each of these steps.

Regards
Andreas Klauer
