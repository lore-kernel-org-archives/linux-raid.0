From: Scott Ransom <sransom@cv.nrao.edu>
Subject: always dirty RAID5 arrays
Date: Tue, 9 Nov 2004 16:03:24 -0500
Message-ID: <200411091603.24933.sransom@cv.nrao.edu>
Reply-To: sransom@nrao.edu
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: sransom@nrao.edu
List-Id: linux-raid.ids

Hi All,

On one of our servers we have 4 6-disk RAID5 arrays running.  Each of the 
arrays was created using the following command:

mdadm --create /dev/md3 --level=5 --verbose --force --chunk=128 \ 
--raid-devices=6 /dev/sd[ijklmn]1

After building and a resync (and a reboot and a resync...), the array looks 
like this:

--------------------------------------------
spigot2  sransom 84: mdadm --detail /dev/md3
/dev/md3:
        Version : 00.90.00
  Creation Time : Tue Sep 21 15:54:31 2004
     Raid Level : raid5
     Array Size : 1220979200 (1164.42 GiB 1250.28 GB)
    Device Size : 244195840 (232.88 GiB 250.06 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 3
    Persistence : Superblock is persistent

    Update Time : Sat Nov  6 10:58:12 2004
          State : dirty
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

           UUID : 264b9069:96d7a1a6:d3b17be5:23fa47ce
         Events : 0.30

    Number   Major   Minor   RaidDevice State
       0       8      129        0      active sync   /dev/sdi1
       1       8      145        1      active sync   /dev/sdj1
       2       8      161        2      active sync   /dev/sdk1
       3       8      177        3      active sync   /dev/sdl1
       4       8      193        4      active sync   /dev/sdm1
       5       8      209        5      active sync   /dev/sdn1
-----------------------------------------------------------------


Notice that the State is "dirty".  If we reboot, the arrays are in a dirty 
status and always need to resync.  Any idea why would this be?  (I'm 
running XFS on the RAIDs and am using a slightly modified RH9.0 kernel:  
2.4.24aa1-xfs)

Thanks for the help,

Scott

-- 
Scott M. Ransom            Address:  NRAO
Phone:  (434) 296-0320               520 Edgemont Rd.
email:  sransom@nrao.edu             Charlottesville, VA 22903 USA
GPG Fingerprint: 06A9 9553 78BE 16DB 407B  FFCA 9BFA B6FF FFD3 2989
