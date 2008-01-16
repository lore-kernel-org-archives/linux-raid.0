From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: How do I get rid of old device?
Date: Wed, 16 Jan 2008 18:09:03 -0500 (EST)
Message-ID: <alpine.DEB.0.999999.0801161808010.4374@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

p34:~# mdadm /dev/md3 --zero-superblock
p34:~# mdadm --examine --scan
ARRAY /dev/md0 level=raid1 num-devices=2 
UUID=f463057c:9a696419:3bcb794a:7aaa12b2
ARRAY /dev/md1 level=raid1 num-devices=2 
UUID=98e4948c:c6685f82:e082fd95:e7f45529
ARRAY /dev/md2 level=raid1 num-devices=2 
UUID=330c9879:73af7d3e:57f4c139:f9191788
ARRAY /dev/md3 level=raid0 num-devices=10 
UUID=6dc12c36:b3517ff9:083fb634:68e9eb49
p34:~#

I cannot seem to get rid of /dev/md3, its almost as if there is a piece of 
it on the root (2) disks or reference to it?

I also dd'd the other 10 disks (non-root) and /dev/md3 persists.


