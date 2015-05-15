From: Xiao Ni <xni@redhat.com>
Subject: raid5 reshape is stuck
Date: Fri, 15 May 2015 03:00:24 -0400 (EDT)
Message-ID: <2043891461.15360424.1431673224036.JavaMail.zimbra@redhat.com>
References: <1612858661.15347659.1431671671467.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1612858661.15347659.1431671671467.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil

   I encounter the problem when I reshape a 4-disks raid5 to raid5. It just can
appear with loop devices.

   The steps are:

[root@dhcp-12-158 mdadm-3.3.2]# mdadm -CR /dev/md0 -l5 -n5 /dev/loop[0-4] --assume-clean
mdadm: /dev/loop0 appears to be part of a raid array:
       level=raid5 devices=6 ctime=Fri May 15 13:47:17 2015
mdadm: /dev/loop1 appears to be part of a raid array:
       level=raid5 devices=6 ctime=Fri May 15 13:47:17 2015
mdadm: /dev/loop2 appears to be part of a raid array:
       level=raid5 devices=6 ctime=Fri May 15 13:47:17 2015
mdadm: /dev/loop3 appears to be part of a raid array:
       level=raid5 devices=6 ctime=Fri May 15 13:47:17 2015
mdadm: /dev/loop4 appears to be part of a raid array:
       level=raid5 devices=6 ctime=Fri May 15 13:47:17 2015
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
[root@dhcp-12-158 mdadm-3.3.2]# mdadm /dev/md0 -a /dev/loop5
mdadm: added /dev/loop5
[root@dhcp-12-158 mdadm-3.3.2]# mdadm --grow /dev/md0 --raid-devices 6
mdadm: Need to backup 10240K of critical section..
[root@dhcp-12-158 mdadm-3.3.2]# cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid5 loop5[5] loop4[4] loop3[3] loop2[2] loop1[1] loop0[0]
      8187904 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6] [UUUUUU]
      [>....................]  reshape =  0.0% (0/2046976) finish=6396.8min speed=0K/sec
      
unused devices: <none>

   It because the sync_max is set to 0 when run the command --grow

[root@dhcp-12-158 mdadm-3.3.2]# cd /sys/block/md0/md/
[root@dhcp-12-158 md]# cat sync_max 
0

   I tried reproduce with normal sata devices. The progress of reshape is no problem. Then
I checked the Grow.c. If I use sata devices, in function reshape_array, the return value
of set_new_data_offset is 0. But if I used loop devices, it return 1. Then it call the function
start_reshape. 

   In the function start_reshape it set the sync_max to reshape_progress. But in sysfs_read it
doesn't read reshape_progress. So it's 0 and the sync_max is set to 0. Why it need to set the
sync_max at this? I'm not sure about this. 

   I tried to fix this but I'm not sure whether it's the right way. I'll send the patches in 
other mails.

Best Regards
Xiao
