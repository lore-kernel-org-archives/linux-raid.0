From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: Problem with changing array_size
Date: Wed, 31 Mar 2010 10:29:13 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D11C5E2964@irsmsx503.ger.corp.intel.com>
References: <905EDD02F158D948B186911EB64DB3D11C584B56@irsmsx503.ger.corp.intel.com>
 <e9c3a7c21003301513l48cb89d7g48c5e0a0742ef043@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c21003301513l48cb89d7g48c5e0a0742ef043@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On
> Behalf Of Dan Williams
> Sent: Wednesday, March 31, 2010 12:14 AM
> To: Kwolek, Adam
> Cc: Neil Brown; linux-raid@vger.kernel.org; Ciechanowski, Ed
> Subject: Re: Problem with changing array_size
>=20
> On Tue, Mar 30, 2010 at 6:53 AM, Kwolek, Adam <adam.kwolek@intel.com>
> wrote:
> > I found that setting new raid volume size using array_size entry in
> sysfs causes that inode references in vfs can be lost.
> >
> > Conditions:
> > =A0SLES 11 (32bit) machine with
> > =A0 =A0 =A0 =A0kernel: 2.6.33
> > =A0 =A0 =A0 =A0mdadm : 3.1.2
> > =A05 SATA hdds in system:
> > =A0 =A0 =A0 =A0SLES 11 on =A0 /dev/sda
> > =A0 =A0 =A0 =A04 test disks /dev/hdb - /dev/hde
> >
> > Reproduction:
> > 1. Configure:
> > =A0 =A0 =A0 =A0# create native raid5 volume, with specified size (r=
elatively
> small)
> > =A0 =A0 =A0 =A0mdadm -C /dev/md/raid5vol_0 -amd -l 5 --chunk 64 --s=
ize 104857
> -n 3 /dev/sdb /dev/sdc /dev/sde -R
> >
> > =A0 =A0 =A0 =A0# Create file system
> > =A0 =A0 =A0 =A0mkfs /dev/md/raid5vol_0
> >
> > =A0 =A0 =A0 =A0# mount it and copy some files there
> > =A0 =A0 =A0 =A0mount /dev/md/raid5vol_0 /mnt/vol
> > =A0 =A0 =A0 =A0cp * /mnt/vol
> >
> > 2. Try to change volume size. This should affect volume, but not vf=
s
> > =A0 =A0 =A0 =A0echo "157285" >/sys/block/md127/md/array_size
>=20
> Of course this affects the filesystem.  You have reduced the size of
> the volume from 209,664KB to 157,285KB.  Perhaps you are confusing th=
e
> --size parameter to mdadm (which is per member) and the md/array_size
> attribute which is the total volume size??
>=20
>=20
> > In the few tries (maybe at first shot) you would probably find that
> when you are trying to execute ls command on mounted volume message i=
n
> user space appears:
> > =A0 =A0 =A0 =A0ls: cannot access 'copied file name': Input/output e=
rror
> > In kernel space messages can be found:
> > =A0In response to size change:
> > =A0 =A0 =A0 =A0Mar 30 16:27:03 linux kernel: md127: detected capaci=
ty change
> from 214695936 to 161059840
> > =A0 =A0 =A0 =A0Mar 30 16:27:03 linux kernel: VFS: busy inodes on ch=
anged
> media or resized disk md127
>=20
> Yes, the filesystem is horribly confused at this point because 50MB o=
f
> space has disappeared.
>=20
> --
> Dan


OK, you are right. This was not the best example - my mistake, but I've=
 got another ;), I hope better.
To real array size increase, grow has to be used (everything for native=
 meta case as previously).

1. Configure (part 1 - the same as before):
	#create volume
	mdadm -C /dev/md/raid5vol_0 -amd -l 5 --chunk 64 --size 104857 -n 3 /d=
ev/sdb /dev/sdc /dev/sde -R

	#create filesystem
	mkfs /dev/md/raid5vol_0

	# mount it and copy some files there
	mount /dev/md/raid5vol_0 /mnt/vol
	cp * /mnt/vol

2. Configure (part 2 - additions)
	#add spare to be ready for OLCE
	mdadm --add /dev/md/raid5vol_0 /dev/sdd

	#set the array_size  to value reported by mdstat,=20
	#to switch to external array size management (in md.c mddev->external_=
size variable is set)
	#   if both size set are removed - result is the same
	echo "209664" >/sys/block/md127/md/array_size

	#start reshape to add spare to array (OLCE on native meta)
	mdadm --grow /dev/md/raid5vol_0 --raid-devices 4 --backup-file=3D/back=
up_file994.bak

3. Size changes
	#after reshape vfs is ok, but now ...
	#set size to value that is set when md increases array size	itself
	echo "314496" >/sys/block/md127/md/array_size



mdstats output before and after reshape are:

Before reshape:
	Personalities : [raid6] [raid5] [raid4]=20
	md127 : active raid5 sdd[4](S) sde[3] sdc[1] sdb[0]
      	209664 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] [U=
UU]
     =20
	unused devices: <none>


After reshape:
	Personalities : [raid6] [raid5] [raid4]=20
	md127 : active raid5 sdd[4] sde[3] sdc[1] sdb[0]
      	314496 blocks super 1.2 level 5, 64k chunk, algorithm 2 [4/4] [U=
UUU]
     =20
	unused devices: <none>

The result is the same as in previous example - file system is lost.
The operations with array_size in example are only for demonstration wh=
at operation is the problem cause.=20
Without those 2 operation (mddev->external_size is not set in md), vfs =
is corrupted also just after reshape (in md during setting size in raid=
5_finish_reshape()).=20
With both array_size set operations just after reshape vfs is ok, incre=
asing size kills vfs.

BR
Adam
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
