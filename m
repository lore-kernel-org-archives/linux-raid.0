From: "John Stoffel" <john@stoffel.org>
Subject: Re: Recovering a RAID6 after all disks were disconnected
Date: Thu, 8 Dec 2016 14:02:54 -0500
Message-ID: <22601.44638.79418.124438@quad.stoffel.home>
References: <CAOxFTczhq3Gr4WW=-sMamaYDmAoMFGh7kkanwJzhXe5NBdMHHQ@mail.gmail.com>
        <22600.7486.444800.536687@quad.stoffel.home>
        <CAOxFTczn4Su6KwjDGS0S5BrUdirv9Tu_zCeo26iFMvL3378xpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOxFTczn4Su6KwjDGS0S5BrUdirv9Tu_zCeo26iFMvL3378xpw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Sorry for not getting back to you sooner, I've been under the weather
lately.  And I'm NOT an expert on this, but it's good you've made
copies of the disks.

Giuseppe> Hello John, and thanks for your time

Giuseppe> I've had sporadic resets of the JBOD due to a variety of reasons
Giuseppe> (power failures or disk failures —the JBOD has the bad habit of
Giuseppe> resetting when one disk has an I/O error, which causes all of the
Giuseppe> disks to go offline temporarily).

John> Please toss that JBOD out the window!  *grin*

Giuseppe> Well, that's exactly why I bought the new one which is the one I'm
Giuseppe> currently using to host the backup disks I'm experimenting on! 8-)
Giuseppe> However I suspect this is a misfeature common to many if not all
Giuseppe> 'home' JBODS which are all SATA based and only provide eSATA and/or
Giuseppe> USB3 connection to the machine.

Giuseppe> The thing happened again a couple of days ago, but this time
Giuseppe> I tried re-adding the disks directly when they came back
Giuseppe> online, using mdadm -a and confident that since they _had_
Giuseppe> been recently part of the array, the array would actually go
Giuseppe> back to work fine —except that this is not the case when ALL
Giuseppe> disks were kicked out of the array! Instead, what happened
Giuseppe> was that all the disks were marked as 'spare' and the RAID
Giuseppe> would not assemble anymore.

John> Can you please send us the full details of each disk using the
John> command:
John> 
John> mdadm -E /dev/sda1
John> 

Giuseppe> Here it is. Notice that this is the result of -E _after_ the attempted
Giuseppe> re-add while the RAID was running, which marked all the disks as
Giuseppe> spares:

Yeah, this is probably a bad state.  I would suggest you try to just
assemble the disks in various orders using your clones:

   mdadm -A /dev/md0 /dev/sdc /dev/sdd /dev/sde /dev/sdf

And then mix up the order until you get a working array.  You might
also want to try assembling using the 'missing' flag for the original
disk which dropped out of the array, so that just the three good disks
are used.  This might take a while to test all the possible
permutations.

You might also want to look back in the archives of this mailing
list.  Phil Turmel has some great advice and howto guides for this.
You can do the test assembles using loop back devices so that you
don't write to the originals, or even to the clones.

This should let you do testing more quickly.


Here's some other pointers for drive timeout issues that you should
look at as well:

    Readings for timeout mismatch issues:  (whole threads if possible)

    http://marc.info/?l=linux-raid&m=139050322510249&w=2
    http://marc.info/?l=linux-raid&m=135863964624202&w=2
    http://marc.info/?l=linux-raid&m=135811522817345&w=1
    http://marc.info/?l=linux-raid&m=133761065622164&w=2
    http://marc.info/?l=linux-raid&m=132477199207506
    http://marc.info/?l=linux-raid&m=133665797115876&w=2
    http://marc.info/?l=linux-raid&m=142487508806844&w=3
    http://marc.info/?l=linux-raid&m=144535576302583&w=2






Giuseppe> ==8<=======

Giuseppe> /dev/sdc:
Giuseppe>           Magic : a92b4efc
Giuseppe>         Version : 1.2
Giuseppe>     Feature Map : 0x9
Giuseppe>      Array UUID : 943d287e:af28b455:88a047f2:d714b8c6
Giuseppe>            Name : labrador:oneforall  (local to host labrador)
Giuseppe>   Creation Time : Fri Nov 30 19:57:45 2012
Giuseppe>      Raid Level : raid6
Giuseppe>    Raid Devices : 4

