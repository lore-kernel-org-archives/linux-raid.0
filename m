From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Query regarding disk failure
Date: Wed, 10 Jul 2013 19:47:45 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1307101945400.8891@uplift.swm.pp.se>
References: <51DD4EF0.6020509@perpetual-data.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51DD4EF0.6020509@perpetual-data.com>
Sender: linux-raid-owner@vger.kernel.org
To: Priya Kamala <priya.kamala@perpetual-data.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 10 Jul 2013, Priya Kamala wrote:

> If a single disk develops bad sector(s) that affects only a single 
> stripe within a given RAID-5 configuration and these bad sectors are 
> discovered when running a "check/resync" (echo check > 
> /sys/block/mdX/md/sync_action), does this result in the entire disk 
> being removed from the RAID? In other words, is access to the other good 
> stripes on the drive disabled as well? If so, why is it done this way? 
> In case the kernel version makes a difference to the behaviour, I'm 
> working with 2.6.21.1.

If drive is kicked, it could be because it's a consumer drive which 
doesn't support TLER/ERC.

Do:

for x in /sys/block/sd[a-z] ; do echo 180  > $x/device/timeout ; done

This should mean the disk isn't kicked from the array unless it's really 
broken.

But as was mentioned in another mail in your thread, you really should 
upgrade your kernel. It's really old.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
