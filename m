From: EJ Vincent <ej@ejane.org>
Subject: Re: Upgrade from Ubuntu 10.04 to 12.04 broken raid6.
Date: Mon, 01 Oct 2012 13:14:26 -0400
Message-ID: <5069CF72.6050906@ejane.org>
References: <loom.20120930T105755-205@post.gmane.org> <alpine.DEB.2.00.1209301203060.13902@uplift.swm.pp.se> <50689B6C.8000307@ejane.org> <CADNH=7GbKAvciDoZ1gEBCBUjqdMHJohrBrxoZXpvnNHAW2vQ6g@mail.gmail.com> <50689C9B.1010603@ejane.org> <5068AB81.1060103@turmel.org> <5068D464.4030504@ejane.org> <50698F32.1080001@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50698F32.1080001@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/1/2012 8:40 AM, Phil Turmel wrote:
> Hi EJ,
>
> On 09/30/2012 07:23 PM, EJ Vincent wrote:
>> On 9/30/2012 4:28 PM, Phil Turmel wrote:
>>> Do you have *any* dmesg output from the old system?  Or dmesg from the
>>> very first boot under 12.04?  That might have enough information to
>>> shorten your search.
>>>
>>> In the future, you should record your setup by saving the output of
>>> "mdadm -D" on each array, "mdadm -E" on each member device, and the
>>> output of "ls -l /dev/disk/by-id/"
>>>
>>> Or try my documentation script "lsdrv". [1]
>>>
>>> HTH,
>>>
>>> Phil
>>>
>>> [1] http://github.com/pturmel/lsdrv
>> Hi Phil,
>>
>> Unfortunately I don't have any dmesg log from the old system or the
>> first boot under 12.04.
>>
>> Getting my system to boot at all under 12.04 was chaotic enough, with
>> the overly-aggressive /usr/share/initramfs-tools/scripts/mdadm-functions
>> ravaging my array and then dropping me to a busybox shell over and over
>> again.  I didn't think to record the very first error.
> I'm not prepared to condemn the 12.04 initramfs--I really don't think it
> is a factor in this crisis.  The critical part is the degraded reboot bug.
>
>> Here's an observation of mine, disks: /dev/sdb1, /dev/sdi1, and
>> /dev/sdj1 don't have the Raid level "-unknown-", neither are they
>> labeled as spares.  They are in fact, labeled clean and appear
>> *different* from the others.
>>
>> Could these disks still contain my metadata from 10.04?  I recall during
>> my installation of 12.04 I had anywhere from 1 to 3 disks unpowered, so
>> that I could drop in a SATA CD/DVDRW into the slot.
> Leaving disks unpowered sounds like a key factor in your crisis.  Raid6
> can't operate with more than two missing, and won't assemble if any disk
> disappears between shutdown and the next boot.  (Must be forced.)
>
> So your array would only partially assemble under 12.04 due to
> deliberately missing drives, then you rebooted with a kernel that has a
> problem with that scenario.
>
> The disks very likely do have useful metadata, but no disk has all of
> it.  It might reduce the permutations you need to try.  If you share
> more information about your system layout, some educated first guesses
> might be possible, too.  The output of "mdadm -E" for every drive, and
> lsdrv for an overview.
>
>> I am downloading 10.04.4 LTS and will be ready to use it soon.  I fear
>> having to do permutations-- 9! (factorial) would mean 362,880
>> combinations.  *gasp*
> Phil
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

