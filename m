From: Mike Myers <mikesm559@yahoo.com>
Subject: Re: Need urgent help in fixing raid5 array
Date: Sat, 6 Dec 2008 11:30:00 -0800 (PST)
Message-ID: <36036.96129.qm@web30803.mail.mud.yahoo.com>
References: <936691.74609.qm@web30806.mail.mud.yahoo.com> <447802.83994.qm@web30807.mail.mud.yahoo.com> <alpine.DEB.1.10.0812051922530.4906@p34.internal.lan> <616202.13446.qm@web30804.mail.mud.yahoo.com> <alpine.DEB.1.10.0812051950550.12295@p34.internal.lan> <638620.91235.qm@web30807.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Myers <mikesm559@yahoo.com>, Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

/dev/sdk1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : e70e0697:a10a5b75:941dd76f:196d9e4e
  Creation Time : Tue Aug 19 21:31:10 2008
     Raid Level : raid5
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 5860559616 (5589.07 GiB 6001.21 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 2

    Update Time : Thu Dec  4 15:32:09 2008
          State : clean
 Active Devices : 6
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 1
       Checksum : ab1934d5 - correct
         Events : 0.1436484

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     6       8      161        6      active sync   /dev/sdk1

   0     0       0        0        0      removed
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8      145        2      active sync   /dev/sdj1
   3     3       8       17        3      active sync   /dev/sdb1
   4     4       8       33        4      active sync   /dev/sdc1
   5     5       8      129        5      active sync   /dev/sdi1
   6     6       8      161        6      active sync   /dev/sdk1
   7     7       8      113        7      spare   /dev/sdh1


Here is the examine from sdh1 (which I thought was the the disk being replaced by now appears to be the spare):

/dev/sdh1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : e70e0697:a10a5b75:941dd76f:196d9e4e
  Creation Time : Tue Aug 19 21:31:10 2008
     Raid Level : raid5
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 5860559616 (5589.07 GiB 6001.21 GB)
   Raid Devices : 7
  Total Devices : 8
Preferred Minor : 2

    Update Time : Fri Dec  5 08:15:16 2008
          State : clean
 Active Devices : 5
Working Devices : 7
 Failed Devices : 1
  Spare Devices : 2
       Checksum : ab1a2d37 - correct
         Events : 0.1438064

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     8       8      113        8      spare   /dev/sdh1

   0     0       0        0        0      removed
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8      145        2      active sync   /dev/sdj1
   3     3       8       17        3      active sync   /dev/sdb1
   4     4       8       33        4      active sync   /dev/sdc1
   5     5       8      129        5      active sync   /dev/sdi1
   6     6       0        0        6      faulty removed
   7     7       8      241        7      spare   /dev/sdp1
   8     8       8      113        8      spare   /dev/sdh1


And here is the output of the examine of a known good member sdb1:


/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : e70e0697:a10a5b75:941dd76f:196d9e4e
  Creation Time : Tue Aug 19 21:31:10 2008
     Raid Level : raid5
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 5860559616 (5589.07 GiB 6001.21 GB)
   Raid Devices : 7
  Total Devices : 8
Preferred Minor : 2

    Update Time : Fri Dec  5 08:15:16 2008
          State : clean
 Active Devices : 5
Working Devices : 7
 Failed Devices : 1
  Spare Devices : 2
       Checksum : ab1a2cd3 - correct
         Events : 0.1438064

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     3       8       17        3      active sync   /dev/sdb1

   0     0       0        0        0      removed
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8      145        2      active sync   /dev/sdj1
   3     3       8       17        3      active sync   /dev/sdb1
   4     4       8       33        4      active sync   /dev/sdc1
   5     5       8      129        5      active sync   /dev/sdi1
   6     6       0        0        6      faulty removed
   7     7       8      241        7      spare   /dev/sdp1
   8     8       8      113        8      spare   /dev/sdh1


Any more ideas as to what's going on?

Thanks,
Mike




----- Original Message ----
From: Mike Myers <mikesm559@yahoo.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
Sent: Saturday, December 6, 2008 11:02:39 AM
Subject: Re: Need urgent help in fixing raid5 array

Ok, here is some more info on this odd problem.

I have seven 1 TB drives in raid5 array.  sdb1 sdc1 sdf1 sdh1 sdi1 sdj1 sdk1

They all have the same uuid, and events is the same for each except sdk1, which I think was the disk being resynced.  As I understand it, when the array is being resynced, the events counter on the newly added drive is different than the others.  The other drives have the same events and uuid, and all show clean.  When I try and assemble the array of the 7 drives, it tells me there are 5 drives and 1 spare, not enough to start the array.  If I remove sdk1 (the drive with the different event number on it), I get the same exact same message.  

By removing one drive at a time from the assemble command, I determined that md thinks that sdh1 is the spare, even though events are the same and the the UUID is the same, the checksum says it's ok.  Why does it think this drive is a spare and not a data drive?  

I had cloned the data drive that had failed and got almost everything copied over, all but 12kb.  So I think it's fine and is not being a problem.

How does md decide which drive is a spare and which is an active synced drive, etc... ?  I can't seem to find a document that outlines all this.

Thx
mike




----- Original Message ----
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Mike Myers <mikesm559@yahoo.com>
Cc: linux-raid@vger.kernel.org
Sent: Friday, December 5, 2008 4:51:26 PM
Subject: Re: Need urgent help in fixing raid5 array

Only use it as A LAST resort, check the mailing list or wait for 
Neil/someone else with/whose had a similar issue who can maybe help more 
here.

On Fri, 5 Dec 2008, Mike Myers wrote:

> Thanks very much.  All the disks I am trying to assemble have the same event count and UUID, which is why I don't understand why it's not assembling.  I'll try the assume-clean option and see if that helps.
>
> It would be great to understand how md determines if the drives are in sync with each other.  I thought the uuid and event count was all you needed...
>
> thx
> mike
>
>
>
>
> ----- Original Message ----
> From: Justin Piszcz <jpiszcz@lucidpixels.com>
> To: Mike Myers <mikesm559@yahoo.com>
> Cc: linux-raid@vger.kernel.org
> Sent: Friday, December 5, 2008 4:24:46 PM
> Subject: Re: Need urgent help in fixing raid5 array
>
>
> You can try this as a last resort:
> http://www.mail-archive.com/linux-raid@vger.kernel.org/msg07815.html
>
> (mdadm w/create and assume-clean) but only use this as a last resort, when
> I had two disk failures, I was able to see some of the data but ultimately
> it was lost, bottom line? i dont use raid5 anymore, raid6 only, in the
> 3ware docs they recommend if you use more than 4 disks you should use
> raid6 if you have the capability, i agree
>
> some others on the list may have more . less intrusive ideas . only  use
> the above method as a LAST RESORT, i was able to assemble the array but I
> had problems getting xfs_repair to fix the filesystem
>
> On Fri, 5 Dec 2008, Mike Myers wrote:
>
>> Anyone?  What am I missing here?
>>
>> thx
>> mike
>>
>>
>>
>>
>> ----- Original Message ----
>> From: Mike Myers <mikesm559@yahoo.com>
>> To: linux-raid@vger.kernel.org
>> Sent: Friday, December 5, 2008 9:03:22 AM
>> Subject: Need urgent help in fixing raid5 array
>>
>> I have a problem with repairing a raid5 array I really need some help with.  I must be missing something here.
>>
>> I have 2 raid5 arrays combined with LVM into a common logical volume and then running XFS on top of that.  Both arrays have 7 1 TB disks in them.  I moved a controller card around so that I could install a new Intel GB ethernet card in one of the PCI-E slots.  That went fine except one of the SATA cables got knocked loose so one of the disks in /dev/md2 wen't offline.  Linux booted fine, started the md2 with 6 elements in it and everything was fine with md2 in a degraded state.  I fixed the cable problem and hot added that drive to the array, but since it was now out of sync, md began a rebuild.  No problem.
>>
>> Around 60% through the resync, smartd started reporting problems with one of the other drives in the array.  Then that drive ejected from the degraded array, caused the raid to stop and the LVm volume to go offline.  Ugh...
>>
>> Ok, so it looks from the smart data that that disk had been having a lot of problems and was failing.  As it happens, I had a new 1 TB disk arrive the same day, and I pressed it to service here.  I used sfdisk -d olddisk | sfdisk newdisk to copy the partition table from the old drive to the new one, and then used ddrescue to copy the data from the old partition (/dev/sdo1) to the new one (/dev/sdp1). That worked pretty well, just 12kB couldn't be recovered.
>>
>> So I remove the old disk,  re-add the new disk, and attempt to start the array with new (cloned) 1 Tb disk in the old disks stead.  Even though the UUID's, magic numbers and events fields are all the same, md thinks the cloned disk is a spare, and doesn't start the array.  What am I missing here?  Why doesn't it view it as the old disk as a member and just start it?
>>
>> thx
>> mike
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



      
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



      
