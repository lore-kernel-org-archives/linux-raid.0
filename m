From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 0 of 8 - Introduction
Date: Fri, 28 May 2004 16:45:25 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040528163700.9426.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Following are 8 patches for md in 2.6.7-rc1-mm1

The first 6 a ready to go to Linus.
The last two are sufficiently new that maybe they should wait a while,
but I don't have any serious concerns about them and have tested them quite a bit.

1 - tidy up some multipath code
2 - fix a bug which stopped failed drives from being removable
    in some cases.
3 - rationalise use of ->hot_remove_disk method.
4 - double check that size in a multiple of chunksize of raid5/6
    (needed for a subsequent patch)
5 - Fix problem with hot-adding to array with non-persistant superblocks.
6 - Get raid1 to cope sensible with a device failure during rebuild.

and the new functionality.

7 - support resizing of devices in raid1/4/5/6.  If the devices are replaced
    with larger ones, the array can grow while online to use the extra space
8 - support adding and removing active drives for raid1.  i.e change a raid1 
    array that used 2 drives so that it uses 3 drives, or vice-versa.

I will release a new mdadm in a few days that provide "--grow" for using
this functionality.

NeilBrown

