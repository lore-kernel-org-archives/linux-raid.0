From: =?iso-8859-2?Q?Karel_Kulhav=FD?= <clock@twibright.com>
Subject: Where mkraid has problems
Date: Fri, 9 Jan 2004 15:13:08 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040109151308.A19557@beton.cybernet.src>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a raidtab file. When two halves of the files are exchanged, you can
switch between the bad behaviour of mkraid (mkraid /dev/md0: /dev/md1
is active) and good behaviour of mkraid (ie. makes the raid):

raiddev /dev/md1
        raid-level              1
        nr-raid-disks           2
        nr-spare-disks          0
        chunk-size              4
        persistent-superblock   1
        device                  /dev/sdb3
        raid-disk               0
        device                  /dev/sda3
        failed-disk             1

raiddev /dev/md0
        raid-level              1
        nr-raid-disks           2
        nr-spare-disks          0
        chunk-size              4
        persistent-superblock   1
        device                  /dev/sdc1
        raid-disk               0
        device                  /dev/sdd1
        raid-disk               1

Cl<
