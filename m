From: Andy Smith <andy@strugglers.net>
Subject: grub-probe: "found two disks with the index 3 for RAID md2" after
 changing superblock 0.9 to 1.0
Date: Mon, 15 Sep 2014 06:47:41 +0000
Message-ID: <20140915064741.GH11855@bitfolk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

During the process of shrinking the number of devices in a raid-10
array from 6 down to 4=B9, I needed to upgrade the superblock from 0.9
to 1.0.

Now, when I run grub-probe on that host it gives me complaints like
this:

    error: found two disks with the index 3 for RAID md2.
    error: superfluous RAID member (6 found).

(many times over)

Searching around I learn that it may be because grub looks at the
end of the disk and finds an md superblock but cannot tell if it is
for the entire disk or for the final partition on the disk:

    http://savannah.gnu.org/bugs/index.php?34250

In my case, I have four disks sda to sdd all of which have three
partitions on them, and md2 is composed of the third (last)
partition.

    $ cat /proc/mdstat=20
    Personalities : [raid1] [raid10]=20
    md2 : active raid10 sdd3[0] sdb3[3] sdc3[4] sda3[5]
          618726528 blocks super 1.0 64K chunks 2 near-copies [4/4] [UU=
UU]

    md1 : active raid10 sda2[0] sdd2[3] sdc2[2] sdb2[1]
          5874688 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUU=
U]

    md0 : active raid1 sdd1[0] sdc1[3] sdb1[2] sda1[1]
          256896 blocks [4/4] [UUUU]

    unused devices: <none>

The thing is, that bug report is quite old and is marked closed, and
also states:

    "The problem is that 0.9x metadata block doesn't have enough
    info to check it. With 1.x we have no such problem."

Of course, it *is* 1.x superblock. Did the poster actually mean to
say that they have no problem with v1.1 and v1.2 (because they are
located at or near the beginning of the device, not at the end)?

The host is Debian wheezy with grub-pc package version
1.99-27+deb7u2 so if that bug is closed due to a fix, I would expect
to have it by now.

There is also a Debian bug bearing some similarity, and that is also
marked fixed upstream and references the above Gnu bug report.

    https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D620390

The host still boots but that may be because md2 is not involved in
booting anyway.

Do other people experience this?

Is it unavoidable with v1.0 superblock?

If so, is there any way to convert to 1.1 or 1.2 without recreating
the array?

Verbose grub-probe output is appended.

Cheers,
Andy

=B9 The thread describing that is here:
  http://marc.info/?l=3Dlinux-raid&m=3D140881268031291&w=3D2

