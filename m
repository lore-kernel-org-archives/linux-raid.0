From: "mario kammerer - the.PRO-jects.com" <m.kammerer@pro-jects.com>
Subject: mdadm state
Date: Mon, 19 Dec 2005 10:41:28 +0100
Message-ID: <1134985289.11548.17.camel@Gentoo-Whng40.pro-jects.com>
Reply-To: m.kammerer@pro-jects.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hello neil, hello all!

i have only a small single question, which i cannot solve via searching
the web.

i got an raid1 with 2 scsi disk (2x 73g) and have the state "dirty,
no-errors".

what can i do to get a REAL CLEAN state - both disks are on, active
sync.

---- snipplet -----
mdadm -D /dev/md1
/dev/md1:
        Version : 00.90.00
  Creation Time : Mon Feb 10 21:17:05 2003
     Raid Level : raid1
     Array Size : 71681920 (68.36 GiB 73.40 GB)
    Device Size : 71681920 (68.36 GiB 73.40 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Mon Dec 19 11:25:26 2005
          State : dirty, no-errors
Active Devices : 2
Working Devices : 2
Failed Devices : 0
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
           UUID : 59a16c8a:d18a2590:cfe54cd9:f8c7ff55
         Events : 0.63
---------------------------------------------------------------------------

many thanks for a small tip!

best regards,
mario - austria - vienna


--
Mario Kammerer  


http://the.PRO-jects.com
1170 Wien - Ottakringer Strasse 30/40
The information in this email is confidential and may be legally
privileged. Access to this email by anyone other than the intended
addressee is unauthorized. If you are not the intended recipient of this
message, any review, disclosure, copying, distribution, retention, or
any action taken or omitted to be taken in reliance on it is prohibited
and may be unlawful. If you are not the intended recipient, please reply
to or forward a copy of this message to the sender and delete the
message, any attachments, and any copies thereof from your system.
Thanx.

 ### LINUX is just like a wigwam... no WINDOWS, no GATES, but an apache
                              inside ####

