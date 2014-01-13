From: Richard Michael <rmichael@edgeofthenet.org>
Subject: Re: After RAID0 grow: inconsistent superblocks and /proc/mdstat
Date: Sun, 12 Jan 2014 23:42:34 -0500
Message-ID: <CABR0jETSpfzfMuxiZrL1YsudZEUV_inZegb5AzsQ-ihyy06_GA@mail.gmail.com>
References: <CABR0jETBgOtu8EbR0oT0TNP_ixg0-vBQUyPZbrDTFBYU3KTL4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABR0jETBgOtu8EbR0oT0TNP_ixg0-vBQUyPZbrDTFBYU3KTL4Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Following up my own message, I forgot to include mdadm and kernel versions:

$ mdadm --version
mdadm - v3.3 - 3rd September 2013

$ uname -a
Linux anvil.localdomain 3.12.6-300.fc20.x86_64 #1 SMP Mon Dec 23
16:44:31 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux



On Sun, Jan 12, 2014 at 11:37 PM, Richard Michael
<rmichael@edgeofthenet.org> wrote:
> Hello list,
>
> I grew a RAID0 by one-disk, and it re-shaped via RAID4 as expected.
>
> However, the component superblocks still RAID4, while /proc/mdstat,
> /sys/block/md0/md/level and "mdadm -D" all indicate RAID0.
>
> I am reluctant to stop the array, in case auto-assemble can't put it
> back together.  (I suppose I could create a new array, but I'd want to
> be quite confident about the layout of the disks.)
>
>
> Is this a bug?  Should/can I re-write the superblock(s)?
>
>
> # cat /proc/mdstat
> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]
> md0 : active raid0 sdc1[2] sdd1[0]
>       5860268032 blocks super 1.2 512k chunks
>
> # cat /sys/block/md0/md/level
> raid0
>
> # mdadm -D /dev/md0
> /dev/md0:
>         Version : 1.2
>   Creation Time : Fri Jan 10 13:02:25 2014
>      Raid Level : raid0
>      Array Size : 5860268032 (5588.79 GiB 6000.91 GB)
>    Raid Devices : 2
>   Total Devices : 2
>     Persistence : Superblock is persistent
>
>     Update Time : Sun Jan 12 20:08:53 2014
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>
>      Chunk Size : 512K
>
>     Number   Major   Minor   RaidDevice State
>        0       8       49        0      active sync   /dev/sdd1
>        2       8       33        1      active sync   /dev/sdc1
>
>
>
> But,
>
>
> # mdadm -E /dev/sd[cd]1
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 8f51352a:610d0ecd:a1e28ddd:86c8586c
>            Name : anvil.localdomain:0  (local to host anvil.localdomain)
>   Creation Time : Fri Jan 10 13:02:25 2014
>      Raid Level : raid4
>    Raid Devices : 3
>
>  Avail Dev Size : 5860268943 (2794.39 GiB 3000.46 GB)
>      Array Size : 5860268032 (5588.79 GiB 6000.91 GB)
>   Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
>     Data Offset : 260096 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=260008 sectors, after=2959 sectors
>           State : clean
>     Device UUID : ad6e6c88:0f897bc1:1f6ec909:f599bc01
>
>     Update Time : Sun Jan 12 20:08:53 2014
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 1388a7b - correct
>          Events : 9451
>
>      Chunk Size : 512K
>
>    Device Role : Active device 1
>    Array State : AA. ('A' == active, '.' == missing, 'R' == replacing)
> /dev/sdd1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 8f51352a:610d0ecd:a1e28ddd:86c8586c
>            Name : anvil.localdomain:0  (local to host anvil.localdomain)
>   Creation Time : Fri Jan 10 13:02:25 2014
>      Raid Level : raid4
>    Raid Devices : 3
>
>  Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
>      Array Size : 5860268032 (5588.79 GiB 6000.91 GB)
>     Data Offset : 260096 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=260008 sectors, after=2959 sectors
>           State : clean
>     Device UUID : b3cda274:547919b1:4e026228:0a4981e7
>
>     Update Time : Sun Jan 12 20:08:53 2014
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : e16a1979 - correct
>          Events : 9451
>
>      Chunk Size : 512K
>
>    Device Role : Active device 0
>    Array State : AA. ('A' == active, '.' == missing, 'R' == replacing)
>
>
>
> Somewhat aside, I grew the array with:
>
> "mdadm --grow /dev/md0 --raid-devices=2 --add /dev/sdc1"
>
> I suspect I should not have used "--add".  Looking at the superblock,
> there is a 3rd unknown device, which I did not intend to add.
>
> Did I convince mdadm to add two devices at the same time, sdc1 *and* a
> missing device?  (This surprises me a bit, in the sense that
> --raid-devices=2 would pertain to the added devices, rather than the
> total devices in the array.)
>
> Or, perhaps mdadm add a "dummy" device as part of the temporary RAID4
> conversion?
>
>
> Thanks for any comments.
>
> Regards,
> Richard
