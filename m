From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: File system corruption during setting new size (native/extarnal
 metatdat) after expansion
Date: Wed, 16 Feb 2011 15:24:53 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D178EC32BC@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

Hi,

I've met again array_size change problem. A while ago I've indicated it=
, during array expansion, file system corruption occurs.
The previous conclusion was that my tests were wrong (too small arrays,=
 on bigger arrays it seems to be ok),=20
I've got now reproduction in our lab on quite big arrays (250G) and on =
my small test arrays also.

This problem is related to array expansion using native and external me=
tadata.
=20
Problem is that after expansion file system on array is corrupted.
Operation that corrupts file system is array size change via sysfs (and=
 for native metadata during reshape finalization in md).
In logs I've got information:
	VFS: busy inodes on changed media or resized disks

My investigation in md goes to block_dev.c/inode.c and flush_disk() (ca=
lled from check_disk_size_change()).
I've found above text there (about busy inodes).=20
My traces shows that in __invalidate_inodes(), inode->i_count =3D=3D 2 =
and it is locked. This makes me to look how invalidate_inodes() is call=
ed.
Before invalidate_inodes() is called, cache is cleared by shrink_dcache=
_sb().
If I've commented shrink_dcache_sb() file system seems to be safe. It i=
s the same when invalidate_inodes() is commented (shrink_cache_sb() cal=
led only).
If I've changed functions order (1. invalidate_inodes(), 2. shrink_dcac=
he_sb()) in __invalidate_device() (block_dev.c) there is no corruption =
also.
When after shrink_dcache_sb() is called invalidate_inodes() on busy ino=
des corruption occurs (if it called earlier it doesn't matter).

This problem can be reproduced on mounted arrays only. If array is not =
mounted, file system corruption disappears.
This means that whole expansion process is correct.
In some cases (rarely) inodes on mounted device are not locked and then=
 FS corruption doesn't happened.


I'd like to know your opinion.
Do you think that problem is in releasing cache but not all inodes (bus=
y case), commands order...
=2E.. or probably changing size on mounted array is a mistake (for curr=
ent code)?

BR
Adam


---------------------------------
My test commands:=09

#create container
mdadm -C /dev/md/imsm0 -amd -e imsm -n 3 /dev/sdb /dev/sdc /dev/sde -R

#create volume
mdadm -C /dev/md/raid5vol_0 -amd -l 5 --chunk 64 --size 104857 -n 3 /de=
v/sdb /dev/sdc /dev/sde -R
mkfs /dev/md/raid5vol_0
mount /dev/md/raid5vol_0 /mnt/vol

#copy some files from current directory
cp * /mnt/vol

#add spare
mdadm --add /dev/md/imsm0 /dev/sdd

#start reshape
mdadm --grow /dev/md/imsm0 --raid-devices 4 --backup-file=3D/backup.bak


-------------------------------------------------------------
Intel Technology Poland Sp. z o.o.
email: adam.kwolek@intel.com=A0=A0=A0=20
phone: +48 58 766 1773


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
