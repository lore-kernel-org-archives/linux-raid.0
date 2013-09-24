From: Andreas Heinlein <aheinlein@gmx.com>
Subject: Strange RAID 1 rebuild problem
Date: Tue, 24 Sep 2013 14:23:03 +0200
Message-ID: <52418427.40208@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

we have a strange problem rebuilding a partially destroyed md raid 1, 
and I hope you can help me.

Short description: We have a machine with two disks with 4 partitions 
each; partitions 2, 3 and 4 each form a raid 1 (md0 = sda2/sdc2, md1 = 
sda3/sdc3, md2 = sda4/sdc4). We lost a disk some days ago and I am now 
trying to rebuild it with a brand new disk (here sdc). I cloned the 
partition table from sda to sdc and successfully added back partitions 2 
and 3 to md0 and md1, respectively. I also added partition 4 to md2, and 
it starts rebuilding. I can see a "RebuildFinished Event" some hours 
later in the logs, but when I look at /proc/mdstat, it looks like this:

md2 : active raid1 sdc4[1](S) sda4[0]
       xxx blocks [2/1] [_U]

So the newly-added partition is listed as a spare, while md2 is running 
on only one of two devices. I have no idea where this comes from, and I 
see no further information in the logs. The array was initially built 
with 2 devices *plus* one spare (which is to be added later on), but I 
don't think this is an issue here.

We're running Linux 2.6.32 on Debian 6.0, with mdadm
