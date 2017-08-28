From: Ming Lei <ming.lei@redhat.com>
Subject: Re: I/O hangs after resuming from suspend-to-ram
Date: Mon, 28 Aug 2017 21:32:20 +0800
Message-ID: <20170828133218.GB19670@ming.t460p>
References: <3926917.BCSovyVWdL@natalenko.name>
 <4174287.OjL0pO8MRx@natalenko.name>
 <20170828125822.GA19670@ming.t460p>
 <3567128.t9myNOm9ia@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3567128.t9myNOm9ia@merkaba>
Sender: linux-block-owner@vger.kernel.org
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

On Mon, Aug 28, 2017 at 03:10:35PM +0200, Martin Steigerwald wrote:
> Ming Lei - 28.08.17, 20:58:
> > On Sun, Aug 27, 2017 at 09:43:52AM +0200, Oleksandr Natalenko wrote:
> > > Hi.
> > > 
> > > Here is disk setup for QEMU VM:
> > > 
> > > ===
> > > [root@archmq ~]# smartctl -i /dev/sda
> > > …
> > > Device Model:     QEMU HARDDISK
> > > Serial Number:    QM00001
> > > Firmware Version: 2.5+
> > > User Capacity:    4,294,967,296 bytes [4.29 GB]
> > > Sector Size:      512 bytes logical/physical
> > > Device is:        Not in smartctl database [for details use: -P showall]
> > > ATA Version is:   ATA/ATAPI-7, ATA/ATAPI-5 published, ANSI NCITS 340-2000
> > > Local Time is:    Sun Aug 27 09:31:54 2017 CEST
> > > SMART support is: Available - device has SMART capability.
> > > SMART support is: Enabled
> > > 
> > > [root@archmq ~]# lsblk
> > > NAME                MAJ:MIN RM  SIZE RO TYPE   MOUNTPOINT
> > > sda                   8:0    0    4G  0 disk
> > > `-sda1                8:1    0    4G  0 part
> > > 
> > >   `-md0               9:0    0    4G  0 raid10
> > >   
> > >     `-system        253:0    0    4G  0 crypt
> > >     
> > >       |-system-boot 253:1    0  512M  0 lvm    /boot
> > >       |-system-swap 253:2    0  512M  0 lvm    [SWAP]
> > >       
> > >       `-system-root 253:3    0    3G  0 lvm    /
> > > 
> > > sdb                   8:16   0    4G  0 disk
> > > `-sdb1                8:17   0    4G  0 part
> > > 
> > >   `-md0               9:0    0    4G  0 raid10
> > >   
> > >     `-system        253:0    0    4G  0 crypt
> > >     
> > >       |-system-boot 253:1    0  512M  0 lvm    /boot
> > >       |-system-swap 253:2    0  512M  0 lvm    [SWAP]
> > >       
> > >       `-system-root 253:3    0    3G  0 lvm    /
> > > 
> > > sr0                  11:0    1 1024M  0 rom
> > > 
> > > [root@archmq ~]# mdadm --misc --detail /dev/md0
> > > 
> > > /dev/md0:
> > >         Version : 1.2
> > >   
> > >   Creation Time : Sat Jul 29 16:37:05 2017
> > >   
> > >      Raid Level : raid10
> > >      Array Size : 4191232 (4.00 GiB 4.29 GB)
> > >   
> > >   Used Dev Size : 4191232 (4.00 GiB 4.29 GB)
> > >   
> > >    Raid Devices : 2
> > >   
> > >   Total Devices : 2
> > >   
> > >     Persistence : Superblock is persistent
> > >     
> > >     Update Time : Sun Aug 27 09:30:33 2017
> > >     
> > >           State : clean
> > >  
> > >  Active Devices : 2
> > > 
> > > Working Devices : 2
> > > 
> > >  Failed Devices : 0
> > >  
> > >   Spare Devices : 0
> > >   
> > >          Layout : far=2
> > >      
> > >      Chunk Size : 512K
> > >      
> > >            Name : archiso:0
> > >            UUID : 43f4be59:c8d2fa0a:a94acdff:1c7f2f4e
> > >          
> > >          Events : 485
> > >     
> > >     Number   Major   Minor   RaidDevice State
> > >     
> > >        0       8        1        0      active sync   /dev/sda1
> > >        1       8       17        1      active sync   /dev/sdb1
> > > 
> > > ===
> > > 
> > > In words: 2 virtual disks, RAID10 setup with far-2 layout, LUKS on it,
> > > then
> > > LVM, then ext4 for boot, swap and btrfs for /.
> > > 
> > > I couldn't reproduce the issue with single disk without RAID.
> > 
> > Could you verify if the following patch fixes your issue?
> 
> Could this also apply to non MD RAID systems? I am using BTRFS RAID
> 1 with two SSDs. So far with CFQ it runs stable.

It is for fixing Oleksandr's issue wrt. blk-mq, and looks not for you.

-- 
Ming
