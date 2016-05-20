From: "John Stoffel" <john@stoffel.org>
Subject: Re: suggest disk numbers in a raidset?
Date: Fri, 20 May 2016 10:31:01 -0400
Message-ID: <22335.8101.224476.822021@quad.stoffel.home>
References: <CAC6SzHJ8Wi18opzDbzjtT+niM5QKOyOU3AAeo0npbDsV+sQOTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC6SzHJ8Wi18opzDbzjtT+niM5QKOyOU3AAeo0npbDsV+sQOTQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: d tbsky <tbskyd@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


d> I need to create a raid6 array with about 20 disks, and it need to
d> grow up in the future, maybe add another 20 disks into the array.

d> I wonder how many disks can a software raid6 array handled? the LSI
d> hardware raid (2208/3108) can only put 32 disks in an array, and I
d> heard it may be just use 16 disks in a array is better in LSI.

d> the system will be using to put NVR recording files, so the disk
d> speed is not very important.

I wouldn't even think of using hardware RAID in this situation, and
I'd also not think about maximizing the size of the RAID6 volumes as
well, due to rebuild speed penalty.  Another issue to think about is
chunk size as the number of members in a RAID array go up.  Say you
have the default 64k block size (number pulled from thin air...), so
you need to have N * 64K worth of data before you can write a full
stripe of data.  So as your writing data, you'll want to keep the
block size down.

But back to goal.  If you're writing large files, since I think NVR
refers to CCTV camera files, please correct me if wrong, you should
just stick with the defaults in terms of RAID defaults.

What I would do just just create a RAID6 array with 10 disks, so you
only have 8 x 4Tb of data, with two parity disks.  Then create another
RAID6 with the remainng 10 disks.  Then you would add them as PVs into
LVM, and then stripe acroos them.  Something like this:

  mdadm --create /dev/md100 --level 6 -n 10 -x 0 --bitmap=internal /dev/sd[cdefghijkl]1
  mdadm --create /dev/md101 --level 6 -n 10 -x 0 --bitmap=internal /dev/sd[mnopqrstuv]1

  pvcreate /dev/md100
  pvcreate /dev/md101

  # Since you want large space, make the extents use larger chunks here
  # in the VG.
  vgcreate -s 16 NVR /dev/md100 /dev/md101


  # Create a 30Tb volume...
  lvcreate -L 30T --name vol1 NVR

  # Make an XFS filesystem on the volume
  mkfs -t xfs /dev/mapper/NVR_vol1


So the entire idea of the above is that you expand things by doing:

  mdadm --create /dev/md102 --level 6 -n 10 -x 0 --bitmap=internal /dev/sda[cdefghijkl]1
  mdadm --create /dev/md103 --level 6 -n 10 -x 0 --bitmap=internal /dev/sda[mnopqrstuv]1

  pvcreate /dev/md102
  pvcreate /dev/md103

  vgextend NVR_data /dev/md102 /dev/md103

  lvresize -L +30T --resizefs /dev/mapper/NVR_vol1


And now you've grown your volume without any impact!  And you and
migrate LVs around and remove PVs (once empty) if you need to down the
line.  Very flexible.

This is one of the big downsides of using ZFS in my mind, once you've
added in a physical device, you can never shrink the filesystem, only
grow it.  Not that you mentioned using ZFS, but it's something to keep
in mind here.

But!!!  I'd also think seriously about making more smaller volumes and
having your software spread stuff out across multiple filesystems.
XFS is good, but I'd be leery of such a huge filesystem on a system
like this.

I'd want redundant power supplies, some hot spare disks, a UPS, and a
rock solid hardware with plenty of memory.  The other issue is that
unless you run a recent linux kernel, you might run into performance
problems with the RAID5/6 parity calculations being all done on a
single CPU core.  Newer versions should have fixed this, but I don't
recall the exact version right now.

Also, think about backups.  With this size of a system, backups are
going to be painful.... but maybe you don't care about backups of NVR
files past a certain time?

Good luck,
John
