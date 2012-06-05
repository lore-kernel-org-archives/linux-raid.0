From: freeone3000 <freeone3000@gmail.com>
Subject: Re: Data Offset
Date: Tue, 5 Jun 2012 00:26:20 -0500
Message-ID: <CAFhY2CjQAutSxzJ-7e+G-1Jw-U6JsFjBBHOmiqOxkhkZy6kd9g@mail.gmail.com>
References: <CAFhY2CjOECFy4bWDL6zs9rtSkVGPR9Wv=1UX9vKgmdjwMsmBYg@mail.gmail.com>
 <20120602095237.3822e2c2@notabene.brown> <CAFhY2Cjwep5mZkYCfRn4UYmQpSyHU13dSCB8HF8F9wG8Rzx9Aw@mail.gmail.com>
 <20120604133526.6da3bf10@notabene.brown> <4FCCFDBB.201@pierre-beck.de> <20120605085728.7e922359@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120605085728.7e922359@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Pierre Beck <mail@pierre-beck.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Swapped out the new drive for the old. The new drive is still labelled
as /dev/sdf, hopefully.. I decided to check times before proceeding,
and to make sure the drives were in the right order. I corrected them
to go by `mdadm --examine`'s output as best I could.

Here's the output of `mdadm --examine /dev/sdf` and the result of
executing the given `./mdadm` command (with re-ordered drives), The
binary compiled from git sources crashed with a segmentation fault
while attempting to print out a failure writing the superblock. I've
tried the drives (with proper sizes) in other combinations, according
to both what you posted and what mdadm --examine says the "Device
Role" is. I haven't found a working combination; is it possible my
drives got swapped around on reboot? There's a re-run of mdadm
--examine at the end of my post.

root@leyline:~/mdadm# mdadm --examine /dev/sdf
/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 9759ad94:75e30b6b:8a726b4d:177a6eda
           Name : leyline:1  (local to host leyline)
  Creation Time : Mon Sep 12 13:19:00 2011
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
     Array Size : 7813048320 (7451.10 GiB 8000.56 GB)
  Used Dev Size : 3906524160 (1862.78 GiB 2000.14 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 2edc16c6:cf45ad32:04b026a4:956ce78b

    Update Time : Fri Jun  1 03:11:54 2012
       Checksum : b3e49e59 - correct
         Events : 2127454

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAA. ('A' =3D=3D active, '.' =3D=3D missing)
root@leyline:~/mdadm# ./mdadm -C /dev/md1 -e 1.2 -l 5 -n 5
--assume-clean -c 512 /dev/sdc3:2048s /dev/sdf:2048s /dev/sdb3:2048s
/dev/sdd3:2048s /dev/sde3:1024s
mdadm: /dev/sdc3 appears to be part of a raid array:
    level=3Draid5 devices=3D5 ctime=3DTue Jun  5 00:10:46 2012
mdadm: /dev/sdf appears to contain an ext2fs file system
    size=3D242788K  mtime=3DFri Oct  7 16:55:40 2011
mdadm: /dev/sdf appears to be part of a raid array:
    level=3Draid5 devices=3D5 ctime=3DMon Sep 12 13:19:00 2011
mdadm: /dev/sdb3 appears to be part of a raid array:
    level=3Draid5 devices=3D5 ctime=3DTue Jun  5 00:10:46 2012
mdadm: /dev/sdd3 appears to be part of a raid array:
    level=3Draid5 devices=3D5 ctime=3DTue Jun  5 00:10:46 2012
Continue creating array? yes
Segmentation fault

Since I couldn't find any fault with running it again (but I am not a
smart man, or I would not be in this position), I decided to run
valgrind over it:
=3D=3D3206=3D=3D Memcheck, a memory error detector
=3D=3D3206=3D=3D Copyright (C) 2002-2010, and GNU GPL'd, by Julian Sewa=
rd et al.
=3D=3D3206=3D=3D Using Valgrind-3.6.0.SVN-Debian and LibVEX; rerun with=
 -h for
copyright info
=3D=3D3206=3D=3D Command: ./mdadm -C /dev/md1 -e 1.2 -l 5 -n 5 --assume=
-clean
-c 512 /dev/sdc3:2048s /dev/sdf:2048s /dev/sdb3:2048s /dev/sdd3:2048s
/dev/sde3:1024s
=3D=3D3206=3D=3D
=3D=3D3206=3D=3D Warning: noted but unhandled ioctl 0x1261 with no size=
/direction hints
=3D=3D3206=3D=3D    This could cause spurious value errors to appear.
=3D=3D3206=3D=3D    See README_MISSING_SYSCALL_OR_IOCTL for guidance on
writing a proper wrapper.
=3D=3D3206=3D=3D Warning: noted but unhandled ioctl 0x1261 with no size=
/direction hints
=3D=3D3206=3D=3D    This could cause spurious value errors to appear.
=3D=3D3206=3D=3D    See README_MISSING_SYSCALL_OR_IOCTL for guidance on
writing a proper wrapper.
=3D=3D3206=3D=3D Warning: noted but unhandled ioctl 0x1261 with no size=
/direction hints
=3D=3D3206=3D=3D    This could cause spurious value errors to appear.
=3D=3D3206=3D=3D    See README_MISSING_SYSCALL_OR_IOCTL for guidance on
writing a proper wrapper.
mdadm: /dev/sdc3 appears to be part of a raid array:
    level=3Draid5 devices=3D5 ctime=3DTue Jun  5 00:14:20 2012
