From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Fri, 17 Apr 2009 09:08:41 +0200
Message-ID: <20090417070841.GA29681@boogie.lpds.sztaki.hu>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com> <cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com> <18899.61151.445765.360191@notabene.brown> <51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com> <18919.64597.426128.498393@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18919.64597.426128.498393@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, Jon Nelson <jnelson-linux-raid@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Apr 17, 2009 at 01:49:41PM +1000, Neil Brown wrote:

> As you probably know, my preferred solution is to have all arrays
> listed in /etc/mdadm.conf.  If it isn't in mdadm.conf, it doesn't get
> assembled.   But I don't have a lot of company in this opinion.  Lots
> of people want to have arrays assembled without them being in
> mdadm.conf, and I'm trying to work with that.

IMHO the goal to have all arrays defined in mdadm.conf would be much
better to achieve if mdadm managed that configuration itself, not unlike
how LVM metadata is handled. Of course doing that right is not exactly
easy...

> Note that 0.90 metadata does contain homehost information to some
> extent.  When homehost is set, the last few bytes of the uuid is set
> from a hash of the homehost name.  That makes it possible to test if a
> 0.90 array was created for 'this' host, but not to find out what host
> it was created for.  So the above expedient won't work for 0.90
> arrays, but the rest of the homehost concept (including any possible
> 'homehost=any' option) does.

How about introducing /dev/md/by-uuid/... (or similar) and teaching
people that if they want to transparently carry their arrays from one
host to another, then they should always refer to it by UUID?

Mounting file systems by UUID instead of device path got accepted by
people who really care about moving things around, so doing the same for
RAID could also work.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
