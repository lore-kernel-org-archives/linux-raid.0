From: Matt Simonsen <matt_lists@careercast.com>
Subject: Re: 4*300GB SW-RAID5 - bad idea?
Date: 13 Oct 2003 15:49:35 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1066085375.18385.12.camel@mattswrk.cbd.careercast.com>
References: <200310140017.41042.dusty@strike.wu-wien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200310140017.41042.dusty@strike.wu-wien.ac.at>
To: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 2003-10-13 at 15:17, Hermann Himmelbauer wrote:
> Hi,
> Some people told me that this configuration would be a bad idea as accessing 
> the RAID would produce a very high load and the RAID would be very slow.

It's only a bad idea if you better performance than it'll offer. RAID
1+0 would be much faster ... at least for writes. If all you do are
reads, though, RAID5 is pretty good.

> Is this true?

Yes, I have found a RAID5 array with 4 disks is generally roughly the
same or slower than one of the same disks standing alone. That's just an
off-the-cuff thing I've found to be true, take it very lighytly. 

The main benefit of RAID5 is your data isn't hosed if one dies ...
compared to RAID striping or LVM striping there is a large performance
hit. If availability is not important, I'd say stripe it and do really
good backups. But a disk will die eventually and you will have to deal
with it so keep that in mind.

>  Are there any performance/CPU Load stats with Linux SW-RAID that 
> I can have a look at?

With your exact disks, none will perfectly match.

search for "Linux RAID5 benchmark" at google.

Matt

