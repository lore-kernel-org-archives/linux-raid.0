From: "Christof Soehngen" <christof@soehngen.org>
Subject: Expert opinion on "Recovering from a multiple disk failure"
Date: Fri, 26 Sep 2003 23:08:36 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <008501c38472$5aa0c650$9b00a8c0@Laptop>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list,

I seem to be in severe trouble because my software RAID 5 is not
accessible anymore, needless to say the data on it is important to me ;)
I use the four disks hde, hdf, hdg, hdh. I'm 100% sure my /etc/raidtab
has correct and actual settings:

raiddev /dev/md0
 raid-level 5
 nr-raid-disks 4
 nr-spare-disks 0
 persistent-superblock 1
 parity-algorithm left-symmetric
 chunk-size 128
 device /dev/hde1
 raid-disk 0
 device /dev/hdf1
 raid-disk 1
 device /dev/hdg1
 raid-disk 2
 device /dev/hdh1
 raid-disk 3

Yesterday there were two power outages. After the first, I saw one of
the hdds rebuilding (hdd led was on all the time).
After the second outage, the md0 was not recognised correctly anymore
after startup.

I think, the important lines from /var/log/boot.msg are the following:

hdh1's event counter: 0000001c
hdg1's event counter: 0000001c
hdf1's event counter: 0000001a
hde1's event counter: 0000001b
superblock update inconsistency
kicking non-fresh hdf1 from array!
kicking faulty hde1!
not enough operational devices for md0 (2/4 failed)

Now I read the ideas in
http://www.faqs.org/docs/Linux-HOWTO/Software-RAID-HOWTO.html#ss6.1
("Recovering from a multiple disk failure") and played with a test raid
system (md1) a little bit. I found out the following:

- If I create a new raid for testing (md1 on hdd1 to hdd4), stop it,
damage one disk (I formatted it), then do a "mkraid /dev/md1 --force",
all data is lost.
- If I mark the faulty disk as "failed-disk" in /etc/raidtab, then do a
"mkraid /dev/md1 --force", the raid is present again, albeit in degraded
mode. A "raidhotadd /dev/md1 /dev/hdd1" would launch a rebuild.

Now my question is: According to the messages displayed above, I figure
out that disk hde1 is damaged, disk hdf1 has a wrong superblock.
I would do the following :

1. Mark hde1 as failed-disk in /etc/raidtab
2. Do a "mkraid /dev/md0 --force"
3. Do a "raidhotadd /dev/md0 /dev/hde1"

What do you think, will my real data be online again?
I really would appreciate your help, thanks in advance, Christof

