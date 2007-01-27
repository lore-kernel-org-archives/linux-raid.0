From: kenneth johansson <ken@kenjo.org>
Subject: md autodetect only detects one disk in raid1
Date: Sat, 27 Jan 2007 19:52:39 +0100
Message-ID: <1169923959.18828.41.camel@duo>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I run raid1 on my root partition /dev/md0. Now I had a bad disk so I had
to replace it but did not notice until I got home that I got a SATA
instead of a PATA. Since I had a free sata interface I just put in in
that. I had no problem adding the disk to the raid1 device that is until
I rebooted the computer. 

both the PATA disk and the SATA disk are detected before md start up the
raid but only the PATA disk is activated. So the raid device is always
booting in degraded mode. since this is the root disk I use the
autodetect feature with partition type fd.

Also Something else in the system claim use of the device since I can
not add the SATA disk after the system has done a complete boot. I guess
it has something to do with device mapper and LVM that I also run on the
data disks but I'm not sure. any tip on what it can be??

If I add the SATA disk to md0 early enough in the boot it works but why
is it not autodetected ?



