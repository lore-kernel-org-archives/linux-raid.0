From: Dave W <dave+gmane@wuertele.com>
Subject: Re: How do I determine which drive should be in which slot?
Date: Tue, 29 Jun 2010 16:00:57 +0000 (UTC)
Message-ID: <loom.20100629T175538-430@post.gmane.org>
References: <loom.20100626T070913-497@post.gmane.org> <loom.20100629T082214-677@post.gmane.org> <20100629170209.126e6336@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb <at> suse.de> writes:

> > How can I tell mdadm to put them in the right slots?
> 
> This is very odd.... that should not happen.  I think I've seen a few reports
> of something like that happening and I'm beginning to wonder if I broke
> something subtle....
> What kernel/mdadm version are you using.

# uname -a
Linux fileserver.whome 2.6.27.24-170.2.68.fc10.i686 #1 SMP Wed May 20 23:10:16
EDT 2009 i686 i686 i386 GNU/Linux
# mdadm --version
mdadm - v2.6.7.1 - 15th October 2008


> You should use "mdadm --examine" to see the configuration of the array, and
> make sure that configuration is copied exactly when you creat a new array -
> same chunk size, same layout, same metadata version etc.

I don't know what metadata version refers to.  I don't see it in the
"mdadm --examine" output.


> Keep a copy of the "mdadm --examine" output and compare it with the output
> after runing the --create and make sure everything is still the same (e.g.
> Data Offset could be changed - that would be awkward).

I also don't see Data Offset in the --examine output.  I wonder if I should
upgrade to a newer mdadm?  Or is that something that I can only see if I
run --examine on a running array?
at the data looks OK.

> If 'fsck' fails, you might like to try again, re-arranging the devices that
> you aren't sure of.

OK, it sounds like you're saying that the --create command won't hurt anything
that I can't fix by running it again.  It is truly safe that way?

Here is the /proc/mdstat and the --examine output:


# cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md0 : inactive sdd1[2](S) sdb1[7](S) sdc1[6](S) sdf1[5](S) sde1[3](S)
      9767559680 blocks
       
unused devices: <none>
# mdadm --examine /dev/sd[bcdef]1
/dev/sdb1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : ddebe2dc:9c023128:eb301463:823c4aa0
  Creation Time : Sun May  2 01:30:10 2010
     Raid Level : raid6
  Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
     Array Size : 5860535808 (5589.04 GiB 6001.19 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Fri Jun 11 05:18:13 2010
          State : clean
 Active Devices : 2
Working Devices : 5
 Failed Devices : 2
  Spare Devices : 3
       Checksum : 9ce7de69 - correct
         Events : 48984

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     7       8       17        7      spare   /dev/sdb1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       0        0        4      faulty removed
   5     5       8       81        5      spare   /dev/sdf1
   6     6       8       33        6      spare   /dev/sdc1
   7     7       8       17        7      spare   /dev/sdb1
/dev/sdc1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : ddebe2dc:9c023128:eb301463:823c4aa0
  Creation Time : Sun May  2 01:30:10 2010
     Raid Level : raid6
  Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
     Array Size : 5860535808 (5589.04 GiB 6001.19 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Fri Jun 11 05:18:13 2010
          State : clean
 Active Devices : 2
Working Devices : 5
 Failed Devices : 2
  Spare Devices : 3
       Checksum : 9ce7de77 - correct
         Events : 48984

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     6       8       33        6      spare   /dev/sdc1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       0        0        4      faulty removed
   5     5       8       81        5      spare   /dev/sdf1
   6     6       8       33        6      spare   /dev/sdc1
   7     7       8       17        7      spare   /dev/sdb1
/dev/sdd1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : ddebe2dc:9c023128:eb301463:823c4aa0
  Creation Time : Sun May  2 01:30:10 2010
     Raid Level : raid6
  Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
     Array Size : 5860535808 (5589.04 GiB 6001.19 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Fri Jun 11 05:18:13 2010
          State : clean
 Active Devices : 2
Working Devices : 5
 Failed Devices : 2
  Spare Devices : 3
       Checksum : 9ce7de85 - correct
         Events : 48984

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       49        2      active sync   /dev/sdd1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       0        0        4      faulty removed
   5     5       8       81        5      spare   /dev/sdf1
   6     6       8       33        6      spare   /dev/sdc1
   7     7       8       17        7      spare   /dev/sdb1
/dev/sde1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : ddebe2dc:9c023128:eb301463:823c4aa0
  Creation Time : Sun May  2 01:30:10 2010
     Raid Level : raid6
  Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
     Array Size : 5860535808 (5589.04 GiB 6001.19 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Fri Jun 11 05:18:13 2010
          State : clean
 Active Devices : 2
Working Devices : 5
 Failed Devices : 2
  Spare Devices : 3
       Checksum : 9ce7de97 - correct
         Events : 48984

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       65        3      active sync   /dev/sde1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       0        0        4      faulty removed
   5     5       8       81        5      spare   /dev/sdf1
   6     6       8       33        6      spare   /dev/sdc1
   7     7       8       17        7      spare   /dev/sdb1
/dev/sdf1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : ddebe2dc:9c023128:eb301463:823c4aa0
  Creation Time : Sun May  2 01:30:10 2010
     Raid Level : raid6
  Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
     Array Size : 5860535808 (5589.04 GiB 6001.19 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Fri Jun 11 05:18:13 2010
          State : clean
 Active Devices : 2
Working Devices : 5
 Failed Devices : 2
  Spare Devices : 3
       Checksum : 9ce7dea5 - correct
         Events : 48984

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8       81        5      spare   /dev/sdf1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       0        0        4      faulty removed
   5     5       8       81        5      spare   /dev/sdf1
   6     6       8       33        6      spare   /dev/sdc1
   7     7       8       17        7      spare   /dev/sdb1
# 



