From: Francis Moreau <francis.moro@gmail.com>
Subject: mdadm 3.3: issue with mdmon --takeover
Date: Tue, 3 Sep 2013 17:54:55 +0200
Message-ID: <CAC9WiBjg4Tbv_UM4o66-8jtFEYGvh3kuP6xSdnz7uL+fq3fZTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Martin :)

I gave 3.3 release a try and I have a first issue: basically starting
mdmon (3.3) with --takeover twice make mdmon failing on the second
run.

Please find details below:

# cat /proc/mdstat
Personalities : [raid1]
md126 : active raid1 sdb[1] sda[0]
      2064384 blocks super external:/md127/0 [2/2] [UU]

md127 : inactive sdb[1](S) sda[0](S)
      65536 blocks super external:ddf

# ps aux | grep dmon
root       311  0.4  1.0  80580 10944 ?        SLsl 17:46   0:00
@sbin/mdmon --takeover md127

# ./mdmon --takeover --all

# ps aux | grep dmon
root      3182  1.3  1.0  15156 11056 ?        SLsl 17:50   0:00
./mdmon --takeover md127

# ./mdmon --takeover --all
...
monitor: wake ( )
monitor: wake ( )
monitor: wake ( )
monitor: wake ( )
monitor: wake ( )
monitor: wake ( 12:array_state )
read_and_act(0): 1378223477.512347 state:clean prev:clean action:idle
prev: idle start:18446744073709551615
ddf mark 0/Linux-MDdeadbeef00000000?Ob79e0c8b1n (5) clean 18446744073709551615
manage_new: inst: 0 action: 11 state: 12
mdmon: ddf_open_new: subarray 0 doesn't exist
mdmon: failed to monitor external:/md127/0
free_aa: sys_name: md126
read_and_act(0): state:clean action:idle next( )
manage_new: inst: 0 action: 20 state: 21
ddf_open_new: new subarray 0, GUID: Linux-MDdeadbeef00000000?Ob79e0c8b1n
free_aa: sys_name: md126
caught sigterm, all clean... exiting
monitor: wake ( )
no arrays to monitor... exiting

# ps aux | grep dmon
#

Thanks
-- 
Francis
