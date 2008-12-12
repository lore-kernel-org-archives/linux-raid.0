From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Basic RAID5/6 reshape question
Date: Thu, 11 Dec 2008 21:52:39 -0600
Message-ID: <4941E007.4090907@gmail.com>
References: <4940E377.7070907@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4940E377.7070907@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Brad Campbell wrote:
> G'day all,
> 
> I'm just doing some system upgrades and shuffling some arrays around as 
> part of the process.
> All my other current questions have been answered by experimentation, 
> but one.
> 
> I'm going to start with a RAID 6 comprised of 7 x 1TB drives, and 
> reshaping to 10 x 1TB.
> I'm doing an experiment right now with re-shaping a RAID-5 of 2 drives 
> into 3 drives which is taking about 20 hours, from that I'm assuming 
> that a nice big re-shape will take a considerable amount of time. I have 
> a reliable UPS, I'm more concerned about a drive or cable flaking out.
> 
> What happens if I'm in the middle of a reshape of a RAID 5 or 6 and lose 
> a drive?
> 
> Will the array be able to continue to reshape in a degraded state?
> 
> Hoping of course that this does not occur, but just trying to plan ahead 
> in case.
> 
> Regards,
> Brad

Reshaping appears to be much much slower.

I can resync in just a 2-3 hours, but a reshape of a single drive 
takes 10-15 hours with nothing else happening, if any other work is 
being done by the disks the number gets much worse.

To make it look just like a normally built array of the same number of 
disks it is very likely that reshaping is moving lots and lots of data 
around to make the changes.

I have so far done 2 reshapes, and I would like to know also how 
dangerous an event would be if it happens during a reshape.



