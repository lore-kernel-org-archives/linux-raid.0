From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: 3-way mirrors
Date: Tue, 7 Sep 2010 21:55:05 +0200
Message-ID: <20100907195504.GB27145@www2.open-std.org>
References: <4C866354.3050904@cdf.toronto.edu> <20100907184917.8181.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100907184917.8181.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Cc: iordan@cdf.toronto.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 07, 2010 at 02:49:17PM -0400, George Spelvin wrote:
> George Spelvin wrote:
> 
> But in the meantime, I'd like check/repair passes to tell me if 2 of the 3
> mirrors agree, so I can blame the third.

I would like to check the error logs of the disks to see if one of the
disagreeing blocks has had an anormaly. This would also work when you
only have 2 copies.

Or some reporting to higher up levels, and the ability to then check out
manually which copy to keep.

Best regards
keld
