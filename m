From: Jon Lewis <jlewis@lewis.org>
Subject: changing MD device names
Date: Sat, 1 Jul 2006 21:32:08 -0400 (EDT)
Message-ID: <Pine.LNX.4.61.0607012009220.2163@soloth.lewis.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a system which was running several raid1 devices (md0 - md2) using 
2 physical drives (hde, and hdg).  I wanted to swap out these drives for 
two different ones, so I did the following:

1) swap out hdg for a new drive
2) create degraded raid1's (md3 and md4) using partitions on new hdg
3) format md3 and md4 and copy data from md0-2 to md3-4
4) install grub on new hdg
5) pull hde

Now, after a bit of fixing in the grub menu and fstab, I have a system 
that boots up using just 1 of the new drives, but the md devices are md3 
and md4.  What's the easiest way to change the prefered minor # and get 
these to be md0 and md1?  Will just booting from a rescue or live CD and 
assembling the new drives as md0 & md1 automatically update the prefered 
minor in their superblocks?

The system is running Centos 4 (2.6.9-34.0.1.EL kernel).

----------------------------------------------------------------------
  Jon Lewis                   |  I route
  Senior Network Engineer     |  therefore you are
  Atlantic Net                |
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
