From: "Michael" <michael@insulin-pumpers.org>
Subject: RE: Please help with a special RAID 1 setup
Date: Wed, 7 Jan 2004 10:59:02 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401071858.i07Iwx228259@bzs.org>
References: <8075D5C3061B9441944E137377645118012F02@cinshrexc03.shermfin.com>
Reply-To: michael@insulin-pumpers.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <8075D5C3061B9441944E137377645118012F02@cinshrexc03.shermfin.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

<snip> 
> I don't believe that the above is a correct statement.  Linux
> software RAID1 will allow mirroring across more than 2 devices:
>

This is correct. Below is info and conf file from our raid1 setup

Boot sector (md1) is 3 partition raid 1
swap and root are 2 partition raid 1 with hot spare

Personalities : [raid0] [raid1] [raid5] 
read_ahead 1024 sectors
md1 : active raid1 sdc1[2] sdb1[1] sda1[0]
      15936 blocks [3/3] [UUU]

md2 : active raid1 sdc2[2] sdb2[1] sda2[0]
      489856 blocks [2/2] [UU]

md0 : active raid1 sdc3[2] sdb3[1] sda3[0]
      16924352 blocks [2/2] [UU]


# raid-1 configuration
raiddev /dev/md1
        raid-level              1
        nr-raid-disks           3
        chunk-size              4
# Spare disks for hot reconstruction
        nr-spare-disks          0
        persistent-superblock   1
        device                  /dev/sda1
        raid-disk               0
        device                  /dev/sdb1
        raid-disk               1
        device                  /dev/sdc1
        raid-disk               2

raiddev /dev/md0
        raid-level              1
        nr-raid-disks           2
        chunk-size              32
        nr-spare-disks          1
        persistent-superblock   1
        device                  /dev/sda3
        raid-disk               0
        device                  /dev/sdb3
        raid-disk               1
        device                  /dev/sdc3
        spare-disk              0

raiddev /dev/md2
        raid-level              1
        nr-raid-disks           2
        chunk-size              4
# Spare disks for hot reconstruction
        nr-spare-disks          1
        persistent-superblock   1
        device                  /dev/sda2
        raid-disk               0
        device                  /dev/sdb2
        raid-disk               1
        device                  /dev/sdc2
        spare-disk              0

Michael@Insulin-Pumpers.org
