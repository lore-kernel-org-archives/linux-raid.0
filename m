From: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Subject: mdadm: /dev/md0 has been started with 1 drive (out of 2).
Date: Tue, 5 Nov 2013 10:41:31 +0200
Message-ID: <C8EFEBC6-4B43-4B71-AA3F-7DC69480220D@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am new to mdadm/software raid and I've built myself a raid1 array, which after a resume from sleep is assembled with 1 out of 2 devices only.

I queried the web, read some threads on the mailing list and learned that event count on these two devices differe a little, and that in a case like this, it would seem, mdadm --assemble --scan --force is a right action. Tried that, but the array is still assembled with only one device.

Where do I go from here?

--examine output:

> % mdadm --examine /dev/sdc1
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : c4cf4a52:6daa94c8:6d88a2fa:8f604199
>            Name : sega:0  (local to host sega)
>   Creation Time : Fri Nov  1 16:24:18 2013
>      Raid Level : raid1
>    Raid Devices : 2
> 
>  Avail Dev Size : 3906553856 (1862.79 GiB 2000.16 GB)
>      Array Size : 1953276736 (1862.79 GiB 2000.16 GB)
>   Used Dev Size : 3906553472 (1862.79 GiB 2000.16 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 814f6fb3:a8a93019:c04ef011:cfa16124
> 
>     Update Time : Tue Nov  5 01:03:48 2013
>        Checksum : 32aca1de - correct
>          Events : 22
> 
> 
>    Device Role : Active device 0
>    Array State : AA ('A' == active, '.' == missing)
> 
> 
> 
> % mdadm --examine /dev/sdd1
> /dev/sdd1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : c4cf4a52:6daa94c8:6d88a2fa:8f604199
>            Name : sega:0  (local to host sega)
>   Creation Time : Fri Nov  1 16:24:18 2013
>      Raid Level : raid1
>    Raid Devices : 2
> 
>  Avail Dev Size : 3906553856 (1862.79 GiB 2000.16 GB)
>      Array Size : 1953276736 (1862.79 GiB 2000.16 GB)
>   Used Dev Size : 3906553472 (1862.79 GiB 2000.16 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : cea7f341:435cdefd:5f883265:a75c5080
> 
>     Update Time : Tue Nov  5 07:53:09 2013
>        Checksum : 55110136 - correct
>          Events : 30
> 
> 
>    Device Role : Active device 1
>    Array State : .A ('A' == active, '.' == missing)


dmesg output:

> [548246.716474] scsi_verify_blk_ioctl: 18 callbacks suppressed
> [548246.716484] mdadm: sending ioctl 800c0910 to a partition!
> [548246.716492] mdadm: sending ioctl 800c0910 to a partition!
> [548246.716512] mdadm: sending ioctl 1261 to a partition!
> [548246.716518] mdadm: sending ioctl 1261 to a partition!
> [548246.718155] mdadm: sending ioctl 800c0910 to a partition!
> [548246.718163] mdadm: sending ioctl 800c0910 to a partition!
> [548246.718174] mdadm: sending ioctl 1261 to a partition!
> [548246.718180] mdadm: sending ioctl 1261 to a partition!
> [548246.720524] mdadm: sending ioctl 800c0910 to a partition!
> [548246.720533] mdadm: sending ioctl 800c0910 to a partition!
> [548247.265498] md: md0 stopped.
> [548247.269420] md: bind<sdc1>
> [548247.271426] md: bind<sdd1>
> [548247.271471] md: kicking non-fresh sdc1 from array!
> [548247.271478] md: unbind<sdc1>
> [548247.274669] md: export_rdev(sdc1)
> [548247.332487] md/raid1:md0: active with 1 out of 2 mirrors
> [548247.332531] md0: detected capacity change from 0 to 2000155377664
> [548247.334969]  md0: unknown partition table
> [548272.306149] md0: detected capacity change from 2000155377664 to 0
> [548272.306163] md: md0 stopped.
> [548272.306175] md: unbind<sdd1>
> [548272.308646] md: export_rdev(sdd1)

Ivan