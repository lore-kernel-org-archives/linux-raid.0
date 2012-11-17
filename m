From: Phil Turmel <philip@turmel.org>
Subject: Re: Issue with Raid 10 super block failing
Date: Sat, 17 Nov 2012 18:48:55 -0500
Message-ID: <50A82267.9030802@turmel.org>
References: <CAPAnFc_USC=a8S_0wcsK36Sx=HXgfVTQ4LPC=m9Y9mDFrYrepg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPAnFc_USC=a8S_0wcsK36Sx=HXgfVTQ4LPC=m9Y9mDFrYrepg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew Reusser <dreusser@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Drew,

On 11/17/2012 01:06 PM, Drew Reusser wrote:
> I hate to be a newbie on this list, and ask a question but I am really at a
> loss.  I have a raid 10 that I have had working and was throwing no errors,
> and I rebooted and now I cannot get it to come back.  I am running a live
> CD and trying to get it to mount, and I am getting errors about bad
> superblocks, invalid bitmaps, and invalid partition tables.  I have been
> scouring the interwebs for the last few days and ran across the archive on
> http://www.spinics.net but cannot find anything that has worked there for
> me so I figured I would join and at least hope.  Last chance for me to take
> it to a data retrieval office which I really don't want to do.
> 
> Here is my setup.  4x1tb disks in raid 10.  I can get the array to mount -
> but it tells me the file system is invalid.  I have the following from
> commands I have seen people ask below.  The devices are currently sitting
> unmounted and not in an array until I can go forward with some confidence I
> am not going to loose my data.
> 
> 
> 
> 
> mint dev # mdadm --examine /dev/sd[abde]
> /dev/sda:
>    MBR Magic : aa55
> Partition[0] :   1953521664 sectors at         2048 (type 83)
> /dev/sdb:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 5a2570f4:0bbaf2d4:8a3cc761:
> 69b655ba
>            Name : mint:0  (local to host mint)
>   Creation Time : Wed Nov 14 20:55:09 2012
>      Raid Level : raid10
>    Raid Devices : 4
> 
>  Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
>      Array Size : 1953262592 (1862.78 GiB 2000.14 GB)
>   Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : e955cd6f:96e08ba2:c40bddae:ac633f0d
> 
>     Update Time : Wed Nov 14 21:15:27 2012
>        Checksum : 5b7c4f1e - correct
>          Events : 9
> 
>          Layout : near=2
>      Chunk Size : 512K
> 
>    Device Role : Active device 1
>    Array State : .A.A ('A' == active, '.' == missing)
> /dev/sdd:
>           Magic : a92b4efc
>         Version : 1.2

This isn't a complete report for four devices.  Please show the output
of "blkid" and "cat /proc/partitions" so we can help you report the
details needed.

Phil


