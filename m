From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Hwo to add swap to raid
Date: Tue, 26 Apr 2005 12:06:35 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0504261200160.29560@lion.drogon.net>
References: <20050426110439.6EF4792C3AC@mercury.mason.home>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050426110439.6EF4792C3AC@mercury.mason.home>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 26 Apr 2005, Chris Mason (Lists) wrote:

> I have a server that was setup with RAID1 so that the data would not be lost
> on a drive failure. However, I since realized I did not RAID the swap file
> and so in the event of a drive failure the server would crash.
> How can I convert the swap partition to RAID? I replaced /dev/hdc and
> partitioned it tbe same as /dev/had, and rebuild /dev/md0 and /dev/md1, but
> need to find a way to get the swap to be /dev/md2.
>
>
>    Device Boot    Start       End    Blocks   Id  System
> /dev/hda1   *         1        26    208813+  fd  Linux raid autodetect
> /dev/hda2            27       153   1020127+  82  Linux swap
> /dev/hda3           154     24792 197912767+  fd  Linux raid autodetect
>
>    Device Boot    Start       End    Blocks   Id  System
> /dev/hdc1   *         1        26    208813+  fd  Linux raid autodetect
> /dev/hdc2            27       153   1020127+  82  Linux swap
> /dev/hdc3           154     24792 197912767+  fd  Linux raid autodetect
>
> [root@mercury root]# cat /proc/mdstat
> Personalities : [raid1]
> read_ahead 1024 sectors
> md1 : active raid1 hdc3[2] hda3[0]
>       197912640 blocks [2/1] [U_]
>       [>....................]  recovery =  1.3% (2665008/197912640)
> finish=306.1min speed=10625K/sec
> md0 : active raid1 hdc1[1] hda1[0]
>       208704 blocks [2/2] [UU]

Try this:

  Turn off all existing swaps:

	swapoff -a

  Verify this by:

	cat /proc/swaps

  then create a RAID-1 out of hda2 and hdc2:

	mdadm --create /dev/md2 --level=1 --raid-disks=2 /dev/hda2 /dev/hdc2

  Now use (c)fdisk to change partition type from swap to 0xFD on both hda2
    and hdc2. (so it'll be autodetected the next time you reboot)

  Create a swap partition on the new md2 (no need to wait for the resync
    to finish)

	mkswap /dev/md2

  Edit /etc/fstab to change the swap mount to

    /dev/md2        none            swap    sw                      0  0

  Activate the new swap:

	swapon -a

Enjoy,

Gordon
