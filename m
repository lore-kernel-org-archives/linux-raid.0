From: "Corey McGuire" <mcguire.corey@ssd.loral.com>
Subject: Victory! re: RAID5 causing lockups
Date: Fri, 27 Jun 2003 13:45:57 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200306271345570203.57E7F751@messaging.ssd.loral.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: alewman@sjdccd.cc.ca.us, bort@partikelsoft.com, corvus@consolex.com, kratz.franz@ssd.loral.com, blatt.guy@ssd.loral.com, linux-raid@vger.kernel.org, mario.scalise@schwab.com, harbeck.seth@ssd.loral.com
List-Id: linux-raid.ids

KNOCK ON WOOD

I got my RAID5 up, built and sync'd and everything.

I don't quite remember exactly what I did, because I have gotten less and less sleep and steadily lost more and more sanity/memory as the week has passed, but I fixed it.

The WD utility didn't find anything (or fix anything) and I nearly killed all my data (well, almost nearly) but after I took a torch to all but one member of my system partition RAID (HDA was my problem, so I had to break it off my system mirror) I rebuilt every RAID from the ground up.  It took forever to do, and the devil is in the details (which I don't recall at all) but once done, it didn't take long to see that this fixed my problem.  Still, I sat up and watched it build and build and build just to make sure my RAID goblin didn't pack up and move to another spot.

I want to thank everyone for their help.  This was a very trying and tedious experience and I tried my best not to be a pest.  I hope to stick around and help others as they come by, because I definitely owe it to the list.

But, first, I think I'll sleep all weekend.

