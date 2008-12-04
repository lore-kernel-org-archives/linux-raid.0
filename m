From: "NeilBrown" <neilb@suse.de>
Subject: Re: Adding a component to an array which has changed size
Date: Fri, 5 Dec 2008 08:21:26 +1100 (EST)
Message-ID: <5c407986211412d7d9e86668b8160e5b.squirrel@neil.brown.name>
References: <20081204122635.GP32420@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081204122635.GP32420@arachsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Webb <chris@arachsys.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, December 4, 2008 11:26 pm, Chris Webb wrote:
> The amount of space reserved in each component for an internal bitmap
> depends on the size of the component. If I have (say) a raid5 arrray of
> size
> 50GB that used to be a raid5 array of size 1GB, and I fail one of the
> slots
> and add in a new replacement, the new slot needs to be bigger than all the
> existing ones because a larger space is reserved by mdadm for the internal
> bitmap.
>
>   3# mdadm --version && uname -sv
>   mdadm - v2.6.7 - 6th June 2008

Fixed in v2.6.8, commit 2a528478c75b6659188fc2ce0d9543124992fe6c

NeilBrown



>   Linux 2.6.27.7 #2 SMP Wed Dec 3 12:00:03 GMT 2008
>
>   3# mdadm --fail /dev/md127 /dev/mapper/slot.51000.1
>   mdadm: set /dev/mapper/slot.51000.1 faulty in /dev/md127
>   3# mdadm --remove /dev/md127 /dev/mapper/slot.51000.1
>   mdadm: hot removed /dev/mapper/slot.51000.1
>
>   3# # wipe superblock so this is a new slot rather than a re-add...
>   3# dd if=/dev/zero of=/dev/mapper/slot.51000.1 bs=1M count=1
>   1+0 records in
>   1+0 records out
>   3# mdadm --add /dev/md127 /dev/mapper/slot.51000.1
>   mdadm: /dev/mapper/slot.51000.1 not large enough to join array
>
>   3# mdadm --examine /dev/mapper/slot.51000.0
>   /dev/mapper/slot.51000.0:
>             Magic : a92b4efc
>           Version : 1.1
>       Feature Map : 0x0
>        Array UUID : 61a6b9ac:4b38148f:c0c0837e:1c34783f
>              Name : 3:shelf.51000
>     Creation Time : Thu Dec  4 11:21:49 2008
>        Raid Level : raid1
>      Raid Devices : 2
>
>    Avail Dev Size : 104857584 (50.00 GiB 53.69 GB)
>        Array Size : 104857584 (50.00 GiB 53.69 GB)
>       Data Offset : 16 sectors
>      Super Offset : 0 sectors
>             State : active
>       Device UUID : f8c6dcec:add24452:267858ec:617382cd
>
>       Update Time : Thu Dec  4 12:07:22 2008
>          Checksum : 1e90683 - correct
>            Events : 19
>
>
>       Array Slot : 0 (0, failed)
>      Array State : U_ 1 failed
>
>
> Is there any way either to persuade mdadm to take the bitmap size for from
> the
> existing components, or ideally to override the bitmap size when creating
> arrays and adding components so I can just choose a constant size for all
> our
> automatically generated arrays, given that the arrays will vary in size
> over
> their lifetimes?
>
> Best wishes,
>
> Chris.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

