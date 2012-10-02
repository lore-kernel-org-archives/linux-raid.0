From: Mark Munoz <mark.munoz@rightthisminute.com>
Subject: Re: MD RAID Bug 7/15/12
Date: Mon, 1 Oct 2012 19:33:50 -0700
Message-ID: <0B674309-5CBC-4C36-983F-AB75D9C2BDDB@rightthisminute.com>
References: <022FFCA9-5D0E-41DB-9617-202C6FAADD06@rightthisminute.com> <20121001130242.745b7ca3@notabene.brown> <42BA87F6-C5A3-4321-A4C7-0DCF0A9DF79D@rightthisminute.com> <20121002114920.1029bed7@notabene.brown>
Mime-Version: 1.0 (Mac OS X Mail 6.1 \(1498\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121002114920.1029bed7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Yes sorry should have sent that output.  This is the weird side!

So md0 was unaffected and it assembled perfectly.  Here is a sample output from /dev/sdf

/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : a24f542c:e0bc0fd0:983af76e:c7581724
           Name : hulk:0  (local to host hulk)
  Creation Time : Wed Aug 15 16:24:17 2012
     Raid Level : raid6
   Raid Devices : 24

 Avail Dev Size : 5860531120 (2794.52 GiB 3000.59 GB)
     Array Size : 128931677952 (61479.42 GiB 66013.02 GB)
  Used Dev Size : 5860530816 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : c3d3ea5b:7db696fd:71474db6:c07c7415

    Update Time : Mon Oct  1 13:54:05 2012
       Checksum : 246155dd - correct
         Events : 41

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 4
   Array State : AAAAAAAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing)

So this chunk size is 64k.  The chunk size of md1 is 4k.

/dev/sdaf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : ab4c898b:03310a29:276a40a1:2ad45c73
           Name : hulk:1  (local to host hulk)
  Creation Time : Mon Oct  1 13:51:50 2012
     Raid Level : raid6
   Raid Devices : 19

 Avail Dev Size : 5860531120 (2794.52 GiB 3000.59 GB)
     Array Size : 99629024416 (47506.82 GiB 51010.06 GB)
  Used Dev Size : 5860530848 (2794.52 GiB 3000.59 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 0a88e45f:7df6b724:59825715:faf4abdf

    Update Time : Mon Oct  1 13:54:05 2012
       Checksum : b276ec79 - correct
         Events : 2

         Layout : left-symmetric
     Chunk Size : 4K

   Device Role : Active device 5
   Array State : AAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing)

I created these arrays using webmin and I guess I must have left the default which is 4k in that tool.  I manually changed md0 and md2 to 64k when I created those arrays.

However here is the weird part.  This is the output of md0 which was the array that built perfectly upon reboot.

/dev/md0:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : aaa29f43:b689f66d:f270c5fc:405620b7
           Name : hulk:2  (local to host hulk)
  Creation Time : Wed Aug 15 16:26:09 2012
     Raid Level : -unknown-
   Raid Devices : 0

 Avail Dev Size : 128931675904 (61479.42 GiB 66013.02 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : b626dd72:995f1277:6f61e94a:489e0468

    Update Time : Sat Sep 29 14:49:09 2012
       Checksum : c09051e9 - correct
         Events : 1


   Device Role : spare
   Array State :  ('A' == active, '.' == missing)


And this is the output of md1 AFTER the recreation.

/dev/md1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : aaa29f43:b689f66d:f270c5fc:405620b7
           Name : hulk:2  (local to host hulk)
  Creation Time : Wed Aug 15 16:26:09 2012
     Raid Level : raid0
   Raid Devices : 2

 Avail Dev Size : 99629022368 (47506.82 GiB 51010.06 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 184bb4db:b77d921f:28a45e09:dc58e1e1

    Update Time : Wed Aug 15 16:26:09 2012
       Checksum : 334e56ee - correct
         Events : 0

     Chunk Size : 64K

   Device Role : Active device 1
   Array State : AA ('A' == active, '.' == missing)


So I am now thinking that during my shutdown this weekend the device /dev/md0 as part of the array /dev/md2 was affected by the bug as well as 18 of the 19 devices contained inside of /devm/md1

Mark Munoz
On Oct 1, 2012, at 6:49 PM, NeilBrown <neilb@suse.de> wrote:

> On Mon, 1 Oct 2012 14:00:24 -0700 Mark Munoz <mark.munoz@rightthisminute.com>
> wrote:
> 
>> Neil,
>> 
>> Thank you again so much for taking time out of your day to personally help me it really means a lot.  I have ran the command and have successfully recreated my md1  Now however md2 will not assemble.  I get this error.
> 
> Please don't take the discussion off-list.
> 
> If you want an answer, you will have to post to the list - and CC me if you
> like.
> 
> NeilBrown
> 
> 
>> 
>> sudo mdadm --assemble --force /dev/md2 /dev/md0 /dev/md1
>> mdadm: superblock on /dev/md1 doesn't match others - assembly aborted
>> 
>> Would I be correct in thinking that I just need to recreate md2 now as well?
>> 
>> I assume with this command?
>> 
>> sudo mdadm --create --assume-clean /dev/md2 --level=0 --chunk=64 --metadata=1.2 --raid-devices=2 /dev/md0 /dev/md1
>> 
>> Mark Munoz
>> 
>> On Sep 30, 2012, at 8:02 PM, NeilBrown <neilb@suse.de> wrote:
>> 
>>> On Sat, 29 Sep 2012 17:12:40 -0700 Mark Munoz
>>> <mark.munoz@rightthisminute.com> wrote:
>>> 
>>>> Hi I appear to have been affected by the bug you found on 7/15/12.  The data I have on this array is really important and I want to make sure I get this correct before I actually make changes.
>>>> 
>>>> Configuration:
>>>> md0 is a RAID 6 volume with 24 devices and 1 spare.  It is working fine and was unaffected.
>>>> md1 is a RAID 6 volume with 19 devices and 1 spare.  It was affected.  All the drives show as unknown raid level and 0 devices.  With the exception of device 5.  It has all the information.
>>>> 
>>>> Here is the output from that drive:
>>>> 
>>>> serveradmin@hulk:/etc/mdadm$ sudo mdadm --examine /dev/sdaf
>>>> /dev/sdaf:
>>>>         Magic : a92b4efc
>>>>       Version : 1.2
>>>>   Feature Map : 0x0
>>>>    Array UUID : 6afb3306:144cec30:1b2d1a19:3a56f0d3
>>>>          Name : hulk:1  (local to host hulk)
>>>> Creation Time : Wed Aug 15 16:25:30 2012
>>>>    Raid Level : raid6
>>>>  Raid Devices : 19
>>>> 
>>>> Avail Dev Size : 5860531120 (2794.52 GiB 3000.59 GB)
>>>>    Array Size : 99629024416 (47506.82 GiB 51010.06 GB)
>>>> Used Dev Size : 5860530848 (2794.52 GiB 3000.59 GB)
>>>>   Data Offset : 2048 sectors
>>>>  Super Offset : 8 sectors
>>>>         State : clean
>>>>   Device UUID : 205dfd9f:9be2b9ca:1f775974:fb1b742c
>>>> 
>>>>   Update Time : Sat Sep 29 12:22:51 2012
>>>>      Checksum : 9f164d8e - correct
>>>>        Events : 38
>>>> 
>>>>        Layout : left-symmetric
>>>>    Chunk Size : 4K
>>>> 
>>>>  Device Role : Active device 5
>>>>  Array State : AAAAAAAAAAAAAAAAAAA ('A' == active, '.' == missing)
>>>> 
>>>> Now I also have md2 which is a striped RAID of both md0 and md1.
>>>> 
>>>> When I type:
>>>> 
>>>> sudo mdadm --create --assume-clean /dev/md1 --level=6 --chunk=4 --metadata=1.2 --raid-devices=19 /dev/sdaa /dev/sdab /dev/sdac /dev/sdad /dev/sdae /dev/sdaf /dev/sdag /dev/sdah /dev/sdai /dev/sdaj /dev/sdak /dev/sdal /dev/sdam /dev/sdan /dev/sdao /dev/sdap /dev/sdaq /dev/sdar /dev/sdas
>>>> 
>>>> the following error for each device.
>>>> 
>>>> mdadm: /dev/sdaa appears to be part of a raid array:
>>>>   level=-unknown- devices=0 ctime=Wed Aug 15 16:25:30 2012
>>>> mdadm: partition table exists on /dev/sdaa but will be lost or
>>>>      meaningless after creating array
>>>> 
>>>> I want to make sure by running this above command that I won't affect any of the data of md2 when I assemble that array after creating md1.  Any help on this issue would be greatly appreciated.  I would normally just DD copies but as you can see I would have to buy 19 more 3TB hard drives as well as the time to DD each drive.  It is a production server and that kind of down time would really rather be avoided.  
>>> 
>>> Running this command will only overwrite the 4K of metadata, 4K from the
>>> start of the devices.  It will not write anything else to any device.
>>> 
>>> so yes, it is safe.
>>> 
>>> NeilBrown
>>> 
>>> 
>>> 
>>>> 
>>>> Thank you so much for your time.
>>>> 
>>>> Mark Munoz
>>>> 623.523.3201--
>>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> 
> 

