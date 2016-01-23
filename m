From: Phil Turmel <philip@turmel.org>
Subject: Re: Wrong device name after hot-swap
Date: Fri, 22 Jan 2016 19:51:24 -0500
Message-ID: <56A2CE8C.2090500@turmel.org>
References: <n7u8gr$1bv$1@ger.gmane.org> <56A2ACB4.6060808@turmel.org>
 <n7ud6o$b1f$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <n7ud6o$b1f$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Paul van der Vlis <paul@vandervlis.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/22/2016 06:15 PM, Paul van der Vlis wrote:
> Op 22-01-16 om 23:27 schreef Phil Turmel:

>> MD stores signatures in the devices it uses that identify them for later
>> assembly.  It does not depend on the device name, though it is recorded
>> in the superblock as a "last connected as" kind of indicator.
> 
> So I can do it as described above?

Yes.  Though I won't comment on grub part.  (I've stopped using it and
am no long current.)

>> In general, you should not rely on device names in your system
>> configuration.  UUIDs and filesystem labels were implemented
>> specifically to avoid this problem.
> 
> So far I know I cannot configure anywhere a disk UUID or a filesytem
> label to a MD-device.

Modern udev creates /dev/disk/by-id/ and similar symlinks, but its not
important for md.

> It feels wrong when I add /dev/sdc1 to the raid, when the name is
> normally /dev/sdb1. But maybe it's no problem, because the device name
> is not impartant while booting from an MD-device.

It's not a problem.  Unless you have specific member device names in
mdadm.conf.  (Don't do that.)

Phil
