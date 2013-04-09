From: =?UTF-8?Q?Rog=C3=A9rio_Brito?= <rbrito@ime.usp.br>
Subject: Converting a regular (non-RAID) HD into a (degraded) RAID 1
 installation in-place
Date: Tue, 9 Apr 2013 17:24:17 -0300
Message-ID: <CAOtrxKNxLDDOkD-9A-1fxPO-SGH97ZBMWt0aG5Eej7osx73LnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear people,

I've been trying to play around with the conversion of a regular
(non-RAID) 2 TB HD that is almost full to "convert it" into a RAID-1
array.

Of course, I have still not played with the real HD, but I am doing
experiments with disk images (mounted as a loopback device) and I am
surprised to find next to no information about this with more than 3
days of searches (or maybe my google-fu is not very good these days).

While it is said to be risky and so on, I want to prevent creating an
empty (degraded) RAID 1 array with a new HD, moving data to this array
from the original drive that I have and, then, plugging the original
drive into the array to see the data copied once more.

Just to make it clear, the HD that want to be part of a RAID 1 array
is *not* a boot device, which means that I don't really care about
GRUB or any other bootloader. It's purpose in life will be to hold
backups (which, in the future, I may reshape when adding more drives,
but not now).

The only reference that I found that mentioned this in-place
conversion was Debian's recipes [0] for mdadm, but it didn't work, as
the original block device (which cointained a pre-populated ext4
filesystem) couldn't be mounted when used in its md format.

Concretely, what I have been doing is:

    mdadm --create /dev/md0 --level=3D1 --raid-devices=3D2 --force
/dev/mapper/loop0p1 missing

where /dev/mapper/loop0p1 is just a regular ext4 filesystem. The array
md0 is created and everything in /proc/mdstat looks fine, but the
command:

    mount -t ext4 /dev/md0 /mnt

doesn't work, saying that:

    mount: wrong fs type, bad option, bad superblock on /dev/md0,
               missing codepage or helper program, or other error
               In some cases useful info is found in syslog - try
               dmesg | tail  or so

If my suspicion is correct, the problem seems to be with the md
metadata overwriting some part of the ext4 filesystem. I have made
sure that the partition /dev/mapper/loop0p1 starts at 1MB after the
beginning of the device /dev/loop0 *and* that there is a lot (many
megabytes) of space after the partition, but before the end of the
device.

I have tried metadata versions 0.9, 1.0, 1.1 and 1.2, all with the
same result. I could only see the previous data that I put in the
filesystem when I created an md device with no metadata (that is, with
--build instead of --create), but that's clearly suboptimal and I
would like to avoid that.

The documentation (man md) relating to the position of the metadata
version 1.2 says that the superblock is positioned at "4KB of from the
start of the device", but is that 4KB *before* the start of the device
(in which case the metadata would fit in the hole between the
MBR/partition table and the beginning of the partition) or 4KB *after*
the beginning of the device (which I think would, indeed, mess with
ext4's bookkeeping information).

I would like to understand better this situation and I can provide all
the details (commands) that I tried so far.

Thank you very much for any help,

Rog=C3=A9rio Brito.


[0]: http://git.debian.org/?p=3Dpkg-mdadm/mdadm.git;a=3Dblob;f=3Ddebian=
/README.recipes;hb=3DHEAD

--=20
Rog=C3=A9rio Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFC=
AAAA
http://rb.doesntexist.org/blog : Projects : https://github.com/rbrito/
DebianQA: http://qa.debian.org/developer.php?login=3Drbrito%40ime.usp.b=
r
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
