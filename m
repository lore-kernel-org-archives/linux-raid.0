From: "=?ISO-8859-1?Q?Thomas_Lang=E5s?=" <thomas.langaas@gmail.com>
Subject: mdadm 2.6, linux 2.6.17, failed grow/reshape
Date: Tue, 20 Feb 2007 20:23:29 +0100
Message-ID: <6264d2ec0702201123l1b0ca58boe51fff8946c4ba0a@mail.gmail.com>
References: <6264d2ec0702201047s7e732a2eq6b72f54af3f4ae4d@mail.gmail.com>
	 <17883.18091.699835.980907@notabene.brown>
	 <6264d2ec0702201122l2f718694k52ebbb1e9bd5717c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6264d2ec0702201122l2f718694k52ebbb1e9bd5717c@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/20/07, Neil Brown <neilb@suse.de> wrote:
> > It says that the device (md0) is in delta 4->5, but I'm unable to get
> > it to restart reshaping.  Are all the data I had on the raid-device
> > lost?  Or is it possible to make it restart where it left off?  It
> > clearly knows how far it has come along, since I get some stats about
> > that.
> Hmm... it should "just work", and it my testing it does.

What should "kick off" the rebuild/reshape-process once it has been
interrupted?

> The reshape process regularly checkpoints its progress so it knows
> where to start off from, and when you assemble the array again, it
> should restart the reshape.

Ok, no matter if it's a different system assembling the drives?  The
kernel is not running the md-device (if there is one?) from
mdadm-2.6-source, it's running the one inside 2.6.17.

> Can you post kernel log messages showing md0 being assembled?  Also
> the output of "mdadm -E" on a couple of drives might be helpful.

Running assemble:
# ./mdadm --assemble --scan
mdadm: failed to RUN_ARRAY /dev/.static/dev/md0: Invalid argument

Ouput from syslog:
Feb 20 20:20:09 ubuntu kernel: [17197083.928000] md: md0 stopped.
Feb 20 20:20:09 ubuntu kernel: [17197084.012000] md: bind<sdd1>
Feb 20 20:20:09 ubuntu kernel: [17197084.012000] md: bind<sde1>
Feb 20 20:20:09 ubuntu kernel: [17197084.012000] md: bind<sdf1>
Feb 20 20:20:09 ubuntu kernel: [17197084.012000] md: bind<sdg1>
Feb 20 20:20:09 ubuntu kernel: [17197084.016000] md: bind<sdc1>

Details:
# ./mdadm --detail /dev/md0
/dev/md0:
        Version : 00.91.03
  Creation Time : Sun Feb 18 01:19:36 2007
     Raid Level : raid5
  Used Dev Size : 244195904 (232.88 GiB 250.06 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sun Feb 18 14:18:48 2007
          State : active, Not Started
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

  Delta Devices : 1, (4->5)

           UUID : e100e921:53bc1ec5:0ff90348:cdad8788
         Events : 0.71599

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1
       2       8       65        2      active sync   /dev/sde1
       3       8       81        3      active sync   /dev/sdf1
       4       8       97        4      active sync   /dev/sdg1

# ./mdadm -E /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.91.03
           UUID : e100e921:53bc1ec5:0ff90348:cdad8788
  Creation Time : Sun Feb 18 01:19:36 2007
     Raid Level : raid5
  Used Dev Size : 244195904 (232.88 GiB 250.06 GB)
     Array Size : 976783616 (931.53 GiB 1000.23 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

  Reshape pos'n : 383536128 (365.77 GiB 392.74 GB)
  Delta Devices : 1 (4->5)

    Update Time : Sun Feb 18 14:18:48 2007
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 8389d7b3 - correct
         Events : 0.71599

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       33        0      active sync   /dev/sdc1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       65        2      active sync   /dev/sde1
   3     3       8       81        3      active sync   /dev/sdf1
   4     4       8      129        4      active sync
root@ubuntu:/home/ubuntu/mdadm-2.6# ./mdadm -E /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.91.03
           UUID : e100e921:53bc1ec5:0ff90348:cdad8788
  Creation Time : Sun Feb 18 01:19:36 2007
     Raid Level : raid5
  Used Dev Size : 244195904 (232.88 GiB 250.06 GB)
     Array Size : 976783616 (931.53 GiB 1000.23 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

  Reshape pos'n : 383536128 (365.77 GiB 392.74 GB)
  Delta Devices : 1 (4->5)

    Update Time : Sun Feb 18 14:18:48 2007
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 8389d7c5 - correct
         Events : 0.71599

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       49        1      active sync   /dev/sdd1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       65        2      active sync   /dev/sde1
   3     3       8       81        3      active sync   /dev/sdf1
   4     4       8      129        4      active sync
root@ubuntu:/home/ubuntu/mdadm-2.6# ./mdadm -E /dev/sde1
/dev/sde1:
          Magic : a92b4efc
        Version : 00.91.03
           UUID : e100e921:53bc1ec5:0ff90348:cdad8788
  Creation Time : Sun Feb 18 01:19:36 2007
     Raid Level : raid5
  Used Dev Size : 244195904 (232.88 GiB 250.06 GB)
     Array Size : 976783616 (931.53 GiB 1000.23 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

  Reshape pos'n : 383536128 (365.77 GiB 392.74 GB)
  Delta Devices : 1 (4->5)

    Update Time : Sun Feb 18 14:18:48 2007
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 8389d7d7 - correct
         Events : 0.71599

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       65        2      active sync   /dev/sde1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       65        2      active sync   /dev/sde1
   3     3       8       81        3      active sync   /dev/sdf1
   4     4       8      129        4      active sync
root@ubuntu:/home/ubuntu/mdadm-2.6# ./mdadm -E /dev/sdf1
/dev/sdf1:
          Magic : a92b4efc
        Version : 00.91.03
           UUID : e100e921:53bc1ec5:0ff90348:cdad8788
  Creation Time : Sun Feb 18 01:19:36 2007
     Raid Level : raid5
  Used Dev Size : 244195904 (232.88 GiB 250.06 GB)
     Array Size : 976783616 (931.53 GiB 1000.23 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

  Reshape pos'n : 383536128 (365.77 GiB 392.74 GB)
  Delta Devices : 1 (4->5)

    Update Time : Sun Feb 18 14:18:48 2007
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 8389d7e9 - correct
         Events : 0.71599

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       81        3      active sync   /dev/sdf1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       65        2      active sync   /dev/sde1
   3     3       8       81        3      active sync   /dev/sdf1
   4     4       8      129        4      active sync


If you have any more I need to run, please let me know and I'll run
the commands :)

--
Thomas