Giuseppe>  Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
Giuseppe>      Array Size : 5860270080 (5588.79 GiB 6000.92 GB)
Giuseppe>   Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
Giuseppe>     Data Offset : 262144 sectors
Giuseppe>    Super Offset : 8 sectors
Giuseppe>    Unused Space : before=262048 sectors, after=944 sectors
Giuseppe>           State : clean
Giuseppe>     Device UUID : 543f75ac:a1f3cf99:1c6b71d9:52e358b9

Giuseppe> Internal Bitmap : 8 sectors from superblock
Giuseppe>     Update Time : Sun Dec  4 17:11:19 2016
Giuseppe>   Bad Block Log : 512 entries available at offset 80 sectors - bad
Giuseppe> blocks present.
Giuseppe>        Checksum : 1e2f00fc - correct
Giuseppe>          Events : 31196

Giuseppe>          Layout : left-symmetric
Giuseppe>      Chunk Size : 512K

Giuseppe>    Device Role : spare
Giuseppe>    Array State : .... ('A' == active, '.' == missing, 'R' == replacing)

Giuseppe> /dev/sdd:
Giuseppe>           Magic : a92b4efc
Giuseppe>         Version : 1.2
Giuseppe>     Feature Map : 0x9
Giuseppe>      Array UUID : 943d287e:af28b455:88a047f2:d714b8c6
Giuseppe>            Name : labrador:oneforall  (local to host labrador)
Giuseppe>   Creation Time : Fri Nov 30 19:57:45 2012
Giuseppe>      Raid Level : raid6
Giuseppe>    Raid Devices : 4

Giuseppe>  Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
Giuseppe>      Array Size : 5860270080 (5588.79 GiB 6000.92 GB)
Giuseppe>   Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
Giuseppe>     Data Offset : 262144 sectors
Giuseppe>    Super Offset : 8 sectors
Giuseppe>    Unused Space : before=262048 sectors, after=944 sectors
Giuseppe>           State : clean
Giuseppe>     Device UUID : 649d53ad:f909b7a9:cd0f57f2:08a55e3b

Giuseppe> Internal Bitmap : 8 sectors from superblock
Giuseppe>     Update Time : Sun Dec  4 17:11:19 2016
Giuseppe>   Bad Block Log : 512 entries available at offset 80 sectors - bad
Giuseppe> blocks present.
Giuseppe>        Checksum : c9dfe033 - correct
Giuseppe>          Events : 31196

Giuseppe>          Layout : left-symmetric
Giuseppe>      Chunk Size : 512K

Giuseppe>    Device Role : spare
Giuseppe>    Array State : .... ('A' == active, '.' == missing, 'R' == replacing)

Giuseppe> /dev/sde:
Giuseppe>           Magic : a92b4efc
Giuseppe>         Version : 1.2
Giuseppe>     Feature Map : 0x9
Giuseppe>      Array UUID : 943d287e:af28b455:88a047f2:d714b8c6
Giuseppe>            Name : labrador:oneforall  (local to host labrador)
Giuseppe>   Creation Time : Fri Nov 30 19:57:45 2012
Giuseppe>      Raid Level : raid6
Giuseppe>    Raid Devices : 4

Giuseppe>  Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
Giuseppe>      Array Size : 5860270080 (5588.79 GiB 6000.92 GB)
Giuseppe>   Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
Giuseppe>     Data Offset : 262144 sectors
Giuseppe>    Super Offset : 8 sectors
Giuseppe>    Unused Space : before=262048 sectors, after=944 sectors
Giuseppe>           State : clean
Giuseppe>     Device UUID : dd3f90ab:619684c0:942a7d88:f116f2db

Giuseppe> Internal Bitmap : 8 sectors from superblock
Giuseppe>     Update Time : Sun Dec  4 17:11:19 2016
Giuseppe>   Bad Block Log : 512 entries available at offset 80 sectors - bad
Giuseppe> blocks present.
Giuseppe>        Checksum : 15a3975a - correct
Giuseppe>          Events : 31196

Giuseppe>          Layout : left-symmetric
Giuseppe>      Chunk Size : 512K

