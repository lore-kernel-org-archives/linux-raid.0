From: "J. David Beutel" <jdb@getsu.com>
Subject: reducing the number of disks a RAID1 expects
Date: Sun, 09 Sep 2007 15:10:41 -1000
Message-ID: <46E49991.9000000@getsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My /dev/hdd started failing its SMART check, so I removed it from a RAID1:

# mdadm /dev/md5 -f /dev/hdd2 -r /dev/hdd2

Now when I boot it looks like this in /proc/mdstat:

md5 : active raid1 hdc8[2] hdg8[1]
      58604992 blocks [3/2] [_UU]

and I get a "DegradedArray event on /dev/md5" email on every boot from 
mdadm monitoring.  I only need 2 disks in md5 now.  How can I stop it 
from being considered "degraded"?  I added a 3rd disk a while ago just 
because I got a new disk with plenty of space, and little /dev/hdd was 
getting old.

mdadm - v1.6.0 - 4 June 2004
Linux 2.6.12-1.1381_FC3 #1 Fri Oct 21 03:46:55 EDT 2005 i686 athlon i386 
GNU/Linux

Cheers,
11011011

