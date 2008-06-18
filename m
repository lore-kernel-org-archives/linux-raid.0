From: Jesse Molina <jmolina@tgen.org>
Subject: resync=PENDING, interrupted RAID5 grow will not automatically
 reconstruct
Date: Tue, 17 Jun 2008 17:30:25 -0700
Message-ID: <C47DA531.9128%jmolina@tgen.org>
References: <3E998AD6CC01E746957550D4CD642A742303FF@TGEN-M2.ad.tgen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E998AD6CC01E746957550D4CD642A742303FF@TGEN-M2.ad.tgen.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jesse Molina <jmolina@tgen.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I think I figured this out.

man md

Read the section regarding the sync_action file.

do as root; =B3echo idle > /sys/block/md2/md/sync_action=B2



After issuing the idle command, my array says;

user@host# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
    =20
md2 : active raid5 sdd5[0] sdg5[4] sdh5[3] sdf5[2] sde5[1]
      325283840 blocks super 0.91 level 5, 64k chunk, algorithm 2 [5/5]
[UUUUU]
      [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>...]  reshap=
e =3D 85.3% (138827968/162641920)
finish=3D279.7min speed=3D1416K/sec

and

user@host# mdadm --detail /dev/md2
/dev/md2:
        Version : 00.91.03
  Creation Time : Sun Nov 18 02:39:31 2007
     Raid Level : raid5
     Array Size : 325283840 (310.21 GiB 333.09 GB)
  Used Dev Size : 162641920 (155.11 GiB 166.55 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Tue Jun 17 17:25:49 2008
          State : active, recovering
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

 Reshape Status : 85% complete
  Delta Devices : 2, (3->5)

           UUID : 05bcf06a:ce126226:d10fa4d9:5a1884ea (local to host
sorrows)
         Events : 0.92399

    Number   Major   Minor   RaidDevice State
       0       8       53        0      active sync   /dev/sdd5
       1       8       69        1      active sync   /dev/sde5
       2       8       85        2      active sync   /dev/sdf5
       3       8      117        3      active sync   /dev/sdh5
       4       8      101        4      active sync   /dev/sdg5
     =20





On 6/17/08 12:03 AM, "Jesse Molina" <jmolina@tgen.org> wrote:

>=20
>=20
> Hello again
>=20
> I now have a new problem.
>=20
> My system is now up, but the array that was causing a problem will no=
t correct
> itself automatically after several hours.  There is no disk activity =
or any
> change in the state of the array after many hours.
>=20
> How do I force the array to resync?
>=20
>=20
>=20
> Here is the array in question.  It's sitting with a flag of "resync=3D=
PENDING".
> How do I get it out of pending?
>=20
> --
>=20
> user@host-->cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]
>=20
> md2 : active raid5 sdd5[0] sdg5[4] sdh5[3] sdf5[2] sde5[1]
>       325283840 blocks super 0.91 level 5, 64k chunk, algorithm 2 [5/=
5]
> [UUUUU]
>         resync=3DPENDING
>=20
> --
>=20
> user@host-->sudo mdadm --detail /dev/md2
> /dev/md2:
>         Version : 00.91.03
>   Creation Time : Sun Nov 18 02:39:31 2007
>      Raid Level : raid5
>      Array Size : 325283840 (310.21 GiB 333.09 GB)
>   Used Dev Size : 162641920 (155.11 GiB 166.55 GB)
>    Raid Devices : 5
>   Total Devices : 5
> Preferred Minor : 2
>     Persistence : Superblock is persistent
>=20
>     Update Time : Mon Jun 16 21:46:57 2008
>           State : active
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>   Delta Devices : 2, (3->5)
>=20
>            UUID : 05bcf06a:ce126226:d10fa4d9:5a1884ea (local to host =
sorrows)
>          Events : 0.92265
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       53        0      active sync   /dev/sdd5
>        1       8       69        1      active sync   /dev/sde5
>        2       8       85        2      active sync   /dev/sdf5
>        3       8      117        3      active sync   /dev/sdh5
>        4       8      101        4      active sync   /dev/sdg5
>=20
> --
>=20
> Some interesting lines from dmesg;
>=20
> md: md2 stopped.
> md: bind<sde5>
> md: bind<sdf5>
> md: bind<sdh5>
> md: bind<sdg5>
> md: bind<sdd5>
> md: md2: raid array is not clean -- starting background reconstructio=
n
> raid5: reshape will continue
> raid5: device sdd5 operational as raid disk 0
> raid5: device sdg5 operational as raid disk 4
> raid5: device sdh5 operational as raid disk 3
> raid5: device sdf5 operational as raid disk 2
> raid5: device sde5 operational as raid disk 1
> raid5: allocated 5252kB for md2
> raid5: raid level 5 set md2 active with 5 out of 5 devices, algorithm=
 2
> RAID5 conf printout:
>  --- rd:5 wd:5
>  disk 0, o:1, dev:sdd5
>  disk 1, o:1, dev:sde5
>  disk 2, o:1, dev:sdf5
>  disk 3, o:1, dev:sdh5
>  disk 4, o:1, dev:sdg5
> ...ok start reshape thread
>=20
> --
>=20
>=20
> Note that in this case, the Array Size is actually the old array size=
 rather
