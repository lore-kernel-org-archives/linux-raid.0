From: Neil Brown <neilb@suse.de>
Subject: Re: Confused about UUID mounting and mirrors
Date: Thu, 19 Jun 2008 13:56:36 +1000
Message-ID: <18521.55540.663213.931163@notabene.brown>
References: <4856A8C6.3030609@kmaclub.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from michael@kmaclub.com on Monday June 16
Sender: linux-raid-owner@vger.kernel.org
To: "michael@kmaclub.com" <michael@kmaclub.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday June 16, michael@kmaclub.com wrote:
> Hello,
> 
> I am making the transition from hardware raid to software raid and 
> things have gone pretty well.
> 
> I am trying to mount everything by UUID to account for devices moving 
> around, etc.
> 
> I have moved all mounts in /etc/fstab to uuid except /boot which is a 
> mirror sitting on /dev/md0.
> 
> Since it is a mirror, blkid returns the same uuid for /dev/md0, 
> /dev/sda1, and /dev/sdb1.
> 
> This confuses mount at boot time.
> 
> How to I get it to correctly find md0 and not the components of the mirror?

One option could be to not use UUIDs for mount md devices.  md devices
do not suffer from random name changes when devices config changes
because they are named based on content rather than location.

I realise that it might be more elegant to use UUIDs for everything,
but if you are just after "practical", but don't bother with UUIDs to
mount md arrays.

NeilBrown