Giuseppe>    Device Role : spare
Giuseppe>    Array State : .... ('A' == active, '.' == missing, 'R' == replacing)

Giuseppe> /dev/sdf:
Giuseppe>           Magic : a92b4efc
Giuseppe>         Version : 1.2
Giuseppe>     Feature Map : 0x9
Giuseppe>      Array UUID : 943d287e:af28b455:88a047f2:d714b8c6
Giuseppe>            Name : labrador:oneforall  (local to host labrador)
Giuseppe>   Creation Time : Fri Nov 30 19:57:45 2012
Giuseppe>      Raid Level : raid6
Giuseppe>    Raid Devices : 4

Giuseppe>  Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
Giuseppe>      Array Size : 5860270080 (5588.79 GiB 6000.92 GB)
Giuseppe>   Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
Giuseppe>     Data Offset : 262144 sectors
Giuseppe>    Super Offset : 8 sectors
Giuseppe>    Unused Space : before=262048 sectors, after=944 sectors
Giuseppe>           State : clean
Giuseppe>     Device UUID : f7359c4e:c1f04b22:ce7aa32f:ed5bb054

Giuseppe> Internal Bitmap : 8 sectors from superblock
Giuseppe>     Update Time : Sun Dec  4 17:11:19 2016
Giuseppe>   Bad Block Log : 512 entries available at offset 80 sectors - bad
Giuseppe> blocks present.
Giuseppe>        Checksum : 3a5b94a7 - correct
Giuseppe>          Events : 31196

Giuseppe>          Layout : left-symmetric
Giuseppe>      Chunk Size : 512K

Giuseppe>    Device Role : spare
Giuseppe>    Array State : .... ('A' == active, '.' == missing, 'R' == replacing)

Giuseppe> ==8<=======

Giuseppe> I do however know the _original_ positions of the respective disks
Giuseppe> from the kernel messages

Giuseppe> At assembly time:

Giuseppe> [  +0.000638] RAID conf printout:
Giuseppe> [  +0.000001]  --- level:6 rd:4 wd:4
Giuseppe> [  +0.000001]  disk 0, o:1, dev:sdf
Giuseppe> [  +0.000001]  disk 1, o:1, dev:sde
Giuseppe> [  +0.000000]  disk 2, o:1, dev:sdd
Giuseppe> [  +0.000001]  disk 3, o:1, dev:sdc

Giuseppe> After the JBOD disappeared and right before they all get kicked out:

Giuseppe> [  +0.000438] RAID conf printout:
Giuseppe> [  +0.000001]  --- level:6 rd:4 wd:0
Giuseppe> [  +0.000001]  disk 0, o:0, dev:sdf
Giuseppe> [  +0.000001]  disk 1, o:0, dev:sde
Giuseppe> [  +0.000000]  disk 2, o:0, dev:sdd
Giuseppe> [  +0.000001]  disk 3, o:0, dev:sdc


John> You might be able to just for the three spare disks (assumed in this
John> case to be sda1, sdb1, sdc1; but you need to be sure first!) to
John> assemble into a full array with:
John> 
John> mdadm -A /dev/md50 /dev/sda1 /dev/sdb1 /dev/sdc1
John> 
John> And if that works, great.   If not, post the error message(s) you get
John> back.

Giuseppe> Note that the RAID has no active disks anymore, since when I tried
Giuseppe> re-adding the formerly active disks that
Giuseppe> where kicked from the array they got marked as spares, and mdraid
Giuseppe> simply refuses to start a RAID6 setup with only spares. The message I
Giuseppe> get is indeed

Giuseppe> mdadm: /dev/md126 assembled from 0 drives and 3 spares - not enough to
Giuseppe> start the array.

Giuseppe> This is the point at which I made a copy of 3 of the 4 disks and
Giuseppe> started playing around. Specifically, I dd'ed sdc into sdh, sdd into
Giuseppe> sdi and sde into sdj and started playing around with sd[hij] rather
Giuseppe> than the original disks, as I mentioned:

