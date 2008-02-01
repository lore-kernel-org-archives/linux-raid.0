From: Berni <wstripes@gmx.at>
Subject: Re: raid problem: after every reboot /dev/sdb1 is removed?
Date: Fri, 1 Feb 2008 18:22:36 +0100
Message-ID: <20080201182236.3506dd33@berni>
References: <20080201135220.617194ff@berni>
	<29a863790802010546x31198785p154aa247734b7b33@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <29a863790802010546x31198785p154aa247734b7b33@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Cormier <gcormier@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

So I deleted all partitions on the second hdd and copied the partition =
table from the first one. After that I made a resync.=20
After a reboot - the sda1 was removed (in past it was the sdb1) _U
After a second reboot the sda1 again is missing. U_

It looks like only one of them can stay in the /dev/md0 raid.=20

Could it be a problem with reiserfs?=20
Or that the (sda1,sdb1) are prim=C3=A4r partitions?=20

thanks
berni

On Fri, 1 Feb 2008 08:46:43 -0500
"Greg Cormier" <gcormier@gmail.com> wrote:

> I had the same problem.
>=20
> Re-doing the partition from ext2 to linux raid fixed my problem, but =
I
> see you're already using that FS type.
>=20
> Maybe it was the action of re-partitioning in general that fixed my
> problem? You could try deleting it and re-creating that partition,
> syncing, and rebooting?
>=20
> Greg
>=20
> On Fri, Feb 1, 2008 at 7:52 AM, Berni <wstripes@gmx.at> wrote:
> > Hi!
> >
> >  I have the following problem with my softraid (raid 1). I'm runnin=
g
> >  Ubuntu 7.10 64bit with kernel 2.6.22-14-generic.
> >
> >  After every reboot my first boot partition in md0 is not synchron.=
 One
> >  of the disks (the sdb1) is removed.
> >  After a resynch every partition is synching. But after a reboot th=
e
> >  state is "removed".
> >
> >  The disks are new and both seagate 250gb with exactly the same par=
tition table.
> >
> >  Here some config files:
> >
> >  #cat /proc/mdstat
> >  Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid=
5]
> >  [raid4] [raid10]
> >  md2 : active raid1 sda6[0] sdb6[1]
> >       117185984 blocks [2/2] [UU]
> >
> >  md1 : active raid1 sda5[0] sdb5[1]
> >       1951744 blocks [2/2] [UU]
> >
> >  md0 : active raid1 sda1[0]
> >       19534912 blocks [2/1] [U_]        <<<<<<<< this is the proble=
m: looks like U_ after reboot
> >
> >  unused devices: <none>
> >
> >  #fdisk /dev/sda
> >   Device Boot      Start         End      Blocks   Id  System
> >  /dev/sda1               1        2432    19535008+  fd  Linux raid
> >  autodetect
> >  /dev/sda2            2433       17264   119138040    5  Extended
> >  /dev/sda3   *       17265       20451    25599577+   7  HPFS/NTFS
> >  /dev/sda4           20452       30400    79915342+   7  HPFS/NTFS
> >  /dev/sda5            2433        2675     1951866   fd  Linux raid
> >  autodetect
> >  /dev/sda6            2676       17264   117186111   fd  Linux raid
> >  autodetect
> >
> >  #fdisk /dev/sdb
> >   Device Boot      Start         End      Blocks   Id  System
> >  /dev/sdb1               1        2432    19535008+  fd  Linux raid
> >  autodetect
> >  /dev/sdb2            2433       17264   119138040    5  Extended
> >  /dev/sdb3           17265       30400   105514920    7  HPFS/NTFS
> >  /dev/sdb5            2433        2675     1951866   fd  Linux raid
> >  autodetect
> >  /dev/sdb6            2676       17264   117186111   fd  Linux raid
> >  autodetect
> >
> >  # mount
> >  /dev/md0 on / type reiserfs (rw,notail)
> >  proc on /proc type proc (rw,noexec,nosuid,nodev)
> >  /sys on /sys type sysfs (rw,noexec,nosuid,nodev)
> >  varrun on /var/run type tmpfs (rw,noexec,nosuid,nodev,mode=3D0755)
> >  varlock on /var/lock type tmpfs (rw,noexec,nosuid,nodev,mode=3D177=
7)
> >  udev on /dev type tmpfs (rw,mode=3D0755)
> >  devshm on /dev/shm type tmpfs (rw)
> >  devpts on /dev/pts type devpts (rw,gid=3D5,mode=3D620)
> >  lrm on /lib/modules/2.6.22-14-generic/volatile type tmpfs (rw)
> >  /dev/md2 on /home type reiserfs (rw)
> >  securityfs on /sys/kernel/security type securityfs (rw)
> >
> >  Could anyone help me to solve this problem?
> >  thanks
> >  greets
> >  Berni
> >  -
> >  To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
> >  the body of a message to majordomo@vger.kernel.org
> >  More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
