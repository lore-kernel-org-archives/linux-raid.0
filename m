From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: How best to re-sync raid1 array? zero superblock on removed disk
 and let it rebuild?
Date: Fri, 28 Aug 2015 04:42:58 -0500
Message-ID: <55E02D22.802@suddenlinkmail.com>
References: <55E02841.9050701@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55E02841.9050701@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/28/2015 04:22 AM, David C. Rankin wrote:
> All,
>
>    I had a disc-controller failure on a server running several raid1 arrays. The
> disks are fine, but I have had the root partition come up in degraded mode. What
> is the best way to tell mdraid to resync the disks? Here are the symptoms:
>
> # cat /proc/mdstat
> Personalities : [raid1]
> md1 : active raid1 sdb7[1]
>        52396032 blocks super 1.2 [2/1] [_U]
>
> md3 : active raid1 sdb6[1] sda6[0]
>        1047552 blocks super 1.2 [2/2] [UU]
>
> md2 : active raid1 sda8[0] sdb8[1]
>        922944192 blocks super 1.2 [2/2] [UU]
>        bitmap: 0/7 pages [0KB], 65536KB chunk
>
> md0 : active raid1 sda5[0] sdb5[1]
>        204608 blocks super 1.2 [2/2] [UU]
>
> unused devices: <none>
>
> # mdadm --misc --detail /dev/md1
> /dev/md1:
>          Version : 1.2
>    Creation Time : Wed Nov 27 04:35:49 2013
>       Raid Level : raid1
>       Array Size : 52396032 (49.97 GiB 53.65 GB)
>    Used Dev Size : 52396032 (49.97 GiB 53.65 GB)
>     Raid Devices : 2
>    Total Devices : 1
>      Persistence : Superblock is persistent
>
>      Update Time : Fri Aug 28 04:12:18 2015
>            State : clean, degraded
>   Active Devices : 1
> Working Devices : 1
>   Failed Devices : 0
>    Spare Devices : 0
>
>             Name : archiso:1
>             UUID : 320d86f7:22999af5:5eeefee1:35cd8970
>           Events : 100308
>
>      Number   Major   Minor   RaidDevice State
>         0       0        0        0      removed
>         1       8       23        1      active sync   /dev/sdb7
>
> Reading, it looks like one approach is the boot the install media and then zero
> the superblock on /dev/sda7 and then reboot. Will that force a rebuild, or do I
> need to fail and remove the disk first? I was thinking:
>
> # mdadm --zero-superblock /dev/sda7
>
> should set it up for a rebuild without more. Is this a sane approach?
>

This adds a bit more of the picture. It's like sda7 doesn't even know it was 
kicked out. There are no disk errors logged for either of the drives:

  # mdadm -E /dev/sd[ab]7
/dev/sda7:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x8
      Array UUID : 320d86f7:22999af5:5eeefee1:35cd8970
            Name : archiso:1
   Creation Time : Wed Nov 27 04:35:49 2013
      Raid Level : raid1
    Raid Devices : 2

  Avail Dev Size : 104792064 (49.97 GiB 53.65 GB)
      Array Size : 52396032 (49.97 GiB 53.65 GB)
     Data Offset : 65536 sectors
    Super Offset : 8 sectors
    Unused Space : before=65448 sectors, after=0 sectors
           State : active
     Device UUID : f5a48ea1:bce2f6f0:f47f9c0b:bad1d64d

     Update Time : Sat Aug  8 17:17:21 2015
   Bad Block Log : 512 entries available at offset 72 sectors - bad blocks present.
        Checksum : 2c45bcef - correct
          Events : 280


    Device Role : Active device 0
    Array State : AA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdb7:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x8
      Array UUID : 320d86f7:22999af5:5eeefee1:35cd8970
            Name : archiso:1
   Creation Time : Wed Nov 27 04:35:49 2013
      Raid Level : raid1
    Raid Devices : 2

  Avail Dev Size : 104792064 (49.97 GiB 53.65 GB)
      Array Size : 52396032 (49.97 GiB 53.65 GB)
     Data Offset : 65536 sectors
    Super Offset : 8 sectors
    Unused Space : before=65448 sectors, after=0 sectors
           State : clean
     Device UUID : 66e069cc:02daa93e:1d4a6eea:e5c21cb7

     Update Time : Fri Aug 28 04:35:31 2015
   Bad Block Log : 512 entries available at offset 72 sectors - bad blocks present.
        Checksum : ed07de3b - correct
          Events : 100584


    Device Role : Active device 1
    Array State : .A ('A' == active, '.' == missing, 'R' == replacing)

Do I try a --re-add on sda7 or just zero it for a complete rebuild? Any help 
appreciated.

-- 
David C. Rankin, J.D.,P.E.
