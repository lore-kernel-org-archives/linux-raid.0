From: Ken Causey <ken@ineffable.com>
Subject: Can't add missing member back in???
Date: 26 Jun 2002 12:10:57 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1025111457.596.13.camel@temp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Interesting problem.  I'm setting up an all software RAID system and
after a few fits and starts have reached some success.  I started to do
some testing and have run into a problem.  What I was doing is I was one
by one unplugging one of the SCSI drives and then powering up the system
to make sure it would power up properly.  The first time I did this
everything worked great.  I plugged the drive back up and used
raidhotadd to recover and got everything to UUU.  I then powered off and
unplugged another drive, system boots up great with only two drives. 
Now its time to plug the drive back in and rebuild the array to be ready
to unplug the last of the three drives for a thorough test.  Only, now I
can ONLY boot up if I DO NOT have the missing drive plugged in.  This is
really weird.  If I have all three devices attached then it claims that
2/3 of the devices that make up md2 (my root) are unavailable and well
then we are screwed.  WTF?

Anyway, here's my setup, let me know what else you need to know:

/boot	/dev/md0 	RAID1	(/dev/sda1 /dev/sdb1 /dev/sdc1)
swap	/dev/md1	RAID1	(/dev/sda2 /dev/sdb2 /dev/sdc2)
/	/dev/md2	RAID5	(/dev/sda3 /dev/sdb3 /dev/sdc3)
/home	/dev/md3	RAID5	(/dev/sda5 /dev/sdb5 /dev/sdc5)
/var	/dev/md4	RAID5	(/dev/sda6 /dev/sdb6 /dev/sdc6)

The drive that is currently "failed" is /dev/sdb.  Again, the system
boots up happily with sdb disconnected.  But has fits if it is
reconnected and all 3 drives are connected.

All help is appreciated,

Ken Causey



