From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: xfs > md 50% write performance drop on .30+ kernel?
Date: Tue, 27 Oct 2009 04:28:00 -0600
Message-ID: <200910270428.00768.tfjellstrom@shaw.ca>
References: <66781b10910120958k4afb637ejba79e4c23900c4da@mail.gmail.com> <20091013225241.GA32197@infradead.org> <66781b10910141234h5fbf5ac3k4adc347621dbc2a1@mail.gmail.com>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66781b10910141234h5fbf5ac3k4adc347621dbc2a1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed October 14 2009, mark delfman wrote:
> Hi Chris... we tried the direct DD as requested and the problem is
> still there...
> 1.3GBsec > 325MBsec  (even more dromatic)... hopefully this helps
> narrow it down?
> 
> 
> Write > MD
> linux-poly:~ # dd if=/dev/zero of=/dev/md0 oflag=direct bs=1M count=20000
> 20000+0 records in
> 20000+0 records out
> 20971520000 bytes (21 GB) copied, 15.7671 s, 1.3 GB/s
> 
> 
> Write > XFS > MD
> linux-poly:~ # dd if=/dev/zero of=/mnt/md0/test oflag=direct bs=1M
>  count=20000 20000+0 records in
> 20000+0 records out
> 20971520000 bytes (21 GB) copied, 64.616 s, 325 MB/s

If it helps, I'm seeing the same sort of thing.
The most I can seemingly tweak out of my new 5x1TB array is 170MB/s write.
Using dd with oflags=direct drops it down to 31MB/s.

Oddly, I see spikes of over 200MB/s write when not using oflags=direct,
but it slows down in between to 11MB/s so over all,
it averages a max of 170MB/s. the device itself is capable of over 500MB/s.
(66% drop?)

small test:

$ dd if=/dev/zero of=/mnt/test-data/test.file bs=512KiB count=4096 oflag=direct
4096+0 records in
4096+0 records out
2147483648 bytes (2.1 GB) copied, 71.8088 s, 29.9 MB/s

$ dd if=/dev/zero of=/mnt/test-data/test.file bs=512KiB count=4096
4096+0 records in
4096+0 records out
2147483648 bytes (2.1 GB) copied, 19.7101 s, 109 MB/s

$ sudo dd if=/dev/md0 of=/tmp/test-data.img bs=1M count=1024
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 2.39796 s, 448 MB/s

$ sudo dd if=/tmp/test-data.img of=/dev/md0 bs=1M count=1024
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 2.05666 s, 522 MB/s

$ cd /mnt/test-data/test
$ iozone -A -s4G -y512k -q512k
       ...                                                               
              KB  reclen   write rewrite    read    reread    
         4194304     512  161732  333316   382361   388726 


[snip]
> 


info, if it helps:

# mdadm -D /dev/md0
/dev/md0:
        Version : 1.01
  Creation Time : Wed Oct 14 08:55:25 2009
     Raid Level : raid5
     Array Size : 3907049472 (3726.05 GiB 4000.82 GB)
  Used Dev Size : 976762368 (931.51 GiB 1000.20 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent

    Update Time : Tue Oct 27 04:18:50 2009
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : natasha:0  (local to host natasha)
           UUID : 7d0e9847:ec3a4a46:32b60a80:06d0ee1c
         Events : 4952

    Number   Major   Minor   RaidDevice State
       0       8       64        0      active sync   /dev/sde
       1       8       80        1      active sync   /dev/sdf
       2       8       32        2      active sync   /dev/sdc
       3       8       48        3      active sync   /dev/sdd
       5       8       96        4      active sync   /dev/sdg

# xfs_info /dev/md0
meta-data=/dev/md0               isize=256    agcount=32, agsize=30523776 blks
         =                       sectsz=4096  attr=2
data     =                       bsize=4096   blocks=976760832, imaxpct=5
         =                       sunit=128    swidth=512 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=476934, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=0
realtime =none                   extsz=2097152 blocks=0, rtextents=0

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
