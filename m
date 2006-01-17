From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 5] md: Introduction
Date: Tue, 17 Jan 2006 17:56:04 +1100
Message-ID: <20060117174531.27739.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids


Greetings.

In line with the principle of "release early", following are 5 patches
against md in 2.6.latest which implement reshaping of a raid5 array.
By this I mean adding 1 or more drives to the array and then re-laying
out all of the data.

This is still EXPERIMENTAL and could easily eat your data.  Don't use it on
valuable data.  Only use it for review and testing.

This release does not make ANY attempt to record how far the reshape
has progressed on stable storage.  That means that if the process is
interrupted either by a crash or by "mdadm -S", then you completely
lose your data.  All of it.
So don't use it on valuable data.

There are 5 patches to (hopefully) ease review.  Comments are most
welcome, as are test results (providing they aren't done on valuable data:-).

You will need to enable the experimental MD_RAID5_RESHAPE config option
for this to work.  Please read the help message that come with it.  
It gives an example mdadm command to effect a reshape (you do not need
a new mdadm, and vaguely recent version should work).

This code is based in part on earlier work by
  "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Though little of his code remains, having access to it, and having
discussed the issues with him greatly eased the processed of creating
these patches.  Thanks Steinar.

NeilBrown


 [PATCH 001 of 5] md: Split disks array out of raid5 conf structure so it is easier to grow.
 [PATCH 002 of 5] md: Allow stripes to be expanded in preparation for expanding an array.
 [PATCH 003 of 5] md: Infrastructure to allow normal IO to continue while array is expanding.
 [PATCH 004 of 5] md: Core of raid5 resize process
 [PATCH 005 of 5] md: Final stages of raid5 expand code.
