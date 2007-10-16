From: Nagilum <nagilum@nagilum.org>
Subject: Re: Help RAID5 reshape Oops / backup-file
Date: Tue, 16 Oct 2007 14:50:09 +0200
Message-ID: <20071016145009.qu5kpigu1c8owkc4@cakebox.homeunix.net>
References: <20071011142518.igm1jud7ms408ggg@cakebox.homeunix.net>
	<18190.46828.156191.300754@notabene.brown>
	<20071012084328.2f6vk4cdw80kscw0@cakebox.homeunix.net>
	<20071014185550.d6hbv2bk00kkwkgc@cakebox.homeunix.net>
	<18194.42699.193194.986448@notabene.brown>
	<20071015135522.xjds82zo08cgc08c@cakebox.homeunix.net>
	<18196.4323.854776.966812@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_5xnu9gheng4c";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18196.4323.854776.966812@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_5xnu9gheng4c
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

----- Message from neilb@suse.de ---------
     Date: Tue, 16 Oct 2007 11:16:19 +1000
     From: Neil Brown <neilb@suse.de>
Reply-To: Neil Brown <neilb@suse.de>
  Subject: Re: Help RAID5 reshape Oops / backup-file
       To: Nagilum <nagilum@nagilum.org>
       Cc: linux-raid@vger.kernel.org


>
> Thanks for the extra details.
> I still cannot manage to reproduce it which is frustrating, but I
> think I can fix your array for you.
>
> Get the source for mdadm 2.6.3, apply the following patch, then use
>
>    mdadm -A /dev/md0 --update=3Dthis /dev/sd[abcde]
>
> that should re-write the part of the superblocks that is wrong, then
> assemble the array.
>
> Please let me know how it goes.
>
> Also, if you could show me "mdadm.conf" and "mdrun.conf" from the
> initrd, that might help.
>
> Thanks,
> NeilBrown
>


----- End message from neilb@suse.de -----

Thanks a bunch mate!

So far it looks very well:

nas:~/mdadm-2.6.3# ./mdadm -Q --detail /dev/md0
/dev/md0:
         Version : 00.91.03
   Creation Time : Sat Sep 15 21:11:41 2007
      Raid Level : raid5
   Used Dev Size : 488308672 (465.69 GiB 500.03 GB)
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Mon Oct  8 23:59:27 2007
           State : active, degraded, Not Started
  Active Devices : 3
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 2

          Layout : left-symmetric
      Chunk Size : 16K

   Delta Devices : 2, (3->5)

            UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
          Events : 0.470134

     Number   Major   Minor   RaidDevice State
        0       8        0        0      active sync   /dev/sda
        1       8       16        1      active sync   /dev/sdb
        2       8       32        2      active sync   /dev/sdc
        3       0        0        3      removed
        4       0        0        4      removed

        5       8       48        -      spare   /dev/sdd
        6       8       64        -      spare   /dev/sde
nas:~/mdadm-2.6.3# mdadm -S /dev/md0
mdadm: stopped /dev/md0
nas:~/mdadm-2.6.3# ./mdadm -A /dev/md0 --update=3Dthis /dev/sd[abcde]
mdadm: Setting this disk from 5 to 4
mdadm: Setting this disk from 6 to 3
mdadm: /dev/md0 assembled from 3 drives and 2 spares - not enough to =20
start the array.
nas:~/mdadm-2.6.3# mdadm -S /dev/md0
mdadm: stopped /dev/md0
nas:~/mdadm-2.6.3# ./mdadm -A /dev/md0 /dev/sd[abcde]
mdadm: /dev/md0 has been started with 5 drives.
nas:~/mdadm-2.6.3# ./mdadm -Q --detail /dev/md0
/dev/md0:
         Version : 00.91.03
   Creation Time : Sat Sep 15 21:11:41 2007
      Raid Level : raid5
      Array Size : 976617344 (931.37 GiB 1000.06 GB)
   Used Dev Size : 488308672 (465.69 GiB 500.03 GB)
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Tue Oct 16 13:42:03 2007
           State : clean, recovering
  Active Devices : 5
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 16K

  Reshape Status : 44% complete
   Delta Devices : 2, (3->5)

            UUID : 25da80a6:d56eb9d6:0d7656f3:2f233380
          Events : 0.470212

     Number   Major   Minor   RaidDevice State
        0       8        0        0      active sync   /dev/sda
        1       8       16        1      active sync   /dev/sdb
        2       8       32        2      active sync   /dev/sdc
        3       8       64        3      active sync   /dev/sde
        4       8       48        4      active sync   /dev/sdd

nas:~# cat /proc/mdstat
md0 : active raid5 sda[0] sdd[4] sde[3] sdc[2] sdb[1]
       976617344 blocks super 0.91 level 5, 16k chunk, algorithm 2 =20
[5/5] [UUUUU]
       [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>.......]  reshape =3D 67.5% =
(329927392/488308672) =20
finish=3D48.6min speed=3D54235K/sec

unused devices: <none>

I'll send an update (including the configs) when its done and I've =20
verified everything is healthy. (and my heart has stopped racing ;)
At first I was bit scared because of the order (sde before sdd) but =20
that's consistent with the mdadm -E output from the devices earlier, =20
so it looks like I'll soon have my data back. *yay* :)

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


--=_5xnu9gheng4c
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHFLOAAKWN2UY+sLwRAum7AJ950U/XZpnKsTkaQHqIa7IW9jOcoQCgoVQV
eb9vT45kKriVo9nTI5T1/To=
=s27P
-----END PGP SIGNATURE-----

--=_5xnu9gheng4c--
