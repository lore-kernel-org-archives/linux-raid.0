From: Phil Turmel <philip@turmel.org>
Subject: Re: Issue with Raid 10 super block failing
Date: Sun, 18 Nov 2012 12:01:59 -0500
Message-ID: <50A91487.70806@turmel.org>
References: <CAPAnFc_USC=a8S_0wcsK36Sx=HXgfVTQ4LPC=m9Y9mDFrYrepg@mail.gmail.com> <50A82267.9030802@turmel.org> <CAPAnFc_ZtiE_-6usMHZA56Vx9JOw=gT3O3ABdpb2kcqLV6hcBw@mail.gmail.com> <50A8F247.8060002@turmel.org> <CAPAnFc9_AqQCHnzpNukVJNuaAZ0k9+i0wEZn6SAX=ucF_X_k2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPAnFc9_AqQCHnzpNukVJNuaAZ0k9+i0wEZn6SAX=ucF_X_k2g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew Reusser <dreusser@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/18/2012 11:49 AM, Drew Reusser wrote:
> On Sun, Nov 18, 2012 at 2:35 PM, Phil Turmel <philip@turmel.org> wrote:

[trim /]

>> Please repeat the examines with "mdadm -E /dev/sd[abde]1"

> I originally started the disks at (block?) 2048 so there was a 2mb
> partition to load the bootloader (grub) and mdadm.  Everything else
> was on one partition as you observed.  I figured the simpler the
> better for this configuration.
> 
> Here you go.
> 
> 
> mint dev # mdadm -E /dev/sd[abde]1
> /dev/sda1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : db9e3115:556a49db:27c42d30:02657472
>            Name : mint:0  (local to host mint)
>   Creation Time : Thu Nov 15 16:08:02 2012
>      Raid Level : raid10
>    Raid Devices : 4
> 
>  Avail Dev Size : 1953259520 (931.39 GiB 1000.07 GB)
>      Array Size : 1952211968 (1861.77 GiB 1999.07 GB)
>   Used Dev Size : 1952211968 (930.89 GiB 999.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 933ec5c0:d6819e33:adb0e6c8:90e337bd
> 
>     Update Time : Thu Nov 15 20:08:55 2012
>        Checksum : b516984f - correct
>          Events : 17
> 
>          Layout : near=2
>      Chunk Size : 512K
> 
>    Device Role : Active device 0
>    Array State : AAAA ('A' == active, '.' == missing)
> /dev/sdb1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : db9e3115:556a49db:27c42d30:02657472
>            Name : mint:0  (local to host mint)
>   Creation Time : Thu Nov 15 16:08:02 2012
>      Raid Level : raid10
>    Raid Devices : 4
> 
>  Avail Dev Size : 1952212992 (930.89 GiB 999.53 GB)
>      Array Size : 1952211968 (1861.77 GiB 1999.07 GB)
>   Used Dev Size : 1952211968 (930.89 GiB 999.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 9d6df7c7:ce401405:4ea18763:a528ecc5
> 
>     Update Time : Thu Nov 15 20:08:55 2012
>        Checksum : 3103c408 - correct
>          Events : 17
> 
>          Layout : near=2
>      Chunk Size : 512K
> 
>    Device Role : Active device 1
>    Array State : AAAA ('A' == active, '.' == missing)
> /dev/sdd1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : db9e3115:556a49db:27c42d30:02657472
>            Name : mint:0  (local to host mint)
>   Creation Time : Thu Nov 15 16:08:02 2012
>      Raid Level : raid10
>    Raid Devices : 4
> 
>  Avail Dev Size : 1953259520 (931.39 GiB 1000.07 GB)
>      Array Size : 1952211968 (1861.77 GiB 1999.07 GB)
>   Used Dev Size : 1952211968 (930.89 GiB 999.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : fa1a1b82:989e933a:95e4d249:5cee901d
> 
>     Update Time : Thu Nov 15 20:08:55 2012
>        Checksum : 5ea6d02d - correct
>          Events : 17
> 
>          Layout : near=2
>      Chunk Size : 512K
> 
>    Device Role : Active device 2
>    Array State : AAAA ('A' == active, '.' == missing)
> /dev/sde1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : db9e3115:556a49db:27c42d30:02657472
>            Name : mint:0  (local to host mint)
>   Creation Time : Thu Nov 15 16:08:02 2012
>      Raid Level : raid10
>    Raid Devices : 4
> 
>  Avail Dev Size : 1952212992 (930.89 GiB 999.53 GB)
>      Array Size : 1952211968 (1861.77 GiB 1999.07 GB)
>   Used Dev Size : 1952211968 (930.89 GiB 999.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 594ed481:471ef11a:027f1c24:6f9d057d
> 
>     Update Time : Thu Nov 15 20:08:55 2012
>        Checksum : 786bd4bc - correct
>          Events : 17
> 
>          Layout : near=2
>      Chunk Size : 512K
> 
>    Device Role : Active device 3
>    Array State : AAAA ('A' == active, '.' == missing)
> 

This all looks like it should work.

Please try "mdadm -v --assemble /dev/md0 /dev/sd[abde]1" and show the
output.  If it doesn't work, also show "cat /proc/mdstat" and "dmesg".

Phil

