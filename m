From: xar <xar@retard.io>
Subject: Re: RAID 6 (containing LUKS dm-crypt) recovery help.
Date: Fri, 07 Nov 2014 06:40:24 -0500
Message-ID: <545CAFA8.2030602@retard.io>
References: <545C5C9D.9000309@retard.io> <21596.40429.244605.398712@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21596.40429.244605.398712@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.UK>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/7/2014 5:24 AM, Peter Grandi wrote:
>> [ ... ] The server experienced some sort of hardware event
>> that resulted in a mandatory restart of the server.
> Details would be helpful: because if some problem happens the
> standard advice is "reload from backups". If you want to
> shortcut that to mostly-recovery context matters to figuring out
> how and how safely.
>
>> [ ... ] completed the restart, the array looked like this,
>> "all spares":
>> md6 :
> What happened to the other MD sets on the same server, if any?
> Any damage? Because if those suffered no damage, there is the
> possibility that the disk rack backplane holding the members of
> 'md6' got damaged, or the specific host adapter; and that the MD
> set content is entirely undamaged and the funny stuff being read
> is a transmission problem.
>
>> inactive sdl1[7](S) sdh1[13](S) sdg1[14](S) sdk1[11](S)
>> sdj1[10](S) sdi1[6](S) sdd1[2](S) sdf1[8](S) sdb1[12](S)
>> sde1[3](S) sdc1[15](S) 21488638704 blocks super 1.2
> "Clever" people hide details as possible, and go to such lengths
> as to actually remove vital information as for example what
> literally follows "super 1.2" here. Because actual quotes are
> too "insipid" and paraphrases are more "challenging":
>
>> The mdadm array has the following characteristics: RAID level:
>> 6 Chunk size: 256k Version: 1.2 Number of devices: 11
> How do you know? Is this part of your records or from actual
> output of 'mdadm --examine'?
>
> But assuming the above is somewhat reliable there is an
> "interesting" situation: in "21488638704 blocks" the number
> 21,488,638,704 is not a whole multiple of 9:
>
>    $ factor 21488638704
>    21488638704: 2 2 2 2 3 13 1801 19121
>
>> All attempts to assemble the array continued to result in the "all
>> spare" condition (output above). Thinking that the metadata had been
>> corrupted somehow,
> Apparently without ever trying 'mdadm --detail /dev/md6' or
> 'mdadm --examine /dev/sd...' as per:
>
>    https://raid.wiki.kernel.org/index.php/RAID_Recovery
>
>> I set out to recreate the array.
> Quite "brave":
>
>    https://raid.wiki.kernel.org/index.php/RAID_Recovery
>    =ABRestore array by recreating (after multiple device failure)
>    Recreating should be considered a *last* resort, only to be
>    used when everything else fails.
>    People getting this wrong is one of the primary reasons people
>    lose data. It is very commonly used way too early in the fault
>    finding process. You have been warned!=BB
>
>> The following is the dev_number fields from the metadata,
>> before I attempted to recreate the array: for i in /dev/sd?1;
>> do echo -n $i '' ; dd 2> /dev/null if=3D$i bs=3D1 count=3D4
>> skip=3D4256 | od -D | head -n1; done: I used the following to
>> extract the index position of each device on a device I
>> suspected wasn't corrupted (for the record, they all returned
>> the same data): [ ... ]
> It is very "astute" indeed to use 'dd' instead of 'mdadm
> --examine'.  For example it "encourages" people who might want
> to help to spend some extra time checking your offsets, that
> "teaches" them.
>
> [ ... ]
>>       Number   Major   Minor   RaidDevice State
>>         12       8       17        0      active sync   /dev/sdb1
>>          3       8       65        1      active sync   /dev/sde1
>>          2       8       49        2      active sync   /dev/sdd1
>>          8       8       81        3      active sync   /dev/sdf1
>>          6       8      129        4      active sync   /dev/sdi1
>>          7       8      177        5      active sync   /dev/sdl1
>>          6       0        0        6      removed
>>         10       8      145        7      active sync   /dev/sdj1
>>         11       8      161        8      active sync   /dev/sdk1
>>         13       8      113        9      active sync   /dev/sdh1
>>         14       8       97       10      active sync   /dev/sdg1
>> The dev_numbers and index position information in conjunction
>> with the historic data (directly above) seemed to indicate
>> that the proper recreation order and command would be the
>> following:
>> mdadm --create /dev/md6 --assume-clean --level=3D6
>> --raid-devices=3D11 --metadata=3D1.2 --chunk=3D256 /dev/sdb1
>> /dev/sde1 /dev/sdd1 /dev/sdf1 /dev/sdi1 /dev/sdl1 /dev/sdc1
>> /dev/sdj1 /dev/sdk1 /dev/sdh1 /dev/sdg1
> The main consequence of the above is that the original MD member
> metadata blocks are no longer available unless something like
> this has been done:
>
>    https://raid.wiki.kernel.org/index.php/RAID_Recovery
>    =ABPreserving RAID superblock information
>    One of the most useful things to do first, when trying to
>    recover a broken RAID array, is to preserve the information
>    reported in the RAID superblocks on each device at the time
>    the array went down (and before you start trying to recreate
>    the array). Something like
>      mdadm --examine /dev/sd[bcdefghijklmn]1 >> raid.status=BB
>
> If you went to the lengths to write 'dd' expressions, you might
> as well have saved the output of '--examine'. Perhaps you did,
> but if you did not attach that output to your request for help
> it would be rather "stunning".
>
> [ ... ]
>
>> Is the "mdadm --create" operation that I issued, incorrect?
>> Have I done anything in error?
> There is something strange: what you report being the output of
> '--detail' from July:
>
>        Array Size : 17581609728 (16767.13 GiB 18003.57 GB)
>     Used Dev Size : 1953512192 (1863.01 GiB 2000.40 GB)
>
> and the output of '--detail' for the re-created:
>
>        Array Size : 17580439296 (16766.01 GiB 18002.37 GB)
>     Used Dev Size : 1953382144 (1862.89 GiB 2000.26 GB)
>
> Both numbers don't match. They are *slightly* different. In
> particular it is rather strange that the "Used Dev Size" is
> different. How is that possible? Have the disks shrunk a little
> in the meantime? :-)
>
> It is intriguing that the difference between 1953512192 and
> 1953382144 is 1024*127KiB or 1024*254 sectors.
>
> Also I have noticed that the MD set is composed of disk of 3
> different models (ST2000DL003-9VT1, ST2000DM001-1CH1,
> ST32000542AS)...
>
>> Is my data gone? Any and all insight are extremly welcomed and
>> appreciated.
> Whether your data is gone depends on what kind of hardware issue
> you have had, and to the consequence of the "brave" '--create'
> above. But also how the MD set was setup, e.g. with members of
> slightly different sizes. The inconsistencies in the reported
> numbers are "confusing".
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hello Peter,

