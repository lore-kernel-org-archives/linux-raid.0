From: "stephan sperber" <quinte17@gmx.de>
Subject: failed raid5 after ide cable malfunction.
Date: Wed, 7 Jan 2009 17:50:56 +0100
Message-ID: <003301c970e8$1c6d2b90$554782b0$@de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: de
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everybody!
I have a little trouble in getting the raid5 up and running again.
What has happened so far:
1. Booting the System
2. Ide cable had some troubles so 2 disks went "mad" during boot and raid
couldn't get assembled.
(/dev/sda4 /dev/sdb2)
3. I forced poweroff because system wasn't responsible due to ATA connection
problems.
4. after reboot the raid5 got up again, were clean, but attempted a resync.
5. during the resync the cable had troubles again, so those 2 devices were
marked as spare.
6. i forced a poweroff again and reseated the cable.
7. I booted again but now all devices of the raid were marked as spare.

Is there a possibility to get the raid active without dataloss?

Here some infos:
cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4]
[raid10] 
md1 : inactive sdc2[2](S) sdb2[1](S) sda4[0](S)
      709140864 blocks
       
unused devices: <none>

mdadm --detail /dev/md1
mdadm: md device /dev/md1 does not appear to be active.

Thx in advance
Stephan

