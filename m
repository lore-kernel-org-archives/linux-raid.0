From: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: Linux mdadm superblock question.
Date: Wed, 17 Feb 2010 13:10:16 -0500
Message-ID: <20100217181016.GA14983@emergent.ellipticsemi.com>
References: <201002140251.59668.volkerarmin@googlemail.com>
 <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
 <201002141940.35716.volkerarmin@googlemail.com>
 <4B7AD35E.7000405@tmr.com>
 <alpine.LNX.2.01.1002161541370.24961@filesrv1.baby-dragons.com>
 <20100217130103.3ca65ef3@notabene.brown>
 <f73f7ab81002162234t531203ccue1f9ecc839c8ae42@mail.gmail.com>
 <4B7BB927.5000305@grumpydevil.homelinux.org>
 <f73f7ab81002170822j7e61455o6bee33d95c9648a1@mail.gmail.com>
 <alpine.DEB.2.00.1002170932010.4721@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002170932010.4721@asgard.lang.hm>
Sender: linux-kernel-owner@vger.kernel.org
To: david@lang.hm
Cc: Kyle Moffett <kyle@moffetthome.net>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, Neil Brown <neilb@suse.de>, "Mr. James W. Laferriere" <babydr@baby-dragons.com>, Bill Davidsen <davidsen@tmr.com>, Volker Armin Hemmann <volkerarmin@googlemail.com>, Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09:41 Wed 17 Feb     , david@lang.hm wrote:
> for a distro that is trying to make one kernel image run on every
> possible type of hardware features like initramfs (and udev, modeules,
> etc) are wonderful.
> 
> however for people who run systems that are known ahead of time and
> static (and who build their own kernels instead of just relying on the
> distro default kernel), all of this is unnessesary complication, which
> leaves more room for problems to creep in.

Such people can easily construct an initramfs containing busybox and
mdadm with a shell script hardcoded to mount their root fs and run
switch_root.  It's a ~10 minute jobbie that only needs to be done once.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
