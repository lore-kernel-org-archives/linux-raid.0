From: Martin Wegner <mw@mroot.net>
Subject: Re: Problem assembling a degraded RAID5
Date: Thu, 12 Apr 2012 22:56:49 +0200
Message-ID: <4F874191.206@mroot.net>
References: <4F8718CD.4070904@mroot.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F8718CD.4070904@mroot.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello.

I was able to gather some more data on the raid array:

Before removing the disk, /proc/mdstat showed this:

------------------------------------------------------------------------------
md1 : active raid5 sdh5[1] sdb5[2] sdc5[3] sdi5[0] sdm5[4](S)
      5860534128 blocks super 1.2 level 5, 16k chunk, algorithm 2 [4/4]
[UUUU]
      bitmap: 0/15 pages [0KB], 65536KB chunk
------------------------------------------------------------------------------

And <mdadm --examine /dev/md1> showed this:

------------------------------------------------------------------------------
/dev/md1:
        Version : 1.2
  Creation Time : Fri Jul  1 20:02:44 2011
     Raid Level : raid5
     Array Size : 5860534128 (5589.04 GiB 6001.19 GB)
  Used Dev Size : 1953511376 (1863.01 GiB 2000.40 GB)
   Raid Devices : 4
  Total Devices : 5
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Wed Apr 11 23:06:09 2012
          State : active
 Active Devices : 4
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 16K

           Name : garm:1  (local to host garm)
           UUID : 610fb4f8:02dab3e7:e2fbd8a5:4828a4b0
         Events : 21215

    Number   Major   Minor   RaidDevice State
       0       8      133        0      active sync   /dev/sdi5
       1       8      117        1      active sync   /dev/sdh5
       3       8       37        2      active sync   /dev/sdc5
       2       8       21        3      active sync   /dev/sdb5

       4       8      197        -      spare   /dev/sdm5

------------------------------------------------------------------------------

So, *after* my repair attempt, the member devices somehow got renamed to
sda5, sdb5, sdg5, sgh5 and sdl5 .

The last device in alphabetical order sdl5 still seems to be the spare
device according to <mdadm --examine ...>.

The sdg5 and sdh5 devices are the HDD models I started the raid5 with at
the beginning (as raid1 at that time). sdg5 reports as raid device 0
according to <mdadm --examine ...>. So I guess that sdg5 and sdh5 got
swapped - maybe because I swapped cables or something like that. But I
think that sdh5 has to be raid device 1, although it is not reporting that.

So that leaves sda5 and sdb5 which also may be swapped, but they should
be raid devices 2 and 3.

For the original device order, this is all I could recover so far. Is
there any way to re-assemble the raid array with this information?

When searching for similar reports, I read that it may be possible to
re-create the array with <mdadm --create ...> if one knows the array's
metadata like level, chunksize, etc. and the original device order when
creating the array.

I think, I have all necessary metadata but the above was all I could
recover about the device order.

On top of this raid5 I had a LUKS crypt device. In the thread [0] on
serverfault.com someone states that multiple tries to do a <mdadm
--create ...> with different device orders can be made and one can check
if a valid RAID was re-created by checking for metadata on the RAID
device. In my case, I could check if a valid LUKS header could be found.
Would this be a possibility?

Is there any way I can recover the raid5 with this information?

I'd really appriciate any help with this issue.

Thanks,

Martin Wegner

[0]
http://serverfault.com/questions/347606/recover-raid-5-data-after-created-new-array-instead-of-re-using

