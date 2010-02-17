From: Gabor Gombas <gombasg@digikabel.hu>
Subject: Re: Linux mdadm superblock question.
Date: Wed, 17 Feb 2010 21:54:06 +0100
Message-ID: <20100217205406.GA13287@twister.home>
References: <201002140251.59668.volkerarmin@googlemail.com>
 <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
 <201002141940.35716.volkerarmin@googlemail.com>
 <4B7AD35E.7000405@tmr.com>
 <alpine.LNX.2.01.1002161541370.24961@filesrv1.baby-dragons.com>
 <20100217130103.3ca65ef3@notabene.brown>
 <f73f7ab81002162234t531203ccue1f9ecc839c8ae42@mail.gmail.com>
 <f73f7ab81002162234t531203ccue1f9ecc839c8ae42@mail.gmail.com>
 <4B7BB927.5000305@grumpydevil.homelinux.org>
 <201002171426.47981.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201002171426.47981.elendil@planet.nl>
Sender: linux-kernel-owner@vger.kernel.org
To: Frans Pop <elendil@planet.nl>
Cc: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, kyle@moffetthome.net, neilb@suse.de, babydr@baby-dragons.com, davidsen@tmr.com, volkerarmin@googlemail.com, mjevans1983@gmail.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 17, 2010 at 02:26:46PM +0100, Frans Pop wrote:

> That's simply not true, at least not for Debian. If you actually use the 
> distro tools [1] the only assumptions are made at kernel *installation* 
> time, not at kernel build time.

And that's why network-booted diskless clients and virtual guests have
all sort of useless modules loaded; the HW where the kernel package was
installed in this case is very different from the HW where the kernel
will run. If only there were a switch to prohibit ever looking at the
current machine's configuration when generating the initramfs...

> I've been using initramfs-tools generated initrds for years without 
> problems, and that includes "root on LVM on LUKS encrypted partition" 
> and "root on LVM on RAID" setups.

I've tried a couple of times to use a Debian-built initramfs with a
custom built kernel. The kernel worked fine without an initramfs (it had
everything built in), but it did not boot with the initramfs.

Gabor
