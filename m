From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Fwd: component device mismatches found
Date: Sun, 19 Mar 2017 11:42:54 +0100
Message-ID: <CAJH6TXhhYC0fenX3JZSwdaS+Rszdxkt8o4iLW6gK_dMsYe1JaA@mail.gmail.com>
References: <CAJH6TXgA-5-PXmFdY7b1J8eYc3zbmb7ui8Fa8k+ihMKd7nQ8vw@mail.gmail.com>
 <58CE5BB9.3090908@youngman.org.uk> <CAJH6TXhYYuh3v8FDDUisCpTZqVJ3WHEb_W0Ky=jkQHm1Y-fR4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXhYYuh3v8FDDUisCpTZqVJ3WHEb_W0Ky=jkQHm1Y-fR4w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

/cc linux-raid


---------- Forwarded message ----------
From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Date: 2017-03-19 11:42 GMT+01:00
Subject: Re: component device mismatches found
To: Wols Lists <antlists@youngman.org.uk>


2017-03-19 11:21 GMT+01:00 Wols Lists <antlists@youngman.org.uk>:
> mdadm --detail /dev/md/0

# mdadm --detail /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Mon Jul 25 12:55:48 2016
     Raid Level : raid1
     Array Size : 488382841 (465.76 GiB 500.10 GB)
  Used Dev Size : 488382841 (465.76 GiB 500.10 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Sun Mar 19 11:38:53 2017
          State : clean, recovering
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

 Rebuild Status : 83% complete

           Name : x:0  (local to host x)
           UUID : b2a5ed53:42890b73:dc6de22a:1ac12524
         Events : 29170

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1




keep in mind that:
1) i've done a check this morning, after seeing the mismatch error in syslog
2) even this check has triggered a rebuild, probably due to the same mismatch.
3) SMART doesn't report any errors,
4) disks are "new", 5600 hours.
5) swap is still unused
