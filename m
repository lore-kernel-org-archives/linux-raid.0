From: Jeffrey C Albro <jalbro@bu.edu>
Subject: Documentation bugs in raidtools
Date: Fri, 28 May 2004 14:59:57 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0405281445550.25012-100000@signals10.bu.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I am reporting based on raidtools-1.00.3-2 on a Redhat 9 system.

You can't "raidhotremove" until you "raidsetfaulty" regardless of
whether the disk is actually failed or not.  I would like there to be 
better documentation to clue the admin into this fact.  

My specific concerns:

1) raidhotremove does not give helpful error messages.  You get a message
like "/dev/md0: can not hot-remove disk: disk busy!".  But if you stop the
raid, you still can't remove the disk.  The raid has to be running AND the
disk needs to be marked faulty.  There should be a hint in the error
message given by raidhotremove.

2) raidhotremove does not have a man page.

3) raidsetfaulty does not have a man page.

I am attaching a "bug bounty" of a coupon for a pint of Ben and Jerry's 
Ice Cream to the resolution of this bug.

Thanks!

-Jeff


-----------------------------------------------------------
Jeffrey Albro | Systems Administrator | Boston University
   - Department of Electrical and Computer Engineering -
jalbro@bu.edu |  Photonics, Room 305  | 617-358-2785
-----------------------------------------------------------



