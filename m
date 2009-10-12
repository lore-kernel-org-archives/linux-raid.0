From: mark delfman <markdelfman@googlemail.com>
Subject: xfs > md 50% write performance drop on .30+ kernel?
Date: Mon, 12 Oct 2009 17:58:20 +0100
Message-ID: <66781b10910120958k4afb637ejba79e4c23900c4da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi... in recent tests we are seeing a 50% drop in performance from
XFS>MD on a 2.6.30 kernel (compared to a 2.6.28 kernel)

In short:  Performance to MD0 direct = circa 1.7GBsec (see below), via
xfs circa 850MBsec.  On previous system (2.6.28) there was no drop in
performance (in fact often an increase).

I am hopefully that this is simply a matter of barriers etc on the
newer kernel and MD, but we have tried many options and nothing seems
to change this so would very much appreciate advice.


Below is the configuration / test results

Hardware:  Decent performance quad core with LSI SAS controller:  10 x
15K SAS drives
(note we have tried this on various hardware and various amounts of drives).

Newer kernel setup  (performance drop)
Kernel 2.6.30.8  (open SUSE userspace)
mdadm - v3.0 - 2nd June 2009
Library version:   1.02.31 (2009-03-03)
Driver version:    4.14.0

RAID0 created: mdadm -C /dev/md0 -l0 -n10 /dev/sd[b-k]
RAID0 Performance:
dd if=/dev/zero of=/dev/md0 bs=1M count=20000
20000+0 records in
20000+0 records out
20971520000 bytes (21 GB) copied, 12.6685 s, 1.7 GB/s


XFS Created:  (can see from output it is self aligning - but tried
various alignments)

# mkfs.xfs -f /dev/md0
meta-data=/dev/md0               isize=256    agcount=32, agsize=22888176 blks
         =                                           sectsz=512   attr=2
data     =                       bsize=4096   blocks=732421600, imaxpct=5
         =                       sunit=16     swidth=160 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=0
realtime =none                   extsz=655360 blocks=0, rtextents=0


Mounted:  mount -o nobarrier /dev/md0 /mnt/md0
/dev/md0 on /mnt/md0 type xfs (rw,nobarrier)
(tried with barriers / async)

Performance:

linux-poly:~ # dd if=/dev/zero of=/mnt/md0/test bs=1M count=20000
20000+0 records in
20000+0 records out
20971520000 bytes (21 GB) copied, 23.631 s, 887 MB/s



Note:

Older kernel setup (no performance drop)
Newer kernel setup
Kernel 2.6.28.4
mdadm  2.6.8
Library version:   1.02.27 (2008-06-25)
Driver version:    4.14.0
