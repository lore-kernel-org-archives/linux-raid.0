From: Phil Turmel <philip@turmel.org>
Subject: Re: Linux software RAID assistance
Date: Wed, 16 Feb 2011 14:10:59 -0500
Message-ID: <4D5C2143.3000907@turmel.org>
References: <4D540F6C.6050904@gmail.com> <20110215155315.55d35b8e@notabene.brown> <4D5A92F3.1090004@turmel.org> <4D5BD678.2050200@gmail.com> <4D5BE119.7000804@turmel.org> <4D5C0E17.3060306@gmail.com> <4D5C140F.9010301@turmel.org> <4D5C1508.3040308@gmail.com> <4D5C15D3.1070608@turmel.org> <4D5C167C.7000101@turmel.org> <4D5C1CF8.1020507@gmail.com> <4D5C1E0B.9060300@turmel.org> <4D5C2061.4060106@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5C2061.4060106@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: simonmcnair@gmail.com
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/16/2011 02:07 PM, Simon McNair wrote:
> pvscan is:
> proxmox:/home/simon# pvscan --verbose
>     Wiping cache of LVM-capable devices
>     Wiping internal VG cache
>     Walking through all physical volumes
>   PV /dev/sda2   VG pve        lvm2 [465.26 GB / 4.00 GB free]
>   PV /dev/md0    VG lvm-raid   lvm2 [8.19 TB / 0    free]
>   Total: 2 [655.05 GB] / in use: 2 [655.05 GB] / in no VG: 0 [0   ]
> 
> lvm-raid is there ....

Very good.

> proxmox:/home/simon# fsck.ext4 -n /dev/md0

Uh, no.

> e2fsck 1.41.3 (12-Oct-2008)
> fsck.ext4: Superblock invalid, trying backup blocks...
> Superblock has an invalid ext3 journal (inode 8).
> Clear? no
> 
> fsck.ext4: Illegal inode number while checking ext3 journal for /dev/md0


> I thought I needed to run fsck against the lvm group ?  I used to do... fsck.ext4 /dev/lvm-raid/RAID so do I need to mount it or something ?

vgscan --verbose

lvscan --verbose


Then either:

fsck -N /dev/mapper/lvm-raid-RAID

or:

fsck -N /dev/lvm-raid/RAID

depends on what udev is doing.

Phil
