From: "Yogesh Pahilwan" <pahilwan.yogesh@spsoftindia.com>
Subject: RE: Linux MD RAID5/6 bitmap patches
Date: Wed, 22 Mar 2006 16:18:29 +0530
Message-ID: <WM452680B12BAC48a19943A909AEA5F1C6@spsoftindia.com>
References: <17441.8598.153372.503058@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17441.8598.153372.503058@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Thanks for your reply. As far as what I understood that when we apply the
bitmap patch, for every write it will do 2 sync writes that is setting the
dirty bit, writing intent log and one async write for clearing the dirty
bit. Is it correct?
If that is the case are there any patches available which can do collection
of sync write in a queue and write a collection in single write request.
For Eg:
For 10 writes , we will have 10 + 1 sync writes + 10 async write.
I mean to say , 10 sync writes for setting the dirty bits + 1 sync write for
write intent log for all queued request in one write operation + 10 async
write for clearing the dirty bit.

So as we reducing the sync write request by using collections will it
improve the performance and any patches available which follows this
approach.

Thanks and Regards
Yogesh

-----Original Message-----
From: Neil Brown [mailto:neilb@suse.de] 
Sent: Wednesday, March 22, 2006 3:36 PM
To: Yogesh Pahilwan
Cc: linux-raid@vger.kernel.org
Subject: Re: Linux MD RAID5/6 bitmap patches

On Wednesday March 22, pahilwan.yogesh@spsoftindia.com wrote:
> Hello,
> 
> I want to know where I can get various MD RAID5/RAID6 bitmap patches for
> linux kernel 2.6.15.

2.6.15 already includes support for bitmaps for MD raid5 and raid6
(And raid1).  No patches needed.

> I want to know what kind of performance optimization possible on bitmap
> patches. I also want to know are 
> there any patches available which provides performance optimizations using
> bitmaps. 

Bitmaps optimise rebuild time after a crash, or after removing and
re-adding a device.  They do not improve normal read/write
performance, and may well cause a small degradation in performance.

NeilBrown