Thank you very much for your thorough and responsive reply. I will do m=
y=20
best to clarify where possible.

> [ ... ] The server experienced some sort of hardware event
> that resulted in a mandatory restart of the server.
> Details would be helpful: because if some problem happens the
> standard advice is "reload from backups". If you want to
> shortcut that to mostly-recovery context matters to figuring out
> how and how safely.

Regarding the nature of the hardware event, unfortunately details are i=
n=20
short supply: the server became unresponsive over the console when=20
attempting to connect via SSH, prompting a restart of the server.  I=20
don't believe there was evidence of a power drop or loss. No server or=20
kernel logs are available for review.

> [ ... ] completed the restart, the array looked like this,
> "all spares":
>> md6 :
> What happened to the other MD sets on the same server, if any?
> Any damage? Because if those suffered no damage, there is the
> possibility that the disk rack backplane holding the members of
> 'md6' got damaged, or the specific host adapter; and that the MD
> set content is entirely undamaged and the funny stuff being read
> is a transmission problem.

"md6" is the only MD set on the server, so name as it is has a=20
raid-level 6. Sorry for any confusion.

> The mdadm array has the following characteristics: RAID level:
> 6 Chunk size: 256k Version: 1.2 Number of devices: 11
> How do you know? Is this part of your records or from actual
> output of 'mdadm --examine'?
> All attempts to assemble the array continued to result in the "all
> spare" condition (output above). Thinking that the metadata had been
> corrupted somehow,
> Apparently without ever trying 'mdadm --detail /dev/md6' or
> 'mdadm --examine /dev/sd...' as per:
> If you went to the lengths to write 'dd' expressions, you might
> as well have saved the output of '--examine'. Perhaps you did,
> but if you did not attach that output to your request for help
> it would be rather "stunning".

