From: Matthew Tice <mjtice@gmail.com>
Subject: Re: Problems with raid after reboot.
Date: Mon, 25 Jul 2011 15:30:32 -0600
Message-ID: <CA+taBv8+KZguxmSTe7huntdMrnvANK3VRJKLpwZjXbymJ36-Ag@mail.gmail.com>
References: <CA+taBv-V7HasgHFFaLV+Ppbgv=b-6CvLLkGHh3oN+GAO0wFHxA@mail.gmail.com>
	<CA+taBv-3OxS52vLgOJiruqAnnOh8nsKtTFsPa20X1DEODdVSYA@mail.gmail.com>
	<CA+taBv_yfW_njVX4r7fpAT105fvBeVMBLbU4M+6tTDY7R1yndA@mail.gmail.com>
	<20110725212107.GA6422@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110725212107.GA6422@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jul 25, 2011 at 3:21 PM, Robin Hill <robin@robinhill.me.uk> wro=
te:
> On Mon Jul 25, 2011 at 03:04:34PM -0600, Matthew Tice wrote:
>
>> Well things are a lot different now - I'm unable to start the array
>> successfully. =C2=A0I removed an older non-relevant drive that was g=
iving
>> me smart errors - when I rebooted the drive assignments shifted (not
>> sure this really matters, though).
>>
>> Now when I try to start the array I get:
>>
>> # mdadm -A -f /dev/md0
>> mdadm: no devices found for /dev/md0
>>
>> I can nudge it slightly with auto-detect:
>>
>> # mdadm --auto-detect
>>
>> Then I try to assemble the array with:
>>
>> # mdadm -A -f /dev/md0 /dev/sd[bcde]
>> mdadm: cannot open device /dev/sde: Device or resource busy
>> mdadm: /dev/sde has no superblock - assembly aborted
>>
> <- SNIP ->
>> =C2=A0=E2=94=82 =C2=A0=E2=94=94=E2=94=80sde: [8:64] MD raid5 (none/4=
) 931.51g md_d0 inactive spare
> <- SNIP ->
>>
>> I've looked but I'm unable to find where the drive is in use.
>
> lsdrv shows that it's in use in array md_d0 - presumably this is a
> part-assembled array (possibly auto-assembled by the kernel). Try
> stopping that first, then doing the "mdadm -A -f /dev/md0 /dev/sd[bcd=
e]"
>

Nice catch, thanks, Robin.

I stopped /dev/md_d0 then started the array on /dev/md0

# mdadm -A -f /dev/md0 /dev/sd[bcde]
mdadm: /dev/md0 has been started with 3 drives (out of 4).

It's only seeing the three drives.  I did an fsck on it just in case
but it failed:

# fsck -n /dev/md0
fsck from util-linux-ng 2.17.2
e2fsck 1.41.12 (17-May-2010)
Superblock has an invalid journal (inode 8).
Clear? no

fsck.ext4: Illegal inode number while checking ext3 journal for /dev/md=
0

Looks like /dev/sde is missing (as also noted above):

# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90
  Creation Time : Sat Mar 12 21:22:34 2011
     Raid Level : raid5
     Array Size : 2197723392 (2095.91 GiB 2250.47 GB)
  Used Dev Size : 732574464 (698.64 GiB 750.16 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Jul 25 14:08:30 2011
          State : clean, degraded
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : daf06d5a:b80528b1:2e29483d:f114274d (local to host st=
orage)
         Events : 0.5593

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       48        1      active sync   /dev/sdd
       2       8       32        2      active sync   /dev/sdc
       3       8       16        3      active sync   /dev/sdb
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
