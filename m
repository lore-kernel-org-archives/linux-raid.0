From: Thomas Andrews <tandrews@grok.co.za>
Subject: Re: One partition degraded after every reboot
Date: Sun, 11 Apr 2004 21:55:35 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040411195535.GA5359@gaspode.nextlink.co.za>
References: <20040326154125.GN1950@gaspode.nextlink.co.za> <20040409133949.GA10900@gaspode.nextlink.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040409133949.GA10900@gaspode.nextlink.co.za>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Apr 09, 2004 at 03:39:49PM +0200, Thomas Andrews wrote:

> What can cause this to occur after a clean shutdown & reboot:
> "md1: former device ide/host2/bus0/target0/lun0/part5 is unavailable, removing from array!"

Well I finally solved it. The error above is somewhat misleading! I
originally created the initrd with the raid1 array degraded. It had to
be done that way because I wanted to re-boot using md1 as the root
device, but at the time /dev/hda5 was still the root.

mkinitrd created a script called "script" which contained the line:

mdadm -A /devfs/md/4 -R -u <magic_number> /dev/hdc5

But what it needs is:

mdadm -A /devfs/md/4 -R -u <magic_number> /dev/hdc5 /dev/hda5

The reason other people get it to work by "fiddling around" is that they
invariably re-do the mkinitrd afterwards, and chances are, most of the
time they will do it with all the devices in the array (ie not degraded
mode.) Creating the initrd with the raid1 running in it's final desired
manner results in mkinitrd putting the correct command into "script", so
there you are.

It's worth noting also that the "broken" initrd also only had /dev/hdc5
whereas the working one has /dev/hdc5 *and* /dev/hda4

In summary, if you get the error above, get the complete raid array up
and running with all devices inserted, and then re-create your initrd:
mkinitrd -r /dev/md? -o /boot/initrd.img-?.?.??-raid

-Thomas

