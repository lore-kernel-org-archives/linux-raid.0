From: William Thompson <wt@electro-mechanical.com>
Subject: Re: raid 10f2 vs 1 on 2 drives
Date: Wed, 23 May 2012 07:25:46 -0400
Message-ID: <20120523112545.GN27769@electro-mechanical.com>
References: <20120522193340.GM27769@electro-mechanical.com>
 <4FBC14DC.8070007@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4FBC14DC.8070007@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 23, 2012 at 12:36:12AM +0200, David Brown wrote:
> On 22/05/12 21:33, William Thompson wrote:
> >I understand that raid 10 f2 is slower on writes due to the location of the
> >2nd copy.  My question is, if lots of writes are performed, could this
> >layout wearout the drives quicker than raid 1?
> 
> No, wear is not going to be significantly different.
> 
> You didn't say whether you are talking about hard disks (where

Sorry about that (Chief).  Yes, I was refering to hard drives.

> location makes a difference, but "wear" on the drive motor is
> insignificant to the disk's expected lifetime), or flash disks

I was thinking about how much more head movement there would be to write the
2nd copy of the data.

> (where people often worry about "wear", though location is
> irrelevant and wear is also irrelevant for most uses of all but the
> most cheapo disks).
