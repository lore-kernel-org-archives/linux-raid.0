From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: How to un-degrade an array after a totally spurious failure?
Date: Mon, 3 Aug 2009 02:30:04 -0500
Message-ID: <20090803073007991.CADI24863@cdptpa-omta03.mail.rr.com>
References: <a2ada9611479c051e268a76df8b45b40.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a2ada9611479c051e268a76df8b45b40.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> >> NeilBrown
> >
> > 	I have exactly the same situation, except there are two "failed"
> > disks on a RAID5 array.  As for the OP, the "failures" are spurious.
> > Running the remove and then the add command puts the disks back in as
> > spare
> > disks, not live ones, and then the array just sits there, doing nothing.
> > I
> > tried the trick of doing
> >
> > echo repair > /sys/block/md0/md/sync_action
> >
> > but the array still just sits there saying it is "clean, degraded", with
> 2
> > spare and 5 working devices.
> >
> 
> No such a good option when you have two failures.
> If you have two failures you need to stop the array, then assemble
> it again using --force.
> It is now too late for that:  adding them with "--add" will have erased
> the old metadata.
> 
> Your only option is to re-create the array.  Make sure you use the
> same parameters (e.g. chunk size) as when you first created the array.
> You can check the correct parameters by looking at a device with
> "--examine".
> Also make sure you put the devices in the correct order.
> 
> The best thing to do is to try creating the array, using
> "--assume-clean" so it won't trigger a resync.
>  Then use "fsck", the "mount" to make sure the data is good.
> Once you are satisfied that the data is good and that you created
> the array with the right parameters, use "echo repair > ...."
> to make sure the array really is 'clean'.
> 
> I guess I should stop mdadm from trashing the superblock when you
> add a spare to an array which has failed....
> 
> NeilBrown

OK, Neil, I've had this occur again.  A prolonged power failure took one of
the systems offline, and now it's convicting 3 of 7 disks in a RAID5 array.
I've done nothing but stop the array.  Prior to stopping the array, mdadm
reported:

Backup:/# mdadm -Dt /dev/md0
/dev/md0:
        Version : 01.02
  Creation Time : Sun Jul 12 20:44:02 2009
     Raid Level : raid5
     Array Size : 8790830592 (8383.59 GiB 9001.81 GB)
  Used Dev Size : 2930276864 (2794.53 GiB 3000.60 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sun Aug  2 04:01:52 2009
          State : clean, degraded
 Active Devices : 4
Working Devices : 4
 Failed Devices : 3
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 256K

           Name : 'Backup':0
           UUID : 940ae4e4:04057ffc:5e92d2fb:63e3efb7
         Events : 14

    Number   Major   Minor   RaidDevice State
       0       8       80        0      active sync   /dev/sdf
       1       8       96        1      active sync   /dev/sdg
       2       8        0        2      active sync   /dev/sda
       3       8       16        3      active sync   /dev/sdb
       4       0        0        4      removed
       5       0        0        5      removed
       6       0        0        6      removed

       4       8       32        -      faulty spare   /dev/sdc
       5       8       48        -      faulty spare   /dev/sdd
       6       8       64        -      faulty spare   /dev/sde

	The array did have a bitmap, but mdadm didn't report it.  When I
attempt using --assemble and --force, I get:

Backup:/# mdadm --assemble --force /dev/md0
mdadm: /dev/md0 not identified in config file.

