From: =?ISO-8859-1?Q?G=FCnther_J=2E?= Niederwimmer <gjn@gjn.priv.at>
Subject: Re: Hello,Re: GPT Table broken on a Raid1
Date: Mon, 24 Sep 2012 21:06:51 +0200
Message-ID: <3192749.CyYuocktFM@techz>
References: <4961154.0TR9MeFlIq@techz> <4838005.Z2kBBljtsi@techz> <2F14DB42-E5C0-43F1-9EE6-CA4859F39756@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2F14DB42-E5C0-43F1-9EE6-CA4859F39756@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Chris,

Am Montag, 24. September 2012, 11:21:35 schrieb Chris Murphy:
> On Sep 24, 2012, at 1:28 AM, G=FCnther J. Niederwimmer wrote:
> > Model: ATA ST3320620AS (scsi)
> > Disk /dev/sda: 320GB
> > Sector size (logical/physical): 512B/512B
> > Partition Table: gpt_sync_mbr
>=20
> Interesting. Parted thinks this disk has a hybrid MBR. G=FCnther, wha=
t is the
> result from:
>=20
> fdisk -l /dev/sda

WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util fd=
isk=20
doesn't support GPT. Use GN Parted.


Disk /dev/sda: 320.1 GB, 320072933376 bytes
256 K=F6pfe, 63 Sektoren/Spur, 38761 Zylinder, zusammen 625142448 Sekto=
ren
Einheiten =3D Sektoren von 1 =D7 512 =3D 512 Bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Ger=E4t  boot.     Anfang        Ende     Bl=F6cke   Id  System
/dev/sda1               1  4294967295  2147483647+  ee  GPT



> And one more, I'd like to see the result from:
> mount

