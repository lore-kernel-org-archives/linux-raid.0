From: "Henry, Andrew" <andrew.henry@logica.com>
Subject: RE: (no subject): should have read--"Regarding thread '"Deleting
 mdadm RAID arrays'".
Date: Mon, 19 May 2008 16:21:32 +0200
Message-ID: <3ECBDC05781B3D48ABD520A01ABF2F9B12C5565BC7@SE-EX008.groupinfra.com>
References: <3ECBDC05781B3D48ABD520A01ABF2F9B12C53D0880@SE-EX008.groupinfra.com>
	<482B5600.6040204@dgreaves.com>
	<3ECBDC05781B3D48ABD520A01ABF2F9B12C5435703@SE-EX008.groupinfra.com>
	<482C4240.7020202@dgreaves.com>
	<3ECBDC05781B3D48ABD520A01ABF2F9B12C546FB2B@SE-EX008.groupinfra.com>
	<3ECBDC05781B3D48ABD520A01ABF2F9B12C54704D3@SE-EX008.groupinfra.com>
 <18481.6589.876469.898266@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18481.6589.876469.898266@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: David Greaves <david@dgreaves.com>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----Original Message-----
From: Neil Brown [mailto:neilb@suse.de]
Sent: 19 May 2008 08:10
To: Henry, Andrew
Cc: David Greaves; LinuxRaid
Subject: RE: (no subject): should have read--"Regarding thread '"Deleting mdadm RAID arrays'".
> These return to prompt without any messages.  If I then run them a second time they complain that the device is not part of an array.  All well and good.
>
> Mdadm --create --verbose /dev/md0 --level=raid1 --raid-devices=2 /dev/sd[ab]1  # NOT OK.  Complains "already an array" starts a new resync.

I wasn't paying close attention to this thread, so maybe I missed
something significant, but what exactly is the "complaint" you get
here?

Mdadm was saying that the array to be created was already part of an array, but I fixed this now by running dd if=/dev/zero of=/dev/sd[ab] to wipe the whole disk

Now when I run:

mdadm --create --verbose /dev/md0 --raid-devices=2 --level=raid1 /dev/sd[ab]1

It replies:

mdadm: size set to 488383936K
mdadm: array /dev/md0 started.

However, when I look at mdstat I see the following:

[root@k2 ~]# cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdb1[1] sda1[0]
      488383936 blocks [2/2] [UU]
      [>....................]  resync =  0.0% (187520/488383936) finish=1301.1min speed=6250K/sec

unused devices: <none>
[root@k2 ~]#

Why does it "resync" upon creating a new array?

>
> Mdadm --stop /dev/md0  # stops resync :)
>
> What else is needed?  Am I unable to recreate the array on md0?  Must I choose a new device such as md1?  Or is there another stop to erasing an array?

Why do you feel a need to erase an array?

Because I created it with version 1.0 superblock and it wasn't getting autodetected by the kernel 2.6.18-53.  I want to re-create it with version 0.9 superblock.

NeilBrown

