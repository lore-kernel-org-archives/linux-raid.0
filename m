From: Chris Francy <zoredache@gmail.com>
Subject: Array Size differences between mdadm --detail and --examine
Date: Mon, 19 Mar 2012 16:04:34 -0700
Message-ID: <CAM8ZctUH--UJmKi56UJNmDss67uzQycLyx1tP0qeyB9GCFBc0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am seeing a different array size with mdadm --detail and --examine,
and I don't understand why.

I have seen this on a production systems, but I created an array in a
VM for testing purposes, and I am seeing the same results.

I have a 5 device RAID10 with created like so.  It has 5 members 8GB
each.  Which I believe should result in an array size of ~20GB.

    mdadm -v --create  /dev/md0 --assume-clean \
       --level=raid10 --layout=o2 --raid-devices=5 \
       --chunk=64 \
       /dev/sdb2 /dev/sdc2 /dev/sdd2 /dev/sde2 /dev/sdf2

mdadm --detail reports an array size of ~20GiB

  root@debian:~# mdadm --detail /dev/md0
  /dev/md0:
    Creation Time : Fri Mar 16 16:06:09 2012
       Raid Level : raid10
       Array Size : 20960960 (19.99 GiB 21.46 GB)
    Used Dev Size : 8384384 (8.00 GiB 8.59 GB)

mdadm --examine reports an array size of ~16GiB

  root@debian:~# mdadm --examine /dev/sdb2  /dev/sdd2 /dev/sde2 /dev/sdf2
  /dev/sdb2:
   Avail Dev Size : 16769024 (8.00 GiB 8.59 GB)
       Array Size : 33537536 (15.99 GiB 17.17 GB)
    Used Dev Size : 16768768 (8.00 GiB 8.59 GB)

Most of my testing was done on a Debian squeeze system, but I manually
compiled and installed mdadm 3.2.3 and I also saw the same confusing
output from a Gentoo based livecd with a recent kernel.

The full output of the mdadm output is pasted available here.
http://paste.debian.net/160057/

The array in the VM seems to work fine, I was able to create a
filesystem and store data on it.  But the output from the --examine is
confusing.

The same is true with the use Dev size  `8384384 (8.00 GiB 8.59 GB)`
versus `16768768 (8.00 GiB 8.59 GB)`.

Chris Francy
