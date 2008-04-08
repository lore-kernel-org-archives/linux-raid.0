From: "Ty! Boyack" <ty@nrel.colostate.edu>
Subject: Write-Intent Bitmaps and disk caches
Date: Tue, 08 Apr 2008 14:16:11 -0600
Message-ID: <47FBD28B.6060209@nrel.colostate.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm a little confused on the write-intent bitmaps and how they interact 
with the disk caches - I would appreciate any clarification here.

The way I understand it, if a device fails in a raid set, the bitmap 
will track regions that have changed since the failed device left the 
array.  If the device is added back in, the re-sync time is much shorter 
since only some blocks have to be re-sync'ed.

But in this case it's possible that blocks A, B, and C were written to 
the device, and the failure was detected on block C.  Thus blocks A and 
B would be probably held in the device's cache (hard drive cache, or 
this problem gets worse if working with disk arrays as devices, since 
they have much larger caches).  When the device was re-added, block C 
would presumably be re-synced as requested by the bitmap, but would A 
and B be lost forever because they fell out of the cache on the drive?

Does the bitmap, or something else, take this into account?  Or will 
this eventually lead to an inconsistent read or data corruption down the 
road?  Or am I just out waving my paranoid flag today?


-- 
-===========================-
  Ty! Boyack
  NREL Unix Network Manager
  ty@nrel.colostate.edu
  (970) 491-1186
-===========================-

