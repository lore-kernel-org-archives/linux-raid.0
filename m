From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: new superblock and raid10 support in mdadm
Date: Thu, 23 Dec 2004 09:55:35 +1100
Message-ID: <16841.64359.324444.351443@cse.unsw.edu.au>
References: <16710.17573.491674.378912@cse.unsw.edu.au>
	<000001c4e858$4c1afe20$6d01a8c0@asitest>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from BO MOON on Wednesday December 22
Sender: linux-raid-owner@vger.kernel.org
To: BO MOON <bmoon@anthologysolutions.com>
Cc: 'rich turner' <rich@storix.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday December 22, bmoon@anthologysolutions.com wrote:
> Hello,
> 
> I noticed some discussions on last September email log,
> But I am not sure.
> 
> I tried to make RAID10 or RAID01. I could make it but
> Problem is that I could not assemble it by "mdadm -As"
> When the system is rebooted.
> 
> My "mdadm.conf" is
> 
>     DEVICE /dev/hd*
>     ARRAY /dev/md0 level=raid1 num-devices=2 devices=/dev/hda4,/dev/hdc4
>     ARRAY /dev/md1 level=raid1 num-devices=2 devices=/dev/hde4,/dev/hdg4
>     ARRAY /dev/md2 level=raid0 num-devices=2 devices=/dev/md0,/dev/md1
> 
> My S/W revs are:
> 
> Linux 2.4.20
> Mdadm 1.2.0
> 
> My HDD size are all greater than 120 GB.
> 
> I tried it manually, too: first assemble the RAID1: md0 and md1.
> Then tried to assemble "md2" but it said "could not find devices for
> md2"

That would be because /dev/md0 and /dev/md1 aren't listed in "DEVICE"
lines.

NeilBrown

> 
> We do not support RAID10 or RAID01 on linux2.4.xx?  
> or any issues on mdadm? 
> 
> Please provide me any clues or advices,
> 
> Bo
> 
