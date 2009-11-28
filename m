From: Kasper Sandberg <postmaster@metanurb.dk>
Subject: Re: Reed Solomon coding based Raid?
Date: Sat, 28 Nov 2009 16:48:20 +0100
Message-ID: <1259423300.31633.190.camel@localhost>
References: <4B113E90.50904@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B113E90.50904@xs4all.nl>
Sender: linux-raid-owner@vger.kernel.org
To: John Hendrikx <hjohn@xs4all.nl>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

As far as i know, theres not support for this, however, i do believe
raid6 uses reed-solomon.

On Sat, 2009-11-28 at 16:15 +0100, John Hendrikx wrote:
> I was wondering if there is support for a raid level where one can 
> choose the redundancy level.  Raid 5 allows for one redundant drive, 
> Raid 6 for two, but there's no raid level that would support arbitrary 
> redundancy (even to the point of allowing one to add extra redundancy 
> later on, by simply putting spare drives to immediate use).
> 
> I'm just a casual Software Raid user, and have been using Raid 6 for a 
> small 8 TB array for a few years now and I realize that there's quite 
> some CPU overhead involved for such redundancy, but for my purposes 
> speed is not a relevant concern (10 MB/sec is enough).
> 
> --John
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

