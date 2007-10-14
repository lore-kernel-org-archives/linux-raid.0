From: Nagilum <nagilum@nagilum.org>
Subject: Re: Help RAID5 reshape Oops / backup-file
Date: Sun, 14 Oct 2007 18:55:50 +0200
Message-ID: <20071014185550.d6hbv2bk00kkwkgc@cakebox.homeunix.net>
References: <20071011142518.igm1jud7ms408ggg@cakebox.homeunix.net>
	<18190.46828.156191.300754@notabene.brown>
	<20071012084328.2f6vk4cdw80kscw0@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_3dexbenvjhgk";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071012084328.2f6vk4cdw80kscw0@cakebox.homeunix.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_3dexbenvjhgk
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Can someone tell me if I'm on the right track?
I've now noticed the following:
# ~/mdadm-2.6.3/mdadm -v -A /dev/md0 /dev/sd[d-e]
mdadm: looking for devices for /dev/md0
mdadm: /dev/sdd is identified as a member of /dev/md0, slot -1.
mdadm: /dev/sde is identified as a member of /dev/md0, slot -1.
mdadm: No suitable drives found for /dev/md0

This "slot -1" is also visible in the examine output:

# mdadm -E /dev/sdd
/dev/sdd:
           Magic : a92b4efc
         Version : 00.91.00
            UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
   Creation Time : Sat Sep 15 21:11:41 2007
      Raid Level : raid5
     Device Size : 488308672 (465.69 GiB 500.03 GB)
      Array Size : 1953234688 (1862.75 GiB 2000.11 GB)
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 0

   Reshape pos'n : 872095808 (831.70 GiB 893.03 GB)
   Delta Devices : 2 (3->5)

     Update Time : Mon Oct  8 23:59:27 2007
           State : clean
  Active Devices : 5
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 0
        Checksum : f42505b9 - correct
          Events : 0.470134

          Layout : left-symmetric
      Chunk Size : 16K

       Number   Major   Minor   RaidDevice State
this     5       8       48       -1      spare   /dev/sdd

    0     0       8        0        0      active sync   /dev/sda
    1     1       8       16        1      active sync   /dev/sdb
    2     2       8       32        2      active sync   /dev/sdc
    3     3       8       64        3      active sync   /dev/sde
    4     4       8       48        4      active sync   /dev/sdd


So can someone confirm that is the likely source of my problem?
And hopefully - if that is indeed the problem - someone can tell me =20
how to update that slot number?
Thanks,
Alex.

----- Message from nagilum@nagilum.org ---------
     Date: Fri, 12 Oct 2007 08:43:28 +0200
     From: Nagilum <nagilum@nagilum.org>
Reply-To: Nagilum <nagilum@nagilum.org>
  Subject: Re: Help RAID5 reshape Oops / backup-file
       To: Neil Brown <neilb@suse.de>
       Cc: linux-raid@vger.kernel.org


> ----- Message from neilb@suse.de ---------
>     Date: Fri, 12 Oct 2007 09:51:08 +1000
>     From: Neil Brown <neilb@suse.de>
> Reply-To: Neil Brown <neilb@suse.de>
>  Subject: Re: Help RAID5 reshape Oops / backup-file
>       To: Nagilum <nagilum@nagilum.org>
>       Cc: linux-raid@vger.kernel.org
>
>
>> It isn't a problem that you didn't specify a backup-file.
>> If you don't, mdadm uses some spare space on one of the new drives.
>> After the critical section has passed, the backup file isn't needed
>> any longer.
>> The problem is that mdadm still wants to find and recover from it.
>>
>> I throughly tested mdadm restarting from a crash during the critical
>> section, but it looks like I didn't properly test restarting from a
>> later crash.
>>
>> I think if you just change the 'return 1' at the end of Grow_restart
>> to 'return 0' it should work for you.
>>
>> I'll try to get this fixed properly (and tested) and release a 2.6.4.
>>
>> NeilBrown
>>
>
>
> ----- End message from neilb@suse.de -----
>
> Thanks, I changed Grow_restart as suggested, now I get:
> nas:~/mdadm-2.6.3# ./mdadm -A /dev/md0 /dev/sd[a-e]
> mdadm: /dev/md0 assembled from 3 drives and 2 spares - not enough to
> start the array.
>
> nas:~/mdadm-2.6.3# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : inactive sda[0] sde[6] sdd[5] sdc[2] sdb[1]
>       2441543360 blocks
>
> unused devices: <none>
>
> which is similar to what the old mdadm is telling me.
> I'll try to find out where it gets the idea these are spares..
> Would it be a good idea to update to vanilla 2.6.23 instead of running
> Debian Etch's 2.6.18-5?
> If there is anything I can do to help with v2.6.4 let me know!
> Thanks,
> Alex.
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> #    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
> #   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
> #  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
> # /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux #
> #           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ----------------------------------------------------------------
> cakebox.homeunix.net - all the machine one needs..


----- End message from nagilum@nagilum.org -----



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


--=_3dexbenvjhgk
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHEkoWAKWN2UY+sLwRAhUUAKCgfWYYpO366QC1wBXX4oj2AOxKJwCcDiBl
x5taFVROKjQw3iAdo8sipKM=
=FV6y
-----END PGP SIGNATURE-----

--=_3dexbenvjhgk--
