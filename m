From: Matti Aarnio <matti.aarnio@zmailer.org>
Subject: Re: RAID1 degradation failure.. (2.4.17)
Date: Tue, 23 Apr 2002 15:39:00 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020423153900.E1284@mea-ext.zmailer.org>
References: <20020423151113.D1284@mea-ext.zmailer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020423151113.D1284@mea-ext.zmailer.org>; from matti.aarnio@zmailer.org on Tue, Apr 23, 2002 at 03:11:13PM +0300
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 23, 2002 at 03:11:13PM +0300, Matti Aarnio wrote:
> I have had a machine to go into degraded mode from whence
> it does recover automatically at next power restart, but
> the thing recovers wrong disk, e.g. leaps back in time!
...
> Apparently when a disk fails from under RAID1, the disks
> that are left into running the set are not marked with
> a NEW serial number in superblock so that auto-recovery
> won't pick obsolete data in case such becomes available.

  Comparing the lattest 2.4.19-pre code to my running one,
  it becomes clear that at 2.4.17 there is (was) missing
  a superblock update call.

/Matti Aarnio
