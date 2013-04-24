From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: RAID50 boot problems
Date: Wed, 24 Apr 2013 14:29:39 +0200 (CEST)
Message-ID: <6325382.2.1366806579476.JavaMail.root@zimbra>
References: <20130424221219.5fa086e3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130424221219.5fa086e3@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Roman Mamedov <rm@romanrm.ru>, linux-raid <linux-raid@vger.kernel.org>, Alexander Zvyagin <zvyagin.alexander@gmail.com>
List-Id: linux-raid.ids

> Sorry, that should be --name, not --path.

roy@raidtest:~$ cat /proc/mdstat=20
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [r=
aid4] [raid10]=20
md0 : active raid5 vdc[1] vdb[0] vdd[3]
      2096000 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] [U=
UU]
     =20
md1 : active raid5 vdf[1] vdg[3] vde[0]
      2096000 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] [U=
UU]
     =20
unused devices: <none>
roy@raidtest:~$ udevadm info --query=3Dproperty --name=3D/dev/md0
DEVLINKS=3D/dev/disk/by-id/md-name-raidtest:0 /dev/disk/by-id/md-uuid-4=
4285c9c:70d2769c:24009302:979f89fd
DEVNAME=3D/dev/md0
DEVPATH=3D/devices/virtual/block/md0
DEVTYPE=3Ddisk
ID_FS_LABEL=3Draidtest:9
ID_FS_LABEL_ENC=3Draidtest:9
ID_FS_TYPE=3Dlinux_raid_member
ID_FS_USAGE=3Draid
ID_FS_UUID=3D7ca2b28e-c483-5ef8-29ab-e952221fd4cc
ID_FS_UUID_ENC=3D7ca2b28e-c483-5ef8-29ab-e952221fd4cc
ID_FS_UUID_SUB=3D6bc3d0db-9521-c852-cbc2-35b5c398d566
ID_FS_UUID_SUB_ENC=3D6bc3d0db-9521-c852-cbc2-35b5c398d566
ID_FS_VERSION=3D1.2
MAJOR=3D9
MD_DEVICES=3D3
MD_LEVEL=3Draid5
MD_METADATA=3D1.2
MD_NAME=3Draidtest:0
MD_UUID=3D44285c9c:70d2769c:24009302:979f89fd
MINOR=3D0
SUBSYSTEM=3Dblock
UDEV_LOG=3D3
USEC_INITIALIZED=3D2756441
roy@raidtest:~$ udevadm info --query=3Dproperty --name=3D/dev/md1
DEVLINKS=3D/dev/disk/by-id/md-name-raidtest:1 /dev/disk/by-id/md-uuid-8=
bd41f4b:080a965a:6b251afc:f4755b7a
DEVNAME=3D/dev/md1
DEVPATH=3D/devices/virtual/block/md1
DEVTYPE=3Ddisk
ID_FS_LABEL=3Draidtest:9
ID_FS_LABEL_ENC=3Draidtest:9
ID_FS_TYPE=3Dlinux_raid_member
ID_FS_USAGE=3Draid
ID_FS_UUID=3D7ca2b28e-c483-5ef8-29ab-e952221fd4cc
ID_FS_UUID_ENC=3D7ca2b28e-c483-5ef8-29ab-e952221fd4cc
ID_FS_UUID_SUB=3Db18fa133-148d-471d-4727-198072ad9dd9
ID_FS_UUID_SUB_ENC=3Db18fa133-148d-471d-4727-198072ad9dd9
ID_FS_VERSION=3D1.2
MAJOR=3D9
MD_DEVICES=3D3
MD_LEVEL=3Draid5
MD_METADATA=3D1.2
MD_NAME=3Draidtest:1
MD_UUID=3D8bd41f4b:080a965a:6b251afc:f4755b7a
MINOR=3D1
SUBSYSTEM=3Dblock
UDEV_LOG=3D3
USEC_INITIALIZED=3D2760291
roy@raidtest:~$=20

> Can you put your initrd (or initramfs or whatever Ubuntu calls it)
> somewhere
> that I can down load it? Or just email it to me, it's probably only
> about 10Meg.

Here are the ones for 12.04 x86 and 13.04 amd64. The same happen on bot=
h

12.04 http://karlsbakk.net/tmp/initrd.img-3.2.0-40-generic-pae
13.04 http://karlsbakk.net/tmp/initrd.img-3.8.0-19-generic

Thanks!

Vennlige hilsener / Best regards

roy
--
Roy Sigurd Karlsbakk
(+47) 98013356
roy@karlsbakk.net
http://blogg.karlsbakk.net/
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
--
I all pedagogikk er det essensielt at pensum presenteres intelligibelt.=
 Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5=
 eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste tilf=
eller eksisterer adekvate og relevante synonymer p=C3=A5 norsk.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
