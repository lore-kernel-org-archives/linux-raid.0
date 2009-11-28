From: Keld Simonsen <keld@keldix.com>
Subject: Re: Reed Solomon coding based Raid?
Date: Sat, 28 Nov 2009 19:57:32 +0100
Message-ID: <20091128185732.GA15674@light.rap.dk>
References: <4B113E90.50904@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B113E90.50904@xs4all.nl>
Sender: linux-raid-owner@vger.kernel.org
To: John Hendrikx <hjohn@xs4all.nl>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Nov 28, 2009 at 04:15:28PM +0100, John Hendrikx wrote:
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

Actually you can choose the number of copies in raid10, via the -n
option. 

Best regards
keld
