From: tyranastrasz@gmx.de
Subject: Re: Restoring a raid0 for data rescue
Date: Sun, 2 Aug 2020 22:38:02 +0200
Message-ID: <057b0c58-3876-0f03-af33-86f3b266a18a@gmx.de>
References: <S1726630AbgHBR6v/20200802175851Z+2001@vger.kernel.org>
 <68c39e83-1155-0c8d-96a9-0418bdaf850d@gmx.de>
 <7437ab4d-9cd1-fe53-a17a-fc9e966ccd92@youngman.org.uk>
 <d8f9d16d-b6a2-77ba-bff2-a56c62dac5df@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d8f9d16d-b6a2-77ba-bff2-a56c62dac5df@gmx.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: antlists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02.08.20 21:24, tyranastrasz@gmx.de wrote:
> On 02.08.20 21:01, antlists wrote:
>> On 02/08/2020 19:09, tyranastrasz@gmx.de wrote:
>>> Hello
>>>
>>> I've a problem with my raid0.
>>> The probelmatic disks (2x 1TB wdred) were in usage in my server, now
>>> they got replaced with 3x 4TB seagate in a raid5.
>>>
>>> Before I turned them off, I made a backup on an external drive (normal
>>> hdd via USB) via rsync -avx /source /mnt/external/
>>>
>>> Whatever happens in the night, the backup isn't complete and I miss
>>> files.
>>> So I put the old raid again into the server and wanted to start, but t=
he
>>> Intel Raid Controller said that one of the disks are no member of a
>>> raid.
>>>
>>> My server mainboard is from Gigabyte a MX11-PC0.
>>>
>>> Well I made some mdadm examines, smartctl, mdstat, lsdrv logfiles and
>>> attached them to the mail.
>>>
>> Ow...
>>
>> This is still the same linux on the server? Because mdstat says no raid
>> personalities are installed. Either linux has changed or you've got
>> hardware raid. in which case you'll need to read up on the motherboard
>> manual.
>>
>> I'm not sure what they're called, but try "insmod raid1x" I think it is=
.
>> Could be raid0x. If that loads the raid0 driver, cat /proc/mdstat shoul=
d
>> list raid0 as a personality. Once that's there, mdadm may be able to
>> start the array.
>>
>> Until you've got a working raid driver in the kernel, I certainly can't
>> help any further. But hopefully reading the mobo manual might help. The
>> other thing to try is an up-to-date rescue disk and see if that can rea=
d
>> the array.
>>
>> Cheers,
>> Wol
>
> No, I have the disks in my pc.
> The server can't boot the disks because Intel Storage says the raid has
> a failure, because one of the disks has no raid information. But as I
> read them both yesterday they had, now (see the last attachment) one of
> them has none.
> It makes no sense... I need the files
>
> Intel means "yeah make a new raid, with data loss" that's no option.
>
> Nara


I tried something what was told here
https://askubuntu.com/questions/69086/mdadm-superblock-recovery

root@Nibler:~# mdadm --create /dev/md0 -v -f -l 0 -c 128 -n 2 /dev/sdd
/dev/sdb
mdadm: /dev/sdd appears to be part of a raid array:
        level=3Dcontainer devices=3D0 ctime=3DThu Jan  1 01:00:00 1970
mdadm: partition table exists on /dev/sdb
mdadm: partition table exists on /dev/sdb but will be lost or
        meaningless after creating array
Continue creating array? yes
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.


root@Nibler:~# mdadm --examine /dev/sdb
/dev/sdb:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : db01d7d9:e46ce30a:792e1d3a:31618e71
            Name : Nibler:0  (local to host Nibler)
   Creation Time : Sun Aug  2 22:13:10 2020
      Raid Level : raid0
    Raid Devices : 2

  Avail Dev Size : 1953260976 (931.39 GiB 1000.07 GB)
     Data Offset : 264192 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D264112 sectors, after=3D0 sectors
           State : clean
     Device UUID : 0ea95638:7e83e76b:848ff6d2:e264029b

     Update Time : Sun Aug  2 22:13:10 2020
   Bad Block Log : 512 entries available at offset 8 sectors
        Checksum : 1b2cf600 - correct
          Events : 0

      Chunk Size : 128K

    Device Role : Active device 1
    Array State : AA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D re=
placing)
root@Nibler:~# mdadm --examine /dev/sdd
/dev/sdd:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : db01d7d9:e46ce30a:792e1d3a:31618e71
            Name : Nibler:0  (local to host Nibler)
   Creation Time : Sun Aug  2 22:13:10 2020
      Raid Level : raid0
    Raid Devices : 2

  Avail Dev Size : 1953260976 (931.39 GiB 1000.07 GB)
     Data Offset : 264192 sectors
    Super Offset : 8 sectors
    Unused Space : before=3D264112 sectors, after=3D0 sectors
           State : clean
     Device UUID : cef9d210:a794ef1e:6e37ee0e:34e10c52

     Update Time : Sun Aug  2 22:13:10 2020
   Bad Block Log : 512 entries available at offset 8 sectors
        Checksum : 99b37c22 - correct
          Events : 0

      Chunk Size : 128K

    Device Role : Active device 0
    Array State : AA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D re=
placing)


But I have no access to /dev/md0 or /dev/md0p1 or /dev/md0p2

root@Nibler:~# mount -o ro /dev/md0p1 /mnt/raid
NTFS signature is missing.
Failed to mount '/dev/md0p1': Invalid argument
The device '/dev/md0p1' doesn't seem to have a valid NTFS.
Maybe the wrong device is used? Or the whole disk instead of a
partition (e.g. /dev/sda, not /dev/sda1)? Or the other way around?


What can I do now?
Even if it costs money...

Nara
