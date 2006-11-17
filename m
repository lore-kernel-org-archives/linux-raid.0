From: Russell Hammer <russ@perneus.com>
Subject: mdadm --misc --detail --test ... question
Date: Fri, 17 Nov 2006 14:21:18 -0500
Message-ID: <1163791278.2861.24.camel@a6000>
Reply-To: russ@perneus.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm trying to test the status of a raid device using mdadm:

# mdadm --misc --detail --test /dev/md0

However this does not appear to work as documented.  As I read the man
page, the return code is supposed to reflect the status of the raid
device:

"
MISC MODE
 ...
       --detail
              The  device  should be an active md device.  mdadm will
              display a detailed description of the array. --brief or --scan
              will cause the output to be less detailed and the format to be
              suitable for inclusion in  /etc/mdadm.conf.   The  exit status
              of mdadm will normally be 0 unless mdadm failed to get useful
              information about the device(s).  However if the --test option
              is given, then the exit status will be:

              0      The array is functioning normally.

              1      The array has at least one failed device.

              2      The array has multiple failed devices and hence is unusable (raid4 or raid5).

              4      There was an error while trying to get information about the device.
"

Am I missing something here (see below)?

Thanks,
Russ

------------------------------------------------------------------------
# mdadm --misc --detail --test /dev/md0; echo -e "\nReturned --> $?"
/dev/md0:
        Version : 00.90.03
  Creation Time : Mon Aug 23 12:49:46 2004
     Raid Level : raid1
     Array Size : 104320 (101.89 MiB 106.82 MB)
    Device Size : 104320 (101.89 MiB 106.82 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Nov 16 13:38:40 2006
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : 403240c4:4a5c7f60:ce59447e:a08858a9
         Events : 0.4476

    Number   Major   Minor   RaidDevice State
       0      33        1        0      active sync   /dev/hde1
       1      34        1        1      active sync   /dev/hdg1

Returned --> 0

# mdadm --manage --fail /dev/md0 /dev/hdg1
mdadm: set /dev/hdg1 faulty in /dev/md0

# mdadm --misc --detail --test /dev/md0; echo -e "\nReturned --> $?"
/dev/md0:
        Version : 00.90.03
  Creation Time : Mon Aug 23 12:49:46 2004
     Raid Level : raid1
     Array Size : 104320 (101.89 MiB 106.82 MB)
    Device Size : 104320 (101.89 MiB 106.82 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Nov 17 14:08:33 2006
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0

           UUID : 403240c4:4a5c7f60:ce59447e:a08858a9
         Events : 0.4478

    Number   Major   Minor   RaidDevice State
       0      33        1        0      active sync   /dev/hde1
       1       0        0        1      removed

       2      34        1        -      faulty spare   /dev/hdg1

Returned --> 0

# mdadm --manage --remove /dev/md0 /dev/hdg1
mdadm: hot removed /dev/hdg1

# mdadm --misc --detail --test /dev/md0; echo -e "\nReturned --> $?"
/dev/md0:
        Version : 00.90.03
  Creation Time : Mon Aug 23 12:49:46 2004
     Raid Level : raid1
     Array Size : 104320 (101.89 MiB 106.82 MB)
    Device Size : 104320 (101.89 MiB 106.82 MB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Nov 17 14:09:02 2006
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           UUID : 403240c4:4a5c7f60:ce59447e:a08858a9
         Events : 0.4480

    Number   Major   Minor   RaidDevice State
       0      33        1        0      active sync   /dev/hde1
       1       0        0        1      removed

Returned --> 0
-----------------------------------------------------------------------------------------