> than what it should be with all five disks.
>=20
> Whatever the correct course of action is here, it appears neither obv=
ious or
> well documented to me.  I suspect that I'm a test case, since I've ar=
chived an
> unusual state.
>=20
>=20
>=20
> -----Original Message-----
> From: Jesse Molina
> Sent: Mon 6/16/2008 6:08 PM
> To: Jesse Molina; Ken Drummond
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Failed RAID5 array grow after reboot interruption; mdadm=
: Failed
> to restore critical section for reshape, sorry.
>=20
>=20
> Thanks for the help.  I confirm success at recovering the array today=
=2E
>=20
> Indeed, replacing the mdadm in the initramfs from the original v2.6.3=
 to
> 2.6.4 fixed the problem.
>=20
> As noted by Richard Scobie, please avoid versions 2.6.5 and 2.6.6.  E=
ither
> v2.6.4 or v2.6.7 will fix this issue.  I fixed it with v2.6.4.
>=20
>=20
>=20
> For historical purposes, and to help others, I was able to fix this a=
s
> follows;
>=20
> Since the mdadm binary was in my initramfs, and I was unable to get t=
he
> working system up to mount it's root file system, I had to interrupt =
the
> initramfs "init" script, replace mdadm with an updated version, and t=
hen
> continue the process.
>=20
> To do this, pass your Linux kernel an option such as "break=3Dmount" =
or maybe
> "break=3Dtop", to stop the init script just before it is about to mou=
nt the
> root file system.  Then, get your new mdadm file and replace the exis=
ting
> one at /sbin/mdadm.
>=20
> To get the actual mdadm binary, you will need to use a working system=
 to
> extract it from a .deb, .rpm, or otherwise download and compile it.  =
In my
> case, for debian, you can do an "ar xv <file.deb>" on the package, an=
d then
> tar -xzf on the data file.  For Debian, I just retrieved the file fro=
m
> http://packages.debian.org
>=20
> Then, stick the new file on a CD/DVD disk, USB flash drive, or other =
media
> and somehow get it onto your system while it's still at the (initramf=
s)
> busybox prompt.  I was able to mount from a CD, so "mount -t iso9660 =
-r
> /dev/cdrom /temp-cdrom", after a "mkdir /temp-cdrom".
>=20
> After you have replaced the old mdadm file with the new one, unmount =
your
> temporary media and then type "mdadm --assemble /dev/md0" for whichev=
er
> array was flunking out on you.  Then "vgchange -a -y" if using LVM.
>=20
> Finally, do ctrl+D to exit the initramfs shell, which will cause the =
"init"
> script to try and continue with the boot process from where you inter=
rupted
> it.  Hopefully, the system will then continue as normal.
>=20
> Note that you will eventually want to update your mdadm file and repl=
ace
> your initramfs.
>=20
>=20
>=20
> Thanks for the help Ken.
>=20
> As for why my system died while it was doing the original grow, I hav=
e no
> idea.  I'll run it in single user and let it finish the job.
>=20
>=20
>=20
> On 6/16/08 9:48 AM, "Jesse Molina" <jmolina@tgen.org> wrote:
>=20
>>=20
>> Thanks.  I'll give the updated mdadm binary a try.  It certainly loo=
ks
>> plausible that this was a recently fixed mdadm bug.
>>=20
>> For the record, I think you typoed this below.  You meant to say v2.=
6.4,
>> rather than v2.4.4.  My current version was v2.6.3.  The current mda=
dm
>> version appears to be v2.6.4, and Debian currently has a -2 release.
>>=20
>> My system is Debian unstable, just as FYI.  It's been since January =
2008
>> since v2.6.4-1 was released, so I guess I've not updated this packag=
e since
>> then.
>>=20
>> Here is the changelog for mdadm;
>>=20
>> http://www.cse.unsw.edu.au/~neilb/source/mdadm/ChangeLog
>>=20
>> Specifically;
>>=20
>> "Fix restarting of a 'reshape' if it was stopped in the middle."
>>=20
>> That sounds like my problem.
>>=20
>> I will try this here in an hour or two and see what happens...
>>=20
>>=20
>>=20
>> On 6/16/08 3:00 AM, "Ken Drummond" <ken.drummond@kendrummond.com> wr=
ote:
>>=20
>>> There was an announcement on this
>>> list for v2.4.4 which included fixes to restarting an interrupted g=
row.
>=20
> --
> # Jesse Molina
> # The Translational Genomics Research Institute
> # http://www.tgen.org
> # Mail =3D jmolina@tgen.org
> # Desk =3D 1.602.343.8459
> # Cell =3D 1.602.323.7608
>=20
>=20
>=20
>=20


--=20
# Jesse Molina
# The Translational Genomics Research Institute
# http://www.tgen.org
# Mail =3D jmolina@tgen.org
# Desk =3D 1.602.343.8459
# Cell =3D 1.602.323.7608


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
