From: Luca Berra <bluca@comedia.it>
Subject: Re: md and lvm
Date: Thu, 30 May 2002 08:21:38 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020530062138.GA31973@colombina.comedia.it>
References: <OF5BD3342B.53CED801-ON48256BC9.00097D87@legend.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <OF5BD3342B.53CED801-ON48256BC9.00097D87@legend.com.cn>
To: linux-raid@vger.kernel.org
Cc: linux-lvm@sistina.com
List-Id: linux-raid.ids

On Thu, May 30, 2002 at 09:44:27AM +0800, lilha@legend.com.cn wrote:
> i try extend a LV with md, but failed,why?
> Can a LV of md extend ?
> follow is my VG information.

> [root@snap /root]# cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid5] [multipath]
> read_ahead 1024 sectors
> md1 : active raid1 hda9[1]
>       272960 blocks [2/1] [_U]
is this a bad disk???

> md2 : active raid5 hda12[2] hda11[1] hda10[0]
>       1638400 blocks level 5, 32k chunk, algorithm 0 [3/3] [UUU]
> 
> md4 : active raid5 hdc7[2] hdc6[1] hdc5[0]
>       1023872 blocks level 5, 32k chunk, algorithm 0 [3/3] [UUU]
raid 5 on the same disk (cool!)

> and now is the error information(i didn't use lvextend before):
> 
> [root@snap /root]# e2fsadm -L+1G /dev/raid-lvm/lv_raid
> e2fsck 1.18, 11-Nov-1999 for EXT2 FS 0.5b, 95/08/09
> The filesystem size (according to the superblock) is 338944 blocks
> The physical size of the device is 236544 blocks
> Either the superblock or the partition table is likely to be corrupt!
> Abort<y>? no
seems you have some problem with the filesystem in /dev/raid-lvm/lv_raid
did you play at reducing it before?

> Pass 1: Checking inodes, blocks, and sizes
> Error reading block 262148 (Invalid argument) while doing inode scan.
> Ignore error<y>? yes
> Error reading block 262149 (Invalid argument) while doing inode scan.
> Ignore error<y>?  no
> Error while scanning inodes (135680): Can't read next inode

it seems you lvreduced the logical volume without resizing the filesystem
before, or your fs is badly corrupt.
Try copying data somewhere else and mkfs the lv again.

> and last is the error information of useing lvextend before:
> [root@snap /root]# lvextend -L+1G /dev/raid-lvm/lv_raid
> lvextend -- extending logical volume "/dev/raid-lvm/lv_raid" to 1.90 GB
> lvextend -- doing automatic backup of volume group "raid-lvm"
> lvextend -- logical volume "/dev/raid-lvm/lv_raid" successfully extended
ok
> [root@snap /root]# e2fsadm -L+1G /dev/raid-lvm/lv_raid
> e2fsadm -- new size too large for "raid-lvm"
> e2fsadm -- size of "/dev/raid-lvm/lv_raid" would  be invalid
e2fsadm = lvextend then resize2fs if extending
          resize2fs then lvreduce if shrinking

so you try to extend the lv by 1G and you succeed, then you try
to extend it by 1G again, but you don't have enugh free PE on the
volume group.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
