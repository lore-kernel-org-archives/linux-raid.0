From: Sam Bingner <sam@bingner.com>
Subject: RE: Anything left to try?
Date: Thu, 2 May 2013 06:01:40 +0000
Message-ID: <C480F6221151144EA453A5C89300815601403A74@MBOX1.ds.sbdhi.com>
References: <CAPSPcXjFQ9zDP9ZK8X3uZXHNKot5hS=0iwj04E_FrNa2Z8n++A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPSPcXjFQ9zDP9ZK8X3uZXHNKot5hS=0iwj04E_FrNa2Z8n++A@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Barrett Lewis <barrett.lewis.mitsi@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I would first ddrescue to all new drives, then work from there... if you expect you will want to be able to undo, you could even do as I did once and ddrescue into lvm logical volumes then work with the snapshots to get the data while retaining a capability to undo anything you do.

You should be able to then mount it read-only and get at least the reshaped data and probably most of the other data.

In any case, whatever you do - don't try to USE that failing drive for anything other than data recovery from that drive to a new drive... in my experience drives only go downhill once they get to where that one is

I expect if you ddrescue the failed drive you will get 99.9% of your data (just missing whatever that bad sector or two you noticed, possibly not even all that much)

Also, don't WRITE to that array - avoid anything that could make the failed drive more out of sync

