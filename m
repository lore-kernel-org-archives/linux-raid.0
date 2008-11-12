From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: md.txt, preread_bypass_threshold and raid5: corrected error
Date: Wed, 12 Nov 2008 11:49:12 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811121144250.12675@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Read through md.txt from 2.6.27.5, noticed this at the end:

   preread_bypass_threshold (currently raid5 only)
       number of times a stripe requiring preread will be bypassed by
       a stripe that does not require preread.  For fairness defaults
       to 1.  Setting this to 0 disables bypass accounting and
       requires preread stripes to wait until all full-width stripe-
       writes are complete.  Valid values are 0 to stripe_cache_size.

In terms of performance for raid5/raid6 - what does this mean?

Also in md.txt there is a lot of outdated information, (e.g. you can only 
grow raid5, etc).

e.g.:

   raid_disks
      a text file with a simple number indicating the number of devices
      in a fully functional array.  If this is not yet known, the file
      will be empty.  If an array is being resized (not currently
                                                   ^^^^^^^^^^^^^^
      possible) this will contain the larger of the old and new sizes.
      ^^^^^^^^^
      Some raid level (RAID1) allow this value to be set while the
      array is active.  This will reconfigure the array.   Otherwise
      it can only be set while assembling an array.


BTW, I did read the URL on correcting sectors etc on RAID5 from yesterday, 
it was quite nice, but is there anyway that-- it can happen automatically 
like a traditional HW raid controller does during a scrubbing or must one 
perform those tasks in the document in order to make it force-reallocate 
the sectors etc?

Justin.
