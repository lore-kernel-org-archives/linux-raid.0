From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid auto-assembly upon boot - device order
Date: Mon, 27 Jun 2011 10:47:39 -0400
Message-ID: <4E08980B.5080002@turmel.org>
References: <4E089067.8010904@ivitera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E089067.8010904@ivitera.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pavel Hofman <pavel.hofman@ivitera.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Pavel,

On 06/27/2011 10:15 AM, Pavel Hofman wrote:
> Hi,
> 
> We are running a raid1 on top of two raid0's. In this specific case we
> cannot use raid10 (different device sizes etc). Upon booting, the raid1
> is always started degraded, with one of the raid0's missing. The log
> says the missing raid could not be found. However, upon booting
> /proc/mdstat lists both the two raid0s OK.
> 
> I guess either the raids are assembled in wrong order (no mutual
> dependencies considered), or without letting the previously assembled
> device to "settle down". I am wondering what would be the proper way to
> fix this issue. The raids are huge (over 1TB each) and recovery takes
> many hours.
> 
> Our mdadm.conf lists the raids in proper order, corresponding to their
> dependency.

I would first check the copy of mdadm.conf in your initramfs.  If it specifies just the raid1, you can end up in this situation.

Most distributions have an 'update-initramfs' script or something similar which must be run after any updates to files that are needed in early boot.

If this is your problem, it also explains why the raid0 appears OK after booting.  The init-scripts that are available on the real root filesystem, containing the correct mdadm.conf, will assemble it.

HTH,

Phil
