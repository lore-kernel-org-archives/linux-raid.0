From: Eric BENARD / Free <ebenard@free.fr>
Subject: RAID5 rebuild difficulties
Date: Wed, 20 Aug 2003 14:53:38 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200308201453.38427.ebenard@free.fr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm having some troubles to rebuild a software RAID5 after several power 
failures.
Does anyone have an idea on how I could resync superblock of 4 partitions in 
order to rebuild the raid without loosing data ?

Many thanks and best regards
Eric

[root@serv root]# mdadm -Eb /dev/hde8
ARRAY /dev/md5 level=raid5 num-devices=3 
UUID=adecf616:84cf5266:30d2b689:ec3729e7
   devices=/dev/hde8
[root@serv root]# mdadm -Eb /dev/hdf6
ARRAY /dev/md5 level=raid5 num-devices=3 
UUID=adecf616:84cf5266:30d2b689:ec3729e7
   devices=/dev/hdf6
[root@serv root]# mdadm -Eb /dev/hdg8
ARRAY /dev/md5 level=raid5 num-devices=3 
UUID=adecf616:84cf5266:310000c4:ec3729e7
   devices=/dev/hdg8
[root@serv root]# mdadm -Eb /dev/hdh6
ARRAY /dev/md5 level=raid5 num-devices=3 
UUID=adecf616:84cf5266:30d2b689:003729e7
   devices=/dev/hdh6

[root@serv root]# mdadm -Af /dev/md5 /dev/hde8 /dev/hdf6 /dev/hdg8 /dev/hdh6
mdadm: superblock on /dev/hdg8 doesn't match others - assembly aborted

[root@serv root]# mdadm -V
mdadm - v1.3.0 - 29 Jul 2003

