From: Andrew Morton <akpm@osdl.org>
Subject: Re: MD Oops on boot with 2.6.2-rc1-mm3
Date: Sun, 25 Jan 2004 16:19:55 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040125161955.060d42bc.akpm@osdl.org>
References: <16403.57499.905471.768545@jik.kamens.brookline.ma.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <16403.57499.905471.768545@jik.kamens.brookline.ma.us>
To: Jonathan Kamens <jik@kamens.brookline.ma.us>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jonathan Kamens <jik@kamens.brookline.ma.us> wrote:
>
> I get an Oops on boot with 2.6.2-rc1-mm3, trying to boot from a RAID1
> MD root partition with two disks in the array; the Oops apparently
> causes the raid array not to be assembled, so the boot stops.

There appears to be a dud raid patch in -mm.  It'll be one of the md-*
patches.

If you have time, could you work out which one?  Ones to start with might be

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.2-rc1/2.6.2-rc1-mm3/broken-out/md-02-preferred_minor-fix.patch

and

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.2-rc1/2.6.2-rc1-mm3/broken-out/md-06-allow-partitioning.patch
