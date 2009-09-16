From: adfas asd <chimera_god@yahoo.com>
Subject: Remote NAS
Date: Wed, 16 Sep 2009 09:21:47 -0700 (PDT)
Message-ID: <92388.79363.qm@web38807.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A couple questions about MD RAID10:

Right now I'm RAIDing two 2TB drives in RAID10offset2. Need to add some drives and maybe I'll remote them using NAS (GB ethernet), for fire and theft protection.
 
So could the BIOS actually boot this if 2 drives are in the machine and 2 are in the garage? Is there a way to specify in mdadm that the two in the garage are mirrored from the two in the system?

Is GB ethernet NAS noticably slower than eSATA?  Is it reliable?
 
What if I use the mobo's e-SATA port to add 5 external drives locally. This would require a port multiplier. I presume it would not be bootable, since a port multiplier needs OS support? Or would something go in initrd.img?  Or would I need an individual boot drive to get things up?
 
Using the array to store MythTV recordings (very large files), but when it does commercial flagging (lots of writes) the array is so busy that GUI response is very slow.  I've set readahead cache to optimal (4096, after testing most sizes), so read should be OK.  I know far is optimized for read, so I chose offset in hopes it would bring up write speed.  Is there a way to speed up writes?



      
