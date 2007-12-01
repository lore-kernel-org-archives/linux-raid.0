From: Nagilum <nagilum@nagilum.org>
Subject: Re: raid5 reshape/resync
Date: Sat, 01 Dec 2007 15:48:17 +0100
Message-ID: <20071201154817.5uwtck6ask0ksw8s@cakebox.homeunix.net>
References: <20071124120209.0t70rfkfswkcww0g@cakebox.homeunix.net>
	<20071125200431.2wbk051yoso4owsk@cakebox.homeunix.net>
	<18254.21183.807123.642613@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_6j1cha91zwg0";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18254.21183.807123.642613@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_6j1cha91zwg0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

----- Message from neilb@suse.de ---------
     Date: Thu, 29 Nov 2007 16:48:47 +1100
     From: Neil Brown <neilb@suse.de>
Reply-To: Neil Brown <neilb@suse.de>
  Subject: Re: raid5 reshape/resync
       To: Nagilum <nagilum@nagilum.org>
       Cc: linux-raid@vger.kernel.org

>> > Hi,
>> > I'm running 2.6.23.8 x86_64 using mdadm v2.6.4.
>> > I was adding a disk (/dev/sdf) to an existing raid5 (/dev/sd[a-e] -> md=
0)
>> > During that reshape (at around 4%) /dev/sdd reported read errors and
>> > went offline.
>
> Sad.
>
>> > I replaced /dev/sdd with a new drive and tried to reassemble the array
>> > (/dev/sdd was shown as removed and now as spare).
>
> There must be a step missing here.
> Just because one drive goes offline, that  doesn't mean that you need
> to reassemble the array.  It should just continue with the reshape
> until that is finished.  Did you shut the machine down or did it crash
> or what
>> > Assembly worked but it would not run unless I use --force.
>
> That suggests an unclean shutdown.  Maybe it did crash?

I started the reshape and went out. When I came back the controller =20
was beeping (indicating the erraneous disk). I tried to log on but I =20
could not get in. The machine was responding to pings but that was =20
about it (no ssh or xdm login worked). So I hard rebooted.
I booted into a rescue root, the /etc/mdadm/mdadm.conf didn't yet =20
include the new disk so the raid was missing one disk and not started.
Since I didn't know what exactly what was going on I --re-added sdf =20
(the new disk) and tried to resume reshaping. A second into that the =20
read failure on /dev/sdd was reported. So I stopped md0 and shut down =20
to verify the read error with another controller.
After I had verified that I replaced /dev/sdd with a new drive and put =20
in the broken drive as /dev/sdg, just in case.

>> > Since I'm always reluctant to use force I put the bad disk back in,
>> > this time as /dev/sdg . I re-added the drive and could run the array.
>> > The array started to resync (since the disk can be read until 4%) and
>> > then I marked the disk as failed. Now the array is "active, degraded,
>> > recovering":
>
> It should have restarted the reshape from whereever it was up to, so
> it should have hit the read error almost immediately.  Do you remember
> where it started the reshape from?  If it restarted from the beginning
> that would be bad.

It must have continued where it left off since the reshape position in =20
all superblocks was at about 4%.

> Did you just "--assemble" all the drives or did you do something else?

Sorry for being a bit unexact here, I didn't actually have to use =20
--assemble, when booting into the rescue root the raid came up with =20
/dev/sdd and /dev/sdf removed. I just had to --re-add /dev/sdf

>> > unusually low which seems to indicate a lot of seeking as if two
>> > operations are happening at the same time.
>
> Well reshape is always slow as it has to read from one part of the
> drive and write to another part of the drive.

Actually it was resyncing with the minimum speed, I managed to crank =20
up the speed to >20MB/s by adjusting /sys/block/md0/md/sync_speed_min

>> > Can someone relief my doubts as to whether md does the right thing here=
?
>> > Thanks,
>
> I believe it is do "the right thing".
>
>> >
>> ----- End message from nagilum@nagilum.org -----
>>
>> Ok, so the reshape tried to continue without the failed drive and
>> after that resynced to the new spare.
>
> As I would expect.
>
>> Unfortunately the result is a mess. On top of the Raid5 I have
>
> Hmm.  This I would not expect.
>
>> dm-crypt and LVM.
>> Although dmcrypt and LVM dont appear to have a problem the filesystems
>> on top are a mess now.
>
> Can you be more specific about what sort of "mess" they are in?

Sure.
So here is the vg-layout:
nas:~# lvdisplay vg01
   --- Logical volume ---
   LV Name                /dev/vg01/lv1
   VG Name                vg01
   LV UUID                4HmzU2-VQpO-vy5R-Wdys-PmwH-AuUg-W02CKS
   LV Write Access        read/write
   LV Status              available
   # open                 0
   LV Size                512.00 MB
   Current LE             128
   Segments               1
   Allocation             inherit
   Read ahead sectors     0
   Block device           253:1

   --- Logical volume ---
   LV Name                /dev/vg01/lv2
   VG Name                vg01
   LV UUID                4e2ZB9-29Rb-dy4M-EzEY-cEIG-Nm1I-CPI0kk
   LV Write Access        read/write
   LV Status              available
   # open                 0
   LV Size                7.81 GB
   Current LE             2000
   Segments               1
   Allocation             inherit
   Read ahead sectors     0
   Block device           253:2

   --- Logical volume ---
   LV Name                /dev/vg01/lv3
   VG Name                vg01
   LV UUID                YQRd0X-5hF8-2dd3-GG4v-wQLH-WGH0-ntGgug
   LV Write Access        read/write
   LV Status              available
   # open                 0
   LV Size                1.81 TB
   Current LE             474735
   Segments               1
   Allocation             inherit
   Read ahead sectors     0
   Block device           253:3

