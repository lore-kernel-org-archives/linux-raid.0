From: Andrew Beresford <beezly@beezly.org.uk>
Subject: Re: RAID autorun support for SunOS disk labels
Date: Fri, 26 Apr 2002 20:03:21 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020426190321.GB31434@monkey.beezly.org.uk>
References: <20020426101101.GA25225@monkey.beezly.org.uk> <1019846049.1670.76.camel@peecee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1019846049.1670.76.camel@peecee>
To: Gregory Leblanc <gleblanc@linuxweasel.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Greg,

On Fri, Apr 26, 2002 at 11:34:09AM -0700, Gregory Leblanc wrote:
> 
> As far as I know nobody has mucked around with the code for autodetect
> stuff on non-DOS disklabels.  Neil Brown has been advocating that people
> not use the partition types, and let the userspace tools set things up. 
> You can find his arguments in the archives for this list (info
> linux-raid to majordomo@vger.kernel.org should get you some links to the
> archives).

Thanks for the information. I've had a flick through the archives and
read up why Neil disagrees with autodetection. However, in my case, the
RAID configuration is reasonably simple and initrd opens up a whole
world of hurt that I can just do without (I tried to go down this road -
admittedly it was 3 in the morning!). I'll create the patch anyway, although it's likely to be a week or so as I'm moving house this weekend. 

I figure that it's more useful to have the choice between autodetection or running raidstart under initrd. 

Cheers,

Beezly


