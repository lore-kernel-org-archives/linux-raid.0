From: adfas asd <chimera_god@yahoo.com>
Subject: Is My Data DESTROYED?!
Date: Thu, 22 Oct 2009 18:36:31 -0700 (PDT)
Message-ID: <644518.48476.qm@web38804.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Today I went in to my HTPC, to find it was hung and the drive light was stuck on.  After all attempts to revive it or switch to terminal 2 or 3 had failed I reset the system.  

It rebooted to tell me that it cannot mount /home, the RAID10offset2 device. 

When I reboot in recovery mode and try to mount /dev/md0 manually it informs me there is an invalid superblock!  I shut down and unplugged each drive in turn, and /proc/mdstat shows the appropriate volume gone, but still can't mount the array.

What has happened here?  Is all my data destroyed?


      
