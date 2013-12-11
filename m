From: Wakko Warner <wakko@animx.eu.org>
Subject: mdadm and the list appreciation
Date: Tue, 10 Dec 2013 20:06:34 -0500
Message-ID: <20131211010634.GB30462@animx.eu.org>
Reply-To: Wakko Warner <wakko@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've not posted much on the list, but I have read the help that the regulars
have given to others.

Today, I had 6 drive drop at one time from my array.  I know why they did
and that has been corrected.

I yanked all the drives from the das box, shutdown all the volumes and then
the array itself.  Then one by one plugged each drive back in waiting for
the kernel to see the drive before going to the next one.

As expected, mdadm -A /dev/mdX <drive list>
didn't work, stated 2 devices were not enough.

I added --force to that and it came up just fine.  I had some large files
that I could sum to verify that it assembled properly.  They checked out OK.
I'm running a check on the array and so far no mismatch count.

Fortunately, nothing was in use at the time this happened.

I'm posting this just to let you guys know how much your help of others
helped me this time.  Atleast I didn't resort to recreating the array again!

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
