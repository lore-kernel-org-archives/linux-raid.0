From: Steven Ihde <x-linux-raid@hamachi.dyndns.org>
Subject: Re: Thanks :)
Date: Fri, 22 Oct 2004 13:51:44 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041022205144.GA28719@hamachi.dyndns.org>
References: <41794C1D.4080004@dgreaves.com> <41796ACC.2010601@robinbowes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <41796ACC.2010601@robinbowes.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 22 Oct 2004 21:17:16 +0100, Robin Bowes wrote:
> David Greaves wrote:
> >I got this yesterday
> >
> >#################
> >This is an automatically generated mail message from mdadm
> >running on cu.dgreaves.com
> >
> >A Fail event had been detected on md device /dev/md0.
> >#################
> 
> David,
> 
> How have you set things up to achieve this?

See the section on Monitor mode (-F option) in the mdadm man page.
Debian's mdadm package, for example, sets it up so mdadm -F gets run
automatically at boot time to monitor your arrays.

-Steve
