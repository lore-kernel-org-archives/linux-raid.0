From: "jeff millar" <wa1hco@adelphia.net>
Subject: Question: Adding another IDE controller
Date: Thu, 10 Apr 2003 19:02:50 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00ac01c2ffb5$4fff2580$6a01a8c0@wa1hco>
References: <Pine.LNX.4.44.0304101555440.25209-100000@karma.hagopian.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I read somewhere that each disk in a raid5 array should be master on a
separate IDE port.  So, I bought a PCI IDE controller and plugged it in.
The motherboard had 4 ports already.  The raid devices used hde1, hdf1, and
hdg1. Oddly, the new controller took over hd[efgh] and moved the motherboard
ports to hd[ijkl].

But anyway...how do I move the drives to different letters and then get it
to reassemble???

I moved the slave disk (hdf) over to the new controller and tried to restart
the array. But, no amount of fiddling with mdadm --assemble and mdadm.conf
would work.  I didn't use --force though...thought it might be best to ask
first :-).  I tried using the uuid, listing the partions in the mdadm.conf,
using --scan, etc. but it just refused to run correctly.  It tried to
assemble the array from a single drive.


After plugging in the new controller and moving the slave driver over...
hdf1 became hde1
hde1 became hdi1
hdg1 became hdk1

Here's a dump from mdadm -D /dev/md0 with the array back to the original
configuration.

/dev/md0:
        Version : 00.90.00
  Creation Time : Sun Jul 14 21:18:51 2002
     Raid Level : raid5
     Array Size : 160071424 (152.66 GiB 163.91 GB)
    Device Size : 80035712 (76.33 GiB 81.96 GB)
   Raid Devices : 3
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Apr  9 22:04:02 2003
          State : dirty, no-errors
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-asymmetric
     Chunk Size : 64K

    Number   Major   Minor   RaidDevice State
       0      33        1        0      active sync   /dev/hde1
       1      33       65        1      active sync   /dev/hdf1
       2      34        1        2      active sync   /dev/hdg1
           UUID : 29abe54b:e219e78b:99662049:8e486c8f
         Events : 0.92

