From: Phil Turmel <philip@turmel.org>
Subject: Re: Brocken Raid & LUKS
Date: Thu, 21 Feb 2013 10:04:37 -0500
Message-ID: <51263785.2010001@turmel.org>
References: <5123A1CC.2000003@heisl.org> <5123BD1F.4060200@turmel.org> <5123E4E9.3020609@heisl.org> <5123EB92.5090505@turmel.org> <5123EF45.6080405@heisl.org> <5123F7C7.7000406@turmel.org> <5123FB71.3060509@heisl.org> <5124196F.6090000@turmel.org> <512516C2.3010105@heisl.org> <5125184A.6040707@turmel.org> <5125C6E9.4050802@heisl.org> <5125EBFD.3050802@heisl.org> <51262137.3040609@turmel.org> <51262CE0.3000809@heisl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51262CE0.3000809@heisl.org>
Sender: linux-raid-owner@vger.kernel.org
To: "stone@heisl.org" <stone@heisl.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/21/2013 09:19 AM, stone@heisl.org wrote:

> o greate idea :)

Whoops!  Not a great idea.  This is a member device.

> but i dont get a good result
> fsck -n /dev/sdc1
> fsck from util-linux 2.20.1
> fsck: fsck.linux_raid_member: not found
> fsck: error 2 while executing fsck.linux_raid_member for /dev/sdc1
> 
> fsck -n /dev/md2
> fsck from util-linux 2.20.1
> e2fsck 1.42 (29-Nov-2011)
> fsck.ext2: Superblock invalid, trying backup blocks...
> fsck.ext2: Bad magic number in super-block while trying to open /dev/md2
> 
> The superblock could not be read or does not describe a correct ext2
> filesystem.  If the device is valid and it really contains an ext2
> filesystem (and not swap or ufs or something else), then the superblock
> is corrupt, and you might try running e2fsck with an alternate superblock:
>     e2fsck -b 8193 <device>

Ignore this.  As long as badblocks was using 4096, then the dd command
is correct.

Phil
