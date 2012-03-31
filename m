From: Bryan Bush <bbushvt@gmail.com>
Subject: Re: RAID6 grow failed
Date: Sat, 31 Mar 2012 15:38:23 -0400
Message-ID: <CAJ72viPH9AykY-tafTChcS0ZbP0gGaiKRybafs4C4Yk-8D=g3A@mail.gmail.com>
References: <CAJ72viP2MLb2tL84P-aK6Rs9eAH4x9Wwd=kVNbmPA=2LAfNLjg@mail.gmail.com>
	<20120328151828.6988d3db@notabene.brown>
	<CAJ72viMxgfjhQiqJYVnjBQGfCq7jtegfvUY0nRdj46XDedeSjg@mail.gmail.com>
	<20120328192601.3db82133@notabene.brown>
	<CAJ72viPX1SDL2pPSkGQnujNcaoNmRposJXxaLhDkZDgFxv=-qA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ72viPX1SDL2pPSkGQnujNcaoNmRposJXxaLhDkZDgFxv=-qA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've had another md issue.  Not sure exactly what caused it but my
array is offline again.  The reshape completed and I was about to
insert a new drive to replace the one that failed on the initial
reshape.
/proc/mdstat contains
md1 : inactive sdk1[13](S) sdh1[9](S) sdi1[10](S) sdc1[8](S)
sdj1[11](S) sdb1[4](S) sdd1[6](S) sde1[7](S) sdl1[0](S) sdn1[2](S)
sdo1[3](S)
      21488647746 blocks super 1.2

"mdadm -As --verbose /dev/md1 -u fa32e2c5:e7bda20b:32af7c90:c7ee61eb" r=
eturns
mdadm: looking for devices for /dev/md1
<cut>
mdadm: /dev/sdo1 is identified as a member of /dev/md1, slot 3.
mdadm: /dev/sdn1 is identified as a member of /dev/md1, slot 2.
mdadm: /dev/sdj1 is identified as a member of /dev/md1, slot 10.
mdadm: /dev/sdl1 is identified as a member of /dev/md1, slot 0.
mdadm: /dev/sdk1 is identified as a member of /dev/md1, slot 8.
mdadm: /dev/sdi1 is identified as a member of /dev/md1, slot 11.
mdadm: /dev/sdh1 is identified as a member of /dev/md1, slot 12.
mdadm: /dev/sde1 is identified as a member of /dev/md1, slot 7.
mdadm: /dev/sdd1 is identified as a member of /dev/md1, slot 6.
mdadm: /dev/sdc1 is identified as a member of /dev/md1, slot 5.
mdadm: /dev/sdb1 is identified as a member of /dev/md1, slot 4.
mdadm: Cannot open /dev/sdl1: Device or resource busy

Those are the 11 surviving disks from my 13 disk raid 6.

mdadm -E on those disks gives me
root@diamond:/# mdadm -E /dev/sd[onjlkihedcb]1
mdadm: metadata format 00.90 unknown, ignored.
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
           Name : 1
  Creation Time : Sat Sep 18 17:05:52 2010
     Raid Level : raid6
   Raid Devices : 13

 Avail Dev Size : 3907026863 (1863.02 GiB 2000.40 GB)
     Array Size : 42977294976 (20493.17 GiB 22004.38 GB)
  Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : b7c75aff:703e77dd:8be71623:24cfd5c4

    Update Time : Sat Mar 31 02:57:09 2012
       Checksum : 2aa46cd7 - correct
         Events : 31205

     Chunk Size : 64K

    Array Slot : 4 (0, failed, 2, 3, 4, failed, 6, 7, 5, failed,
failed, failed, failed, failed)
   Array State : u_uuUuuu_____ 7 failed
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
           Name : 1
  Creation Time : Sat Sep 18 17:05:52 2010
     Raid Level : raid6
   Raid Devices : 13

 Avail Dev Size : 3907026863 (1863.02 GiB 2000.40 GB)
     Array Size : 42977294976 (20493.17 GiB 22004.38 GB)
  Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 73f50290:c36a95a1:99de8ad3:2a4e84c8

    Update Time : Sat Mar 31 02:57:09 2012
       Checksum : 338d3cfe - correct
         Events : 31205

     Chunk Size : 64K

    Array Slot : 8 (0, failed, 2, 3, 4, failed, 6, 7, 5, failed,
failed, failed, failed, failed)
   Array State : u_uuuUuu_____ 7 failed
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
           Name : 1
  Creation Time : Sat Sep 18 17:05:52 2010
     Raid Level : raid6
   Raid Devices : 13

 Avail Dev Size : 3907026863 (1863.02 GiB 2000.40 GB)
     Array Size : 42977294976 (20493.17 GiB 22004.38 GB)
  Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : de927013:298f7906:5abdae1e:ccab9188

    Update Time : Sat Mar 31 02:57:09 2012
       Checksum : 27103b2e - correct
         Events : 31205

     Chunk Size : 64K

    Array Slot : 6 (0, failed, 2, 3, 4, failed, 6, 7, 5, failed,
failed, failed, failed, failed)
   Array State : u_uuuuUu_____ 7 failed
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
           Name : 1
  Creation Time : Sat Sep 18 17:05:52 2010
     Raid Level : raid6
   Raid Devices : 13

 Avail Dev Size : 3907026863 (1863.02 GiB 2000.40 GB)
     Array Size : 42977294976 (20493.17 GiB 22004.38 GB)
  Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : a258e2c3:e4abf94c:33be105e:fff62610

    Update Time : Sat Mar 31 02:57:09 2012
       Checksum : e4f969ba - correct
         Events : 31205

     Chunk Size : 64K

    Array Slot : 7 (0, failed, 2, 3, 4, failed, 6, 7, 5, failed,
failed, failed, failed, failed)
   Array State : u_uuuuuU_____ 7 failed
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
           Name : 1
  Creation Time : Sat Sep 18 17:05:52 2010
     Raid Level : raid6
   Raid Devices : 13

 Avail Dev Size : 3907026863 (1863.02 GiB 2000.40 GB)
     Array Size : 42977294976 (20493.17 GiB 22004.38 GB)
  Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : bf54f25f:3a82eb7e:4b852f91:6857c476

    Update Time : Sat Mar 31 02:54:55 2012
       Checksum : 4cd96340 - correct
         Events : 31205

     Chunk Size : 64K

    Array Slot : 9 (0, failed, 2, 3, 4, failed, 6, 7, 5, 12, 11, 10, 9,=
 8)
   Array State : u_uuuuuuuuuuU 2 failed
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
           Name : 1
  Creation Time : Sat Sep 18 17:05:52 2010
     Raid Level : raid6
   Raid Devices : 13

 Avail Dev Size : 3907026863 (1863.02 GiB 2000.40 GB)
     Array Size : 42977294976 (20493.17 GiB 22004.38 GB)
  Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : e239f08a:e56a2abd:18bd6e8d:6e614aa2

    Update Time : Sat Mar 31 02:54:55 2012
       Checksum : dddb72e2 - correct
         Events : 31205

     Chunk Size : 64K

    Array Slot : 10 (0, failed, 2, 3, 4, failed, 6, 7, 5, 12, 11, 10, 9=
, 8)
   Array State : u_uuuuuuuuuUu 2 failed
