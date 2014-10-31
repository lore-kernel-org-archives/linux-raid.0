From: Caspar Smit <c.smit@truebit.nl>
Subject: Trying to get POLICY working
Date: Fri, 31 Oct 2014 16:19:04 +0100
Message-ID: <CADvHm=ZLp08Ydp+P=gn+bu1=GgVORx0TSJoRU33z3UNubwQryQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I'm trying to get the POLICY framework of mdadm working but I can't seem to.

As i understand in the man page of mdadm the Incremental and POLICY
directives could allow adding a new disk without MD superblock as
spare to an already active array:

"Note that mdadm will normally only add devices to an array which were
previously working (active or spare) parts of that array.  The support
for automatic inclusion of a new drive as a spare in some array
requires a configuration through POLICY in config file."

Furthermore:

"If no md metadata is found, the device may be still added to an array
as a spare if POLICY allows."


To get the basics working I created a system with 3 disks /dev/sdb,
/dev/sdc and /dev/sdd

Created a RAID5 with one missing disk:

mdadm -C /dev/md0 -l 5 -n 3 /dev/sd[b-c] missing

I set the POLICY in mdadm.conf to:

POLICY action=force-spare

This should add any device (passed through mdadm --incremental) as
spare no matter what (Am i correct?)

Now when I do:

#mdadm --incremental /dev/sdd
mdadm: no RAID superblock on /dev/sdd.

Well, i know there is no MD superblock on /dev/sdd but shouldn't the
policy setting kick in here and add /dev/sdd as spare (and hence start
rebuilding) to /dev/md0?

mdadm version: 3.2.5-5 (latest debian wheezy stable)
kernel version: 3.2.63-2 (latest debian wheezy stable)

Kind regards,
Caspar Smit
