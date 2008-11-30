From: Wilhelm Meier <wilhelm.meier@fh-kl.de>
Subject: mdadm and automatic re-add / incremental mode with usb-disk
Date: Sun, 30 Nov 2008 12:31:58 +0100
Message-ID: <200811301231.58180.wilhelm.meier@fh-kl.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm using debian etch with mdadm 2.5.6-9.

I have a md-device /dev/md1000 with two usb-disks as raid1. The array 
is assembled well if the system boots, if I unplug one of the disks, 
the array goes to degraded. Thats all ok.

If I re-plug the usb-disk, udev discovers the device fine, but mdadm 
doesn't start the re-add to the md-array. I have to do this but hand.

Is there something missing to make this work automatically?

I tried the mdm-2.6.2 from etch-backports too. Same effect.

Here, if I try to use the --incremental mode, it constructs a new (!) 
array /dev/md/d_1000  instead of adding it to /dev/md1000. 
Thats strange to me.

I thought I got it working some weeks ago (maybe with earlier / other 
versions of mdadm or somme missing other tool), but I can't get the 
puzzle right now.

Any hints?
-- 
Wilhelm