/dev/sdj1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
           Name : 1
  Creation Time : Sat Sep 18 17:05:52 2010
     Raid Level : raid6
   Raid Devices : 13

 Avail Dev Size : 3907026863 (1863.02 GiB 2000.40 GB)
     Array Size : 42977294976 (20493.17 GiB 22004.38 GB)
  Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : f04f830d:ffc3352f:443c92c0:b03ec412

    Update Time : Sat Mar 31 02:54:55 2012
       Checksum : 76173e74 - correct
         Events : 31201

     Chunk Size : 64K

    Array Slot : 11 (0, failed, 2, 3, 4, failed, 6, 7, 5, 12, 11, 10, 9=
, 8)
   Array State : u_uuuuuuuuUuu 2 failed
/dev/sdk1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
           Name : 1
  Creation Time : Sat Sep 18 17:05:52 2010
     Raid Level : raid6
   Raid Devices : 13

 Avail Dev Size : 3907026863 (1863.02 GiB 2000.40 GB)
     Array Size : 42977294976 (20493.17 GiB 22004.38 GB)
  Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 74bb612c:34c2ddf6:4828ed5c:22ea7b38

    Update Time : Sat Mar 31 02:54:55 2012
       Checksum : 1eb03faa - correct
         Events : 31205

     Chunk Size : 64K

    Array Slot : 13 (0, failed, 2, 3, 4, failed, 6, 7, 5, 12, 11, 10, 9=
, 8)
   Array State : u_uuuuuuUuuuu 2 failed
/dev/sdl1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
           Name : 1
  Creation Time : Sat Sep 18 17:05:52 2010
     Raid Level : raid6
   Raid Devices : 13

 Avail Dev Size : 3907026863 (1863.02 GiB 2000.40 GB)
     Array Size : 42977294976 (20493.17 GiB 22004.38 GB)
  Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 14c53549:bd43ec01:794d70ff:3ea30a9d

    Update Time : Sat Mar 31 02:57:09 2012
       Checksum : 4d82a984 - correct
         Events : 31205

     Chunk Size : 64K

    Array Slot : 0 (0, failed, 2, 3, 4, failed, 6, 7, 5, failed,
failed, failed, failed, failed)
   Array State : U_uuuuuu_____ 7 failed
/dev/sdn1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
           Name : 1
  Creation Time : Sat Sep 18 17:05:52 2010
     Raid Level : raid6
   Raid Devices : 13

 Avail Dev Size : 3907026863 (1863.02 GiB 2000.40 GB)
     Array Size : 42977294976 (20493.17 GiB 22004.38 GB)
  Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : dd08d581:c542403f:33ab15bb:e5a7f122

    Update Time : Sat Mar 31 02:57:09 2012
       Checksum : 5024eb8 - correct
         Events : 31205

     Chunk Size : 64K

    Array Slot : 2 (0, failed, 2, 3, 4, failed, 6, 7, 5, failed,
failed, failed, failed, failed)
   Array State : u_Uuuuuu_____ 7 failed
