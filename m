From: Joe Landman <joe.landman@gmail.com>
Subject: Re: raid6 + caviar black + mpt2sas horrific performance
Date: Wed, 30 Mar 2011 09:46:29 -0400
Message-ID: <4D933435.3010709@gmail.com>
References: <20110330080823.GA9167@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110330080823.GA9167@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/30/2011 04:08 AM, Louis-David Mitterrand wrote:
> Hi,
>
> I am seeing horrific performance on a Dell T610 with a LSISAS2008 (Dell
> H200) card and 8 WD1002FAEX Caviar Black 1TB configured in mdadm raid6.
>
> The LSI card is upgraded to the latest 9.00 firmware:
> http://www.lsi.com/storage_home/products_home/host_bus_adapters/sas_hbas/internal/sas9211-8i/index.html
> and the 2.6.38.2 kernel uses the newer mpt2sas driver.
>
> On the T610 this command takes 20 minutes:
>
> 	tar -I pbzip2 -xvf linux-2.6.37.tar.bz2  22.64s user 3.34s system 2% cpu 20:00.69 total

Get rid of the "v" option.  And do an

	sync
	echo 3 > /proc/sys/vm/drop_caches

before the test.  Make sure your file system is local, and not NFS 
mounted (this could easily explain the timing BTW).

While we are at it, don't use pbzip2, use single threaded bzip2, as 
there may be other platform differences that impact the parallel extraction.

Here is an extraction on a local md based Delta-V unit (we use 
internally for backups)

[root@vault t]# /usr/bin/time tar -xf ~/linux-2.6.38.tar.bz2
25.18user 4.08system 1:06.96elapsed 43%CPU (0avgtext+0avgdata 
16256maxresident)k
6568inputs+969880outputs (4major+1437minor)pagefaults 0swaps

This also uses an LSI card.

On one of internal file servers using a hardware RAID

root@crunch:/data/kernel/2.6.38# /usr/bin/time tar -xf linux-2.6.38.tar.bz2
22.51user 3.73system 0:22.59elapsed 116%CPU (0avgtext+0avgdata 
0maxresident)k
0inputs+969872outputs (0major+3565minor)pagefaults 0swaps

Try a similar test on your two units, without the "v" option.  Then try 
to get useful information about the MD raid, and file system atop this.

For our MD raid Delta-V system

[root@vault t]# mdadm --detail /dev/md2
/dev/md2:
         Version : 1.2
   Creation Time : Mon Nov  1 10:38:35 2010
      Raid Level : raid6
      Array Size : 10666968576 (10172.81 GiB 10922.98 GB)
   Used Dev Size : 969724416 (924.80 GiB 993.00 GB)
    Raid Devices : 13
   Total Devices : 14
     Persistence : Superblock is persistent

     Update Time : Wed Mar 30 04:46:35 2011
           State : clean
  Active Devices : 13
Working Devices : 14
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 512K

            Name : 2
            UUID : 45ddd631:efd08494:8cd4ff1a:0695567b
          Events : 18280

     Number   Major   Minor   RaidDevice State
        0       8       35        0      active sync   /dev/sdc3
       13       8      227        1      active sync   /dev/sdo3
        2       8       51        2      active sync   /dev/sdd3
        3       8       67        3      active sync   /dev/sde3
        4       8       83        4      active sync   /dev/sdf3
        5       8       99        5      active sync   /dev/sdg3
        6       8      115        6      active sync   /dev/sdh3
        7       8      131        7      active sync   /dev/sdi3
        8       8      147        8      active sync   /dev/sdj3
        9       8      163        9      active sync   /dev/sdk3
       10       8      179       10      active sync   /dev/sdl3
       11       8      195       11      active sync   /dev/sdm3
       12       8      211       12      active sync   /dev/sdn3

       14       8      243        -      spare   /dev/sdp3

[root@vault t]# mount | grep md2
/dev/md2 on /backup type xfs (rw)

[root@vault t]# grep md2 /etc/fstab
/dev/md2		/backup			xfs	defaults	1 2

And a basic speed check on the md device

[root@vault t]# dd if=/dev/md2 of=/dev/null bs=32k count=32000
32000+0 records in
32000+0 records out
1048576000 bytes (1.0 GB) copied, 3.08236 seconds, 340 MB/s

[root@vault t]# dd if=/dev/zero of=/backup/t/big.file bs=32k count=32000
32000+0 records in
32000+0 records out
1048576000 bytes (1.0 GB) copied, 2.87177 seconds, 365 MB/s

Some 'lspci -vvv' output, and contents of /proc/interrupts, 
/proc/cpuinfo, ... would be helpful.




>
> where on a lower spec'ed Poweredge 2900 III server (LSI Logic MegaRAID
> SAS 1078 + 8 x Hitachi Ultrastar 7K1000 in mdadm raid6) it takes 22
> _seconds_:
>
> 	tar -I pbzip2 -xvf linux-2.6.37.tar.bz2  16.40s user 3.22s system 86% cpu 22.773 total
>
> Besides hardware, the other difference between servers is that the
> PE2900's MegaRAID has no JBOD mode so each disk must be configured as a
> "raid0" vdisk unit. On the T610 no configuration was necessary for the
> disks to "appear" in the OS. Would configuring them as raid0 vdisks
> change anything?
>
> Thanks in advance for any suggestion,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
