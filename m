From: Tapani Tarvainen <raid@tapanitarvainen.fi>
Subject: Re: Full use of varying drive sizes?
Date: Tue, 22 Sep 2009 16:05:13 +0300
Message-ID: <20090922130513.GE28275@hamsu.tarvainen.info>
References: <697034.10751.qm@web51302.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <697034.10751.qm@web51302.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 22, 2009 at 04:24:23AM -0700, Jon Hardcastle (jd_hardcastle@yahoo.com) wrote:

> I have an array made of many drive sizes ranging from 500GB to 1TB

> But could someone tell me, did I dream that there might one day be
> support to allow you to actually use that unused space in the array?

You can partition the disks and raid the partitions separately.

> I have 3x500GB 2x750GB 1x1TB so I have 1TB of completely unused
> space!

If yoy partition the 750GB disks as 500+250 and the 1TB disk as
500+250+250 you could, for example, create one 6x500GB RAID6 array
and one 3x250GB RAID5 and have 250GB non-raid space, or one
6x500GB RAID6 and two 2x250GB RAID1's.

-- 
Tapani Tarvainen
