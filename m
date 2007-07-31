From: DrYak <blackkitty@bigfoot.com>
Subject: raid-0 to raid-5 ?
Date: Tue, 31 Jul 2007 14:09:52 +0200
Message-ID: <46AF2690.3000802@bigfoot.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have questions regarding the possibilities to migrate a striped array
into one with parity check.

I currently have a file server with two 300GB IDE drives. They are
configured using linux' software RAID in mode 0 (stripped).
The raided data is the subsequently partitioned using LVM with a couple
of partitions in ReiserFS and JFS format.

I have recently acquired  a 320GB SATA drive and a compatible SATA
controller. I would like to add a 300GB partition from that drive to the
stripe to add parity checks for security, transforming the raid set into
a raid-5.
The machine is running Debian 3.1, but I plan to upgrade to Debian 4.0
somewhere during all the upgrades.


Two questions :

I. *RAIDRECONF*
- Could raidreconf handle correctly the additional 300GB and raid
transformation ?
I've read on this list that raidreconf has mixed result.
Some people report flawless additions to RAIDs, other people report data
b0rked beyond any hope of recovery.
Has anyone tested a RAID-0 to RAID-5 transformation ? Is it more
reliable than RAID-5 addition ?
Or is it even less maintained and tested than the raid-5 additions ?
(Also, I've read that there are some people wanting to add journalling
feature to raidreconf, for better handling of interruptions etc. Is this
still developped or was it droped).

II. *MDADM --GROW*
- The current total of critical data happen to fit within 300GB.
What do you think if I :
- copy all the critical data to the newer 320GB drive.
- create a new RAID-5 set with the original 300GB drives (the set will
have somewhere around 300GB free, I think)
- LVM partition of the raid set
- copy the data back from the 320GB drive
- make a 300GB on the new drive, and add it to the RAID as a third drive
in the set using the new --GROW option of MDADM
Is it possible ? Will LVM correctly survive being on a device that
suddenly increases in size ?

Thank you a lot and have a nice day.

- DrYak -
