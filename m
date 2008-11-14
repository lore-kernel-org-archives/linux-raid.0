From: " Robin Hill" <robin@robinhill.me.uk>
Subject: Re: OT: Tips for good hard drives for a home server
Date: Fri, 14 Nov 2008 05:34:53 -0800
Message-ID: <20081114053453.9372C520@resin11.mta.everyone.net>
Reply-To: <robin@robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- billycrook@gmail.com wrote:

> Obviously RAID-class drives benefit in hardware raid (with hardware
> raid controllers).  But do RAID-class drives benefit when used on a
> non-raid hardware controller, with linux software raid (mdadm)?  What
> about a hardware raid controller in JBOD mode?
> 
> Are the raid-class drives supposed to be used:
>  - in a raid fashion
> or
>  - on a hardware raid controller
> or both?
> 
From what I can tell, modern RAID-class drives are just certified for 24x7 operation.  Some may also have some features tweaked for hardware RAID (e.g. disabling write caching) but I've not seen this on any I've bought.  I'd recommend using them in any situation where you're going to be running the system full-time, whether they're standalone or in software or hardware RAID.

Cheers,
    Robin
