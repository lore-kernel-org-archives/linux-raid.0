From: Phil Turmel <philip@turmel.org>
Subject: Re:
Date: Tue, 25 Dec 2012 00:38:04 -0500
Message-ID: <50D93BBC.5020206@turmel.org>
References: <CADzS=aoy=7sb7fdKy3tH3tHtbBmnm0vSQ4vyYK0SCX-Ekis0Uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADzS=aoy=7sb7fdKy3tH3tHtbBmnm0vSQ4vyYK0SCX-Ekis0Uw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: bobzer <bobzer@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/24/2012 07:12 PM, bobzer wrote:
> Hi everyone,
> 
> i don't understand what happend (like i did nothing)
> the file look like there are here, i can browse, but can't read or copy

Two of your array members are failed.  Raid5 can only loose one.

> i'm sure the problem is obvious :
> 
> mdadm --detail /dev/md0
> /dev/md0:
>         Version : 1.2
>   Creation Time : Sun Mar  4 22:49:14 2012
>      Raid Level : raid5
>      Array Size : 3907021568 (3726.03 GiB 4000.79 GB)
>   Used Dev Size : 1953510784 (1863.01 GiB 2000.40 GB)
>    Raid Devices : 3
>   Total Devices : 3
>     Persistence : Superblock is persistent
> 
>     Update Time : Mon Dec 24 18:51:53 2012
>           State : clean, FAILED
>  Active Devices : 1
> Working Devices : 1
>  Failed Devices : 2
>   Spare Devices : 0
> 
>          Layout : left-symmetric
>      Chunk Size : 128K
> 
>            Name : debian:0  (local to host debian)
>            UUID : bf3c605b:9699aa55:d45119a2:7ba58d56
>          Events : 409
> 
>     Number   Major   Minor   RaidDevice State
>        3       8       17        0      active sync   /dev/sdb1
>        1       0        0        1      removed
>        2       0        0        2      removed
> 
>        1       8       33        -      faulty spare   /dev/sdc1
>        2       8       49        -      faulty spare   /dev/sdd1

It would be good to know *why* they failed, and in what order.

Please post your "dmesg", and the output of "mdadm -E /dev/sd[bcd]1".

> ls /dev/sd*
> /dev/sda  /dev/sda1  /dev/sda2  /dev/sda5  /dev/sda6  /dev/sda7
> /dev/sdb  /dev/sdb1  /dev/sdc  /dev/sdc1  /dev/sdd  /dev/sdd1
> 
> i thought about :
> mdadm --stop /dev/md0
> mdadm --assemble --force /dev/md0 /dev/sd[bcd]1

It'll be something like this.  Depends on the sequence of failures.

> but i don't know what i should do :-(
> thank you for your help
> 
> merry christmas

And to you. :-)

Phil

