From: "NeilBrown" <neilb@suse.de>
Subject: Re: Unable to stop array
Date: Mon, 8 Jun 2009 09:02:22 +1000 (EST)
Message-ID: <953048308fa5f94ed5dfd3f2c37a3767.squirrel@neil.brown.name>
References: <20090607185225345.YFHY28090@cdptpa-omta04.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090607185225345.YFHY28090@cdptpa-omta04.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, June 8, 2009 4:52 am, Leslie Rhorer wrote:
>
> I am trying to stop one of my arrays for maintenance, but it won't let me.
> I've un-mounted the filesystem, but I still get the following:
>
> mdadm: fail to stop array /dev/md0: Device or resource busy
>
> How do I get the array to be free so I can stop it?
>

Find out what is keeping it busy.
This is not always as easy as you might like.
You could:

 lsof /dev/md0
         to see if any process have it open
 grep md0 /proc/mounts
         to see if it is still mounted
 grep md0 /proc/swaps
         to see if it is in used for swap
 grep md0 /proc/mdstat
         to see if it is included in some other md array
 ls -l /sys/block/md0/holders /sys/block/md0/*/holders
         to see if dm is using it at all
 grep loop /proc/partitions
         to see if there are any loop devices.  If there are,
         one could conceivable be using it.

I cannot think off hand of anything else that might be using the
device.

NeilBrown