Sam

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Barrett Lewis
> Sent: Wednesday, May 01, 2013 4:53 AM
> To: linux-raid@vger.kernel.org
> Subject: Anything left to try?
> 
> For about two months on and off I've been struggling to outrun cascade
> failures with my hardware and to recover as much of my data as
> possible.  I think I am finally at a point where it might be time to
> stick a fork in it, but I wanted to ask if there was any magic left I
> could try at this point.
> 
> 
> <backstory>
> I was starting to hear mechanical problems in my drives and decided to
> reshape my array from RAID5 to RAID6.  In the middle, the server
> crashed, and for irrelevant reasons the backup file was lost.  I was
> able to re-assemble the array with the --invalid-backup flag, which
> was an amazing miracle after a month of thinking all was lost.  I did
> not trust my hardware to survive the rest of the reshape before having
> another failure so started rsyncing all the files off.
> At this point I had what was originally a synced raid5, which was
> growing/reshaping to a raid6 onto a new drive. Eventually /dev/sdd
> totally failed and got marked F as per /proc/mdstat. The array was
> still operational, still showed 4 of 6 components active, where the
> fifth still being resynced.   The rsync was going while it was
> reshaping, since I didn't have faith the array would live long enough
> for the 5 day reshape to complete, which would have gotten me up to
> 5/6 components of the raid 6, at which point I would have added
> another drive for 6/6. The reason I didn't immediatly add the extra
> drive is because I really felt this array and its drives were a
> timebomb and I was more immediatly interested in copying the data off
> than trying to get the full raid 6 running (if reshape was going to
> take 5 days and I expected another drive to fail within a few).
> Anyway, quite a bit of my data got rsynced off, this morning I woke up
> to find another drive (/dev/sda) in the array had failed as I
> anticipated.
> </backstory>
> 
> 
> 
> I am really confused about what kind of state it is in:
> 
> cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md0 : active raid6 sdb[0] sdc[7] sda[5](F) sde[4] sdd[2](F) sdf[6]
>       7813531648 blocks super 1.2 level 6, 512k chunk, algorithm 18
> [6/3] [UU_U__]
> 
> unused devices: <none>
> 
> So judging from the above, I would expect the array to be totally
> offline/broken.  3 out of 6 drives in a raid6?  But my array is still
> "active" and I still have it mounted, can still see the folder
> structure and many files, just the certain folders give I/O errors
> when you try to ls them.  How is this possible?  Why do I have some
> files but not the others?  Is it wrong to expect all or nothing of a
> filesystem on md0 (ext4)?
> 
> My theory: The array had been 40% through the reshape onto the new
> drive (even with 4/5 of the 'old' components), then 1 more of the old
> components died, so I am at 3/5 of the old components PLUS a new drive
> with 40% of the stripes, so right now in essence I have 40% of the 4th
> drive needed for minimum raid6 operation, and thus can see 40% of the
> files? I don't know if mdadm is capable of that kind of magic, but I
> can't otherwise explain how my array is even assembled right now. Can
> anyone tell me if this is possible/accurate? If it is something like
> this, why doen't mdstat say something other than "active" like
> "degraded" etc?
> 
> 
> 
> The important question:   I managed to get ~80% of my data rsynced off
> before sda failed.  /dev/sda still seems partially functional, Disk
> Utility says /dev/sda is "green" but with 1 bad sector, it has
> readable status from --examine, but occasionally it makes awful
> mechanical noises.  I'm wondering if mdadm hit some error threshold
> and marked it as failed early to try to protect the rest of the array.
>  Since the array is otherwise hosed, I would be willing to do anything
> (potentially destructive) to *attempt* to bring /dev/sda back into the
> array, even for only a day or so (to rsync as much of the remaining
> 20% as possible), before I have to dismantle the array.  Is there any
> way I can say "mdadm, do your best and try to work with /dev/sda if
> you can"?  Or is it time to move on?
> 
> sudo mdadm --examine /dev/sd[a-f]
> /dev/sda:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x4
>      Array UUID : 8bc78af0:d9a981e3:73549f21:
> 2f76cd24
>            Name : mainframe:vault  (local to host mainframe)
>   Creation Time : Wed Aug 15 21:57:14 2012
>      Raid Level : raid6
>    Raid Devices : 6
> 
>  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
>      Array Size : 7813531648 (7451.56 GiB 8001.06 GB)
>   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : f18da9cc:27f5eee4:61ba900e:dd6ca8b9
> 
>   Reshape pos'n : 3277520896 (3125.69 GiB 3356.18 GB)
>      New Layout : left-symmetric
> 
>     Update Time : Sun Apr 21 06:27:31 2013
>        Checksum : 75147b14 - correct
>          Events : 755496
> 
>          Layout : left-symmetric-6
>      Chunk Size : 512K
> 
>    Device Role : Active device 4
>    Array State : AA.AAA ('A' == active, '.' == missing)
> /dev/sdb:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x4
>      Array UUID : 8bc78af0:d9a981e3:73549f21:2f76cd24
>            Name : mainframe:vault  (local to host mainframe)
>   Creation Time : Wed Aug 15 21:57:14 2012
>      Raid Level : raid6
>    Raid Devices : 6
> 
>  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
>      Array Size : 7813531648 (7451.56 GiB 8001.06 GB)
>   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 004a89c7:bd03e0fe:b6ea3ab9:76e5e5e0
> 
>   Reshape pos'n : 3277520896 (3125.69 GiB 3356.18 GB)
>      New Layout : left-symmetric
> 
>     Update Time : Sun Apr 21 13:41:12 2013
>        Checksum : 5bc7638b - correct
>          Events : 759402
> 
>          Layout : left-symmetric-6
>      Chunk Size : 512K
> 
>    Device Role : Active device 0
>    Array State : AA.A.A ('A' == active, '.' == missing)
> /dev/sdc:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x6
>      Array UUID : 8bc78af0:d9a981e3:73549f21:2f76cd24
>            Name : mainframe:vault  (local to host mainframe)
>   Creation Time : Wed Aug 15 21:57:14 2012
>      Raid Level : raid6
>    Raid Devices : 6
> 
>  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
>      Array Size : 7813531648 (7451.56 GiB 8001.06 GB)
>   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
> Recovery Offset : 1638760448 sectors
>           State : clean
>     Device UUID : 0d8ddf14:2601f343:0b7e182f:cc8358e9
> 
>   Reshape pos'n : 3277520896 (3125.69 GiB 3356.18 GB)
>      New Layout : left-symmetric
> 
>     Update Time : Sun Apr 21 13:41:12 2013
>        Checksum : ce2e55b3 - correct
>          Events : 759402
> 
>          Layout : left-symmetric-6
>      Chunk Size : 512K
> 
>    Device Role : Active device 5
>    Array State : AA.A.A ('A' == active, '.' == missing)
> /dev/sde:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x4
>      Array UUID : 8bc78af0:d9a981e3:73549f21:2f76cd24
>            Name : mainframe:vault  (local to host mainframe)
>   Creation Time : Wed Aug 15 21:57:14 2012
>      Raid Level : raid6
>    Raid Devices : 6
> 
>  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
>      Array Size : 7813531648 (7451.56 GiB 8001.06 GB)
>   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 1df1fd17:592f431a:f3f05592:fbfccdcd
> 
>   Reshape pos'n : 3277520896 (3125.69 GiB 3356.18 GB)
>      New Layout : left-symmetric
> 
>     Update Time : Sun Apr 21 13:41:12 2013
>        Checksum : 8da25408 - correct
>          Events : 759402
> 
>          Layout : left-symmetric-6
>      Chunk Size : 512K
> 
>    Device Role : Active device 3
>    Array State : AA.A.A ('A' == active, '.' == missing)
> /dev/sdf:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x4
>      Array UUID : 8bc78af0:d9a981e3:73549f21:2f76cd24
>            Name : mainframe:vault  (local to host mainframe)
>   Creation Time : Wed Aug 15 21:57:14 2012
>      Raid Level : raid6
>    Raid Devices : 6
> 
>  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
>      Array Size : 7813531648 (7451.56 GiB 8001.06 GB)
>   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 15dcad1e:3808a229:7409b3aa:4e03ae1b
> 
>   Reshape pos'n : 3277520896 (3125.69 GiB 3356.18 GB)
>      New Layout : left-symmetric
> 
>     Update Time : Sun Apr 21 13:41:12 2013
>        Checksum : 9ee36b5 - correct
>          Events : 759402
> 
>          Layout : left-symmetric-6
>      Chunk Size : 512K
> 
>    Device Role : Active device 1
>    Array State : AA.A.A ('A' == active, '.' == missing)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
