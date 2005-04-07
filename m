From: Mitchell Laks <mlaks@verizon.net>
Subject: How to move a singleton raid1 drive from raid1 /dev/md2 to /dev/md1
Date: Thu, 07 Apr 2005 01:25:08 -0400
Message-ID: <200504070125.09062.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Software Raid Gurus!:

I have 

A1:~# cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 hdb1[0] hdg1[1]
      244195904 blocks [2/2] [UU]

md1 : active raid1 hdc1[0]
      244195904 blocks [1/1] [U]

md2 : active raid1 hde1[0]
      244195904 blocks [1/1] [U]

Now I want to take /dev/hde1 and get rid of /dev/md2 and add /dev/hde1 
to /dev/md1.

First i made sure that /dev/md2 was unmounted. I then took it out 
of /etc/fstab.

Then I did:

A1:~# mdadm /dev/md2 -f /dev/hde1
mdadm: set /dev/hde1 faulty in /dev/md2

Then I tried:

A1:~# mdadm /dev/md2 -r /dev/hde1
mdadm: hot remove failed for /dev/hde1: Device or resource busy

So I didnt know what to do next. So I did

A1:~# mdadm -S /dev/md2

then I did

A1:~# mdadm /dev/md2 -r /dev/hde1
mdadm: cannot get array info for /dev/md2

obviously the wrong thing to do...

A1:~# cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 hdb1[0] hdg1[1]
      244195904 blocks [2/2] [UU]

md1 : active raid1 hdc1[0]
      244195904 blocks [1/1] [U]

unused devices: <none>
A1:~#                                              



So I decided not to risk anything else, and I turn to you for help. I would 
like to take the device /dev/hde1 at this point and add it to /dev/md1 safely 
and then sync /dev/md1 to full raid1 status  ... Then I would like to adjust 
the /etc/mdadm.conf file ...

I guess I dont know the algorithm for ending a raid on a single 
drive/partition and then making it subservient to another drive in a raid1 
status.

Thank you all for your help!!!!

Mitchell Laks
