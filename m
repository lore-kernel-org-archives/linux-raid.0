From: "Clemens Eisserer" <linuxhippy@web.de>
Subject: Autodetection using RAID1 on externa USB2-HDs
Date: Wed, 16 Feb 2005 07:54:26 +0100
Message-ID: <1061567322@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!

I am trying to use my external USB2.0 hd for  raid1 in my laptop, however autodetection does not work and I do not really know - but I have at least a theory.

What i did till now:
1.) set the partition-type of both partitiuons from 83 (Linux) to fd (Linux Raid Autodetection)
2.) mdadm --create /dev/md0 --level=raid1 --reaid-devices=2 /dev/hda2 /dev/sda1

This works great on creation, I can watch with /proc/mdstat the syncing process, but if I reboot the autodetection does not work. I can see that linux-raid discovers an raid (on /dev/hda2) but something returns "-22" (have forgotten what exactly) - it seems that my usb-disc (/dev/sda1) is simply not known at raid-discovery-time.
Some seconds later I can see that the kernel disvcovers my usb-drive - so I think my theory could be right?

Is there a way to tell the kernel after boot where to find raid-arrays and howto handle them. Is that maybe possible with only a /boot partition and the reast on a mirrored "/" (root) partition.

Please help, I don't know any further :(

lg Clemens Eisserer
__________________________________________________________
Mit WEB.DE FreePhone mit hoechster Qualitaet ab 0 Ct./Min.
weltweit telefonieren! http://freephone.web.de/?mc=021201

