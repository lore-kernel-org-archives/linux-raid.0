From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: md: could not bd_claim hde1
Date: Sun, 11 Oct 2009 21:23:39 +0200
Message-ID: <20091011192339.GC32284@boogie.lpds.sztaki.hu>
References: <Pine.LNX.4.61.0910102326250.22812@soloth.lewis.org>
 <738ae0e0ab81ff72cc23b359d0011d1c.squirrel@neil.brown.name>
 <Pine.LNX.4.61.0910110051270.22812@soloth.lewis.org>
 <4AD198E8.2070707@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4AD198E8.2070707@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Jon Lewis <jlewis@lewis.org>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Oct 11, 2009 at 12:35:52PM +0400, Michael Tokarev wrote:

> ># cat /proc/mounts
> >rootfs / rootfs rw 0 0
> >/dev/root / ext3 rw 0 0
> 
> That's what you get for using rh and their nash ;)
>
> What IS /dev/root?  How does your root device
> is specified in initramfs -- by uuid/label?

Hmm. cat /proc/mounts:

rootfs / rootfs rw 0 0
/dev/root / ext3 rw,noatime,errors=remount-ro,data=ordered 0 0

Vanilla 2.6.31.3 with no initramfs in sight, no UUID, no label thingy,
just good old "root=/dev/md0".

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
