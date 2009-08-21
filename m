From: "NeilBrown" <neilb@suse.de>
Subject: Re: Growing raid 5: Failed to reshape
Date: Sat, 22 Aug 2009 07:30:33 +1000 (EST)
Message-ID: <2735df411d9ed83a9d11664f595d6dfc.squirrel@neil.brown.name>
References: <5c45fce80908211231v9238a12i3829ad5d1b107df5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5c45fce80908211231v9238a12i3829ad5d1b107df5@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, August 22, 2009 5:31 am, Anshuman Aggarwal wrote:
> Hi all,
>
> Here is my problem and configuration. :
>
> I had a 3 partition raid5 cluster to which I added  a 4th disk and
> tried to grow the raid5 by adding the partition on the 4th disk and
> then growing it. Unfortunately since another sync task was happening
> on the same disks, the operation to move the critical section did not
> complete before the machine was shutdown by the UPS (in control not a
> crash) due to low battery.
>
>  Kernel: 2.6.30.4; mdadm (tried 2.6.7 and 3.0)
>
> Now, only 1 of my 3 partitions has the superblock and the other 2 and
> the 4th new one does not have anything.

It is very strange that only one partition has a superblock.
I cannot imagine any way that could have happened short of changing
the partition tables or deliberately destroying them.
I feel the need to ask "are you sure" though presumably you are or
you wouldn't have said so...

>
> Here is the output of a few mdadm commands.
>
> $mdadm --misc --examine /dev/sdd5
> /dev/sdd5:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x4
>      Array UUID : 495f6668:f1e12d10:99520f92:7619b487
>            Name : GATEWAY:raid5_280G  (local to host GATEWAY)
>   Creation Time : Fri Jul 31 23:05:48 2009
>      Raid Level : raid5
>    Raid Devices : 4
>
>  Avail Dev Size : 586099060 (279.47 GiB 300.08 GB)
>      Array Size : 1758296832 (838.42 GiB 900.25 GB)
>   Used Dev Size : 586098944 (279.47 GiB 300.08 GB)
>     Data Offset : 272 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 754ae1cf:bbee0582:f660ec89:a88800d3
>
>   Reshape pos'n : 0
>   Delta Devices : 1 (3->4)

It certainly looks like it didn't get very far.  We cannot
know from this for certain.
mdadm should have copied the first 4 chunks (256K) to somewhere
near the end of the new device, then allowed the reshape to continue.
It is possible that the reshape had written to some of these early
blocks.  If it did we need to recover that backed-up data.  I should
probably add functionality to mdadm to find and recover such a backup....

For now your best bet is to simply try to recreate the array.
i.e something like

  mdadm -C /dev/md0 -l5 -n3 -e 1.2 --name "raid5_280G" --assume-clean \
        /dev/sdc5 /dev/sdd5 /dev/sde5

You need to make sure that you get the right devices in the right
order.  From the information you gave I only know for certain that
/dev/sdd5 is the middle of the three.

This will write new superblocks and assemble the array but will not
change any of the data.  You can then access the array read-only
and see if the data looks like it is all there.  If it isn't, stop
the array and try to work out why.
If it is, you can try to grow the array again, this time with a more
reliable power supply ;-)

Speaking of which... just how long was it before when you started the
grow and when the power shut off.  It really shouldn't be more than
a few seconds, even if other things are happening on the system.
(normally it would be a few hundred milliseconds at most).

Good luck,
NeilBrown


>
>     Update Time : Fri Aug 21 09:55:38 2009
>        Checksum : e18481fb - correct
>          Events : 13581
>
>          Layout : left-symmetric
>      Chunk Size : 64K
>
>     Array Slot : 4 (0, failed, failed, 2, 1, 3)
>    Array State : uUuu 2 failed
>
> $mdadm --assemble --scan
> mdadm: Failed to restore critical section for reshape, sorry.
>
> I am positive that none of the actual growing steps even started so my
> data 'should' be safe as long as I can recreate the superblocks,
> right?
>
> As always, appreciate the help of the open source community. Thanks!!
>
> Thanks,
> Anshuman
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

