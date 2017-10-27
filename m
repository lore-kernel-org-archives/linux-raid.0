From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: mount(2) system call failed: Structure needs cleaning?
Date: Thu, 26 Oct 2017 19:59:47 -0500
Message-ID: <5a939404-9405-1721-99c9-0884dc978702@suddenlinkmail.com>
References: <021c3df6-536c-73bc-84e2-281d4bd8099d@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <021c3df6-536c-73bc-84e2-281d4bd8099d@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/26/2017 07:32 PM, David C. Rankin wrote:
> All,
> 
<snip>
> This is the original array detail:
> 
> # mdadm -D /dev/md126
> /dev/md126:
>         Version : 1.0
>   Creation Time : Thu Aug 21 01:43:22 2008
>      Raid Level : raid1
>      Array Size : 20972752 (20.00 GiB 21.48 GB)
>   Used Dev Size : 20972752 (20.00 GiB 21.48 GB)
>    Raid Devices : 2
>   Total Devices : 1
>     Persistence : Superblock is persistent
> 
>   Intent Bitmap : Internal
> 
>     Update Time : Fri Oct 20 15:55:58 2017
>           State : clean, degraded
>  Active Devices : 1
> Working Devices : 1
>  Failed Devices : 0
>   Spare Devices : 0
> 
>            Name : 1
>            UUID : e45cfbeb:77c2b93b:43d3d214:390d0f25
>          Events : 19154344
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       69        0      active sync   /dev/sde5
>        -       0        0        1      removed
> 
<snip>
>   Sigh... I knew that usb cable rig was just asking for trouble...
> 

Yes, it looks like something on the array was corrupted. When I attempt to set
the --size to the exact size of the array, it says I have 4 less bytes than
the original array size:

# mdadm --verbose --create /dev/md126 --level=1 --raid-devices=2
--metadata=1.0 --bitmap=internal --size=20972752 --readonly
--uuid=e45cfbeb:77c2b93b:43d3d214:390d0f25 /dev/sdf5 missing
mdadm: /dev/sdf5 is smaller than given size. 20972748K < 20972752K + metadata
mdadm: create aborted

(this is an old ATA drive, so I wonder if the 4096 block size is messing
things up?)

Is there a way out of this conundrum?

-- 
David C. Rankin, J.D.,P.E.
