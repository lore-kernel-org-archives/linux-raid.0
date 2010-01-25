From: anoneironaut84 <anoneironaut@hotmail.com>
Subject: Linear RAID failure.  How to recreate?
Date: Sun, 24 Jan 2010 19:25:23 -0800 (PST)
Message-ID: <27301741.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hey all,

     I'm just wondering if there is any way to recreate a linear array.  For
example in a simple two disk linear RAID array if one disk fail if I replace
the old drive with a working drive can I stop the linear RAID array, format
the simple device nodes and recreate the array?  I tried to do something
like this but failed:

bash# mdadm --manage /dev/md1 -f /dev/sda2
mdadm: set /dev/sda2 faulty in /dev/md1
bash# mdadm --manage /dev/md1 -f /dev/sdb2
mdadm: set /dev/sdb2 faulty in /dev/md1
bash# cat /proc/mdstat
Personalities : [linear] [raid1]
md1 : active linear sdb2[1] sda2[0]
      957216768 blocks 64k rounding

md0 : active raid1 sdb1[1]
      9775424 blocks [2/1] [_U]

unused devices: <none>
bash# mdadm --manage /dev/md1 -r /dev/sdb2
mdadm: hot remove failed for /dev/sdb2: Device or resource busy
bash# mdadm --manage /dev/md1 -r /dev/sda2
mdadm: hot remove failed for /dev/sda2: Device or resource busy
bash# mdadm --manage /dev/md1 -fr /dev/sda2
mdadm: hot remove failed for /dev/sda2: Device or resource busy
bash# mdadm --manage --stop /dev/md1
mdadm: fail to stop array /dev/md1: Device or resource busy
bash# fuser -m /dev/md1
bash# fuser -m /dev/sda2
bash# fuser -m /dev/sdb2
bash# mdadm --manage --stop /dev/md1
mdadm: fail to stop array /dev/md1: Device or resource busy
bash-2.05b# lsof | grep md1
bash-2.05b#

Would appreciate some input.

Thanks!

-JD

PS  My system is RHEL-4 running on the 2.6.22 kernel.
-- 
View this message in context: http://old.nabble.com/Linear-RAID-failure.--How-to-recreate--tp27301741p27301741.html
Sent from the linux-raid mailing list archive at Nabble.com.

