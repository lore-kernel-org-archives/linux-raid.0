From: "Magnus Naeslund(k)" <mag@kite.se>
Subject: Re: Raid 1 (non) performance
Date: Mon, 20 Nov 2006 15:12:19 +0100
Message-ID: <4561B7C3.7030000@kite.se>
References: <455B4609.6090905@kite.se> <Pine.LNX.4.64.0611191107590.15092@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0611191107590.15092@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

dean gaudet wrote:
> 
> i see you have split /var and / on the same spindle... if your /home is on 
> / then you're causing extra seek action by having two active filesystems 
> on the same spindles.  another option to consider is to make / small and 
> mostly read-only and move /home to /var/home (and use a symlink or mount 
> --bind to place it at /home).
> 

Yes I have it like this now:
	/var/bind/home on /home type bind (rw,bind,noatime)

> hopefully your swap isn't being used much anyhow.
> 

Zero used, infact.

> try "iostat -kx /dev/sd* 5" and see if the split is causing you troubles 
> -- i/o activity on more than one partition at once.
> 

It seems to be roughly the same numbers on the disks.

> turning off write caching is a recipe for disasterous performance on most 
> ata disks... unfortunately.  better to buy a UPS and set up nut or apcupsd 
> or something to handle shutdown.  or just take your chances.
> 

This is a mail server, I would like it to not lose mail if there is an power outage.
Is there anything one can do without buying more hardware?


Thanks for the feedback,
Magnus