Yes, I saved the -E/--examine information, "just in case". :-)

Before performing a re-create of the array, I did, in fact, print the=20
contents (-E, --examine) of the metadata stored on each device:

# cat mdadm.e.bak

/dev/sdb1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 6958450b:e4dfa2f3:259ff733:f343a584
            Name : server:6  (local to host server)
   Creation Time : Sat Apr 23 06:22:23 2011
      Raid Level : raid6
    Raid Devices : 11

  Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
      Array Size : 17581609728 (16767.13 GiB 18003.57 GB)
   Used Dev Size : 3907024384 (1863.01 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 12a56302:5b436263:1b841be2:fccd07ed

     Update Time : Fri Nov  7 00:37:26 2014
        Checksum : d7063845 - correct
          Events : 667126

          Layout : left-symmetric
      Chunk Size : 256K

    Device Role : Active device 0
    Array State : A.A.AA.AAA. ('A' =3D=3D active, '.' =3D=3D missing)

/dev/sdc1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 6958450b:e4dfa2f3:259ff733:f343a584
            Name : server:6  (local to host server)
   Creation Time : Sat Apr 23 06:22:23 2011
      Raid Level : raid6
    Raid Devices : 11

  Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
      Array Size : 17581609728 (16767.13 GiB 18003.57 GB)
   Used Dev Size : 3907024384 (1863.01 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 0416e499:16488db2:5473119d:1a0c8141

     Update Time : Sun Nov  2 12:24:42 2014
        Checksum : cd22e98b - correct
          Events : 667122

          Layout : left-symmetric
      Chunk Size : 256K

    Device Role : Active device 6
    Array State : A.A.AAAAAA. ('A' =3D=3D active, '.' =3D=3D missing)

/dev/sdd1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 6958450b:e4dfa2f3:259ff733:f343a584
            Name : server:6  (local to host server)
   Creation Time : Sat Apr 23 06:22:23 2011
      Raid Level : raid6
    Raid Devices : 11

  Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
      Array Size : 17581609728 (16767.13 GiB 18003.57 GB)
   Used Dev Size : 3907024384 (1863.01 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 56f35811:d62afc50:a893a3af:10f01367

     Update Time : Fri Nov  7 00:37:26 2014
        Checksum : 1b299f9b - correct
          Events : 667126

          Layout : left-symmetric
      Chunk Size : 256K

    Device Role : Active device 2
    Array State : A.A.AA.AAA. ('A' =3D=3D active, '.' =3D=3D missing)

/dev/sde1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 6958450b:e4dfa2f3:259ff733:f343a584
            Name : server:6  (local to host server)
   Creation Time : Sat Apr 23 06:22:23 2011
      Raid Level : raid6
    Raid Devices : 11

  Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
      Array Size : 17581609728 (16767.13 GiB 18003.57 GB)
   Used Dev Size : 3907024384 (1863.01 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 63f4d908:16f38b7f:ebd9a1d7:0f186e56

     Update Time : Sun Nov  2 10:23:32 2014
        Checksum : 5896c904 - correct
          Events : 667118

          Layout : left-symmetric
      Chunk Size : 256K

    Device Role : Active device 1
    Array State : AAAAAAAAAA. ('A' =3D=3D active, '.' =3D=3D missing)

/dev/sdf1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 6958450b:e4dfa2f3:259ff733:f343a584
            Name : server:6  (local to host server)
   Creation Time : Sat Apr 23 06:22:23 2011
      Raid Level : raid6
    Raid Devices : 11

  Avail Dev Size : 3907026672 (1863.02 GiB 2000.40 GB)
      Array Size : 17581609728 (16767.13 GiB 18003.57 GB)
   Used Dev Size : 3907024384 (1863.01 GiB 2000.40 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : ee4ac68b:2152463c:b0d72a12:4da24489

     Update Time : Sun Nov  2 10:23:32 2014
        Checksum : 59d06a2 - correct
          Events : 667118

          Layout : left-symmetric
      Chunk Size : 256K

    Device Role : Active device 3
    Array State : AAAAAAAAAA. ('A' =3D=3D active, '.' =3D=3D missing)

/dev/sdg1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 6958450b:e4dfa2f3:259ff733:f343a584
            Name : server:6  (local to host server)
   Creation Time : Sat Apr 23 06:22:23 2011
      Raid Level : raid6
    Raid Devices : 11

  Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
      Array Size : 17581609728 (16767.13 GiB 18003.57 GB)
   Used Dev Size : 3907024384 (1863.01 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 72ee0230:51b42c7a:3327c930:302be14e

     Update Time : Sun Nov  2 08:35:01 2014
        Checksum : cbfacb4a - correct
          Events : 667100

          Layout : left-symmetric
      Chunk Size : 256K

    Device Role : Active device 10
    Array State : .AAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)

/dev/sdh1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 6958450b:e4dfa2f3:259ff733:f343a584
            Name : server:6  (local to host server)
   Creation Time : Sat Apr 23 06:22:23 2011
      Raid Level : raid6
    Raid Devices : 11

  Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
      Array Size : 17581609728 (16767.13 GiB 18003.57 GB)
   Used Dev Size : 3907024384 (1863.01 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 429cfff7:ecadc967:40f73261:bef9656e

     Update Time : Fri Nov  7 00:37:26 2014
        Checksum : d17f38ee - correct
          Events : 667126

          Layout : left-symmetric
      Chunk Size : 256K

    Device Role : Active device 9
    Array State : A.A.AA.AAA. ('A' =3D=3D active, '.' =3D=3D missing)

/dev/sdi1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 6958450b:e4dfa2f3:259ff733:f343a584
            Name : server:6  (local to host server)
   Creation Time : Sat Apr 23 06:22:23 2011
      Raid Level : raid6
    Raid Devices : 11

  Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
      Array Size : 17581609728 (16767.13 GiB 18003.57 GB)
   Used Dev Size : 3907024384 (1863.01 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 6dea792a:f1117c0c:ac16951c:a8b61783

     Update Time : Fri Nov  7 00:37:26 2014
        Checksum : 78bfc76c - correct
          Events : 667126

          Layout : left-symmetric
      Chunk Size : 256K

    Device Role : Active device 4
    Array State : A.A.AA.AAA. ('A' =3D=3D active, '.' =3D=3D missing)

/dev/sdj1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 6958450b:e4dfa2f3:259ff733:f343a584
            Name : server:6  (local to host server)
   Creation Time : Sat Apr 23 06:22:23 2011
      Raid Level : raid6
    Raid Devices : 11

  Avail Dev Size : 3907026672 (1863.02 GiB 2000.40 GB)
      Array Size : 17581609728 (16767.13 GiB 18003.57 GB)
   Used Dev Size : 3907024384 (1863.01 GiB 2000.40 GB)
     Data Offset : 272 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 4b37d852:2236e8e6:15c52c77:4214f7de

     Update Time : Fri Nov  7 00:37:26 2014
        Checksum : 32014484 - correct
          Events : 667126

          Layout : left-symmetric
      Chunk Size : 256K

    Device Role : Active device 7
    Array State : A.A.AA.AAA. ('A' =3D=3D active, '.' =3D=3D missing)

/dev/sdk1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 6958450b:e4dfa2f3:259ff733:f343a584
            Name : server:6  (local to host server)
   Creation Time : Sat Apr 23 06:22:23 2011
      Raid Level : raid6
    Raid Devices : 11

  Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
      Array Size : 17581609728 (16767.13 GiB 18003.57 GB)
   Used Dev Size : 3907024384 (1863.01 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : aa149905:9cd207c4:4bb4c244:3f502348

     Update Time : Fri Nov  7 00:37:26 2014
        Checksum : f8a3e98f - correct
          Events : 667126

          Layout : left-symmetric
      Chunk Size : 256K

    Device Role : Active device 8
    Array State : A.A.AA.AAA. ('A' =3D=3D active, '.' =3D=3D missing)

/dev/sdl1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 6958450b:e4dfa2f3:259ff733:f343a584
            Name : server:6  (local to host server)
   Creation Time : Sat Apr 23 06:22:23 2011
      Raid Level : raid6
    Raid Devices : 11

  Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
      Array Size : 17581609728 (16767.13 GiB 18003.57 GB)
   Used Dev Size : 3907024384 (1863.01 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 59a2393b:27209cc2:1f6fa576:5ed6e2a7

     Update Time : Fri Nov  7 00:37:26 2014
        Checksum : be7b7d99 - correct
          Events : 667126

          Layout : left-symmetric
      Chunk Size : 256K

    Device Role : Active device 5
    Array State : A.A.AA.AAA. ('A' =3D=3D active, '.' =3D=3D missing)

> There is something strange: what you report being the output of
> '--detail' from July:
>
>        Array Size : 17581609728 (16767.13 GiB 18003.57 GB)
>     Used Dev Size : 1953512192 (1863.01 GiB 2000.40 GB)
>
> and the output of '--detail' for the re-created:
>
>        Array Size : 17580439296 (16766.01 GiB 18002.37 GB)
>     Used Dev Size : 1953382144 (1862.89 GiB 2000.26 GB)
>
> Both numbers don't match. They are*slightly*  different. In
> particular it is rather strange that the "Used Dev Size" is
> different. How is that possible? Have the disks shrunk a little
> in the meantime?

Peter, that is an excellent observation! Indeed, the above -E/--examine=
=20
data confirms that some disks have a 272 offset, while most others have=
=20
a 2048 offset, for example:

/dev/sdj1:
Data Offset : 272 sectors
Super Offset : 8 sectors

/dev/sdk1:
Data Offset: 2048 sectors
Super Offset: 8 sectors

The current breakdown:

# grep "272 sectors" mdadm.e.bak | wc -l
2

# grep "2048 sectors" mdadm.e.bak | wc -l
9

Therefore, based on the backup -E/--examine data, two out of the 11=20
total disks have an offset of 272, while the remaining nine are using 2=
048.

Could this explain the discrepancy you observed?

=46or the record, every disk is GUID GPT partitioned, with the same sec=
tor=20
size for all partitions. All partitions are identical in sector size,=20
regardless of the Seagate HDD disk model.

Here is a sample of the partition data:

# parted /dev/sdb unit s print | grep -A1 Number
Number  Start  End          Size         File system  Name     Flags
  1      2048s  3907028991s  3907026944s               primary  raid

# parted /dev/sdc unit s print | grep -A1 Number
Number  Start  End          Size         File system  Name     Flags
  1      2048s  3907028991s  3907026944s               primary  raid

# parted /dev/sdd unit s print | grep -A1 Number
Number  Start  End          Size         File system  Name     Flags
  1      2048s  3907028991s  3907026944s               primary  raid

# parted /dev/sde unit s print | grep -A1 Number
Number  Start  End          Size         File system  Name     Flags
  1      2048s  3907028991s  3907026944s               primary  raid

# parted /dev/sdf unit s print | grep -A1 Number
Number  Start  End          Size         File system  Name     Flags
  1      2048s  3907028991s  3907026944s               primary  raid

# parted /dev/sdg unit s print | grep -A1 Number
Number  Start  End          Size         File system  Name     Flags
  1      2048s  3907028991s  3907026944s               primary  raid

# parted /dev/sdh unit s print | grep -A1 Number
Number  Start  End          Size         File system  Name     Flags
  1      2048s  3907028991s  3907026944s  ntfs         primary  raid

# parted /dev/sdi unit s print | grep -A1 Number
Number  Start  End          Size         File system  Name     Flags
  1      2048s  3907028991s  3907026944s               primary  raid

# parted /dev/sdj unit s print | grep -A1 Number
Number  Start  End          Size         File system  Name     Flags
  1      2048s  3907028991s  3907026944s               primary  raid

# parted /dev/sdk unit s print | grep -A1 Number
Number  Start  End          Size         File system  Name     Flags
  1      2048s  3907028991s  3907026944s               primary  raid

# parted /dev/sdl unit s print | grep -A1 Number
Number  Start  End          Size         File system  Name     Flags
  1      2048s  3907028991s  3907026944s               primary  raid

My only explanation is that the cause of this offset discrepancy may=20
have something to do with the age of the array.  The array had an=20
original creation time of year 2011.

This server was originally running Ubuntu 10.04 LTS (I believe) before=20
being eventually upgraded to 12.04 LTS--although the server has been=20
running healthy on 12.04 LTS for several years without issue(s).

If memory serves, the older version of mdadm that shipped with 10.04 LT=
S=20
did a myriad of things differently regarding the location of the=20
superblock(s), offset(s), etc. but I can't say for sure. Did older mdad=
m=20
builds on 12.04 LTS ever use offsets of 272, rather than 2048?

Perhaps Neil could comment? :-)

I do hope that supplying the -E/--examine information will be useful to=
=20
you all. What's the next step?

Thank you for all your efforts and for your keen eyes.

-xar
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
