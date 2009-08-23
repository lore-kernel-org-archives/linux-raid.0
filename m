From: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Subject: raid array not auto restarting
Date: Sun, 23 Aug 2009 19:19:44 +0530
Message-ID: <5c45fce80908230649y4acc48acxefc8a4bef698e860@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Although its not a show stopper, would really appreciate some help on this.

My raid arrays don't start up automatically like they used to after I
grew them to include the 4th disk (yes, I DID modify the mdadm.conf so
I'm not sure what's not working here)
Kernel: 2.6.30.4; mdadm 3.0 (are there any other libraries whose
version I should be checking also, since I manually upgraded Ubuntu
Jaunty to mdadm 3.0)

Here is the /proc/mdstat after booting up:
---------------------
cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md_d126 : inactive sda2[3](S)
      195334208 blocks super 1.2

md_d127 : inactive sdb[0](S)
      293057216 blocks super 1.2

unused devices: <none>

------------------
cat /etc/md/mdadm.conf

DEVICE /dev/sdb /dev/sdd5 /dev/sdc5 /dev/sda1
DEVICE /dev/sdc6 /dev/sdd6 /dev/sda2
DEVICE /dev/sdc7 /dev/sdd7

# auto-create devices with Debian standard permissions
# CREATE owner=root group=disk mode=0660 auto=yes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR root

# definitions of existing MD arrays
ARRAY /dev/md_d127 LEVEL=raid5 NUM-DEVICES=4 METADATA=1.2
UUID=42c56ea0:2484f566:387adc6c:b3f6a014
DEVICES=/dev/sdb,/dev/sdd5,/dev/sdc5,/dev/sda1 NAME=GATEWAY:raid5_280G
ARRAY /dev/md_d126 LEVEL=raid5 num-devices=3 METADATA=1.2
UUID=54b83ff7:55316d90:d497a0cb:5a3309fe
DEVICES=/dev/sdc6,/dev/sdd6,/dev/sda2 NAME=GATEWAY:raid5_186G
ARRAY /dev/md_d125 LEVEL=raid5 NUM-DEVICES=2 METADATA=1.2
UUID=e501ec78:3e45999f:4ecca49e:d48db221 DEVICES=/dev/sdc7,/dev/sdd7
NAME=GATEWAY:raid5_178G
----------------

This array starts fine when I do the following:

mdadm -S /dev/md_d1*
mdadm -A -s

So, if the scan works without any changes in the mdadm, then why
doesn't it work at boot time?

Thanks again,
Anshuman
