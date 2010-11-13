From: Mike Viau <viaum@sheridanc.on.ca>
Subject: (unknown)
Date: Sat, 13 Nov 2010 01:01:47 -0500
Message-ID: <BAY148-w34F1B0624B57B12374AC90EF340@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <bounce-debian-user=gldu-debian-user-2=m.gmane.org@lists.debian.org>
Sender: <xtreme911@msn.com>
Subject: 
Resent-Message-ID: <jc_5DC12QBB.A.P7G.Ioi3MB@liszt>
List-Post: <mailto:debian-user@lists.debian.org>
List-Help: <mailto:debian-user-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-user-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-user-request@lists.debian.org?subject=unsubscribe>
To: linux-raid@vger.kernel.org
Cc: debian-user@lists.debian.org
List-Id: linux-raid.ids


Hello=2C

I am trying to re-setup my fake-raid (RAID1) volume with LVM2 like setup pr=
eviously. I had been using dmraid on a Lenny installation which gave me (fr=
om memory) a block device like /dev/mapper/isw_xxxxxxxxxxx_ and also a /dev=
/One1TB=2C but have discovered that the mdadm has replaced the older and be=
lieved to be obsolete dmraid for multiple disk/raid support.

Automatically the fake-raid LVM physical volume does not seem to be set up.=
 I believe my data is safe as I can insert a knoppix live-cd in the system =
and mount the fake-raid volume (and browse the files). I am planning on per=
haps purchasing another at least 1TB drive to backup the data before trying=
 to much fancy stuff with mdadm in fear of loosing the data.

A few commands that might shed more light on the situation:


pvdisplay (showing the /dev/md/[device] not recognized yet by LVM2=2C note =
sdc another single drive with LVM)

  --- Physical volume ---
  PV Name               /dev/sdc7
  VG Name               XENSTORE-VG
  PV Size               46.56 GiB / not usable 2.00 MiB
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              11920
  Free PE               0
  Allocated PE          11920
  PV UUID               wRa8xM-lcGZ-GwLX-F6bA-YiCj-c9e1-eMpPdL


cat /proc/mdstat (showing what mdadm shows/discovers)

Personalities :
md127 : inactive sda[1](S) sdb[0](S)
      4514 blocks super external:imsm

unused devices:=20


ls -l /dev/md/imsm0 (showing contents of /dev/md/* [currently only one file=
/link ])

lrwxrwxrwx 1 root root 8 Nov  7 08:07 /dev/md/imsm0 -> ../md127


ls -l /dev/md127 (showing the block device)

brw-rw---- 1 root disk 9=2C 127 Nov  7 08:07 /dev/md127




It looks like I can not even access the md device the system created on boo=
t.=20

Does anyone have a guide or tips to migrating from the older dmraid to mdad=
m for fake-raid?


fdisk -uc /dev/md127=A0 (showing the block device is inaccessible)

Unable to read /dev/md127


dmesg (pieces of dmesg/booting)

[=A0=A0=A0 4.214092] device-mapper: uevent: version 1.0.3
[=A0=A0=A0 4.214495] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initia=
lised: dm-devel@redhat.com
[=A0=A0=A0 5.509386] udev[446]: starting version 163
[=A0=A0=A0 7.181418] md: md127 stopped.
[=A0=A0=A0 7.183088] md: bind<sdb>
[=A0=A0=A0 7.183179] md: bind<sda>



update-initramfs -u (Perhaps the most interesting error of them all=2C I ca=
n confirm this occurs with a few different kernels)

update-initramfs: Generating /boot/initrd.img-2.6.32-5-xen-amd64
mdadm: cannot open /dev/md/OneTB-RAID1-PV: No such file or directory


Revised my information=2C inital thread on Debian-users thread at:
http://lists.debian.org/debian-user/2010/11/msg01015.html

Thanks for any ones help :)

-M
 		 	   		  =
