From: Michael Guntsche <mike@it-loops.com>
Subject: Strange initramfs+udev+raid interaction creating /dev/md/*
Date: Wed, 4 Aug 2010 21:42:16 +0200
Message-ID: <20100804194216.GA4481@gibson.comsick.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi list,

I am facing a strange behaviour between udev and the raid code here and
to be honest I do not know where the problem is.

The problem is the following. I have two md devices

ARRAY /dev/md0 metadata=0.90 UUID=3b9e371a:f651d170:2a42ebe3:f331026f
ARRAY /dev/md/1 metadata=1.00 name=gibson:1
UUID=2f18e1fe:867d891e:501f93be:ea635188

/dev/md/1 is giving me troubles. 
I am booting using an initramfs. Looking through the initramfs 
scripts I see that /dev/md/1 gets created by it. The syslog on the 
other hand shows me this during the boot process.

Aug  4 21:23:12 gibson mdadm[3606]: DeviceDisappeared event detected on
md device /dev/md/1
Aug  4 21:23:12 gibson mdadm[3606]: NewArray event detected on md device
/dev/md1

Apparently the device gets removed and then added as /dev/md1 as a
result /dev/md/1 disappears.
If I then run mdadm -Ds I see this

KERNEL[1280949869.791242] change   /devices/virtual/block/md1 (block)
KERNEL[1280949869.792353] change   /devices/virtual/block/md0 (block)
UDEV  [1280949869.850176] change   /devices/virtual/block/md1 (block)
UDEV  [1280949870.044863] change   /devices/virtual/block/md0 (block)

and /dev/md/1 is re-created. 

Now my question. Why does /dev/md/1 disappear and /dev/md1 gets created?
And even if /dev/md1 gets created shouldn't this trigger udev
automatically resulting in the creation of /dev/md/1 like running mdadm
-Ds does?

Kind regards,
Michael Guntsche