mdadm: /dev/sdf appears to contain an ext2fs file system
    size=3D242788K  mtime=3DFri Oct  7 16:55:40 2011
mdadm: /dev/sdf appears to be part of a raid array:
    level=3Draid5 devices=3D5 ctime=3DTue Jun  5 00:14:20 2012
mdadm: /dev/sdb3 appears to be part of a raid array:
    level=3Draid5 devices=3D5 ctime=3DTue Jun  5 00:14:20 2012
mdadm: /dev/sdd3 appears to be part of a raid array:
    level=3Draid5 devices=3D5 ctime=3DTue Jun  5 00:14:20 2012
Continue creating array? =3D=3D3206=3D=3D Invalid read of size 8
=3D=3D3206=3D=3D    at 0x43C9B7: write_init_super1 (super1.c:1327)
=3D=3D3206=3D=3D    by 0x41F1B9: Create (Create.c:951)
=3D=3D3206=3D=3D    by 0x407231: main (mdadm.c:1464)
=3D=3D3206=3D=3D  Address 0x8 is not stack'd, malloc'd or (recently) fr=
ee'd
=3D=3D3206=3D=3D
=3D=3D3206=3D=3D
=3D=3D3206=3D=3D Process terminating with default action of signal 11 (=
SIGSEGV)
=3D=3D3206=3D=3D  Access not within mapped region at address 0x8
=3D=3D3206=3D=3D    at 0x43C9B7: write_init_super1 (super1.c:1327)
=3D=3D3206=3D=3D    by 0x41F1B9: Create (Create.c:951)
=3D=3D3206=3D=3D    by 0x407231: main (mdadm.c:1464)
=3D=3D3206=3D=3D  If you believe this happened as a result of a stack
=3D=3D3206=3D=3D  overflow in your program's main thread (unlikely but
=3D=3D3206=3D=3D  possible), you can try to increase the size of the
=3D=3D3206=3D=3D  main thread stack using the --main-stacksize=3D flag.
=3D=3D3206=3D=3D  The main thread stack size used in this run was 83886=
08.
=3D=3D3206=3D=3D
=3D=3D3206=3D=3D HEAP SUMMARY:
=3D=3D3206=3D=3D     in use at exit: 37,033 bytes in 350 blocks
=3D=3D3206=3D=3D   total heap usage: 673 allocs, 323 frees, 4,735,171 b=
ytes allocated
=3D=3D3206=3D=3D
=3D=3D3206=3D=3D LEAK SUMMARY:
=3D=3D3206=3D=3D    definitely lost: 832 bytes in 8 blocks
=3D=3D3206=3D=3D    indirectly lost: 18,464 bytes in 4 blocks
=3D=3D3206=3D=3D      possibly lost: 0 bytes in 0 blocks
=3D=3D3206=3D=3D    still reachable: 17,737 bytes in 338 blocks
=3D=3D3206=3D=3D         suppressed: 0 bytes in 0 blocks
=3D=3D3206=3D=3D Rerun with --leak-check=3Dfull to see details of leake=
d memory
=3D=3D3206=3D=3D
=3D=3D3206=3D=3D For counts of detected and suppressed errors, rerun wi=
th: -v
=3D=3D3206=3D=3D ERROR SUMMARY: 1 errors from 1 contexts (suppressed: 4=
 from 4)

