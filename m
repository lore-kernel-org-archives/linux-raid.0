From: "Dragon" <Sunghost@gmx.de>
Subject: Possible to rescue SW Raid5 with 2 missing Disks
Date: Mon, 04 Mar 2013 00:09:15 +0100
Message-ID: <20130303230915.7630@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I do create with missing sdd. Than i mount -a and get :"
mount -a
"mount: wrong fs type, bad option, bad superblock on /dev/md2,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so"
And
"EXT4-fs (md2): bad geometry: block count 3651722880 exceeds size of device (3651721600 blocks)" and the mount fails

Ok is the superblock on sdf4 bad? What can i do next?
thx