On 10/1/2012 8:40 AM, Phil Turmel wrote:
> Hi EJ,
>
> On 09/30/2012 07:23 PM, EJ Vincent wrote:
>> On 9/30/2012 4:28 PM, Phil Turmel wrote:
>>> Do you have *any* dmesg output from the old system?  Or dmesg from the
>>> very first boot under 12.04?  That might have enough information to
>>> shorten your search.
>>>
>>> In the future, you should record your setup by saving the output of
>>> "mdadm -D" on each array, "mdadm -E" on each member device, and the
>>> output of "ls -l /dev/disk/by-id/"
>>>
>>> Or try my documentation script "lsdrv". [1]
>>>
>>> HTH,
>>>
>>> Phil
>>>
>>> [1] http://github.com/pturmel/lsdrv
>> Hi Phil,
>>
>> Unfortunately I don't have any dmesg log from the old system or the
>> first boot under 12.04.
>>
>> Getting my system to boot at all under 12.04 was chaotic enough, with
>> the overly-aggressive /usr/share/initramfs-tools/scripts/mdadm-functions
>> ravaging my array and then dropping me to a busybox shell over and over
>> again.  I didn't think to record the very first error.
> I'm not prepared to condemn the 12.04 initramfs--I really don't think it
> is a factor in this crisis.  The critical part is the degraded reboot bug.
>
>> Here's an observation of mine, disks: /dev/sdb1, /dev/sdi1, and
>> /dev/sdj1 don't have the Raid level "-unknown-", neither are they
>> labeled as spares.  They are in fact, labeled clean and appear
>> *different* from the others.
>>
>> Could these disks still contain my metadata from 10.04?  I recall during
>> my installation of 12.04 I had anywhere from 1 to 3 disks unpowered, so
>> that I could drop in a SATA CD/DVDRW into the slot.
> Leaving disks unpowered sounds like a key factor in your crisis.  Raid6
> can't operate with more than two missing, and won't assemble if any disk
> disappears between shutdown and the next boot.  (Must be forced.)
>
> So your array would only partially assemble under 12.04 due to
> deliberately missing drives, then you rebooted with a kernel that has a
> problem with that scenario.
>
> The disks very likely do have useful metadata, but no disk has all of
> it.  It might reduce the permutations you need to try.  If you share
> more information about your system layout, some educated first guesses
> might be possible, too.  The output of "mdadm -E" for every drive, and
> lsdrv for an overview.
>
>> I am downloading 10.04.4 LTS and will be ready to use it soon.  I fear
>> having to do permutations-- 9! (factorial) would mean 362,880
>> combinations.  *gasp*
> Phil
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi Phil,

Here's the information you requested.

