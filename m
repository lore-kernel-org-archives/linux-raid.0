From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: md extension to support booting from raid whole disks.
Date: Wed, 29 Apr 2009 09:07:22 +0200
Message-ID: <20090429070722.GC9372@boogie.lpds.sztaki.hu>
References: <1240574900.4507.2076.camel@ezra> <18935.35883.181289.739254@notabene.brown> <49F79331.1050007@zytor.com> <1240963507.18303.866.camel@ezra> <49F79A0B.1000805@zytor.com> <1240965373.18303.929.camel@ezra>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1240965373.18303.929.camel@ezra>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Reurich <daniel@centurion.net.nz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 29, 2009 at 12:36:13PM +1200, Daniel Reurich wrote:

> This is the last hurdle to supplanting proprietary hardware raid
> controllers with their proprietary drivers and management tool stacks,
> and make software raid actually use able for the average Joe with his
> small business server built from cheap commodity hardware running linux.

Huh? You have just written:

> In which case your probably using a hardware raid controller anyway so
> not our problem. 

You first say that people with any non-trivial configuration should use
a HW RAID controller to justify the breaking of their systems. Then you
say you would like MD to replace HW RAID in such setups. This makes no
sense.

I have set up both cheap commodity hardware and (not so) big HW RAID.
Both have their uses and their weaknesses. Your "boot directly from
RAID5/6" scheme will _never_ work reliably on cheap commodity hardware
unless you fix the hardware _first_. If you want to use cheap commodity
hardware and still have reliability, then boot from RAID1. (And use
lilo; grub is still less reliable in some failure modes. Being dumb
helps sometimes.)

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