On 04/12/12 20:02, Martin Wegner wrote:
> Hello.
> 
> I've had a disk "failure" in a raid5 containing 4 drives and 1 spare.
> The raid5 still reported to be clean but smart data was indicating one
> drive failing. So I did these steps:
> 
> 1. I shut down the system and replaced the failing drive with a new one.
> 2. Upon booting the system, another drive of this array was missing. I
> thought it would be the spare device and tried to start the array with
> the remaining 3 devices (out of the 4 non-spare), but it didn't work.
> All devices were set up as spare in the array (so I also used --force
> eventually, but still no luck.). So I came to the conclusion that the
> missing device was not the spare device.
> 3. I shut down the system again and re-checked all the cables and also
> re-installed the failing device and removed the new one. So, the raid
> array should be (physically and the actual data on the array) in the
> exact same state as before I had removed the disk.
> 
> But the raid5 array cannot be started anymore. mdadm reports that the
> superblocks of the devices do not match.
> 
> Can anyone help me how to recover this raid array? I'm pretty desperate
> at this point.
> 
> Here is the data of $ mdadm --examine ... of all member devices:
> 
> /dev/sda5:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 610fb4f8:02dab3e7:e2fbd8a5:4828a4b0
>            Name : garm:1  (local to host garm)
>   Creation Time : Fri Jul  1 20:02:44 2011
>      Raid Level : -unknown-
>    Raid Devices : 0
> 
>  Avail Dev Size : 3907023024 (1863.01 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : b80889b3:d910f7cf:940fe571:45fdbd79
> 
>     Update Time : Thu Apr 12 17:47:39 2012
>        Checksum : e5c307f8 - correct
>          Events : 2
> 
> 
>    Device Role : spare
>    Array State :  ('A' == active, '.' == missing)
> 
> 
> /dev/sdb5:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 610fb4f8:02dab3e7:e2fbd8a5:4828a4b0
>            Name : garm:1  (local to host garm)
>   Creation Time : Fri Jul  1 20:02:44 2011
>      Raid Level : -unknown-
>    Raid Devices : 0
> 
>  Avail Dev Size : 3907023024 (1863.01 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 5c645db4:15f5123c:54736b86:201f0767
> 
>     Update Time : Thu Apr 12 17:47:39 2012
>        Checksum : 5482cd74 - correct
>          Events : 2
> 
> 
>    Device Role : spare
>    Array State :  ('A' == active, '.' == missing)
> 
> 
> /dev/sdg5:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 610fb4f8:02dab3e7:e2fbd8a5:4828a4b0
>            Name : garm:1  (local to host garm)
>   Creation Time : Fri Jul  1 20:02:44 2011
>      Raid Level : raid5
>    Raid Devices : 4
> 
>  Avail Dev Size : 3907023024 (1863.01 GiB 2000.40 GB)
>      Array Size : 11721068256 (5589.04 GiB 6001.19 GB)
>   Used Dev Size : 3907022752 (1863.01 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 0ec23618:69bcb467:20fe2b20:5dedf2d6
> 
> Internal Bitmap : 2 sectors from superblock
>     Update Time : Thu Apr 12 17:14:54 2012
>        Checksum : edbcd80f - correct
>          Events : 21215
> 
>          Layout : left-symmetric
>      Chunk Size : 16K
> 
>    Device Role : Active device 0
>    Array State : AAAA ('A' == active, '.' == missing)
> 
> 
> /dev/sdh5:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 610fb4f8:02dab3e7:e2fbd8a5:4828a4b0
>            Name : garm:1  (local to host garm)
>   Creation Time : Fri Jul  1 20:02:44 2011
>      Raid Level : -unknown-
>    Raid Devices : 0
> 
>  Avail Dev Size : 3907023024 (1863.01 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : ff352ee9:4f8d881c:e5408fde:e6234761
> 
>     Update Time : Thu Apr 12 17:47:39 2012
>        Checksum : bc2d09a6 - correct
>          Events : 2
> 
> 
>    Device Role : spare
>    Array State :  ('A' == active, '.' == missing)
> 
> 
> /dev/sdl5:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 610fb4f8:02dab3e7:e2fbd8a5:4828a4b0
>            Name : garm:1  (local to host garm)
>   Creation Time : Fri Jul  1 20:02:44 2011
>      Raid Level : raid5
>    Raid Devices : 4
> 
>  Avail Dev Size : 3907023024 (1863.01 GiB 2000.40 GB)
>      Array Size : 11721068256 (5589.04 GiB 6001.19 GB)
>   Used Dev Size : 3907022752 (1863.01 GiB 2000.40 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : bdf903e3:88296c06:e340658c:4378ac7b
> 
> Internal Bitmap : 2 sectors from superblock
>     Update Time : Sun Apr  8 20:44:46 2012
>        Checksum : 682f35bb - correct
>          Events : 21215
> 
>          Layout : left-symmetric
>      Chunk Size : 16K
> 
>    Device Role : spare
>    Array State : AAAA ('A' == active, '.' == missing)
> 
> Thanks in advance,
> 
> Martin Wegner
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