mdadm --examine of all my drives (again):
/dev/sdb3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 9ed0b17f:e9a7a813:a9139679:4f8f999b
           Name : leyline:1  (local to host leyline)
  Creation Time : Tue Jun  5 00:14:35 2012
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 3906525098 (1862.78 GiB 2000.14 GB)
     Array Size : 7813046272 (7451.10 GiB 8000.56 GB)
  Used Dev Size : 3906523136 (1862.78 GiB 2000.14 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : feb94069:b2afeb6e:ae6b2af2:f9e3cee4

    Update Time : Tue Jun  5 00:14:35 2012
       Checksum : 1909d79e - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdc3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 9ed0b17f:e9a7a813:a9139679:4f8f999b
           Name : leyline:1  (local to host leyline)
  Creation Time : Tue Jun  5 00:14:35 2012
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 3906525098 (1862.78 GiB 2000.14 GB)
     Array Size : 7813046272 (7451.10 GiB 8000.56 GB)
  Used Dev Size : 3906523136 (1862.78 GiB 2000.14 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : ed6116ac:4f91c2dd:4ada53df:0e14fc2a

    Update Time : Tue Jun  5 00:14:35 2012
       Checksum : fe0cffd8 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdd3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 9ed0b17f:e9a7a813:a9139679:4f8f999b
           Name : leyline:1  (local to host leyline)
  Creation Time : Tue Jun  5 00:14:35 2012
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 3906523136 (1862.78 GiB 2000.14 GB)
     Array Size : 7813046272 (7451.10 GiB 8000.56 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : d839ca02:1d14cde3:65b54275:8caa0275

    Update Time : Tue Jun  5 00:14:35 2012
       Checksum : 3ac0c483 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing)
mdadm: No md superblock detected on /dev/sde3.



On Mon, Jun 4, 2012 at 5:57 PM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 04 Jun 2012 20:26:05 +0200 Pierre Beck <mail@pierre-beck.de> =
wrote:
>
>> I'll try and clear up some confusion (I was in IRC with freeone3000)=
=2E
>>
>> /dev/sdf is an empty drive, a replacement for a failed drive. The Ar=
ray
>> attempted to assemble, but failed and reported one drive as spare. T=
his
>> is the moment we saved the --examines.
>>
>> In expectation of a lost write due to drive write-cache, we executed
>> --assemble --force, which kicked another drive.
>>
>> @James: remove /dev/sdf for now and replace /dev/sde3, which indeed =
has
>> a very outdated update time, with the non-present drive. Post an
>> --examine of that drive. It should report update time Jun 1st.
>>
>> We tried to re-create the array with --assume-clean. But mdadm chose=
 a
>> different data offset for the drives. A re-create with proper data
>> offset will be necessary.
>
> OK, try:
>
> =C2=A0 git clone -b data_offset git://neil.brown.name/mdadm
> =C2=A0 cd mdadm
> =C2=A0 make
>
> =C2=A0 ./mdadm -C /dev/md1 -e 1.2 -l 5 -n 5 --assume-clean -c 512 \
> =C2=A0 =C2=A0 =C2=A0/dev/sdc3:2048s /dev/sdb3:2048s ??? =C2=A0/dev/sd=
d3:1024s ???
>
> The number after ':' after a device name is a data offset. =C2=A0's' =
means sectors.
> With out 's' it means Kilobytes.
> I don't know what should be at slot 2 or 4 so I put '???'. =C2=A0You =
should fill it
> in. =C2=A0You should also double check the command and double check t=
he names of
> your devices.
> Don't install this mdadm, and don't use it for anything other than
> re-creating this array.
>
> Good luck.
>
> NeilBrown
>
>>
>> Greetings,
>>
>> Pierre Beck
>>
>>
>> Am 04.06.2012 05:35, schrieb NeilBrown:
>> > On Fri, 1 Jun 2012 19:48:41 -0500 freeone3000<freeone3000@gmail.co=
m> =C2=A0wrote:
>> >
>> >> Sorry.
>> >>
>> >> /dev/sde fell out of the array, so I replaced the physical drive =
with
>> >> what is now /dev/sdf. udev may have relabelled the drive - smartc=
tl
>> >> states that the drive that is now /dev/sde works fine.
>> >> /dev/sdf is a new drive. /dev/sdf has a single, whole-disk partit=
ion
>> >> with type marked as raid. It is physically larger than the others=
=2E
>> >>
>> >> /dev/sdf1 doesn't have a mdadm superblock. /dev/sdf seems to, so =
I
>> >> gave output of that device instead of /dev/sdf1, despite the
>> >> partition. Whole-drive RAID is fine, if it gets it working.
>> >>
>> >> What I'm attempting to do is rebuild the RAID from the data from =
the
>> >> other four drives, and bring the RAID back up without losing any =
of
>> >> the data. /dev/sdb3, /dev/sdc3, /dev/sdd3, and what is now /dev/s=
de3
>> >> should be used to rebuild the array, with /dev/sdf as a new drive=
=2E If
>> >> I can get the array back up with all my data and all five drives =
in
>> >> use, I'll be very happy.
>> > You appear to have 3 devices that are happy:
>> > =C2=A0 =C2=A0sdc3 is device 0 =C2=A0 data-offset 2048
>> > =C2=A0 =C2=A0sdb3 is device 1 =C2=A0 data-offset 2048
>> > =C2=A0 =C2=A0sdd3 is device 3 =C2=A0 data-offset 1024
>> >
>> > nothing claims to be device 2 or 4.
>> >
>> > sde3 looks like it was last in the array on 23rd May, a little ove=
r
>> > a week before your report. =C2=A0Could that have been when "sde fe=
ll out of the
>> > array" ??
>> > Is it possible that you replaced the wrong device?
>> > Or is it possible the the array was degraded when sde "fell out" r=
esulting
>> > in data loss?
>> >
>> > I need more precise history to understand what happened, as I cann=
ot suggest
>> > a fixed until I have that understanding.
>> >
>> > When did the array fail?
>> > How certain are you that you replaced the correct device?
>> > Can you examine the drive that you removed and see what it says?
>> > Are you certain that the array wasn't already degraded?
>> >
>> > NeilBrown
>> >
>



--=20
James Moore
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
