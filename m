From: "Henry, Andrew" <andrew.henry@logica.com>
Subject: RE: (no subject): should have read--"Regarding thread '"Deleting
 mdadm RAID arrays'".
Date: Fri, 16 May 2008 11:02:45 +0200
Message-ID: <3ECBDC05781B3D48ABD520A01ABF2F9B12C54704D3@SE-EX008.groupinfra.com>
References: <3ECBDC05781B3D48ABD520A01ABF2F9B12C53D0880@SE-EX008.groupinfra.com>
 <482B5600.6040204@dgreaves.com>
 <3ECBDC05781B3D48ABD520A01ABF2F9B12C5435703@SE-EX008.groupinfra.com>
 <482C4240.7020202@dgreaves.com>
 <3ECBDC05781B3D48ABD520A01ABF2F9B12C546FB2B@SE-EX008.groupinfra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3ECBDC05781B3D48ABD520A01ABF2F9B12C546FB2B@SE-EX008.groupinfra.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> -----Original Message-----
>
> Thanks a lot for the help.  I'll try mdadm --stop as soon as syncing has
> finished (95% complete now!!!)
>

Well, sync finished successfully.

Mdadm --dtop /dev/md0   # OK
Mdadm --zero-superblock --force /dev/sda1  # OK
Mdadm --zero-superblock --force /dev/sdb1  # OK

These return to prompt without any messages.  If I then run them a second time they complain that the device is not part of an array.  All well and good.

Mdadm --create --verbose /dev/md0 --level=raid1 --raid-devices=2 /dev/sd[ab]1  # NOT OK.  Complains "already an array" starts a new resync.

Mdadm --stop /dev/md0  # stops resync :)

What else is needed?  Am I unable to recreate the array on md0?  Must I choose a new device such as md1?  Or is there another stop to erasing an array?

