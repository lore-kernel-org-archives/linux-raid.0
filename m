From: Marc MERLIN <marc@merlins.org>
Subject: Re: clearing blocks wrongfully marked as bad if --update=no-bbl
 can't be used?
Date: Fri, 4 Nov 2016 11:18:08 -0700
Message-ID: <20161104181808.lplrtmafwlub3ck4@merlins.org>
References: <20161030161929.GA5582@metamorpher.de>
 <20161030164342.GC28648@merlins.org>
 <20161030170242.GA5724@metamorpher.de>
 <20161030021614.asws67j34ji64qle@merlins.org>
 <20161030093337.GA3627@metamorpher.de>
 <20161030153857.GB28648@merlins.org>
 <20161030161929.GA5582@metamorpher.de>
 <f6b83548-cb8b-be21-ee4f-cae9f7fa2950@turmel.org>
 <20161030171234.GD28648@merlins.org>
 <20161030171654.GE28648@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161030171654.GE28648@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Neil Brown <neilb@suse.de>, Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Oct 30, 2016 at 10:16:54AM -0700, Marc MERLIN wrote:
> myth:~# mdadm --assemble --update=force-no-bbl /dev/md5
> mdadm: /dev/md5 has been started with 5 drives.
> myth:~# 
> myth:~# mdadm --examine-badblocks /dev/sd[defgh]1
> No bad-blocks list configured on /dev/sdd1
> No bad-blocks list configured on /dev/sde1
> No bad-blocks list configured on /dev/sdf1
> No bad-blocks list configured on /dev/sdg1
> No bad-blocks list configured on /dev/sdh1
> 
> Now I'll make sure to turn off this feature on all my other arrays
> in case it got turned on without my asking for it.

Right, so I thought I was home free, but not even close. My array is
back up, the badblock feature is disabled, array reports clean, but I
cannot access data past 8.8TB, it just fails.

myth:~# dd if=/dev/md5 of=/dev/null bs=1GB skip=8797
dd: reading `/dev/md5': Invalid argument
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.000403171 s, 0.0 kB/s
myth:~# dd if=/dev/md5 of=/dev/null bs=1GB skip=8796
dd: reading `/dev/md5': Invalid argument
1+0 records in
1+0 records out
1000000000 bytes (1.0 GB) copied, 10.5817 s, 94.5 MB/s


myth:~# mdadm --query --detail /dev/md5
 
/dev/md5:
        Version : 1.2
  Creation Time : Tue Jan 21 10:35:52 2014
     Raid Level : raid5
     Array Size : 15627542528 (14903.59 GiB 16002.60 GB)
  Used Dev Size : 3906885632 (3725.90 GiB 4000.65 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent
 
  Intent Bitmap : Internal
 
    Update Time : Mon Oct 31 07:56:07 2016
          State : clean 
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
  
         Layout : left-symmetric
     Chunk Size : 512K
  
           Name : gargamel.svh.merlins.org:5
           UUID : ec672af7:a66d9557:2f00d76c:38c9f705
         Events : 147992
  
    Number   Major   Minor   RaidDevice State
       0       8       97        0      active sync   /dev/sdg1
       6       8      113        1      active sync   /dev/sdh1
       2       8       81        2      active sync   /dev/sdf1
       3       8       65        3      active sync   /dev/sde1
       5       8       49        4      active sync   /dev/sdd1


myth:~# 
myth:~# mdadm --examine /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : ec672af7:a66d9557:2f00d76c:38c9f705
           Name : gargamel.svh.merlins.org:5
  Creation Time : Tue Jan 21 10:35:52 2014
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 7813771264 (3725.90 GiB 4000.65 GB)
     Array Size : 15627542528 (14903.59 GiB 16002.60 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=0 sectors
          State : clean
    Device UUID : 075571ff:411517e9:027f8c2f:cef0457a

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Oct 31 07:56:07 2016
       Checksum : d4e74521 - correct
         Events : 147992

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)

all 5 devices look about the same outside of serial numbers.

Any idea why it's failing that way?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
