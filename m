From: rmack@mackman.net
Subject: Creating in degraded mode...
Date: Wed, 26 Feb 2003 08:22:13 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0302260819010.10893-100000@mackman.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I currently have a 2 drive RAID-1 array.  I would like to convert it into 
a 3 drive RAID-5 array.  I'd rather avoid raidreconf because I'v never 
used it before.  It seems to me, that I should be able to run the existing 
RAID-1 in degraded mode (only one drive), and then copy it's contents to a 
degraded (only two drive) RAID-5 array.  The question, of course, is how 
do I create a RAID-5 array in degraded mode?  After the copy, I would then 
hotadd the other former RAID-1 drive into the RAID-5 and let it 
reconstruct the array.

Any thoughts?  Please reply to me directly, I'm off the list for now.

Thanks, Ryan Mack

