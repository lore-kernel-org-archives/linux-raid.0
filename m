From: Neil Brown <neilb@suse.de>
Subject: Re: md126-7
Date: Wed, 4 Apr 2007 07:15:12 +1000
Message-ID: <17938.50144.495779.735588@notabene.brown>
References: <46127910.9070006@corky.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Just Marc on Tuesday April 3
Sender: linux-raid-owner@vger.kernel.org
To: Just Marc <marc@corky.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 3, marc@corky.net wrote:
> Hi everyone,
> 
> I've been using the RAID subsystem quite a bit over the years.  This 
> week, for the first time, I created a RAID6 array over loop devices that 
> point to files.
> 
> To my surprise the device showing in /proc/mdstat for this new array is 
> /dev/md127.   This is a fresh system and RAID has never been configured 
> on it.  I tried re-doing everything from scratch again and was sometimes 
> even given /dev/md126 (though I wasn't able to reproduce this one, it 
> happened once). 
> 
> My kernel is 2.6.20.4.    Can anyone give me a hint about what's going on?

Maybe if you tell us what commands you ran, we could explain what you
did?
Maybe you did

   mdadm -C /dev/bigdev -amd -l6 -n5 /dev/sd[a-e]

As the name "bigdev" doesn't look like "md%d", it will just choose an
unused number up around 127.

NeilBrown
