From: Jayshankar Nair <jshankar@CS.ColoState.EDU>
Subject: raid0 and iscsi
Date: Sun, 12 Oct 2003 22:34:30 -0600 (MDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310130434.h9D4YU0n020486@bach.cs.colostate.edu>
Reply-To: Jayshankar Nair <jshankar@CS.ColoState.EDU>
Mime-Version: 1.0
Content-Type: TEXT/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-MD5: 9E9/Ef6elwaezxcdqjdIlg==
To: linux-raid@vger.kernel.org
Cc: jshankar@CS.ColoState.EDU
List-Id: linux-raid.ids

Hello,


I was testing the raid0 configuration for the iscsi device ( /dev/sdb and 
/dev/sdc).

For writing a 512MB in a LAN environment it was taking 24 hrs. i was going
through the source code of raid0.c and certain things doesn't made sense to me.

1> what role does the Hash bit play.
2>If my chunk size is 8 byte. Does that mean it will write 8 byte into device 0 
and then into device 1. Is the write request to the disk in synchronous or
asynchronous mode. 


3> Is wite_disk_sb in md.c responsible for writing into disk??. Is fsync_dev 
responsible for synhronous write ??. If so can i change to asynchronous write.I 
will really appreciate if somebody can tell me what all routines I need to go 
through to figure out the functionality of raid0 behaviour.

Thanks
Jayshankar

