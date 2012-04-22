From: Veedar Hokstadt <veedar@gmail.com>
Subject: mdadm -E won't examine loop back device, works ok on source disk
Date: Sun, 22 Apr 2012 17:00:04 -0400
Message-ID: <CANb3qHeDF10CoRiteo_wwUSvGtpjcNWPh95xdatkFoY+GyAZJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Consider a SATA drive /dev/sdb which is a member of an imsm RAID0 array...

% sum /dev/sdb
25645 156290904

The drive was imaged to a file without error and mounted as a loopback device...

% sum /dev/loop2
25645 156290904

The checksums match as expected. But I can not examine the loopback I get....

% mdadm  -E -v /dev/loop2
mdadm: No md superblock detected on /dev/loop2.

But I can examine the physical source drive /dev/sdb...

% mdadm  -E -v /dev/sdb
/dev/sdb:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.0.00
    Orig Family : e92a11d9
         Family : e92a11d9
     Generation : 00001608
           UUID : 25137636:2ff64e75:10ae5444:4e8f609b
       Checksum : e1237b20 correct
    MPB Sectors : 1
          Disks : 2
   RAID Devices : 1

  Disk01 Serial : 8068C3QVT
          State : active
             Id : 00010000
    Usable Size : 312577294 (149.05 GiB 160.04 GB)

[Volume0]:
           UUID : 72acd5fa:35c5a901:995af79b:83a29de1
     RAID Level : 0
        Members : 2
      This Slot : 1
     Array Size : 625154048 (298.10 GiB 320.08 GB)
   Per Dev Size : 312577283 (149.05 GiB 160.04 GB)
  Sector Offset : 0
    Num Stripes : 1221004
     Chunk Size : 128 KiB
       Reserved : 0
  Migrate State : idle
      Map State : normal
    Dirty State : clean

  Disk00 Serial : 809BC541T
          State : active failed
             Id : 00000000
    Usable Size : 312577294 (149.05 GiB 160.04 GB)

I'm trying to recover data from a failed RAID0.
I can successfully reassemble the RAID0 from the image files using
other proprietary recovery software.
But I would like to get it working with mdadm if at all possible.
Any ideas?

Regards,
V
