From: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Subject: Re: How do I tell if my partition is aligned for a 64k/RAID-6?
Date: Sat, 27 Dec 2008 08:58:22 -0500
Message-ID: <20081227135822.GI6284@josefsipek.net>
References: <alpine.DEB.1.10.0812250821360.31386@p34.internal.lan> <495410F4.5010508@ziu.info> <alpine.DEB.1.10.0812251846270.32331@p34.internal.lan> <20081227133824.GH6284@josefsipek.net> <alpine.DEB.1.10.0812270850490.15403@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812270850490.15403@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Michal Soltys <soltys@ziu.info>, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

On Sat, Dec 27, 2008 at 08:53:21AM -0500, Justin Piszcz wrote:
> Why bother partitioning?  I also run a Linux SW RAID1 on the host, as you 
> know the drive letters can change when working on a server.
>
> Example: Before I created the array (RAID-6), my disks were /dev/sda,  
> /dev/sdb and /dev/sdc (spare), the RAID-6 was /dev/sdd.  After reboot,  
> /dev/sdd became /dev/sda and /dev/sd[a-c] became /dev/sd[b-d].
>
> In lilo.conf I had:
> raid-extra-boot="/dev/sda,/dev/sdb"
>
> If I ran LILO and forgot to fix the lilo.conf to reflect the new drive  
> mappings:
> raid-extra-boot="/dev/sdb,/dev/sdc"
>
> I could be at risk of ruining the partition?

Hrm...interesting point. LILO could mess up the superblock in sector 0.

> I try to avoid such situations when possible, to be safe.

:)

I don't know how LILO would handle it, but I would try to use
/dev/disk/by-*/* instead of the rather unstable /dev/sd* names.

Just my 0.02 cents.

Jeff.

-- 
Keyboard not found!
Press F1 to enter Setup