/dev/sdo1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : fa32e2c5:e7bda20b:32af7c90:c7ee61eb
           Name : 1
  Creation Time : Sat Sep 18 17:05:52 2010
     Raid Level : raid6
   Raid Devices : 13

 Avail Dev Size : 3907026863 (1863.02 GiB 2000.40 GB)
     Array Size : 42977294976 (20493.17 GiB 22004.38 GB)
  Used Dev Size : 3907026816 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 6efe22ba:87cc1ffb:a070dbd0:b9020b5e

    Update Time : Sat Mar 31 02:57:09 2012
       Checksum : 4a0eee4e - correct
         Events : 31205

     Chunk Size : 64K

    Array Slot : 3 (0, failed, 2, 3, 4, failed, 6, 7, 5, failed,
failed, failed, failed, failed)
   Array State : u_uUuuuu_____ 7 failed
root@diamond:/#

and my mdadm.conf contains
ARRAY /dev/md1 level=3Draid6 num-devices=3D13 name=3D1
UUID=3Dfa32e2c5:e7bda20b:32af7c90:c7ee61eb

I'm confused as to why /dev/sdl1 says device or resource is busy..
Any ideas?
Thanks
-Bryan




On Wed, Mar 28, 2012 at 6:35 AM, Bryan Bush <bbushvt@gmail.com> wrote:
> Changing the number of devices to 12 worked!
> Thanks!
> -Bryan
>
> On Wed, Mar 28, 2012 at 4:26 AM, NeilBrown <neilb@suse.de> wrote:
>> On Wed, 28 Mar 2012 03:54:45 -0400 Bryan Bush <bbushvt@gmail.com> wr=
ote:
>>
>>> On Wed, Mar 28, 2012 at 12:18 AM, NeilBrown <neilb@suse.de> wrote:
>>> > On Tue, 27 Mar 2012 22:44:18 -0400 Bryan Bush <bbushvt@gmail.com>=
 wrote:
>>> >
>>> >> I hope this is the right place to ask this question. =A0I have a=
t 8
>>> >> drive RAID 6 array that I wanted to grow to 13 drives (adding 5 =
more).
>>> >> =A0I issued the mdadm command and checked /proc/mdstat and all l=
ooked
>>> >> well. =A0However at some point in time a disk failed and that hu=
ng my
>>> >> system. =A0Upon reboot the array is inactive and I can't get it =
to
>>> >> reassemble.
>>>
>>> > Hmmm... what do you have in /etc/mdadm.conf??
>>>
>>> root@diamond:~# cat /etc/mdadm/mdadm.conf
>>> # mdadm.conf
>>> #
>>> # Please refer to mdadm.conf(5) for information about this file.
>>> #
>>>
>>> # by default, scan all partitions (/proc/partitions) for MD superbl=
ocks.
>>> # alternatively, specify devices to scan, using wildcards if desire=
d.
>>> DEVICE partitions
>>>
>>> # auto-create devices with Debian standard permissions
>>> CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes
>>>
>>> # automatically tag new arrays as belonging to the local system
>>> HOMEHOST <system>
>>>
>>> # instruct the monitoring daemon where to send mail alerts
>>> MAILADDR root
>>>
>>> # definitions of existing MD arrays
>>>
>>> # This file was auto-generated on Fri, 14 Jan 2011 22:22:14 -0500
>>> # by mkconf $Id$
>>>
>>> ARRAY /dev/md1 level=3Draid6 num-devices=3D8 metadata=3D01.02 name=3D=
1
>>> UUID=3Dfa32e2c5:e7bda20b:32af7c90:c7ee61eb
>>
>> I think this array now has 13 devices, not 8. =A0You might want to f=
ix that.
>> If you do, it might all magically start working.
>>
>> (also get rid of the metadata=3D or make it metadata=3D1.2)
>>
>> Or just get rid of the num-devices=3D bit.
>>
>>> ARRAY /dev/md0 level=3Draid5 num-devices=3D4 metadata=3D00.90
>>> UUID=3D989c3b8b:bd60d243:683690d9:73a11dfa
>>>
>>> root@diamond:~#
>>>
>>> >
>>> > Though if the names have changed at all it would be safer to do
>>> >
>>> > =A0mdadm -Asf /dev/md1 -u fa32e2c5:e7bda20b:32af7c90:c7ee61eb
>>> >
>>>
>>> root@diamond:~# mdadm -Asf /dev/md1 -u fa32e2c5:e7bda20b:32af7c90:c=
7ee61eb
>>> mdadm: metadata format 01.02 unknown, ignored.
>>> mdadm: metadata format 00.90 unknown, ignored.
>>> mdadm: no devices found for /dev/md1
>>
>> Odd. =A0I the above change to mdadm.conf doesn't help, try rerunning=
 this
>> command with --verbose and report the result.
>>
>> NeilBrown
>>
>>
>>> root@diamond:~#
>>>
>>> Didn't seem to help.
>>> Any other ideas?
>>> Thanks
>>> -Bryan
>>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