Giuseppe> So one thing that I've done is to hack around the superblock in the
Giuseppe> disks (copies) to put back the device roles as they were (getting the
Giuseppe> information from the pre-failure dmesg output). (By the way, I've been
Giuseppe> using Andy's Binary Editor for the superblock editing, so if anyone is
Giuseppe> interested in a be.ini for mdraid v1 superblocks, including checksum
Giuseppe> verification, I'd be happy to share). Specifically, I've left the
Giuseppe> device number untouched, but I have edited the dev_roles array so that
Giuseppe> the slots corresponding to the dev_number from all the disks map to
Giuseppe> appropriate device roles.

Giuseppe> Specifically, I hand-edited the superblocks to achieve this:


Giuseppe> ==8<===============

Giuseppe> /dev/sdh:
Giuseppe>           Magic : a92b4efc
Giuseppe>         Version : 1.2
Giuseppe>     Feature Map : 0x9
Giuseppe>      Array UUID : 943d287e:af28b455:88a047f2:d714b8c6
Giuseppe>            Name : labrador:oneforall  (local to host labrador)
Giuseppe>   Creation Time : Fri Nov 30 19:57:45 2012
Giuseppe>      Raid Level : raid6
Giuseppe>    Raid Devices : 4

Giuseppe>  Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
Giuseppe>      Array Size : 5860270080 (5588.79 GiB 6000.92 GB)
Giuseppe>   Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
Giuseppe>     Data Offset : 262144 sectors
Giuseppe>    Super Offset : 8 sectors
Giuseppe>    Unused Space : before=262048 sectors, after=944 sectors
Giuseppe>           State : clean
Giuseppe>     Device UUID : 543f75ac:a1f3cf99:1c6b71d9:52e358b9

Giuseppe> Internal Bitmap : 8 sectors from superblock
Giuseppe>     Update Time : Sun Dec  4 17:11:19 2016
Giuseppe>   Bad Block Log : 512 entries available at offset 80 sectors - bad
Giuseppe> blocks present.
Giuseppe>        Checksum : 1e3300fe - correct
Giuseppe>          Events : 31196

Giuseppe>          Layout : left-symmetric
Giuseppe>      Chunk Size : 512K

Giuseppe>    Device Role : Active device 3
Giuseppe>    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

Giuseppe> /dev/sdi:
Giuseppe>           Magic : a92b4efc
Giuseppe>         Version : 1.2
Giuseppe>     Feature Map : 0x9
Giuseppe>      Array UUID : 943d287e:af28b455:88a047f2:d714b8c6
Giuseppe>            Name : labrador:oneforall  (local to host labrador)
Giuseppe>   Creation Time : Fri Nov 30 19:57:45 2012
Giuseppe>      Raid Level : raid6
Giuseppe>    Raid Devices : 4

Giuseppe>  Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
Giuseppe>      Array Size : 5860270080 (5588.79 GiB 6000.92 GB)
Giuseppe>   Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
Giuseppe>     Data Offset : 262144 sectors
Giuseppe>    Super Offset : 8 sectors
Giuseppe>    Unused Space : before=262048 sectors, after=944 sectors
Giuseppe>           State : clean
Giuseppe>     Device UUID : 649d53ad:f909b7a9:cd0f57f2:08a55e3b

Giuseppe> Internal Bitmap : 8 sectors from superblock
Giuseppe>     Update Time : Sun Dec  4 17:11:19 2016
Giuseppe>   Bad Block Log : 512 entries available at offset 80 sectors - bad
Giuseppe> blocks present.
Giuseppe>        Checksum : c9e3e035 - correct
Giuseppe>          Events : 31196

Giuseppe>          Layout : left-symmetric
Giuseppe>      Chunk Size : 512K

Giuseppe>    Device Role : Active device 2
Giuseppe>    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

Giuseppe> /dev/sdj:
Giuseppe>           Magic : a92b4efc
Giuseppe>         Version : 1.2
Giuseppe>     Feature Map : 0x9
Giuseppe>      Array UUID : 943d287e:af28b455:88a047f2:d714b8c6
Giuseppe>            Name : labrador:oneforall  (local to host labrador)
Giuseppe>   Creation Time : Fri Nov 30 19:57:45 2012
Giuseppe>      Raid Level : raid6
Giuseppe>    Raid Devices : 4

Giuseppe>  Avail Dev Size : 5860271024 (2794.39 GiB 3000.46 GB)
Giuseppe>      Array Size : 5860270080 (5588.79 GiB 6000.92 GB)
Giuseppe>   Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
Giuseppe>     Data Offset : 262144 sectors
Giuseppe>    Super Offset : 8 sectors
Giuseppe>    Unused Space : before=262048 sectors, after=944 sectors
Giuseppe>           State : clean
Giuseppe>     Device UUID : dd3f90ab:619684c0:942a7d88:f116f2db

Giuseppe> Internal Bitmap : 8 sectors from superblock
Giuseppe>     Update Time : Sun Dec  4 17:11:19 2016
Giuseppe>   Bad Block Log : 512 entries available at offset 80 sectors - bad
Giuseppe> blocks present.
Giuseppe>        Checksum : 15a7975c - correct
Giuseppe>          Events : 31196

Giuseppe>          Layout : left-symmetric
Giuseppe>      Chunk Size : 512K

Giuseppe>    Device Role : Active device 1
Giuseppe>    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

Giuseppe> ==8<===============

Giuseppe> And I _can_ assemble the array, but what I get is this:

Giuseppe> [  +0.003574] md: bind<sdi>
Giuseppe> [  +0.001823] md: bind<sdh>
Giuseppe> [  +0.000978] md: bind<sdj>
Giuseppe> [  +0.003971] md/raid:md127: device sdj operational as raid disk 1
Giuseppe> [  +0.000125] md/raid:md127: device sdh operational as raid disk 3
Giuseppe> [  +0.000105] md/raid:md127: device sdi operational as raid disk 2
Giuseppe> [  +0.015017] md/raid:md127: allocated 4374kB
Giuseppe> [  +0.000139] md/raid:md127: raid level 6 active with 3 out of 4
Giuseppe> devices, algorithm 2
Giuseppe> [  +0.000063] RAID conf printout:
Giuseppe> [  +0.000002]  --- level:6 rd:4 wd:3
Giuseppe> [  +0.000003]  disk 1, o:1, dev:sdj
Giuseppe> [  +0.000002]  disk 2, o:1, dev:sdi
Giuseppe> [  +0.000001]  disk 3, o:1, dev:sdh
Giuseppe> [  +0.004187] md127: bitmap file is out of date (31193 < 31196) --
Giuseppe> forcing full recovery
Giuseppe> [  +0.000065] created bitmap (22 pages) for device md127
Giuseppe> [  +0.000072] md127: bitmap file is out of date, doing full recovery
Giuseppe> [  +0.100300] md127: bitmap initialized from disk: read 2 pages, set
Giuseppe> 44711 of 44711 bits
Giuseppe> [  +0.039741] md127: detected capacity change from 0 to 6000916561920
Giuseppe> [  +0.000085] Buffer I/O error on dev md127, logical block 0, async page read
Giuseppe> [  +0.000064] Buffer I/O error on dev md127, logical block 0, async page read
Giuseppe> [  +0.000022] Buffer I/O error on dev md127, logical block 0, async page read
Giuseppe> [  +0.000022] Buffer I/O error on dev md127, logical block 0, async page read
Giuseppe> [  +0.000019] ldm_validate_partition_table(): Disk read failed.
Giuseppe> [  +0.000021] Buffer I/O error on dev md127, logical block 0, async page read
Giuseppe> [  +0.000026] Buffer I/O error on dev md127, logical block 0, async page read
Giuseppe> [  +0.000022] Buffer I/O error on dev md127, logical block 0, async page read
Giuseppe> [  +0.000021] Buffer I/O error on dev md127, logical block 0, async page read
Giuseppe> [  +0.000019] Dev md127: unable to read RDB block 0
Giuseppe> [  +0.000016] Buffer I/O error on dev md127, logical block 0, async page read
Giuseppe> [  +0.000022] Buffer I/O error on dev md127, logical block 0, async page read
Giuseppe> [  +0.000030]  md127: unable to read partition table

Giuseppe> and any attempt to access md127 content gives an I/O error.


Giuseppe> -- 
Giuseppe> Giuseppe "Oblomov" Bilotta
Giuseppe> --
Giuseppe> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
Giuseppe> the body of a message to majordomo@vger.kernel.org
Giuseppe> More majordomo info at  http://vger.kernel.org/majordomo-info.html
