From: "Marcin M. Jessa" <lists@yazzy.org>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Sun, 25 Sep 2011 23:58:00 +0200
Message-ID: <4E7FA3E8.5010603@yazzy.org>
References: <4E7EDE58.3000804@yazzy.org> <20110926074002.6399de56@notabene.brown>
Reply-To: lists@yazzy.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110926074002.6399de56@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/25/11 11:40 PM, NeilBrown wrote:

[...]

> You wouldn't expect an LV to contain a partition table.  You would expect it
> to contain a filesystem.

Yes, there is still data available on the LVs.
I actually managed to grab some files from one of the LVs using 
foremost. But foremost is limited and creates it's own directory 
hierarchy with file names being changed.

> What does
>     fsck -f -n /dev/fridge/storage
>
> show??

# fsck -f -n /dev/fridge/storage
fsck from util-linux 2.19.1
e2fsck 1.42-WIP (02-Jul-2011)
fsck.ext2: Superblock invalid, trying backup blocks...
fsck.ext2: Bad magic number in super-block while trying to open 
/dev/mapper/fridge-storage

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
     e2fsck -b 8193 <device>


-- 

Marcin M. Jessa
