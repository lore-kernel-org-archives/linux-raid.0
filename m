From: "Wade Pinkston" <blata@bugs.osu.edu>
Subject: raid not creating
Date: Fri, 27 Jan 2006 09:35:57 -0800 (PST)
Message-ID: <57285.192.55.52.1.1138383357.squirrel@bugs.osu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Using /dev/hda
(parted) p
Disk geometry for /dev/hda: 0.000-28629.562 megabytes
Disk label type: msdos
Minor    Start       End     Type      Filesystem  Flags
1          0.031    101.975  primary   ext3        boot
2        101.975  20104.782  primary   ext3
3      20104.783  28623.625  primary   ext3

Using /dev/hdc
(parted) p
Disk geometry for /dev/hdc: 0.000-28629.562 megabytes
Disk label type: msdos
Minor    Start       End     Type      Filesystem  Flags
1          0.031    101.975  primary   ext2        raid
2        101.975  20104.782  primary   ext2        raid
3      20104.783  28623.625  primary   ext2        raid

Disk geometry for /dev/hde: 0.000-95396.273 megabytes
Disk label type: msdos
Minor    Start       End     Type      Filesystem  Flags
1          0.031  60000.578  primary   ext3        raid
2      60000.579  61004.641  primary   linux-swap  raid
3      61004.641  95393.781  primary   ext3        raid

Disk geometry for /dev/hdg: 0.000-95396.273 megabytes
Disk label type: msdos
Minor    Start       End     Type      Filesystem  Flags
1          0.031  60000.578  primary   ext2        raid
2      60000.579  61004.641  primary   ext2
3      61004.641  95393.781  primary   ext3        raid


# mdadm --create --verbose /dev/md4 --level=1 --raid-devices=2 /dev/hde3
/dev/hdg3
mdadm: /dev/hde3 appears to contain an ext2fs file system
    size=35214480K  mtime=Thu Jan 26 13:38:20 2006
mdadm: /dev/hdg3 appears to contain an ext2fs file system
    size=35214480K  mtime=Thu Jan 26 13:38:20 2006
mdadm: size set to 35214400K
Continue creating array? y
mdadm: SET_ARRAY_INFO failed for /dev/md4: Device or resource busy

As you can see I have 4 drive.  I am trying to crate raid1 arrays using
these drives.  obviously its not working.  the suggestions I've found to
correct the mdadm error have said to build the array in init 1.  this has
not worked for me either.  all 5 md devices give this error.  I have tried
to force the array as well as building it with missing devices.  none of
witch have worked.  can anyone help with getting these arrays working?

thank for any assistance

--
Ipsa scienta protesta est
