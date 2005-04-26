From: "Chris Mason (Lists)" <lists@masonc.com>
Subject: Hwo to add swap to raid
Date: Tue, 26 Apr 2005 06:57:56 -0400
Message-ID: <20050426110439.6EF4792C3AC@mercury.mason.home>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a server that was setup with RAID1 so that the data would not be lost
on a drive failure. However, I since realized I did not RAID the swap file
and so in the event of a drive failure the server would crash.
How can I convert the swap partition to RAID? I replaced /dev/hdc and
partitioned it tbe same as /dev/had, and rebuild /dev/md0 and /dev/md1, but
need to find a way to get the swap to be /dev/md2.


   Device Boot    Start       End    Blocks   Id  System
/dev/hda1   *         1        26    208813+  fd  Linux raid autodetect
/dev/hda2            27       153   1020127+  82  Linux swap
/dev/hda3           154     24792 197912767+  fd  Linux raid autodetect

   Device Boot    Start       End    Blocks   Id  System
/dev/hdc1   *         1        26    208813+  fd  Linux raid autodetect
/dev/hdc2            27       153   1020127+  82  Linux swap
/dev/hdc3           154     24792 197912767+  fd  Linux raid autodetect

[root@mercury root]# cat /proc/mdstat 
Personalities : [raid1] 
read_ahead 1024 sectors
md1 : active raid1 hdc3[2] hda3[0]
      197912640 blocks [2/1] [U_]
      [>....................]  recovery =  1.3% (2665008/197912640)
finish=306.1min speed=10625K/sec
md0 : active raid1 hdc1[1] hda1[0]
      208704 blocks [2/2] [UU]

Chris Mason
NetConcepts
(264) 497-5670 Fax: (264) 497-8463
Int:  (646)722-0001 Fax: (815)301-9759 
Yahoo IM: netconcepts_anguilla@yahoo.com 
Skype ID: netconcepts

