From: Phil Turmel <philip@turmel.org>
Subject: Re:
Date: Tue, 25 Dec 2012 21:15:35 -0500
Message-ID: <50DA5DC7.8000405@turmel.org>
References: <CADzS=aoy=7sb7fdKy3tH3tHtbBmnm0vSQ4vyYK0SCX-Ekis0Uw@mail.gmail.com> <50D93BBC.5020206@turmel.org> <CADzS=ar9c7hC1Z7HT9pTUEnoPR+jeo8wdexrrsFbVfPnZ9Tbmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADzS=ar9c7hC1Z7HT9pTUEnoPR+jeo8wdexrrsFbVfPnZ9Tbmg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: bobzer <bobzer@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/25/2012 07:16 PM, bobzer wrote:
> thanks to help me

No problem, but please *don't* top-post, and *do* trim replies.  Also,
use reply-to-all on kernel.org mailing lists.

> root@debian:~# mdadm -E /dev/sd[bcd]1
> /dev/sdb1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : bf3c605b:9699aa55:d45119a2:7ba58d56
>            Name : debian:0  (local to host debian)
>   Creation Time : Sun Mar  4 22:49:14 2012
>      Raid Level : raid5
>    Raid Devices : 3
> 
>  Avail Dev Size : 3907021954 (1863.01 GiB 2000.40 GB)
>      Array Size : 7814043136 (3726.03 GiB 4000.79 GB)
>   Used Dev Size : 3907021568 (1863.01 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 5e71f69a:a78b0cd7:bbbb7ecb:cf81f9f6
> 
>     Update Time : Tue Dec 25 06:25:02 2012
>   Bad Block Log : 512 entries available at offset 2032 sectors
>        Checksum : 922ddaa8 - correct
>          Events : 413
> 
>          Layout : left-symmetric
>      Chunk Size : 128K
> 
>    Device Role : Active device 0
>    Array State : A.. ('A' == active, '.' == missing)
> mdadm: No md superblock detected on /dev/sdc1.
> mdadm: No md superblock detected on /dev/sdd1.

This is bad.  The two disks are still offline.  You must find and fix
the hardware problem that is keeping these two disks from communicating.
 Unless the two disks suffered a simultaneous power surge, the odds they
are OK is good.  But look at your cables, controller, or power supply.

> I would like to understand too
> dmesg (with the begin removed) show a lot of error :
> http://pastebin.com/D1D8AKF9

I browsed it: all attempts to communicate with those two drives failed.
 That must be fixed first.  Then we can help you recover the data.  If
you can plug the three drives into another machine, that would be the
simplest way to isolate the problem.

HTH,

Phil
