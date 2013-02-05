From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Interpreting mdstat output
Date: Tue, 5 Feb 2013 13:40:14 +0000
Message-ID: <20130205134014.GA587@nsrc.org>
References: <20130205122048.GA417@nsrc.org>
 <20130205130237.GA9299@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130205130237.GA9299@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 05, 2013 at 01:02:37PM +0000, Robin Hill wrote:
> > 1. The UUUU_ and [22/21] suggests that one disk is bad, but is that true?
> > And if so which one?
> > 
> No, that's normal. A RAID5 (or RAID6) array is created in a degraded
> form, then the last disk(s) are recovered (it's the quickest way of
> getting the array ready for use).

Ah I see. Thank you.
