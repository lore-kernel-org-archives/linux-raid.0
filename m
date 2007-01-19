From: dean gaudet <dean@arctic.org>
Subject: Re: bad performance on RAID 5
Date: Thu, 18 Jan 2007 17:33:06 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0701181731080.3052@twinlark.arctic.org>
References: <45AE9640.1040500@start.no>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45AE9640.1040500@start.no>
Sender: linux-raid-owner@vger.kernel.org
To: Sevrin Robstad <quackyo@start.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 17 Jan 2007, Sevrin Robstad wrote:

> I'm suffering from bad performance on my RAID5.
> 
> a "echo check >/sys/block/md0/md/sync_action"
> 
> gives a speed at only about 5000K/sec , and HIGH load average :
> 
> # uptime
> 20:03:55 up 8 days, 19:55,  1 user,  load average: 11.70, 4.04, 1.52

iostat -kx /dev/sd? 10  ... and sum up the total IO... 

also try increasing sync_speed_min/max....

and a loadavg jump like that suggests to me you have other things 
competing for the disk at the same time as the "check".

-dean
