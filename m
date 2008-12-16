From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: can I freeze I/O for some time to a given disk / md / dm
	device?
Date: Tue, 16 Dec 2008 17:13:12 +0100
Message-ID: <20081216161312.GI18423@boogie.lpds.sztaki.hu>
References: <49479897.1080500@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49479897.1080500@wpkg.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: Linux IDE <linux-ide@vger.kernel.org>, Linux-Raid <linux-raid@vger.kernel.org>, LVM general discussion and development <linux-lvm@redhat.com>
List-Id: linux-raid.ids

On Tue, Dec 16, 2008 at 01:01:27PM +0100, Tomasz Chmielewski wrote:

> Is it possible to "freeze I/O" for some time to a given disk / md / dm  
> device?
>
> Say, "freeze I/O" so that userspace waits for any response for 30, 60  
> seconds or more?

For real disks you can use /sys/block/sdX/device/unload_heads to achieve
something similar (see Documentation/laptops/disk-shock-protection.txt
in the kernel source about how to use it). That won't work for md/dm
devices though.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
