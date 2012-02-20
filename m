From: "RANSOM, Tony" <tony.ransom@baesystems.com>
Subject: RE: Problem rebuild raid 1 replacement disk
Date: Mon, 20 Feb 2012 18:58:22 +1030
Message-ID: <807765805CA0DF48898D4C016E982BFC065A6D9BF5@MWLSVEXM002.au.baesystems.com>
References: <807765805CA0DF48898D4C016E982BFC065A67CE25@MWLSVEXM002.au.baesystems.com>,<20120220162915.43b4f451@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120220162915.43b4f451@notabene.brown>
Content-Language: en-AU
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,

Thanks for the reply:


>What is the output of each of
>  mdadm -E /dev/sdb

root@server2:~# mdadm -E /dev/sdb
/dev/sdb:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 15e5ad84:82b4dd79:6719eb14:a41dd719
  Creation Time : Mon Mar 28 23:52:08 2011
     Raid Level : raid1
  Used Dev Size : 1953027008 (1862.55 GiB 1999.90 GB)
     Array Size : 1953027008 (1862.55 GiB 1999.90 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1

    Update Time : Sun Feb 19 15:44:55 2012
          State : active
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 5e4b8288 - correct
         Events : 1314601

      Number   Major   Minor   RaidDevice State
this     2       8       16        2      spare   /dev/sdb

   0     0       0        0        0      removed
   1     1       8        3        1      active sync   /dev/sda3
   2     2       8       16        2      spare   /dev/sdb


>  mdadm -E /dev/sdb3

root@server2:~# mdadm -E /dev/sdb3
/dev/sdb3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 15e5ad84:82b4dd79:6719eb14:a41dd719
  Creation Time : Mon Mar 28 23:52:08 2011
     Raid Level : raid1
  Used Dev Size : 1953027008 (1862.55 GiB 1999.90 GB)
     Array Size : 1953027008 (1862.55 GiB 1999.90 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1

    Update Time : Mon Feb 20 18:38:09 2012
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 5e621af4 - correct
         Events : 1349308


      Number   Major   Minor   RaidDevice State
this     0       8       19        0      active sync   /dev/sdb3

   0     0       8       19        0      active sync   /dev/sdb3
   1     1       8        3        1      active sync   /dev/sda3




>What version of mdadm do you have?

root@server2:~# mdadm -V
mdadm - v2.6.7.1 - 15th October 2008

>What is the starting sector of /dev/sdb3?  In particular, is it a multiple of
64K?

589824

Doesn't appear to be. Each sector (according to gdisk is 512 bytes), but this is same as sda.


Odd that the system thinks sdb is a spare?

Can it be corrected?

Thanks again,
Tony









"Warning:
The information contained in this email and any attached files is
confidential to BAE Systems Australia. If you are not the intended
recipient, any use, disclosure or copying of this email or any
attachments is expressly prohibited.  If you have received this email
in error, please notify us immediately. VIRUS: Every care has been
taken to ensure this email and its attachments are virus free,
however, any loss or damage incurred in using this email is not the
sender's responsibility.  It is your responsibility to ensure virus
checks are completed before installing any data sent in this email to
your computer."


