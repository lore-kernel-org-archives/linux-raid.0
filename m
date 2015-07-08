From: Phil Turmel <philip@turmel.org>
Subject: Re: Resurrecting a Dirty RAID-5
Date: Wed, 8 Jul 2015 09:19:48 -0400
Message-ID: <559D2374.7040208@turmel.org>
References: <OFC233BA12.DDED55A2-ON85257E7C.00420655-85257E7C.0043331F@jt-sw.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <OFC233BA12.DDED55A2-ON85257E7C.00420655-85257E7C.0043331F@jt-sw.com>
Sender: linux-raid-owner@vger.kernel.org
To: jtroan@jt-sw.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning John,

On 07/08/2015 08:14 AM, jtroan@jt-sw.com wrote:

[trim /]

> I booted from the RHEL 6.5 DVD and entered rescue mode.  Using information
> from the Linux RAID wiki [1], I was able to confirm that my sd0 and sd1
> drives are alive and have all three partitions I had originally deployed to
> them -- /boot, /, and swap space.
> 
> Following the advice on the wiki [1], I'm asking for some help in using
> mdadm via rescue mode in trying to get this dirty RAID-5 back on its feet
> with the surviving two drives.  (I've got a third drive already on hand
> that's I'll then use to bring the RAID back to full robustness.)

From this report, you should only need to do a forced assembly from the
rescue environment with the good devices.  Like so (substituting actual
names):

mdadm -Afv /dev/md2 /dev/sda2 /dev/sdb2

If that fails, paste the verbose output in your reply here.

If the above succeeds, you may shut down, plug in your new drive, and
boot into your normal environment (still degraded, but should be
bootable).  Then add the new drive's partitions to each array.

Don't do *anything* else.

HTH,

Phil
