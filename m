From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: strange raid6 assembly problem
Date: Thu, 24 Aug 2006 10:10:47 -0700
Message-ID: <44EDDD97.60303@zytor.com>
References: <20060824123126.GP4670@kyu.freenux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060824123126.GP4670@kyu.freenux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mickael Marchand <mikmak@freenux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mickael Marchand wrote:
> 
> so basically I don't really know what to do with my sdf3 at the moment
> and fear to reboot again :o)
> maybe a --re-add /dev/sdf3 could work here ? but will it survive a
> reboot ?
> 

At this point, for whatever reason, your kernel doesn't see /dev/sdf3 as 
part of the array.

You could mdadm --add it, and yes, it should survive a reboot.  Unless 
something is seriously goofy, of course, but that's impossible to 
determine from your trouble report.

A RAID-6 in two-disk degraded mode often ends up needing two recovery 
passes (one to go from 2->1 and one from 1->0).  This isn't a technical 
need, but is a result of the fact that unless you happen to have two 
hotspares standing by, the 2->1 recovery typically will have started by 
the time second disk is added.  This may be the source of your strangeness.

	-hpa
