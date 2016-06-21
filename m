From: Wakko Warner <wakko@animx.eu.org>
Subject: Making spare active without sync?
Date: Tue, 21 Jun 2016 13:47:40 -0400
Message-ID: <20160621174740.GA7601@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have an array that a drive dropped out due to a write error.  I don't know
if the drive is still good or not.  Another drive also has some read errors. 
I zero'd the superblock of the member device and added it back in.  When it
hit the errors, of course it kicks both out of the array.  I've already
recovered most of the data by forcing to assemble with the members that were
active (including the member that failed 2nd).  The data that is in the bad
spot isn't important and is recoverable by other means, but I'd like to try
this anyway.

I've already created a dm snapshot target for these 4 drives.  What I'd like
to do is make the drive that I zero'd the superblock on active without doing
any sync/resync.  Is this possible to do?  Or do I need to recreate the
array?  I don't care if the actual array does south right now.


Here's an mdadm -E on one member (All other members have the same
information regarding the array, ie offsets)
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : d2524c57:00804101:5bbb59b4:871db7a6
           Name : kame:2  (local to host kame)
  Creation Time : Sat Sep 24 09:17:18 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
     Array Size : 5860543296 (5589.05 GiB 6001.20 GB)
  Used Dev Size : 3907028864 (1863.02 GiB 2000.40 GB)
   Super Offset : 3907029152 sectors
   Unused Space : before=0 sectors, after=280 sectors
          State : clean
    Device UUID : 0638ac21:63fe9f2b:2aca8835:c65d4ac5

Internal Bitmap : -8 sectors from superblock
    Update Time : Mon Jun 20 00:30:30 2016
       Checksum : 6a1ca36f - correct
         Events : 54245

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 0
   Array State : A.AA ('A' == active, '.' == missing, 'R' == replacing)

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
