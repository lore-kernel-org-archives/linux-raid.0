From: Markus Hochholdinger <Markus@hochholdinger.net>
Subject: Re: [PATCH 018 of 29] md: Support changing rdev size on running arrays.
Date: Thu, 1 Apr 2010 17:23:36 +0200
Message-ID: <201004011723.44480.Markus@hochholdinger.net>
References: <20080627164503.9671.patches@notabene> <201003301652.16622.Markus@hochholdinger.net> <20100331164114.307a57aa@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3842982.p4AgFaLY26";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100331164114.307a57aa@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--nextPart3842982.p4AgFaLY26
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

Am 31.03.2010 um 07:41 Uhr schrieb Neil Brown <neilb@suse.de>:
> On Tue, 30 Mar 2010 16:52:13 +0200
> Markus Hochholdinger <Markus@hochholdinger.net> wrote:
> > Am 28.06.2008 um 01:41 Uhr schrieb Neil Brown <neilb@suse.de>:
> > > On Friday June 27, Markus@hochholdinger.net wrote:
> > > > Am Freitag, 27. Juni 2008 08:51 schrieb NeilBrown:
> > > > > From: Chris Webb <chris@arachsys.com>
[..]
> > Then I change the size of xvda1 and get the following kernel message:
> > [ 3281.905317] Setting capacity to 4194304
> > [ 3281.905317] xvda1: detected capacity change from 1073741824 to
> > 2147483648
> > After this i do:
> > echo "0" > /sys/block/md1/md/rd0/size
> > No kernel message so far and
> >   cat /sys/block/md1/md/rd0/size
> > still shows 1048570.
> That is very odd.  The number printed out in the "detected capacity chang=
e"
> line is exactly the name that should be used when you write to
> "md/rd0/size".

it's good to hear this isn't normal, so the error must be on my side.

OK, from the beginning:
# dd if=3D/dev/zero of=3D/dev/xvda1 bs=3D16M
# dd if=3D/dev/zero of=3D/dev/xvdb1 bs=3D16M
# blockdev --getsz /dev/xvda1
4194304
# blockdev --getsz /dev/xvdb1
4194304
#=20
mdadm --create /dev/md1 --raid-disks=3D2 --level=3D1 --metadata=3D0.9 /dev/=
xvda1 /dev/xvdb1
[  715.153257] md: bind<xvda1>
[  715.156154] md: bind<xvdb1>
[  715.192298] raid1: md1 is not clean -- starting background reconstruction
[  715.192298] raid1: raid set md1 active with 2 out of 2 mirrors
[  715.192320] md1: detected capacity change from 0 to 2147418112
mdadm: array /dev/md1 started.
[  715.197762]  md1: unknown partition table

=3D> resize xvda1 to 3GB

Here i need to say that the new size will show up until someone asks for th=
e=20
new size! I've done this with "fdisk -l". But now i see:
# blockdev --getsz /dev/xvda1
4194304
# fdisk -l /dev/xvda1
[  867.124950] Setting capacity to 6291456
[  867.124950] xvda1: detected capacity change from 2147483648 to 3221225472

Disk /dev/xvda1: 3221 MB, 3221225472 bytes
255 heads, 63 sectors/track, 391 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
Disk identifier: 0x00000000

Disk /dev/xvda1 doesn't contain a valid partition table
# blockdev --getsz /dev/xvda1
6291456


=46or me it seems the "blockdev --getsz" was cached somehow.