The server has 10 disks, a dedicated 500GB disk for the operating system 
(which Ubuntu 10.04.4 has labeled /dev/sdd), and 9 x 2TB disks 
(/dev/sd[a,b,c,e,f,g,h,i,j):

Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
Disk /dev/sdd: 500.1 GB, 500107862016 bytes
Disk /dev/sde: 2000.4 GB, 2000398934016 bytes
Disk /dev/sdf: 2000.4 GB, 2000398934016 bytes
Disk /dev/sdg: 2000.4 GB, 2000398934016 bytes
Disk /dev/sdh: 2000.4 GB, 2000398934016 bytes
Disk /dev/sdi: 2000.4 GB, 2000398934016 bytes
Disk /dev/sdj: 2000.4 GB, 2000398934016 bytes

The devices are spread amongst an on-board SATA controller, MCP78S 
GeForce AHCI, and two SiI 3124 PCI-X SATA controllers.

The layout is as follows: 5 disks are attached to the on-board 
controller, 3 attached to one SiI 3124 controller, and 2 attached to the 
other SiI 3124 controller.

I've loaded your lsdrv script, here are the results:

PCI [pata_amd] 00:06.0 IDE interface: nVidia Corporation MCP78S [GeForce 
8200] IDE (rev a1)
scsi 0:x:x:x [Empty]
scsi 1:x:x:x [Empty]

PCI [sata_sil24] 06:04.0 RAID bus controller: Silicon Image, Inc. SiI 
3124 PCI-X Serial ATA Controller (rev 02)
scsi 2:0:0:0 ATA ST2000DL003-9VT1
sda 1.82t [8:0] Empty/Unknown
  sda1 1.82t [8:1] Empty/Unknown
scsi 5:0:0:0 ATA ST2000DL003-9VT1
sdb 1.82t [8:16] Empty/Unknown
  sdb1 1.82t [8:17] Empty/Unknown
scsi 7:0:0:0 ATA ST2000DL003-9VT1
sdc 1.82t [8:32] Empty/Unknown
  sdc1 1.82t [8:33] Empty/Unknown
scsi 9:x:x:x [Empty]

PCI [ahci] 00:09.0 SATA controller: nVidia Corporation MCP78S [GeForce 
8200] AHCI Controller (rev a2)
scsi 3:0:0:0 ATA WDC WD5000AAKS-2
sdd 465.76g [8:48] Empty/Unknown
  sdd1 237.00m [8:49] Empty/Unknown
  Mounted as /dev/sdd1 @ /boot
  sdd2 3.73g [8:50] Empty/Unknown
  sdd3 23.28g [8:51] Empty/Unknown
  Mounted as /dev/disk/by-uuid/65a128d3-3e2e-487a-a36b-11cbe5530429 @ /
  sdd4 438.52g [8:52] Empty/Unknown
scsi 4:0:0:0 ATA ST2000DL003-9VT1
sde 1.82t [8:64] Empty/Unknown
  sde1 1.82t [8:65] Empty/Unknown
scsi 6:0:0:0 ATA ST32000542AS
sdf 1.82t [8:80] Empty/Unknown
  sdf1 1.82t [8:81] Empty/Unknown
scsi 8:0:0:0 ATA ST32000542AS
sdg 1.82t [8:96] Empty/Unknown
  sdg1 1.82t [8:97] Empty/Unknown
scsi 10:0:0:0 ATA ST2000DL003-9VT1
sdh 1.82t [8:112] Empty/Unknown
  sdh1 1.82t [8:113] Empty/Unknown
scsi 11:x:x:x [Empty]

PCI [sata_sil24] 08:04.0 RAID bus controller: Silicon Image, Inc. SiI 
3124 PCI-X Serial ATA Controller (rev 02)
scsi 12:0:0:0 ATA ST2000DL003-9VT1
sdi 1.82t [8:128] Empty/Unknown
  sdi1 1.82t [8:129] Empty/Unknown
scsi 13:0:0:0 ATA ST2000DL003-9VT1
sdj 1.82t [8:144] Empty/Unknown
  sdj1 1.82t [8:145] Empty/Unknown
scsi 14:x:x:x [Empty]
scsi 15:x:x:x [Empty]

Here is what mdadm -E looks like for each member of the array, now under 
Ubuntu 10.04.4:

# mdadm -E /dev/sda1
/dev/sda1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 321fc20c:997e9a1a:bb67ffde:9de489f5
            Name : ruby:6  (local to host ruby)
   Creation Time : Mon Apr 11 15:40:25 2011
      Raid Level : -unknown-
    Raid Devices : 0

  Avail Dev Size : 3907026672 (1863.02 GiB 2000.40 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 6190765b:200ff748:d50a75e3:597405c4

     Update Time : Sun Sep 30 19:13:16 2012
        Checksum : 37454049 - correct
          Events : 1


     Array Slot : 4 (empty, empty, failed, failed, empty, failed, empty, 
failed, empty, failed, failed, empty, failed... <shortened for readability>)
    Array State :  378 failed

# mdadm -E /dev/sdb1
/dev/sdb1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 321fc20c:997e9a1a:bb67ffde:9de489f5
            Name : ruby:6  (local to host ruby)
   Creation Time : Mon Apr 11 15:40:25 2011
      Raid Level : -unknown-
    Raid Devices : 0

  Avail Dev Size : 3907026672 (1863.02 GiB 2000.40 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 7d707598:a8881376:531ae0c6:aac82909

     Update Time : Sun Sep 30 19:13:16 2012
        Checksum : c9effdc2 - correct
          Events : 1


     Array Slot : 11 (empty, empty, failed, failed, empty, failed, 
empty, failed, empty, failed, failed, empty, failed... <shortened for 
readability>)
    Array State :  378 failed

# mdadm -E /dev/sdc1
/dev/sdc1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 321fc20c:997e9a1a:bb67ffde:9de489f5
            Name : ruby:6  (local to host ruby)
   Creation Time : Mon Apr 11 15:40:25 2011
      Raid Level : raid6
    Raid Devices : 9

  Avail Dev Size : 3907026672 (1863.02 GiB 2000.40 GB)
      Array Size : 27349181440 (13041.11 GiB 14002.78 GB)
   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : a6fd99b2:7bb75287:5d844ec5:822b6d8a

     Update Time : Sun Sep 30 00:34:27 2012
        Checksum : 760485cb - correct
          Events : 2474296

      Chunk Size : 512K

     Array Slot : 7 (0, 1, failed, failed, 2, failed, 4, 5, 6, 7, 8, 3)
    Array State : uuuuuUuuu 3 failed

# mdadm -E /dev/sde1
/dev/sde1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 321fc20c:997e9a1a:bb67ffde:9de489f5
            Name : ruby:6  (local to host ruby)
   Creation Time : Mon Apr 11 15:40:25 2011
      Raid Level : -unknown-
    Raid Devices : 0

  Avail Dev Size : 3907026672 (1863.02 GiB 2000.40 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 179691a0:fd201c2d:49c73803:409a0a9c

     Update Time : Sun Sep 30 19:13:16 2012
        Checksum : 584e3a3a - correct
          Events : 1


     Array Slot : 8 (empty, empty, failed, failed, empty, failed, empty, 
failed, empty, failed, failed, empty, failed... <shortened for readability>)
    Array State :  378 failed

# mdadm -E /dev/sdf1
/dev/sdf1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 321fc20c:997e9a1a:bb67ffde:9de489f5
            Name : ruby:6  (local to host ruby)
   Creation Time : Mon Apr 11 15:40:25 2011
      Raid Level : -unknown-
    Raid Devices : 0

  Avail Dev Size : 3907026672 (1863.02 GiB 2000.40 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : f3f72549:8543972f:1f4a655d:fa9416bd

     Update Time : Sun Sep 30 19:13:16 2012
        Checksum : 7e963c27 - correct
          Events : 1


     Array Slot : 1 (empty, empty, failed, failed, empty, failed, empty, 
failed, empty, failed, failed, empty, failed... <shortened for readability>)
    Array State :  378 failed

# mdadm -E /dev/sdg1
/dev/sdg1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 321fc20c:997e9a1a:bb67ffde:9de489f5
            Name : ruby:6  (local to host ruby)
   Creation Time : Mon Apr 11 15:40:25 2011
      Raid Level : -unknown-
    Raid Devices : 0

  Avail Dev Size : 3907026672 (1863.02 GiB 2000.40 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 9c908e4b:ad7d8af8:ff5d2ab6:50b013e5

     Update Time : Sun Sep 30 19:13:16 2012
        Checksum : cab43e2e - correct
          Events : 1


     Array Slot : 0 (empty, empty, failed, failed, empty, failed, empty, 
failed, empty, failed, failed, empty, failed... <shortened for readability>)
    Array State :  378 failed

# mdadm -E /dev/sdh1
/dev/sdh1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 321fc20c:997e9a1a:bb67ffde:9de489f5
            Name : ruby:6  (local to host ruby)
   Creation Time : Mon Apr 11 15:40:25 2011
      Raid Level : -unknown-
    Raid Devices : 0

  Avail Dev Size : 3907026672 (1863.02 GiB 2000.40 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 321368f6:9f38bc16:76f787c3:4b3d398d

     Update Time : Sun Sep 30 19:13:16 2012
        Checksum : 4942a22e - correct
          Events : 1


     Array Slot : 6 (empty, empty, failed, failed, empty, failed, empty, 
failed, empty, failed, failed, empty, failed... <shortened for readability>)
    Array State :  378 failed

# mdadm -E /dev/sdi1
/dev/sdi1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 321fc20c:997e9a1a:bb67ffde:9de489f5
            Name : ruby:6  (local to host ruby)
   Creation Time : Mon Apr 11 15:40:25 2011
      Raid Level : raid6
    Raid Devices : 9

  Avail Dev Size : 3907026672 (1863.02 GiB 2000.40 GB)
      Array Size : 27349181440 (13041.11 GiB 14002.78 GB)
   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 9d53248b:1db27ffc:a2a511c3:7176a7eb

     Update Time : Sun Sep 30 00:34:27 2012
        Checksum : 22b9429c - correct
          Events : 2474296

      Chunk Size : 512K

     Array Slot : 10 (0, 1, failed, failed, 2, failed, 4, 5, 6, 7, 8, 3)
    Array State : uuuuuuuuU 3 failed

# mdadm -E /dev/sdj1
/dev/sdj1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 321fc20c:997e9a1a:bb67ffde:9de489f5
            Name : ruby:6  (local to host ruby)
   Creation Time : Mon Apr 11 15:40:25 2011
      Raid Level : raid6
    Raid Devices : 9

  Avail Dev Size : 3907026672 (1863.02 GiB 2000.40 GB)
      Array Size : 27349181440 (13041.11 GiB 14002.78 GB)
   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 880ed7fb:b9c673de:929d14c5:53f9b81d

     Update Time : Sun Sep 30 00:34:27 2012
        Checksum : a9748cf3 - correct
          Events : 2474296

      Chunk Size : 512K

     Array Slot : 9 (0, 1, failed, failed, 2, failed, 4, 5, 6, 7, 8, 3)
    Array State : uuuuuuuUu 3 failed

I'd be happy to also supply a dump of 'lshw' which I believe is similar 
to 'lsdrv' if that would be useful to you.  The system is back on 
10.04.4 LTS, and is using mdadm version 2.6.7.1.

Thanks for your continued input and assistance.  Much appreciated.

-EJ


