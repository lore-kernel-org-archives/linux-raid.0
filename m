From: linux-lists@artelesys.com
Subject: mdadm info
Date: Fri, 2 Jul 2004 00:13:06 -0500 (CDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0407012355300.23562-100000@westhost38.westhost.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Hello.
Was wondering if there is any additional documentation for the mdadm 
program besides the man page. The values I get running mdadm -D are not 
immediately intuitive to me, For instance, why do I get "-1" under the 
"Failed Devices:" field ?  or why is the "Total Devices:" field "1" while
all others "2"? 

Thanks in advance for any pointers you can provide.   

Arturo

****
/sbin/mdadm -D  /dev/md2
/dev/md2:
        Version : 00.90.00
  Creation Time : Fri Dec 13 20:27:49 2002
     Raid Level : raid1
     Array Size : 521984 (509.75 MiB 534.51 MB)
    Device Size : 521984 (509.75 MiB 534.51 MB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Thu Jul  1 17:03:36 2004
          State : dirty
 Active Devices : 2
Working Devices : 2
 Failed Devices : -1
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0       3        6        0      active sync   /dev/hda6
       1      22        6        1      active sync   /dev/hdc6
           UUID : 255a65a8:5e8e0a35:0aef765e:6f307c50
         Events : 0.196

