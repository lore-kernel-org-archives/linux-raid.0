From: Ben DJ <bendj095124367913213465@gmail.com>
Subject: Clarify /etc/mdadm.conf format and content?
Date: Wed, 4 Nov 2009 21:53:04 -0800
Message-ID: <babafd2f0911042153y427d3194w520f2294f0ff7f53@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've two arrays, "/boot" on RAID-1 & "/, etc" on LVM on RAID-10.

I currently have,

cat /etc/mdadm.conf
  DEVICE partitions
  ARRAY /dev/md0 metadata=1.00 name=Rescue:0
UUID=864b9359:09f5f39b:69a4ae8a:e3d794f8
  ARRAY /dev/md1 metadata=1.01 name=Rescue:1
UUID=6d541863:4e7235a3:81291c4d:b7f4b48c


Couple of questions.

(1) What's the "Rescue" in the name field?  Does it matter what the
name is?  I _thought_ name was derived from hostname ... ?

(2) For re-populating /etc/mdadm, should I use the output of,

  mdadm --detail --scan

or,

  mdadm --examine --scan


The two have different device names -- note "/dev/mdX" vs"/dev/md/X",

mdadm --detail --scan > tmp.txt
cat tmp.txt
  ARRAY /dev/md1 metadata=1.01 name=Rescue:1
UUID=6d541863:4e7235a3:81291c4d:b7f4b48c
  ARRAY /dev/md0 metadata=1.00 name=Rescue:0
UUID=864b9359:09f5f39b:69a4ae8a:e3d794f8

mdadm --examine --scan
  ARRAY /dev/md/0 metadata=1.0
UUID=864b9359:09f5f39b:69a4ae8a:e3d794f8 name=Rescue:0
  ARRAY /dev/md/1 metadata=1.1
UUID=6d541863:4e7235a3:81291c4d:b7f4b48c name=Rescue:1

(3) my RAID-10 has --layout=f2 & --chunk=256.  Should either of those
specs be included in the /etc/mdadm.conf?

Thanks,

BenDJ
