From: Patrick Smears <patrick@smears.org>
Subject: mdadm fails to recognise DDF partitions from Marvell MV64460 controller
Date: Fri, 06 Dec 2013 17:44:28 +0000
Message-ID: <52A20CFC.7050802@smears.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a Lenovo D20 server, which has a Marvel MV64460 (fake)RAID 
controller.

For various reasons I need to be able to dual-boot the machine with 
Windows, so I need to use the native RAID format (which the Windows 
drivers understand).

It uses DDF metadata on its partitions, which I've been using 
successfully with "dmraid" for some time, but I'd like to move to mdadm 
since the dmraid support is lacking in a number of respects (e.g. cannot 
create metadata; cannot rebuild arrays, etc...).

Unfortunately, though dmraid recognises the partition as DDF, mdadm does 
not - it always reports the disk as having no superblock.

I've done some debugging on this, and it appears that the RAID 
controller's BIOS departs from the DDF spec in a couple of (minor) ways 
- and so because mdadm is stricter in its checks than dmraid, it refuses 
to recognise the disk.

I think I can come up with a patch to work around this - should I do 
that and submit it (and if so, where should I send it)? Or would it be 
better to describe the issues I've found in more detail first?

Regards,

Patrick


