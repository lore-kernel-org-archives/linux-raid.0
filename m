From: William Thompson <wt@electro-mechanical.com>
Subject: Re: RAID1 question
Date: Fri, 30 Sep 2011 10:17:01 -0400
Message-ID: <20110930141701.GG19871@electro-mechanical.com>
References: <20110929183457.GA19871@electro-mechanical.com>
 <20110929192611.GA23316@cthulhu.home.robinhill.me.uk>
 <20110929193705.GE19871@electro-mechanical.com>
 <4E855E7F.3000800@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4E855E7F.3000800@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kai Stian Olstad <kai.stian.olstad@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Sep 30, 2011 at 08:15:27AM +0200, Kai Stian Olstad wrote:
> On 29. sep. 2011 21:37, William Thompson wrote:
> > The reason I asked this was because a mirrored pair that I currently have is
> > 0.90 version and I was going to use 1.0
> 
> You'll find information about going from 0.90 to 1.0 in the archive,
> take a look at these links:
> http://thread.gmane.org/gmane.linux.raid/34014/focus=34029
> http://thread.gmane.org/gmane.linux.raid/34424/focus=34441

I'll look at those when I have time.  In this specific case, I do not care
if the data is destroyed.  Just wanted to know if the disks would still be
in sync.

For the sync part, I don't believe it would really matter which metadata
version I used, the disks would be in sync except for areas where the old
metadata was stored.  Am I right on this?  That is assuming RAID1.

