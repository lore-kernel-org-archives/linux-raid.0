From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: raid5, media scans and stripe-wise resync
Date: Mon, 25 Oct 2004 22:34:46 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410260234.i9Q2YpN28275@www.watkins-home.com>
References: <20041025220212.GA30613@sam.triumf.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041025220212.GA30613@sam.triumf.ca>
To: 'Konstantin Olchanski' <olchansk@sam.triumf.ca>
Cc: 'David Mansfield' <md@dm.cobite.com>, 'Jure Pe_ar' <pegasus@nerv.eu.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a cron job that tests each disk once per day.  This really helps.
But I have still had md find a bad sector.  But the risk of having 2 disks
with bad sectors is very low if you test each night.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Konstantin Olchanski
Sent: Monday, October 25, 2004 6:02 PM
To: Guy
Cc: 'David Mansfield'; 'Jure Pe_ar'; linux-raid@vger.kernel.org
Subject: Re: raid5, media scans and stripe-wise resync

On Mon, Oct 25, 2004 at 04:29:09PM -0400, anybody wrote:
> 1 disk has a bad sector and another disk fails, game over.

On a single-disk, 1 bad sector kills just the one unlucky file.
On a degraded RAID0 or RAID5, 1 bad sector kills the filesystem.
On a healthy RAID0 or RAID5, 2 bad sectors on different disks kill the
filesystem.

Does this make sense?
RAID is less fault tolerant than a single disk?

-- 
Konstantin Olchanski
Data Acquisition Systems: The Bytes Must Flow!
Email: olchansk-at-triumf-dot-ca
Snail mail: 4004 Wesbrook Mall, TRIUMF, Vancouver, B.C., V6T 2A3, Canada
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