The layout was created like that and except for increasing the size of =20
the lv3 never changed anything. Therefore I think its safe to assume =20
they are located in order and without gaps. The first lv is swap, so =20
not much to loose here, the second lv is "/" reiserfs and is fine too. =20
The third lv however looks pretty bad.
I uploaded the "xfs_repair -n /dev/mapper/vg01-lv3" output to =20
http://www.nagilum.org/md/xfs_repair.txt.
I can mount the filesystem but the directories all look like that:

drwxr-xr-x 16 nagilum nagilum  155 2007-09-18 18:20 .
drwxr-xr-x  5 nagilum nagilum   89 2007-09-22 17:56 ..
drwxr-xr-x 12 nagilum nagilum  121 2007-09-18 18:19 biz
?---------  ? ?       ?          ?                ? comm
?---------  ? ?       ?          ?                ? dev
drwxr-xr-x  8 nagilum nagilum   76 2007-09-18 18:19 disk
drwxr-xr-x  7 nagilum nagilum   64 2007-09-18 18:19 docs
?---------  ? ?       ?          ?                ? game
?---------  ? ?       ?          ?                ? gfx
drwxr-xr-x  5 nagilum nagilum   40 2007-09-18 18:20 hard
drwxr-xr-x  8 nagilum nagilum   69 2007-09-18 18:20 misc
drwxr-xr-x  4 nagilum nagilum   27 2007-09-18 18:20 mods
drwxr-xr-x  5 nagilum nagilum   39 2007-09-18 18:20 mus
?---------  ? ?       ?          ?                ? pix
drwxr-xr-x  6 nagilum nagilum   51 2007-09-18 18:20 text
drwxr-xr-x 22 nagilum nagilum 4096 2007-09-18 18:21 util

Also the files which are readable are corrupt.
It looks to me as if md mixed up the chunk order in the stripes past =20
the 4% mark.
I looked at a larger textfile to see what kind damage was done and see =20
that it starts out ok but at 0xd000 the data becomes random data until =20
0x11000.
Maybe a table to simplify things:
Ok     0x0     - 0xd000
Random 0xd000  - 0x11000
Ok     0x11000 - 0x21000
Random 0x21000 - 0x25000
Ok     0x25000 - 0x35000
Random 0x35000 - 0x39000

And so on.. 0x4000 is equal to my chunk size.
  Since LUKS uses the sectornumber for whitening the "random data" =20
must be wrongly decrypted text.
I'm not sure how to reorder things so it will be ok again, I'll ponder =20
about that while I try to recreate the situation using files and =20
losetup.
And finally the information from the failed drive:

nas:~# mdadm -E /dev/sdg
/dev/sdg:
           Magic : a92b4efc
         Version : 00.91.00
            UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
   Creation Time : Sat Sep 15 21:11:41 2007
      Raid Level : raid5
   Used Dev Size : 488308672 (465.69 GiB 500.03 GB)
      Array Size : 2441543360 (2328.44 GiB 2500.14 GB)
    Raid Devices : 6
   Total Devices : 7
Preferred Minor : 0

   Reshape pos'n : 118360960 (112.88 GiB 121.20 GB)
   Delta Devices : 1 (5->6)

     Update Time : Fri Nov 23 20:05:50 2007
           State : active
  Active Devices : 6
Working Devices : 7
  Failed Devices : 0
   Spare Devices : 1
        Checksum : 9a8358c4 - correct
          Events : 0.677965

          Layout : left-symmetric
      Chunk Size : 16K

       Number   Major   Minor   RaidDevice State
this     3       8       96        3      active sync   /dev/sdg

    0     0       8        0        0      active sync   /dev/sda
    1     1       8       16        1      active sync   /dev/sdb
    2     2       8       32        2      active sync   /dev/sdc
    3     3       8       96        3      active sync   /dev/sdg
    4     4       8       64        4      active sync   /dev/sde
    5     5       8       80        5      active sync   /dev/sdf
    6     6       8       48        6      spare   /dev/sdd

from md's point of view the array is "fine" now of course:

nas:~# mdadm -Q --detail /dev/md0
/dev/md0:
         Version : 00.90.03
   Creation Time : Sat Sep 15 21:11:41 2007
      Raid Level : raid5
      Array Size : 2441543360 (2328.44 GiB 2500.14 GB)
   Used Dev Size : 488308672 (465.69 GiB 500.03 GB)
    Raid Devices : 6
   Total Devices : 6
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Sat Dec  1 15:25:59 2007
           State : clean
  Active Devices : 6
Working Devices : 6
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 16K

            UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
          Events : 0.986918

     Number   Major   Minor   RaidDevice State
        0       8        0        0      active sync   /dev/sda
        1       8       16        1      active sync   /dev/sdb
        2       8       32        2      active sync   /dev/sdc
        3       8       48        3      active sync   /dev/sdd
        4       8       64        4      active sync   /dev/sde
        5       8       80        5      active sync   /dev/sdf

Ok, enough for now, any useful ideas are greatly appreciated!
Alex.



=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux #
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..


--=_6j1cha91zwg0
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHUXQwAKWN2UY+sLwRAuPlAJ4qtI6hXtCLjMfYxorbtILZNSx9qwCgu4aB
dMosrapGjy9x93LgntYr0hI=
=55he
-----END PGP SIGNATURE-----

--=_6j1cha91zwg0--