$ sudo grub-probe --target=3Dfs -v /boot/grub
grub-probe: info: Scanning for dmraid_nv RAID devices on disk hd0.
grub-probe: info: the size of hd0 is 625134827.
grub-probe: info: the size of hd0 is 625134827.
grub-probe: info: Scanning for dmraid_nv RAID devices on disk hd1.
grub-probe: info: the size of hd1 is 625134827.
grub-probe: info: the size of hd1 is 625134827.
grub-probe: info: Scanning for dmraid_nv RAID devices on disk hd2.
grub-probe: info: the size of hd2 is 625142448.
grub-probe: info: the size of hd2 is 625142448.
grub-probe: info: Scanning for dmraid_nv RAID devices on disk hd3.
grub-probe: info: the size of hd3 is 625134827.
grub-probe: info: the size of hd3 is 625134827.
grub-probe: info: Scanning for dmraid_nv RAID devices on disk hd4.
grub-probe: info: the size of hd4 is 625134827.
grub-probe: info: the size of hd4 is 625134827.
grub-probe: info: Scanning for dmraid_nv RAID devices on disk hd5.
grub-probe: info: the size of hd5 is 976773168.
grub-probe: info: the size of hd5 is 976773168.
grub-probe: info: Scanning for dmraid_nv RAID devices on disk hd6.
grub-probe: info: the size of hd6 is 3907029168.
grub-probe: info: the size of hd6 is 3907029168.
grub-probe: info: Scanning for dmraid_nv RAID devices on disk hd7.
grub-probe: info: the size of hd7 is 5860533168.
grub-probe: info: the size of hd7 is 5860533168.
grub-probe: info: Scanning for dmraid_nv RAID devices on disk hd8.
grub-probe: info: the size of hd8 is 3907029168.
grub-probe: info: the size of hd8 is 3907029168.
grub-probe: info: Scanning for dmraid_nv RAID devices on disk hd9.
grub-probe: info: the size of hd9 is 3907029168.
grub-probe: info: the size of hd9 is 3907029168.
grub-probe: info: Scanning for dmraid_nv RAID devices on disk hd10.
grub-probe: info: the size of hd10 is 976773168.
grub-probe: info: the size of hd10 is 976773168.
grub-probe: info: Scanning for dmraid_nv RAID devices on disk hd11.
grub-probe: info: the size of hd11 is 5860533168.
grub-probe: info: the size of hd11 is 5860533168.
grub-probe: info: scanning hd0 for LVM.
grub-probe: info: the size of hd0 is 625134827.
grub-probe: info: no LVM signature found.
grub-probe: info: the size of hd0 is 625134827.
grub-probe: info: scanning hd1 for LVM.
grub-probe: info: the size of hd1 is 625134827.
grub-probe: info: no LVM signature found.
grub-probe: info: the size of hd1 is 625134827.
grub-probe: info: scanning hd2 for LVM.
grub-probe: info: the size of hd2 is 625142448.
grub-probe: info: no LVM signature found.
grub-probe: info: the size of hd2 is 625142448.
grub-probe: info: scanning hd3 for LVM.
grub-probe: info: the size of hd3 is 625134827.
grub-probe: info: no LVM signature found.
grub-probe: info: the size of hd3 is 625134827.
grub-probe: info: scanning hd4 for LVM.
grub-probe: info: the size of hd4 is 625134827.
grub-probe: info: no LVM signature found.
grub-probe: info: the size of hd4 is 625134827.
grub-probe: info: scanning hd5 for LVM.
grub-probe: info: the size of hd5 is 976773168.
grub-probe: info: no LVM signature found.
grub-probe: info: the size of hd5 is 976773168.
grub-probe: info: scanning hd6 for LVM.
grub-probe: info: the size of hd6 is 3907029168.
grub-probe: info: no LVM signature found.
grub-probe: info: the size of hd6 is 3907029168.
grub-probe: info: scanning hd7 for LVM.
grub-probe: info: the size of hd7 is 5860533168.
grub-probe: info: no LVM signature found.
grub-probe: info: the size of hd7 is 5860533168.
grub-probe: info: scanning hd8 for LVM.
grub-probe: info: the size of hd8 is 3907029168.
grub-probe: info: no LVM signature found.
grub-probe: info: the size of hd8 is 3907029168.
grub-probe: info: scanning hd9 for LVM.
grub-probe: info: the size of hd9 is 3907029168.
grub-probe: info: no LVM signature found.
grub-probe: info: the size of hd9 is 3907029168.
grub-probe: info: scanning hd10 for LVM.
grub-probe: info: the size of hd10 is 976773168.
grub-probe: info: no LVM signature found.
grub-probe: info: the size of hd10 is 976773168.
grub-probe: info: scanning hd11 for LVM.
grub-probe: info: the size of hd11 is 5860533168.
grub-probe: info: no LVM signature found.
grub-probe: info: the size of hd11 is 5860533168.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd0.
grub-probe: info: the size of hd0 is 625134827.
grub-probe: info: the size of hd0 is 625134827.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd1.
grub-probe: info: the size of hd1 is 625134827.
grub-probe: info: the size of hd1 is 625134827.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd2.
grub-probe: info: the size of hd2 is 625142448.
grub-probe: info: the size of hd2 is 625142448.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd3.
grub-probe: info: the size of hd3 is 625134827.
grub-probe: info: the size of hd3 is 625134827.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd4.
grub-probe: info: the size of hd4 is 625134827.
grub-probe: info: the size of hd4 is 625134827.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd5.
grub-probe: info: the size of hd5 is 976773168.
grub-probe: info: the size of hd5 is 976773168.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd6.
grub-probe: info: the size of hd6 is 3907029168.
grub-probe: info: the size of hd6 is 3907029168.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd7.
grub-probe: info: the size of hd7 is 5860533168.
grub-probe: info: the size of hd7 is 5860533168.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd8.
grub-probe: info: the size of hd8 is 3907029168.
grub-probe: info: the size of hd8 is 3907029168.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd9.
grub-probe: info: the size of hd9 is 3907029168.
grub-probe: info: the size of hd9 is 3907029168.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd10.
grub-probe: info: the size of hd10 is 976773168.
grub-probe: info: the size of hd10 is 976773168.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd11.
grub-probe: info: the size of hd11 is 5860533168.
grub-probe: info: the size of hd11 is 5860533168.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd0.
grub-probe: info: the size of hd0 is 625134827.
grub-probe: info: the size of hd0 is 625134827.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd1.
grub-probe: info: the size of hd1 is 625134827.
grub-probe: info: the size of hd1 is 625134827.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd2.
grub-probe: info: the size of hd2 is 625142448.
grub-probe: info: the size of hd2 is 625142448.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd3.
grub-probe: info: the size of hd3 is 625134827.
grub-probe: info: the size of hd3 is 625134827.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd4.
grub-probe: info: the size of hd4 is 625134827.
grub-probe: info: the size of hd4 is 625134827.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd5.
grub-probe: info: the size of hd5 is 976773168.
grub-probe: info: the size of hd5 is 976773168.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd6.
grub-probe: info: the size of hd6 is 3907029168.
grub-probe: info: the size of hd6 is 3907029168.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd7.
grub-probe: info: the size of hd7 is 5860533168.
grub-probe: info: the size of hd7 is 5860533168.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd8.
grub-probe: info: the size of hd8 is 3907029168.
grub-probe: info: the size of hd8 is 3907029168.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd9.
grub-probe: info: the size of hd9 is 3907029168.
grub-probe: info: the size of hd9 is 3907029168.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd10.
grub-probe: info: the size of hd10 is 976773168.
grub-probe: info: the size of hd10 is 976773168.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd11.
grub-probe: info: the size of hd11 is 5860533168.
grub-probe: info: the size of hd11 is 5860533168.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd0.
grub-probe: info: the size of hd0 is 625134827.
grub-probe: info: the size of hd0 is 625134827.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd0,msdos3=
=2E
grub-probe: info: the size of hd0 is 625134827.
grub-probe: info: Found array md2 (mdraid09).
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd0,msdos2=
=2E
grub-probe: info: the size of hd0 is 625134827.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd0,msdos1=
=2E
grub-probe: info: the size of hd0 is 625134827.
grub-probe: info: Found array md0 (mdraid09).
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd1.
grub-probe: info: the size of hd1 is 625134827.
grub-probe: info: the size of hd1 is 625134827.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd1,msdos3=
=2E
grub-probe: info: the size of hd1 is 625134827.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd1,msdos2=
=2E
grub-probe: info: the size of hd1 is 625134827.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd1,msdos1=
=2E
grub-probe: info: the size of hd1 is 625134827.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd2.
grub-probe: info: the size of hd2 is 625142448.
grub-probe: info: the size of hd2 is 625142448.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd2,msdos3=
=2E
grub-probe: info: the size of hd2 is 625142448.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd2,msdos2=
=2E
grub-probe: info: the size of hd2 is 625142448.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd2,msdos1=
=2E
grub-probe: info: the size of hd2 is 625142448.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd3.
grub-probe: info: the size of hd3 is 625134827.
grub-probe: info: the size of hd3 is 625134827.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd3,msdos3=
=2E
grub-probe: info: the size of hd3 is 625134827.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd3,msdos2=
=2E
grub-probe: info: the size of hd3 is 625134827.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd3,msdos1=
=2E
grub-probe: info: the size of hd3 is 625134827.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd4.
grub-probe: info: the size of hd4 is 625134827.
grub-probe: info: the size of hd4 is 625134827.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd5.
grub-probe: info: the size of hd5 is 976773168.
grub-probe: info: the size of hd5 is 976773168.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd6.
grub-probe: info: the size of hd6 is 3907029168.
grub-probe: info: the size of hd6 is 3907029168.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd7.
grub-probe: info: the size of hd7 is 5860533168.
grub-probe: info: the size of hd7 is 5860533168.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd8.
grub-probe: info: the size of hd8 is 3907029168.
grub-probe: info: the size of hd8 is 3907029168.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd9.
grub-probe: info: the size of hd9 is 3907029168.
grub-probe: info: the size of hd9 is 3907029168.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd10.
grub-probe: info: the size of hd10 is 976773168.
grub-probe: info: the size of hd10 is 976773168.
grub-probe: info: Scanning for mdraid09 RAID devices on disk hd11.
grub-probe: info: the size of hd11 is 5860533168.
grub-probe: info: the size of hd11 is 5860533168.
grub-probe: info: Scanning for mdraid1x RAID devices on disk md0.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd0.
grub-probe: info: the size of hd0 is 625134827.
grub-probe: info: the size of hd0 is 625134827.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd0,msdos3=
=2E
grub-probe: info: the size of hd0 is 625134827.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd0,msdos2=
=2E
grub-probe: info: the size of hd0 is 625134827.
grub-probe: info: Found array md/1 (mdraid1x).
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd0,msdos1=
=2E
grub-probe: info: the size of hd0 is 625134827.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd1.
grub-probe: info: the size of hd1 is 625134827.
grub-probe: info: the size of hd1 is 625134827.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd1,msdos3=
=2E
grub-probe: info: the size of hd1 is 625134827.
error: found two disks with the index 3 for RAID md2.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd1,msdos2=
=2E
grub-probe: info: the size of hd1 is 625134827.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd1,msdos1=
=2E
grub-probe: info: the size of hd1 is 625134827.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd2.
grub-probe: info: the size of hd2 is 625142448.
grub-probe: info: the size of hd2 is 625142448.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd2,msdos3=
=2E
grub-probe: info: the size of hd2 is 625142448.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd2,msdos2=
=2E
grub-probe: info: the size of hd2 is 625142448.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd2,msdos1=
=2E
grub-probe: info: the size of hd2 is 625142448.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd3.
grub-probe: info: the size of hd3 is 625134827.
grub-probe: info: the size of hd3 is 625134827.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd3,msdos3=
=2E
grub-probe: info: the size of hd3 is 625134827.
error: superfluous RAID member (6 found).
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd3,msdos2=
=2E
grub-probe: info: the size of hd3 is 625134827.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd3,msdos1=
=2E
grub-probe: info: the size of hd3 is 625134827.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd4.
grub-probe: info: the size of hd4 is 625134827.
grub-probe: info: the size of hd4 is 625134827.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd5.
grub-probe: info: the size of hd5 is 976773168.
grub-probe: info: the size of hd5 is 976773168.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd6.
grub-probe: info: the size of hd6 is 3907029168.
grub-probe: info: the size of hd6 is 3907029168.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd7.
grub-probe: info: the size of hd7 is 5860533168.
grub-probe: info: the size of hd7 is 5860533168.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd8.
grub-probe: info: the size of hd8 is 3907029168.
grub-probe: info: the size of hd8 is 3907029168.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd9.
grub-probe: info: the size of hd9 is 3907029168.
grub-probe: info: the size of hd9 is 3907029168.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd10.
grub-probe: info: the size of hd10 is 976773168.
grub-probe: info: the size of hd10 is 976773168.
grub-probe: info: Scanning for mdraid1x RAID devices on disk hd11.
grub-probe: info: the size of hd11 is 5860533168.
grub-probe: info: the size of hd11 is 5860533168.
grub-probe: info: scanning md/1 for LVM.
grub-probe: info: no LVM signature found.
grub-probe: info: scanning md0 for LVM.
grub-probe: info: no LVM signature found.
grub-probe: info: scanning md2 for LVM.
grub-probe: info: scanning hd0 for LVM.
grub-probe: info: the size of hd0 is 625134827.
grub-probe: info: no LVM signature found.
grub-probe: info: the size of hd0 is 625134827.
grub-probe: info: scanning hd0,msdos3 for LVM.
grub-probe: info: the size of hd0 is 625134827.
grub-probe: info: no LVM signature found.
grub-probe: info: scanning hd0,msdos2 for LVM.
grub-probe: info: the size of hd0 is 625134827.
grub-probe: info: no LVM signature found.
grub-probe: info: scanning hd0,msdos1 for LVM.
grub-probe: info: the size of hd0 is 625134827.
grub-probe: info: no LVM signature found.
grub-probe: info: scanning hd1 for LVM.
grub-probe: info: the size of hd1 is 625134827.
grub-probe: info: no LVM signature found.
grub-probe: info: the size of hd1 is 625134827.
grub-probe: info: scanning hd1,msdos3 for LVM.
grub-probe: info: the size of hd1 is 625134827.
grub-probe: info: no LVM signature found.
grub-probe: info: scanning hd1,msdos2 for LVM.
grub-probe: info: the size of hd1 is 625134827.
grub-probe: info: no LVM signature found.
grub-probe: info: scanning hd1,msdos1 for LVM.
grub-probe: info: the size of hd1 is 625134827.
grub-probe: info: no LVM signature found.
grub-probe: info: scanning hd2 for LVM.
grub-probe: info: the size of hd2 is 625142448.
grub-probe: info: no LVM signature found.
grub-probe: info: the size of hd2 is 625142448.
grub-probe: info: scanning hd2,msdos3 for LVM.
grub-probe: info: the size of hd2 is 625142448.
grub-probe: info: no LVM signature found.
grub-probe: info: scanning hd2,msdos2 for LVM.
grub-probe: info: the size of hd2 is 625142448.
grub-probe: info: no LVM signature found.
grub-probe: info: scanning hd2,msdos1 for LVM.
grub-probe: info: the size of hd2 is 625142448.
grub-probe: info: no LVM signature found.
grub-probe: info: scanning hd3 for LVM.
grub-probe: info: the size of hd3 is 625134827.
grub-probe: info: no LVM signature found.
grub-probe: info: the size of hd3 is 625134827.
grub-probe: info: scanning hd3,msdos3 for LVM.
grub-probe: info: the size of hd3 is 625134827.
grub-probe: info: scanning hd3,msdos2 for LVM.
grub-probe: info: the size of hd3 is 625134827.
grub-probe: info: no LVM signature found.
grub-probe: info: scanning hd3,msdos1 for LVM.
grub-probe: info: the size of hd3 is 625134827.
grub-probe: info: no LVM signature found.
grub-probe: info: scanning hd4 for LVM.
grub-probe: info: the size of hd4 is 625134827.
grub-probe: info: no LVM signature found.
grub-probe: info: the size of hd4 is 625134827.
grub-probe: info: scanning hd5 for LVM.
grub-probe: info: the size of hd5 is 976773168.
grub-probe: info: no LVM signature found.
grub-probe: info: the size of hd5 is 976773168.
grub-probe: info: scanning hd6 for LVM.
grub-probe: info: the size of hd6 is 3907029168.
grub-probe: info: no LVM signature found.
grub-probe: info: the size of hd6 is 3907029168.
grub-probe: info: scanning hd7 for LVM.
grub-probe: info: the size of hd7 is 5860533168.
grub-probe: info: no LVM signature found.
grub-probe: info: the size of hd7 is 5860533168.
grub-probe: info: scanning hd8 for LVM.
grub-probe: info: the size of hd8 is 3907029168.
grub-probe: info: no LVM signature found.
grub-probe: info: the size of hd8 is 3907029168.
grub-probe: info: scanning hd9 for LVM.
grub-probe: info: the size of hd9 is 3907029168.
grub-probe: info: no LVM signature found.
grub-probe: info: the size of hd9 is 3907029168.
grub-probe: info: scanning hd10 for LVM.
grub-probe: info: the size of hd10 is 976773168.
grub-probe: info: no LVM signature found.
grub-probe: info: the size of hd10 is 976773168.
grub-probe: info: scanning hd11 for LVM.
grub-probe: info: the size of hd11 is 5860533168.
grub-probe: info: no LVM signature found.
grub-probe: info: the size of hd11 is 5860533168.
grub-probe: info: opening mduuid/78cf4169e31908f4e667021c582159fb.
ext2

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
