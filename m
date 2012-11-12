From: Drew <drew.kay@gmail.com>
Subject: Re: question: no-bitmap RAID1 with off-site drive
Date: Mon, 12 Nov 2012 09:56:23 -0800
Message-ID: <CACJz6Qt93zm47+576HSWBv+GGcNKKmz0G7+soAqPSMeBk2KFCg@mail.gmail.com>
References: <6.2.5.6.2.20121111163935.05df8b18@binnacle.cx>
 <6.2.5.6.2.20121111170842.05dfe758@binnacle.cx> <50A06F9F.3090600@websitemanagers.com.au>
 <6.2.5.6.2.20121112095127.039df8b0@binnacle.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6.2.5.6.2.20121112095127.039df8b0@binnacle.cx>
Sender: linux-raid-owner@vger.kernel.org
To: starlight.2012q4@binnacle.cx
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> The third drive will never be on site
> (think about the risk), but that just
> means that the array will grow from
> 2->1 and then from 1->2 instead
> of from 2->3 and 3->2.

I'd argue your risk from a failing disk during resync is significantly
greater then your risk of facility failure during the same window. Not
sure what drives are pricing where you are but adding a forth into the
rotation is cheap insurance. Two for the array, one syncing, one
offsite.

Some recent blogs (
http://storagemojo.com/2010/02/27/does-raid-6-stops-working-in-2019/
for example ) suggest that modern drives will encounter unrecoverable
read errors approx every 12TB read. That works out to approx every
6-12 resyncs based on 1-2TB drives.


-- 
Drew
