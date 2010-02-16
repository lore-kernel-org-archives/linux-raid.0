From: Neil Brown <neilb@suse.de>
Subject: Re: Linux mdadm superblock question.
Date: Tue, 16 Feb 2010 11:50:36 +1100
Message-ID: <20100216115036.0f6b7bb6@notabene.brown>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 11 Feb 2010 18:00:23 -0500 (EST)
Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> Hi,
> 
> I may be converting a host to ext4 and was curious, is 0.90 still the only 
> superblock version for mdadm/raid-1 that you can boot from without having 
> to create an initrd/etc?
> 
> Are there any benefits to using a superblock > 0.90 for a raid-1 boot 
> volume < 2TB?

The only noticeable differences that I can think of are:
 1/ If you reboot during recovery of a spare, then 0.90 will restart the
    recovery at the start, while 1.x will restart from where it was up to.
 2/ The /sys/class/block/mdXX/md/dev-YYY/errors counter is reset on each
    re-assembly with 0.90, but is preserved across stop/start with 1.x
 3/ If your partition starts on a multiple of 64K from the start of the
    device and is the last partition and contains 0.90 metadata, then
    mdadm can get confused by it.
 4/ If you move the devices to a host with a different arch and different
    byte-ordering, then extra effort will be needed to see the array for
    0.90, but not for 1.x

I suspect none of these is a big issue.

It is likely that future extensions will only be supported on 1.x metadata.
For example I hope to add support for storing a bad-block list, so that a
read error during recovery will only be fatal for that block, not the whole
recovery process.  This is unlikely ever to be supported on 0.90.  However
it may not be possible to hot-enable it on 1.x either, depending on how much
space has been reserved for extra metadata, so there is no guarantee that
using 1.x now makes you future-proof.

And yes, 0.90 is still the only superblock version that supports in-kernel
autodetect, and I have no intention of adding in-kernel autodetect for any
other version.

NeilBrown