> You could try
>    strace echo 0 > /sys/block/md1/md/rd0/size
# strace echo 0 > /sys/block/md1/md/rd0/size
execve("/bin/echo", ["echo", "0"], [/* 26 vars */]) =3D 0
brk(0)                                  =3D 0x2352000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D=20
0x7f5b648c8000
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or=20
directory)
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D=20
0x7f5b648c6000
access("/etc/ld.so.preload", R_OK)      =3D -1 ENOENT (No such file or=20
directory)
open("/etc/ld.so.cache", O_RDONLY)      =3D 3
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D15141, ...}) =3D 0
mmap(NULL, 15141, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0x7f5b648c2000
close(3)                                =3D 0
access("/etc/ld.so.nohwcap", F_OK)      =3D -1 ENOENT (No such file or=20
directory)
open("/lib/libc.so.6", O_RDONLY)        =3D 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\320\353\1\0\0\0\0\0=
"...,=20
832) =3D 832
fstat(3, {st_mode=3DS_IFREG|0755, st_size=3D1379752, ...}) =3D 0
mmap(NULL, 3487784, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
=3D=20
0x7f5b64359000
mprotect(0x7f5b644a3000, 2097152, PROT_NONE) =3D 0
mmap(0x7f5b646a3000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|
MAP_DENYWRITE, 3, 0x14a000) =3D 0x7f5b646a3000
mmap(0x7f5b646a8000, 18472, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|
MAP_ANONYMOUS, -1, 0) =3D 0x7f5b646a8000
close(3)                                =3D 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D=20
0x7f5b648c1000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D=20
0x7f5b648c0000
arch_prctl(ARCH_SET_FS, 0x7f5b648c06f0) =3D 0
mprotect(0x7f5b646a3000, 16384, PROT_READ) =3D 0
mprotect(0x7f5b648c9000, 4096, PROT_READ) =3D 0
munmap(0x7f5b648c2000, 15141)           =3D 0
brk(0)                                  =3D 0x2352000
brk(0x2373000)                          =3D 0x2373000
open("/usr/lib/locale/locale-archive", O_RDONLY) =3D 3
fstat(3, {st_mode=3DS_IFREG|0644, st_size=3D3519008, ...}) =3D 0
mmap(NULL, 3519008, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0x7f5b63ffd000
close(3)                                =3D 0
fstat(1, {st_mode=3DS_IFREG|0644, st_size=3D4096, ...}) =3D 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D=20
0x7f5b648c5000
write(1, "0\n", 2)                      =3D -1 EINVAL (Invalid argument)
close(1)                                =3D 0
munmap(0x7f5b648c5000, 4096)            =3D 0
open("/usr/share/locale/locale.alias", O_RDONLY) =3D 1
fstat(1, {st_mode=3DS_IFREG|0644, st_size=3D2570, ...}) =3D 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D=20
0x7f5b648c5000
read(1, "# Locale name alias data base.\n#"..., 4096) =3D 2570
read(1, "", 4096)                       =3D 0
close(1)                                =3D 0
munmap(0x7f5b648c5000, 4096)            =3D 0
open("/usr/share/locale/en_US.utf8/LC_MESSAGES/coreutils.mo", O_RDONLY) =3D=
 -1=20
ENOENT (No such file or directory)
open("/usr/share/locale/en_US/LC_MESSAGES/coreutils.mo", O_RDONLY) =3D -1 E=
NOENT=20
(No such file or directory)
open("/usr/share/locale/en.utf8/LC_MESSAGES/coreutils.mo", O_RDONLY) =3D -1=
=20
ENOENT (No such file or directory)
open("/usr/share/locale/en/LC_MESSAGES/coreutils.mo", O_RDONLY) =3D -1 ENOE=
NT=20
(No such file or directory)
write(2, "echo: ", 6echo: )                   =3D 6
write(2, "write error", 11write error)             =3D 11
open("/usr/share/locale/en_US.utf8/LC_MESSAGES/libc.mo", O_RDONLY) =3D -1 E=
NOENT=20
(No such file or directory)
open("/usr/share/locale/en_US/LC_MESSAGES/libc.mo", O_RDONLY) =3D -1 ENOENT=
 (No=20
such file or directory)
open("/usr/share/locale/en.utf8/LC_MESSAGES/libc.mo", O_RDONLY) =3D -1 ENOE=
NT=20
(No such file or directory)
open("/usr/share/locale/en/LC_MESSAGES/libc.mo", O_RDONLY) =3D -1 ENOENT (N=
o=20
such file or directory)
write(2, ": Invalid argument", 18: Invalid argument)      =3D 18
write(2, "\n", 1
)                       =3D 1
exit_group(1)                           =3D ?
# echo $?
1
# cat /sys/block/md1/md/rd0/size=20
2097088


> to be sure there is no error return.

Hm, there seems to be some error, but i don't get it what it is.


> And maybe
>    blockdev --getsz /dev/xvda1

# blockdev --getsz /dev/xvda1
6291456


> and
>    blockdev --getsz /dev/xvda

There is no xvda! I use Xen and i can assign a logical volume directly to=20
xvda1, so i don't have to put a partition table on this block device! Perha=
ps=20
this is the error!?


> to double check that the block size looks right.

Yeah, the block size looks right.


> Are you sure the message didn't say "xvda: detected capacity change...",
> and you still need to change the size of the partition?

Yes, i'm sure and i used copy&paste, so no write error here. There is no xv=
da=20
because i can assign a logical volume direct to xvda1 inside my virtual xen=
=20
machine.

So i try to use partitions, assigning hole disks (xvdc and xvdd) to md1=20
doesn't work also. But with partitions i have the problem that=20
after "resizing" the partition, my partition xvdc1 seems to be not grown fr=
om=20
the view of the linux system:
# blockdev --getsz /dev/xvdc1
2088387
# blockdev --getsz /dev/xvdc
4194304
# fdisk -l /dev/xvdc

Disk /dev/xvdc: 2147 MB, 2147483648 bytes
255 heads, 63 sectors/track, 261 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/xvdc1               1         261     2096451   fd  Linux raid autodet=
ect


Is it possible that this raid1 grow only works with lvm?

Another note to
  echo 0 > /sys/block/md1/md/rd0/size
The first time after a grow it works only once, giving a return code of 0 a=
nd=20
no error message. And after that it will return:
# echo 0 > /sys/block/md1/md/rd0/size
=2Dbash: echo: write error: Invalid argument
# echo $?
1

Is this supposed to work only once (after a grow)? But also if it has a ret=
urn=20
code of 0 the value of /sys/block/md1/md/rd0/size doesn't change. Still=20
puzzled...

Which superblock version should i use for this grow? My live servers all ha=
ve=20
0.9 so i first try this with 0.9. But if you say this will only work with=20
1.0, 1.1 or 1.2 i'll try all this with this specific superblock version.

Any further ideas what i can try?

Many thanks in advance.


=2D-=20
greetings

eMHa

--nextPart3842982.p4AgFaLY26
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAku0unsACgkQXT3LE+AjWCsN9ACg7zltPd5zLgvVQeoUphyDJI9a
06UAn0goiMErrKgW3XUOcWwZQ4mRnsGg
=IDZy
-----END PGP SIGNATURE-----

--nextPart3842982.p4AgFaLY26--
