From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: (boot time consequences of) Linux mdadm superblock question.
Date: Thu, 18 Feb 2010 00:58:09 -0200
Message-ID: <20100218025809.GA20358@khazad-dum.debian.net>
References: <201002140251.59668.volkerarmin@googlemail.com>
 <alpine.DEB.2.00.1002170932010.4721@asgard.lang.hm>
 <20100217181016.GA14983@emergent.ellipticsemi.com>
 <201002171927.07051.volkerarmin@googlemail.com>
 <20100217183703.GA15446@emergent.ellipticsemi.com>
 <alpine.DEB.2.00.1002171040350.4721@asgard.lang.hm>
 <20100218102407.49f73d67@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100218102407.49f73d67@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: david@lang.hm, Nick Bowler <nbowler@elliptictech.com>, Volker Armin Hemmann <volkerarmin@googlemail.com>, Kyle Moffett <kyle@moffetthome.net>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, "Mr. James W. Laferriere" <babydr@baby-dragons.com>, Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 18 Feb 2010, Neil Brown wrote:
> Using user-space autodetection, you can plug "mdadm -I" into udev, and have
> arrays assembled as they are found, and filesystems mounted as arrays are
> assembled, and then you just have to wait for the root filesystem to appear,
> not for "all devices".

Is this ready for testing somewhere?  initramfs+mdadm.conf is operator-error
bait, proper auto-assemble that does away with the requirement of an
up-to-date mdadm.conf inside the initrd would help a great deal, there.

It will need something like LVM has to blacklist/whitelist what device
classes it will scan for superblocks though, or it will eventually cause a
lot of trouble.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
