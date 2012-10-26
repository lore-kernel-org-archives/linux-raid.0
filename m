From: Phil Turmel <philip@turmel.org>
Subject: Re: mdadm: Cannot convert RAID1 of this size - reduce size to multiple
 of 4K first.
Date: Fri, 26 Oct 2012 17:04:43 -0400
Message-ID: <508AFAEB.2030000@turmel.org>
References: <CAEhu1-6MpArC4AehLdfUX-zabspB_Dn6j2R20CGUwv8NSHEPwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEhu1-6MpArC4AehLdfUX-zabspB_Dn6j2R20CGUwv8NSHEPwQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Drescher <drescherjm@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/26/2012 04:31 PM, John Drescher wrote:
> I got the following message when trying to convert a 2 disk raid1 to a
> 6 disk raid 6 in a 3.3.8 kernel:
> 
> fileserver1 btrfs-root # mdadm --grow /dev/md3 --level=6 --raid-devices=6
> mdadm: Cannot convert RAID1 of this size - reduce size to multiple of 4K first.
> 
> Fileserver1 btrfs-root # uname -a
> Linux fileserver1 3.3.8-gentoo-fileserver1-raid1 #3 SMP Thu Jul 12
> 20:06:18 EDT 2012 x86_64 Intel(R) Xeon(R) CPU E31230 @ 3.20GHz
> GenuineIntel GNU/Linux
> 
> fileserver1 btrfs-root # mdadm --version
> mdadm - v3.2.6 - 25th October 2012
> 
> fileserver1 btrfs-root # mdadm -D /dev/md3
> /dev/md3:
>         Version : 1.2
>   Creation Time : Wed Sep 28 16:03:56 2011
>      Raid Level : raid1
>      Array Size : 1874607039 (1787.76 GiB 1919.60 GB)
>   Used Dev Size : 1874607039 (1787.76 GiB 1919.60 GB)
>    Raid Devices : 2
>   Total Devices : 6
>     Persistence : Superblock is persistent
> 
>     Update Time : Fri Oct 26 16:24:22 2012
>           State : clean
>  Active Devices : 2
> Working Devices : 6
>  Failed Devices : 0
>   Spare Devices : 4
> 
>            Name : fileserver1:3  (local to host fileserver1)
>            UUID : df2200d4:3ba5d29c:524dc437:35d663ea
>          Events : 785
> 
>     Number   Major   Minor   RaidDevice State
>        0       8      116        0      active sync   /dev/sdh4
>        1       8        4        1      active sync   /dev/sda4
> 
>        2       8      244        -      spare   /dev/sdp4
>        3       8      196        -      spare   /dev/sdm4
>        4       8      212        -      spare   /dev/sdn4
>        5       8      228        -      spare   /dev/sdo4

The "Used Dev Size" must be a multiple of the target chunk size, and the
smallest allowed chunk size is 4K.

> Would upgrading the kernel avoid needing to reduce the size of the
> array? If not I assume I have to reduce the size of the btrfs
> filesystem then resize the array to 1874604032. Is that correct?

Upgrading the kernel won't help.  For a 4K chunk size, 1874607032
sectors is correct.  For other chunk sizes, you'll have to shrink a bit
more (1874607039 == 0x6FBC3BBF).

HTH,

Phil

