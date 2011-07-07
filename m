From: Phil Turmel <philip@turmel.org>
Subject: Re: dm-crypt over raid6 unreadable after crash
Date: Thu, 07 Jul 2011 09:32:38 -0400
Message-ID: <4E15B576.9040004@turmel.org>
References: <20110706161228.GA1491@apartia.fr> <4E1494BB.9060101@turmel.org> <20110707090540.GA7288@apartia.fr> <4E15A980.3060508@turmel.org> <20110707130917.GA18812@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110707130917.GA18812@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/07/2011 09:09 AM, Louis-David Mitterrand wrote:
> On Thu, Jul 07, 2011 at 08:41:36AM -0400, Phil Turmel wrote:
>>
>> So, cryptsetup saw and properly handled /dev/md2.
>>
>> [...]
>>
>> Well.  /dev/md1 is assembled correctly as far as I can tell.  That
>> make me wonder what else might be in play.  First, it would be good to
>> know if the luks data is truly intact at the 1MB offset.  As a test,
>> please add a linear device mapper layer that skips the 1MB.  Like so:
>>
>> echo 0 1683724288 linear /dev/md1 2048 | dmsetup create mdtest
> 
> That worked fine.
> 
> I then successfully unlocked mdtest with:
> 
> 	cryptsetup luksOpen /dev/mapper/mdtest cmd1
> 
>> Depending on grml's udev setup, this may prompt you to unlock
>> /dev/mapper/mdtest.  Otherwise, use cryptsetup to test it, and then
>> unlock it.  Do *NOT* mount yet.  Run "fsck -n" to see if it is intact.
> 
> root@grml /dev/mapper # xfs_check /dev/mapper/cmd1
> xfs_check: /dev/mapper/cmd1 is not a valid XFS filesystem (unexpected SB magic number 0xd0f1b462)
> xfs_check: size check failed

This is important.  When I computed the sector count for the linear mapping, I just took 2048 off the end.  You may want to select a sector count that aligns the endpoint.

> xfs_check: WARNING - filesystem uses v1 dirs,limited functionality provided.
> xfs_check: read failed: Invalid argument
> xfs_check: data size check failed
> cache_node_purge: refcount was 1, not zero (node=0x1835a30)
> xfs_check: cannot read root inode (22)
> cache_node_purge: refcount was 1, not zero (node=0x1835c80)
> xfs_check: cannot read realtime bitmap inode (22)
> xfs_check: size check failed
> xfs_check: WARNING - filesystem uses v1 dirs,limited functionality provided.
> xfs_check: read failed: Invalid argument
> xfs_check: data size check failed
> bad superblock magic number d0f1b462, giving up

If the md array is assembled with devices out of order, the initialization vectors for all the sectors are likely to be wrong, with no way to examine the contents to try to work out the device order.  Of course, I don't know of any way mdadm can screw up the device order with v1+ metadata.

>> I also wonder if the md device itself was partitioned, maybe with EFI
>> GPT, and the grml liveCD doesn't support it?  (Long shot.)  Please
>> show "zcat /proc/config.gz |grep PART"
> 
> root@grml /dev/mapper # zcat /proc/config.gz |grep PART
> CONFIG_PM_STD_PARTITION=""
> CONFIG_MTD_PARTITIONS=y
> CONFIG_MTD_REDBOOT_PARTS=m
> # CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
> # CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
> CONFIG_MTD_AR7_PARTS=m
> CONFIG_PARTITION_ADVANCED=y
> CONFIG_ACORN_PARTITION=y
> # CONFIG_ACORN_PARTITION_CUMANA is not set
> # CONFIG_ACORN_PARTITION_EESOX is not set
> CONFIG_ACORN_PARTITION_ICS=y
> # CONFIG_ACORN_PARTITION_ADFS is not set
> # CONFIG_ACORN_PARTITION_POWERTEC is not set
> # CONFIG_ACORN_PARTITION_RISCIX is not set
> CONFIG_OSF_PARTITION=y
> CONFIG_AMIGA_PARTITION=y
> CONFIG_ATARI_PARTITION=y
> CONFIG_MAC_PARTITION=y
> CONFIG_MSDOS_PARTITION=y
> CONFIG_MINIX_SUBPARTITION=y
> CONFIG_SOLARIS_X86_PARTITION=y
> CONFIG_LDM_PARTITION=y
> CONFIG_SGI_PARTITION=y
> CONFIG_ULTRIX_PARTITION=y
> CONFIG_SUN_PARTITION=y
> CONFIG_KARMA_PARTITION=y
> CONFIG_EFI_PARTITION=y
         ^^^
So that's not it.

> CONFIG_SYSV68_PARTITION=y
> 
>> I'm running out of ideas.
> 
> Well thanks a lot for trying at least. At least now I understand how
> 'linear' can be used.

Sorry I couldn't help more.

Phil
