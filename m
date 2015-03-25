From: Xiao Ni <xni@redhat.com>
Subject: /dev/md0 can't be created
Date: Wed, 25 Mar 2015 02:15:34 -0400 (EDT)
Message-ID: <12135556.2792023.1427264134774.JavaMail.zimbra@redhat.com>
References: <1215809785.2787621.1427263359309.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1215809785.2787621.1427263359309.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all

   I have encountered so many times, the raid device is created successfully, but the directory
/dev/md0 can't be created. It can't reproduce 100%. 

[root@intel-sugarbay-do-01 create_assemble]# cat /proc/mdstat 
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md0 : active raid10 loop7[7](S) loop6[6] loop5[5] loop4[4] loop3[3] loop2[2] loop1[1] loop0[0]
      1788416 blocks super 1.2 512K chunks 2 near-copies [7/7] [UUUUUUU]
      bitmap: 0/1 pages [0KB], 65536KB chunk

unused devices: <none>
[root@intel-sugarbay-do-01 create_assemble]# ls /dev/md0
ls: cannot access /dev/md0: No such file or directory

    The underline devices are loop devices which are created with big file.

    The kernel I used is RHEL7 (3.10.0-234.el7.x86_64.debug, mdadm - v3.3.2 - 21st August 2014) 
I'll try to reproduce this with upstream kernel and mdadm. But I think it shouldn't be the problem about kernel.

    What do you think I should check for this? And which tool is responsible for creating the directory? Maybe
I can add some log to it to find the reason.

Best Regards
Xiao
