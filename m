From: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: Linux mdadm superblock question.
Date: Thu, 18 Feb 2010 09:12:30 -0500
Message-ID: <20100218141230.GA26473@emergent.ellipticsemi.com>
References: <201002141940.35716.volkerarmin@googlemail.com>
 <4B7AD35E.7000405@tmr.com>
 <alpine.LNX.2.01.1002161541370.24961@filesrv1.baby-dragons.com>
 <20100217130103.3ca65ef3@notabene.brown>
 <f73f7ab81002162234t531203ccue1f9ecc839c8ae42@mail.gmail.com>
 <4B7BB927.5000305@grumpydevil.homelinux.org>
 <f73f7ab81002170822j7e61455o6bee33d95c9648a1@mail.gmail.com>
 <alpine.DEB.2.00.1002170932010.4721@asgard.lang.hm>
 <20100217181016.GA14983@emergent.ellipticsemi.com>
 <87sk8z9q0h.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87sk8z9q0h.fsf@frosties.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: david@lang.hm, Kyle Moffett <kyle@moffetthome.net>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, Neil Brown <neilb@suse.de>, "Mr. James W. Laferriere" <babydr@baby-dragons.com>, Bill Davidsen <davidsen@tmr.com>, Volker Armin Hemmann <volkerarmin@googlemail.com>, Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04:33 Thu 18 Feb     , Goswin von Brederlow wrote:
> Nick Bowler <nbowler@elliptictech.com> writes:
> 
> > On 09:41 Wed 17 Feb     , david@lang.hm wrote:
> >> however for people who run systems that are known ahead of time and
> >> static (and who build their own kernels instead of just relying on the
> >> distro default kernel), all of this is unnessesary complication, which
> >> leaves more room for problems to creep in.
> >
> > Such people can easily construct an initramfs containing busybox and
> > mdadm with a shell script hardcoded to mount their root fs and run
> > switch_root.  It's a ~10 minute jobbie that only needs to be done once.
> 
> Except when mdadm, cryptsetup, lvm change you need to update it.
> Esspecially when you set up a new system that might have newer
> metadata.

I meant "once per system".  One typically doesn't _need_ to update the
mdadm in the initramfs, as long as it's capable of assembling the root
array.

> Also at least Debian doesn't (yet) support a common initramfs for their
> kernel packaging. You either build a kernel without need for one or you
> have a per kernel initramfs that is automatically build and updated
> whenever anything in the initrmafs changes. Not often, but still too
> often, the initramfs then doesn't work.

The scenario was when users configure and build their own kernel.  These
users are presumably capable of using grub's "initrd" command or the
CONFIG_INITRAMFS_SOURCE kernel option.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
