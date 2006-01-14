From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: md faster than h/w?
Date: Sat, 14 Jan 2006 13:14:44 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0601141304510.2853-100000@coffee.psychology.mcmaster.ca>
References: <43C8B5A5.5010500@fastmail.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43C8B5A5.5010500@fastmail.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> My preference will probably be raid10 - ie raid0 2 drives, raid0
> another 2 drives, and then raid1 both raid0s. My 5th disk can be a hot
> spare. Round reasonable?

spares are pretty iffy if you are really worried about reliability,
since the disk just sits there for potentially years, then suddenly
it's recovered-onto, which is a lot of stress.  it's not pleasant 
if the spare fails during recovery (though not fatal, just that you're 
still in degraded/vulnerable.)  that's the reason that most people 
tend towards R6 rather than R5+HS.  admittedly, having a HS shared 
among multiple raids is more parsimonious, and R6 can be slow for write.

> Alternatively, we could probably get a 6th disk and do raid1 on
> disk #5 & #6 and install the OS on that - keeping the application
> data separate. This would be ideal, I think. For some reason, I like
> to keep os separate from application data.

fragmenting your storage has drawbacks as well, since in the normal 
course of things, some fragment becomes too small.

also bear in mind that higher-order raids (many disks, whether R0,
R10, R6, etc) tend to want you to do very large transfers.  if your 
traffic is small blocks, especially many interleaved stream of them,
you might not benefit much from parallelism.  (for instance, 64k is 
a pretty common raid stripe size, but if you have a 14-disk R6,
you'd really like to be doing writes in multiples of 768K!)

regards, mark hahn.

