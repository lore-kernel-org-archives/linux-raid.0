From: "Johnson Yan" <johnson_yan@usish.com>
Subject: RAID0 DeviceDisappeared event happen when restart mdmonitor service
Date: Fri, 14 Sep 2012 18:02:41 +0800
Message-ID: <012401cd9260$141ca630$3c55f290$@com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: zh-cn
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,
When I restart mdmonitor service, a notify email will be received, which
indicate DeviceDisappeared event happened for RAID0, is this phenomenon
reasonable? Could anyone explain this? 


The email info as below
......
Host            : host3.com
Event           : DeviceDisappeared
MD Device       : /dev/md1
......

[root@host3 ~]# service mdmonitor restart
Killing mdmonitor:                                         [  OK  ]
Starting mdmonitor:                                        [  OK  ]
[root@host3 ~]#
[root@host3 ~]# cat /proc/mdstat
Personalities : [raid1] [raid0] 
md1 : active raid0 sda1[1] sdb1[0]
      927933312 blocks super 1.2 64k chunks
      
md2 : active raid1 sdc1[1] sde1[0]
      292836160 blocks super 1.2 [2/2] [UU]
      bitmap: 0/2 pages [0KB], 131072KB chunk

md0 : active raid1 sdf1[0] sdg1[1]
      488254272 blocks super 1.2 [2/2] [UU]
      bitmap: 0/2 pages [0KB], 131072KB chunk

unused devices: <none>
[root@host3 ~]# 
[root@host3 ~]# uname -r
3.2.28-11.el6.x86_64
[root@host3 ~]# 
[root@host3 ~]# mdadm -V
mdadm - v3.2.5 - 18th May 2012
[root@host3 ~]# 


Thanks in advance.
Johnson Yan


