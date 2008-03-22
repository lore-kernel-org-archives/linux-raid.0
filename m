From: Arthur Britto <ahbritto@iat.com>
Subject: Re: Help: Re-assemble raid-5 with inconsistent events.
Date: Sat, 22 Mar 2008 13:14:20 -0700
Message-ID: <1206216860.10786.12.camel@loss.redstem.com>
References: <1206153639.16304.30.camel@loss.redstem.com>
	 <47E54234.3040407@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47E54234.3040407@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2008-03-22 at 13:30 -0400, Bill Davidsen wrote: 
> Might I suggest that you
> - back up your mdadm.conf file
> - replace the list of components in the ARRAY description with the UUID 
> of the array
> - change configure to use PARTITIONS and try them all
> - try the assemble with mdadm figuring out what goes where
> 
> Your chances of getting something drastically wrong are lower. You may 
> have to use --force to get the assembly, and should run fsck *with the 
> -n option* first to see what you have.

I was using UUID :)

As you suggested, I changed DEVICES to 'partitions' as that was my
original intent.

Rather than just hope, I looked at the source for mdadm.  A thousand
cheers for open source! =D

And discovered:
-v Would show how partitions were assigned.
    mdadm -v -A /dev/md5 showed all was good.
--force updates the events first thing when assembling.
   Solving my exact issue.

My array is now operational.  And the rest is up to reiserfsck. :/

Thank you so much,

-Arthur


