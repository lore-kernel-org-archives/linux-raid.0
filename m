From: dean gaudet <dean@arctic.org>
Subject: Re: Care and feeding of RAID?
Date: Sat, 9 Sep 2006 22:23:40 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0609092215140.18380@twinlark.arctic.org>
References: <44FD722C.7050608@waldoware.com> <44FDB66D.8060202@waldoware.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44FDB66D.8060202@waldoware.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Waldo <pwaldo@waldoware.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 5 Sep 2006, Paul Waldo wrote:

> What about bitmaps?  Nobody has mentioned them.  It is my understanding that
> you just turn them on with "mdadm /dev/mdX -b internal".  Any caveats for
> this?

bitmaps have been working great for me on a raid5 and raid1.  it makes it 
that much more tolerable when i accidentally crash the box and don't have 
to wait forever for a resync.

i don't notice the extra write traffic all that much... under heavy 
traffic i see about 3 writes/s to the spare disk in the raid5 -- i assume 
those are all due to the bitmap in the superblock on the spare.

i've considered using an external bitmap, i forget why i didn't do that 
initially.  the filesystem on the raid5 already has an external journal on 
raid1.

-dean
