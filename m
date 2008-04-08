From: Henry Huang <hwh6k@earthlink.net>
Subject: RAID-6/External Bitmap Issues
Date: Tue, 8 Apr 2008 15:57:58 -0700 (GMT-07:00)
Message-ID: <33156703.1207695479029.JavaMail.root@elwamui-royal.atl.sa.earthlink.net>
Reply-To: Henry Huang <hwh6k@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Fairly new to Linux and md, so forgive me if this has been covered already.

So anyone who's been looking into write-intent bitmaps under mdadm has probably seen this blurb from the man page already:

       If  an  array  is  using a write-intent bitmap, then devices which have
       been removed can be re-added in a way that avoids a full reconstruction
       but  instead just updates the blocks that have changed since the device
       was removed.  For arrays with persistent metadata (superblocks) this is
       done  automatically.  For arrays created with --build mdadm needs to be
       told that this device we removed recently with --re-add.

       Devices can only be removed from an array if they  are  not  in	active
       use,  i.e.  that must be spares or failed devices.  To remove an active
       device, it must first be marked as faulty.

Having read some harsh performance criticisms of internal bitmaps, I figure I'll try a quick test with an external bitmap instead.  I set up four 500 MB loopback devices, and create a RAID-6 array with an external bitmap (on a physically separate drive) and version 1.2 superblocks.  Then I fail, remove, and re-add one device.

Problem: instead of resyncing, it simply re-adds the device as a spare, in a "failed" state.

Since RAID-6 has a two-drive cushion before complete failure, I wonder what failing/removing/re-adding a second device will do.  Answer: the exact same thing.

So I stop the array, and re-assemble it WITHOUT the --bitmap parameter.  This time, both of the soft-failed devices are slow-resynced into the array -- as expected.

(Notice that I didn't bother using Grow mode to "remove" the bitmap -- apparently with an external bitmap it doesn't matter, since no information about its existence seems to stored in the superblock, or anywhere else persistently.)

What am I missing here?  It's fairly obvious to me that the expected behavior from the manual (automatic fast rebuilding w/o full reconstruction) is not happening -- despite using superblocks.

-H

