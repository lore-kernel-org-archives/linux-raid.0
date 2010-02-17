From: Frans Pop <elendil@planet.nl>
Subject: Re: Linux mdadm superblock question.
Date: Wed, 17 Feb 2010 14:26:46 +0100
Message-ID: <201002171426.47981.elendil@planet.nl>
References: <201002140251.59668.volkerarmin@googlemail.com> <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com> <201002141940.35716.volkerarmin@googlemail.com> <4B7AD35E.7000405@tmr.com> <alpine.LNX.2.01.1002161541370.24961@filesrv1.baby-dragons.com> <20100217130103.3ca65ef3@notabene.brown> <f73f7ab81002162234t531203ccue1f9ecc839c8ae42@mail.gmail.com> <f73f7ab81002162234t531203ccue1f9ecc839c8ae42@mail.gmail.com> <4B7BB927.5000305@grumpydevil.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-To: <4B7BB927.5000305@grumpydevil.homelinux.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Cc: kyle@moffetthome.net, neilb@suse.de, babydr@baby-dragons.com, davidsen@tmr.com, volkerarmin@googlemail.com, mjevans1983@gmail.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Rudy Zijlstra wrote:
> 1/ distro tools assume that the kernel being build will run on that
> machine. For servers this is often not true. There are very valid
> security reasons to exclude compilation capability from many servers.

That's simply not true, at least not for Debian. If you actually use the 
distro tools [1] the only assumptions are made at kernel *installation* 
time, not at kernel build time.

I've been using initramfs-tools generated initrds for years without 
problems, and that includes "root on LVM on LUKS encrypted partition" 
and "root on LVM on RAID" setups.

Cheers,
FJP

[1] I.e. if you build and install the kernel as a .deb package using e.g. 
the deb-pkg target or kernel-package.
