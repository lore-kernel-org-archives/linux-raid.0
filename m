From: Chris Murphy <lists@colorremedies.com>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Wed, 9 Jan 2013 23:25:44 -0700
Message-ID: <4A81E770-60DD-4C5F-A341-B449BF2C381F@colorremedies.com>
References: <201212212357.19292.thomas@fjellstrom.ca> <201212222044.27731.thomas@fjellstrom.ca> <201301091141.52238.thomas@fjellstrom.ca>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201301091141.52238.thomas@fjellstrom.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 9, 2013, at 11:41 AM, Thomas Fjellstrom <thomas@fjellstrom.ca> wrote:
> 
> So I've retested the array without bcache in th way, and my write speeds are 
> still a fraction of the read speeds. Is this normal for a setup like mine?

It looks like roughly 1/3 of the write performance? There is a non-insignificant penalty with RAID6 writes in IOPS, so I would look at whether your test is even valid; i.e. is it writing or rewriting in amounts that match what you will be using the array for? If not, disqualify the test and results and come up with something else that's more like the actual usage.

Is this for DAS? For big media files, IOPS is not typically what you need. You get large sequential writes.

> 
> IBM M1015 flashed with the LSI 9211-8i IT firmware
> 7x2TB Seagate Baracuda HDDs in raid6 unpartitioned and formatted with XFS

I'm not following. This is a SAS controller and you're using a Barracuda, which I think is a SATA drive? If you're using SAS drives, I'd expect them to be good enough quality and low UER that you could do RAID5 and avoid some of the write penalty. RAID 6 implies quite a few drives, have you considered RAID 10 instead? That card will do RAID 10 itself. The other possibility just RAID 0 the thing for DAS, and then back it up daily with rsync to a separate DAS RAID 0, or linear array.

Chris Murphy