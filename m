From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 15:21:51 +0000
Message-ID: <20110131152151.GD7861@cthulhu.home.robinhill.me.uk>
References: <AANLkTi=oCi1oMTMk_uhsiYA0CA80+8_k-AtvYXZ3jC+U@mail.gmail.com>
 <AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com>
 <AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon Jan 31, 2011 at 01:00:13PM -0200, Roberto Spadim wrote:

> i think make two very big raid 0
> and after raid1
> is better
> 
Not really - you increase the failure risk doing this.  With this setup,
a single drive failure from each RAID0 array will lose you the entire
array.  With the reverse (RAID0 over RAID1) then you require both drives
in the RAID1 to fail in order to lose the array.  Of course, with a 4
drive array then the risk is the same (33% with 2 drive failures) but
with a 6 drive array it changes to 60% for RAID1 over RAID0 versus 20%
for RAID0 over RAID1.

Cheers,
    Robin
