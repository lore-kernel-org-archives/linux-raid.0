From: John Peel <jrp@thepeel.org>
Subject: Moving Raid 0+1 to new machine
Date: Wed, 31 Jul 2002 16:52:06 -0500 (CDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0207311642580.3949-100000@thepeel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So I have this nice array set up using software raid under redhat 7.2, in 
this nice server and all was working well until something started 
bringing the whole thing to it's knees. Now anytime there is any 
significant i/o the server dies. I would like to move the raid 0+1 to a 
different working box to retreive the data until I can repair the server. 
My question is, is there anything I need to look out for in moving the 
drives other than the obvious. Do the drive letters matter or anthinglike 
that or if I set the raidtab file up correctly pointing to the drives in 
their new places should it all reconstruct fine and should I be able to 
get the data. In addition should the drives have to resync for 30 minutes  
everytime the server dies or is there a larger problem going on?

fyi I am running RedHat Linux 7.2 with kernel 2.4.18 smp on an ext3 
filesystem with a software raid of 4 disks raid 0+1. If you need any 
additional info please let me know. Thanks in advance -John

john peel
jrp@thepeel.org
www.thepeel.org

