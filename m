From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: Raid selection questions (10 vs 6, n2 vs f2) on an 8 drive array
Date: Sat, 19 Feb 2011 01:54:39 +0100
Message-ID: <20110219005439.GA3251@www2.open-std.org>
References: <AANLkTi=2xjjuvT3tTs1Y9Qfrn6HxWS3hwzF-Q0ZhPFVM@mail.gmail.com> <4D5F0458.3060403@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D5F0458.3060403@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Larry Schwerzler <larry@schwerzler.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Feb 18, 2011 at 05:44:24PM -0600, Stan Hoeppner wrote:
> Larry Schwerzler put forth on 2/18/2011 2:55 PM:
> 
> > 1. In my research of raid10 I very seldom hear of drive configurations
> > with more drives then 4, are there special considerations with having
> > an 8 drive raid10 array? I understand that I'll be loosing 2TB of
> > space from my current setup, but i'm not too worried about that.
> 
> This is because Linux mdraid is most popular with the hobby crowd, not
> business, and most folks in this segment aren't running more than 4
> drives in a RAID 10.  For business solutions using embedded Linux and
> mdraid, mdraid is typically hidden from the user who isn't going to be
> writing posts on the net about mdraid.  He calls his vendor for support.
>  In a nutshell, that's why you see little or no posts about mdraid 10
> arrays larger than 4 drives.

well on https://raid.wiki.kernel.org/index.php/Performance
there are several performance reports with 6 or 10 spindles, so there...

For an 8 drive Linux MD raid10 maybe you should consider a motherboard
with 8 sata ports.

Best regards
keld
