From: Xiao Ni <xni@redhat.com>
Subject: Does --freeze-reshape only work during initrd boot phase?
Date: Fri, 22 May 2015 06:30:09 -0400 (EDT)
Message-ID: <1625238601.2947919.1432290609781.JavaMail.zimbra@redhat.com>
References: <2047702950.2945677.1432290136375.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2047702950.2945677.1432290136375.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all

   I'm trying to use --freeze-reshape, I search how to use it, there is just some 
explanation in man mdadm. And I see the main usage about this is during initrd boot phase.
Does --freeze-reshape only work during initrd boot phase?

   I tried this after the machine started. The steps are as follows:
[root@intel-canoepass-02 tmp]# mdadm -CR /dev/md0 -l5 -n5 /dev/loop[0-4] --assume-clean
mdadm: /dev/loop0 appears to be part of a raid array:
       level=raid5 devices=5 ctime=Fri May 22 06:14:35 2015
mdadm: /dev/loop1 appears to be part of a raid array:
       level=raid5 devices=5 ctime=Fri May 22 06:14:35 2015
mdadm: /dev/loop2 appears to be part of a raid array:
       level=raid5 devices=5 ctime=Fri May 22 06:14:35 2015
mdadm: /dev/loop3 appears to be part of a raid array:
       level=raid5 devices=5 ctime=Fri May 22 06:14:35 2015
mdadm: /dev/loop4 appears to be part of a raid array:
       level=raid5 devices=5 ctime=Fri May 22 06:14:35 2015
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
[root@intel-canoepass-02 tmp]# mdadm /dev/md0 -a /dev/loop5 
mdadm: added /dev/loop5
[root@intel-canoepass-02 tmp]# mdadm -Es
ARRAY /dev/md/0  metadata=1.2 UUID=24d3d007:8ec28d4e:edb482fe:db7cab71 name=0
   spares=1
[root@intel-canoepass-02 tmp]# mdadm -Es > /etc/mdadm.conf 
[root@intel-canoepass-02 tmp]# mdadm --grow /dev/md0 --raid-devices 6
[root@intel-canoepass-02 tmp]# cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid5 loop5[5] loop4[4] loop3[3] loop2[2] loop1[1] loop0[0]
      2043904 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6] [UUUUUU]
      [====>................]  reshape = 23.9% (122368/510976) finish=0.8min speed=7648K/sec
      
unused devices: <none>
[root@intel-canoepass-02 tmp]# mdadm -S /dev/md0 
mdadm: stopped /dev/md0
[root@intel-canoepass-02 tmp]# mdadm -As --freeze-reshape
mdadm: /dev/md/0 has been started with 6 drives.
[root@intel-canoepass-02 tmp]# cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid5 loop0[0] loop5[5] loop4[4] loop3[3] loop2[2] loop1[1]
      2043904 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6] [UUUUUU]
      [=========>...........]  reshape = 46.9% (240128/510976) finish=0.1min speed=23808K/sec
      
unused devices: <none>

   The reshape is not freeze. I think it should be freeze now, am I right? The reason I want to
use this is that I want to use --grow --continue. I see --continue is used when reshape is 
interrupted. 

Best Regards
Xiao
