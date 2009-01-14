From: Eamonn Hamilton <eamonn@snifter.org>
Subject: differnet UUIDs and no of spares :(
Date: Wed, 14 Jan 2009 17:26:41 +0000
Message-ID: <1231954002.17710.13.camel@brandy.snifter.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Guys,

I'm looking at a server with a bunch of disks that had a raid 5 with two
spares, however, one of the spares failed, the system then started
rebuilding on the other and it crashed during the rebuild.

I'm now left in the following situation :


for a in a b c d e f g h i; do mdadm --examine --scan /dev/sd${a}; done
ARRAY /dev/md0 level=raid5 num-devices=7 UUID=e1e75e8b:f9f387cd:5feed4c5:31c51eb2
ARRAY /dev/md0 level=raid5 num-devices=7 UUID=e1e75e8b:f9f387cd:5feed4c5:31c51eb2
ARRAY /dev/md0 level=raid5 num-devices=7 UUID=e1e75e8b:f9f387cd:5feed4c5:31c51eb2
ARRAY /dev/md0 level=raid5 num-devices=7 UUID=e1e75e8b:f9f387cd:5feed4c5:31c51eb2
ARRAY /dev/md0 level=raid5 num-devices=7 UUID=e1e75e8b:f9f387cd:5feed4c5:31c51eb2
ARRAY /dev/md0 level=raid5 num-devices=7 UUID=e1e75e8b:f9f387cd:8d12a2d2:3188faf0
   spares=1
ARRAY /dev/md0 level=raid5 num-devices=7 UUID=e1e75e8b:f9f387cd:8d12a2d2:3188faf0
ARRAY /dev/md0 level=raid5 num-devices=7 UUID=e1e75e8b:f9f387cd:8d12a2d2:3188faf0
   spares=1
ARRAY /dev/md0 level=raid5 num-devices=7 UUID=e1e75e8b:f9f387cd:8d12a2d2:3188faf0


The system complains because of the different uuids, and refuses to
recreate the array.

Is it basically stuffed, or is there something I can do to recover the
2TB filesystem that's on there ?

Cheers,
Eamonn