devtmpfs on /dev type devtmpfs=20
(rw,relatime,size=3D12354704k,nr_inodes=3D3088676,mode=3D755)
tmpfs on /dev/shm type tmpfs (rw,relatime)
tmpfs on /run type tmpfs (rw,nosuid,nodev,relatime,mode=3D755)
devpts on /dev/pts type devpts (rw,relatime,gid=3D5,mode=3D620,ptmxmode=
=3D000)
/dev/sde2 on / type btrfs (rw,relatime,ssd,space_cache)
proc on /proc type proc (rw,relatime)
sysfs on /sys type sysfs (rw,relatime)
tmpfs on /sys/fs/cgroup type tmpfs (rw,nosuid,nodev,noexec,relatime,mod=
e=3D755)
cgroup on /sys/fs/cgroup/systemd type cgroup=20
(rw,nosuid,nodev,noexec,relatime,release_agent=3D/lib/systemd/systemd-c=
groups-
agent,name=3Dsystemd)
cgroup on /sys/fs/cgroup/cpuset type cgroup=20
(rw,nosuid,nodev,noexec,relatime,cpuset)
cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup=20
(rw,nosuid,nodev,noexec,relatime,cpuacct,cpu)
cgroup on /sys/fs/cgroup/memory type cgroup=20
(rw,nosuid,nodev,noexec,relatime,memory)
cgroup on /sys/fs/cgroup/devices type cgroup=20
(rw,nosuid,nodev,noexec,relatime,devices)
cgroup on /sys/fs/cgroup/freezer type cgroup=20
(rw,nosuid,nodev,noexec,relatime,freezer)
cgroup on /sys/fs/cgroup/net_cls type cgroup=20
(rw,nosuid,nodev,noexec,relatime,net_cls)
cgroup on /sys/fs/cgroup/blkio type cgroup=20
(rw,nosuid,nodev,noexec,relatime,blkio)
cgroup on /sys/fs/cgroup/perf_event type cgroup=20
(rw,nosuid,nodev,noexec,relatime,perf_event)
systemd-1 on /proc/sys/fs/binfmt_misc type autofs=20
(rw,relatime,fd=3D31,pgrp=3D1,timeout=3D300,minproto=3D5,maxproto=3D5,d=
irect)
tmpfs on /var/lock type tmpfs (rw,nosuid,nodev,relatime,mode=3D755)
tmpfs on /var/run type tmpfs (rw,nosuid,nodev,relatime,mode=3D755)
tmpfs on /media type tmpfs (rw,nosuid,nodev,noexec,relatime,mode=3D755)
debugfs on /sys/kernel/debug type debugfs (rw,relatime)
hugetlbfs on /dev/hugepages type hugetlbfs (rw,relatime)
securityfs on /sys/kernel/security type securityfs (rw,relatime)
mqueue on /dev/mqueue type mqueue (rw,relatime)
/dev/sde1 on /boot/efi type vfat=20
(rw,relatime,fmask=3D0002,dmask=3D0002,allow_utime=3D0020,codepage=3Dcp=
437,iocharset=3Diso8859-1,shortname=3Dmixed,utf8,errors=3Dremount-
ro)
fusectl on /sys/fs/fuse/connections type fusectl (rw,relatime)
/dev/sdd2 on /data1 type ext4 (rw,relatime,data=3Dordered)
/dev/sdc1 on /data type ext4 (rw,relatime,data=3Dordered)
/dev/md126p4 on /windows/D type fuseblk=20
(rw,nosuid,nodev,noexec,relatime,user_id=3D0,group_id=3D0,default_permi=
ssions,allow_other,blksize=3D4096)
/dev/md126p5 on /windows/E type fuseblk=20
(rw,nosuid,nodev,noexec,relatime,user_id=3D0,group_id=3D0,default_permi=
ssions,allow_other,blksize=3D4096)
/dev/md126p6 on /home type ext4 (rw,relatime,data=3Dordered)
/dev/md126p3 on /windows/C type fuseblk=20
(rw,nosuid,nodev,noexec,relatime,user_id=3D0,group_id=3D0,default_permi=
ssions,allow_other,blksize=3D4096)
rpc_pipefs on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw,relatime)
bbs:/data1/ on /datas1 type nfs=20
(rw,relatime,vers=3D3,rsize=3D262144,wsize=3D262144,namlen=3D255,hard,p=
roto=3Dtcp,timeo=3D600,retrans=3D2,sec=3Dsys,mountaddr=3D192.168.100.20=
0,mountvers=3D3,mountport=3D1516,mountproto=3Dudp,local_lock=3Dnone,add=
r=3D192.168.100.200)
bbs:/data2/ on /datas2 type nfs=20
(rw,relatime,vers=3D3,rsize=3D262144,wsize=3D262144,namlen=3D255,hard,p=
roto=3Dtcp,timeo=3D600,retrans=3D2,sec=3Dsys,mountaddr=3D192.168.100.20=
0,mountvers=3D3,mountport=3D1516,mountproto=3Dudp,local_lock=3Dnone,add=
r=3D192.168.100.200)
none on /var/lib/ntp/proc type proc (ro,nosuid,nodev,relatime)
gvfs-fuse-daemon on /run/user/gjn/gvfs type fuse.gvfs-fuse-daemon=20
(rw,nosuid,nodev,relatime,user_id=3D1000,group_id=3D100


>=20
> I want to make sure nothing is directly mounting sda or sdb.

OK
=20
> > But the good thing from this, Grub2 found my Windows 7 Installation=
 on the
> > Raid1 and Make a Start Entry, with mdadm this is not working, Grub2=
 don't
> > found the windows?
>=20
> Let's do one thing at a time. We don't even really have the basics co=
vered
> yet. I am not able to reproduce your problem where the kernel and par=
ted
> complain about the alternate GPT header not being at the end of the d=
isk.
> I'm using kernel 3.5.3-1.fc17 and mdadm 3.2.5.

OK Chris ;)=20

Thanks for the help,
--=20
mit freundlichen Gr=FC=DFen / best Regards.

  G=FCnther J. Niederwimmer
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
