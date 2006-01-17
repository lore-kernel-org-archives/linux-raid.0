From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Tue, 17 Jan 2006 08:07:48 -0700 (MST)
Message-ID: <Pine.LNX.4.64.0601170805290.17902@filesrv1.baby-dragons.com>
References: <20060117174531.27739.patches@notabene>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060117174531.27739.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Neil ,

On Tue, 17 Jan 2006, NeilBrown wrote:
> Greetings.
>
> In line with the principle of "release early", following are 5 patches
> against md in 2.6.latest which implement reshaping of a raid5 array.
> By this I mean adding 1 or more drives to the array and then re-laying
> out all of the data.
 	Please inform me of which of the 2.6.latest to use ?  Tia ,  JimL

The latest stable version of the Linux kernel is:		2.6.15.1 	2006-01-15 06:14 UTC 	F 	V 	  	C 	Changelog
The latest prepatch for the stable Linux kernel tree is:	2.6.16-rc1 	2006-01-17 08:09 UTC 	  	V 	  	C 	Changelog
The latest snapshot for the stable Linux kernel tree is:	2.6.15-git12 	2006-01-16 08:04 UTC 	  	V 	  	C 	Changelog


> This is still EXPERIMENTAL and could easily eat your data.  Don't use it on
> valuable data.  Only use it for review and testing.
>
> This release does not make ANY attempt to record how far the reshape
> has progressed on stable storage.  That means that if the process is
> interrupted either by a crash or by "mdadm -S", then you completely
> lose your data.  All of it.
> So don't use it on valuable data.
>
> There are 5 patches to (hopefully) ease review.  Comments are most
> welcome, as are test results (providing they aren't done on valuable data:-).
>
> You will need to enable the experimental MD_RAID5_RESHAPE config option
> for this to work.  Please read the help message that come with it.
> It gives an example mdadm command to effect a reshape (you do not need
> a new mdadm, and vaguely recent version should work).
>
> This code is based in part on earlier work by
>  "Steinar H. Gunderson" <sgunderson@bigfoot.com>
> Though little of his code remains, having access to it, and having
> discussed the issues with him greatly eased the processed of creating
> these patches.  Thanks Steinar.
>
> NeilBrown
>
> [PATCH 001 of 5] md: Split disks array out of raid5 conf structure so it is easier to grow.
> [PATCH 002 of 5] md: Allow stripes to be expanded in preparation for expanding an array.
> [PATCH 003 of 5] md: Infrastructure to allow normal IO to continue while array is expanding.
> [PATCH 004 of 5] md: Core of raid5 resize process
> [PATCH 005 of 5] md: Final stages of raid5 expand code.
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network        Engineer | 3542 Broken Yoke Dr. |  Give me Linux  |
| babydr@baby-dragons.com | Billings , MT. 59105 |   only  on  AXP |
|  http://www.asteriskhelpdesk.com/cgi-bin/astlance/r.cgi?babydr   |
+------------------------------------------------------------------+
