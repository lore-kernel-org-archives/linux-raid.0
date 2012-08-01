From: Albert Pauw <albert.pauw@gmail.com>
Subject: ddf failed disk disappears after adding spare
Date: Wed, 01 Aug 2012 10:29:51 +0200
Message-ID: <5018E8FF.6030402@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Hi Neil,

here is a procedure which shows you another problem. It has to do with 
the table produced at the end of the mdadm -E command, showing the disks 
and their status. Seems when a disk has failed and another added, the 
failed one disappears.

Hope you can find the problem and fix it.

Regards,

Albert

Here is the exact procedure which shows the problem:

Create a container with 5 disks:

mdadm -CR /dev/md127 -e ddf -l container -n 5 /dev/loop[1-5]

  Physical Disks : 5
       Number    RefNo      Size       Device      Type/State
          0    d1c8c16e    479232K /dev/loop1 Global-Spare/Online
          1    6de79cb6    479232K /dev/loop2 Global-Spare/Online
          2    b5fd1d6c    479232K /dev/loop3 Global-Spare/Online
          3    0be2d310    479232K /dev/loop4 Global-Spare/Online
          4    5d8ac3d0    479232K /dev/loop5 Global-Spare/Online


Create a RAID 5 set of 3 disks in container:

mdadm -CR /dev/md0 -l 5 -n 3 /dev/md127

Physical Disks : 5
       Number    RefNo      Size       Device      Type/State
          0    d1c8c16e    479232K /dev/loop1      active/Online
          1    6de79cb6    479232K /dev/loop2      active/Online
          2    b5fd1d6c    479232K /dev/loop3      active/Online
          3    0be2d310    479232K /dev/loop4 Global-Spare/Online
          4    5d8ac3d0    479232K /dev/loop5 Global-Spare/Online


Create a RAID 1 set of 2 disks in container:

mdadm -CR /dev/md1 -l 1 -n 2 /dev/md127

Physical Disks : 5
       Number    RefNo      Size       Device      Type/State
          0    d1c8c16e    479232K /dev/loop1      active/Online
          1    6de79cb6    479232K /dev/loop2      active/Online
          2    b5fd1d6c    479232K /dev/loop3      active/Online
          3    0be2d310    479232K /dev/loop4      active/Online
          4    5d8ac3d0    479232K /dev/loop5      active/Online


Fail first disk in RAID 5 set:

mdadm -f /dev/md0 /dev/loop1

Physical Disks : 5
       Number    RefNo      Size       Device      Type/State
          0    d1c8c16e    479232K /dev/loop1      active/Offline, Failed
          1    6de79cb6    479232K /dev/loop2      active/Online
          2    b5fd1d6c    479232K /dev/loop3      active/Online
          3    0be2d310    479232K /dev/loop4      active/Online
          4    5d8ac3d0    479232K /dev/loop5      active/Online


Remove failed disk:

mdadm -r /dev/md0 /dev/loop1

Physical Disks : 5
       Number    RefNo      Size       Device      Type/State
          0    d1c8c16e    479232K                 active/Offline, 
Failed, Missing
          1    6de79cb6    479232K /dev/loop2      active/Online
          2    b5fd1d6c    479232K /dev/loop3      active/Online
          3    0be2d310    479232K /dev/loop4      active/Online
          4    5d8ac3d0    479232K /dev/loop5      active/Online


Add failed disk back:

mdadm -a --force /dev/md0 /dev/loop1

Physical Disks : 5
       Number    RefNo      Size       Device      Type/State
          0    d1c8c16e    479232K /dev/loop1      active/Offline, 
Failed, Missing
          1    6de79cb6    479232K /dev/loop2      active/Online
          2    b5fd1d6c    479232K /dev/loop3      active/Online
          3    0be2d310    479232K /dev/loop4      active/Online
          4    5d8ac3d0    479232K /dev/loop5      active/Online


Add spare disk to container:

mdadm -a --force /dev/md0 /dev/loop6

Physical Disks : 5
       Number    RefNo      Size       Device      Type/State
          0    6de79cb6    479232K /dev/loop2      active/Online
          1    b5fd1d6c    479232K /dev/loop3      active/Online
          2    0be2d310    479232K /dev/loop4      active/Online
          3    5d8ac3d0    479232K /dev/loop5      active/Online
          4    1dcfe3cf    479232K /dev/loop6      active/Online, Rebuilding

This is wrong! Physical disks should be 6 now!

Removed failed disk (which is missing from list now!) again, zero 
superblock and add again:

mdadm -r /dev/md0 /dev/loop1
mdadm --zero-superblock /dev/loop1
mdadm -a --force /dev/md0 /dev/loop1


Physical Disks : 6
       Number    RefNo      Size       Device      Type/State
          0    6de79cb6    479232K /dev/loop2      active/Online
          1    b5fd1d6c    479232K /dev/loop3      active/Online
          2    0be2d310    479232K /dev/loop4      active/Online
          3    5d8ac3d0    479232K /dev/loop5      active/Online
          4    1dcfe3cf    479232K /dev/loop6      active/Online
          5    8147a3ef    479232K /dev/loop1 Global-Spare/Online

And there they are, all 6 of them.


