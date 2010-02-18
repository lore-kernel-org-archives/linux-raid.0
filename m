From: Neil Brown <neilb@suse.de>
Subject: Re: (boot time consequences of) Linux mdadm superblock question.
Date: Thu, 18 Feb 2010 16:34:48 +1100
Message-ID: <20100218163448.0d3f3107@notabene.brown>
References: <20100217181016.GA14983@emergent.ellipticsemi.com>
	<201002171927.07051.volkerarmin@googlemail.com>
	<20100217183703.GA15446@emergent.ellipticsemi.com>
	<alpine.DEB.2.00.1002171040350.4721@asgard.lang.hm>
	<20100218102407.49f73d67@notabene.brown>
	<20100218025809.GA20358@khazad-dum.debian.net>
	<20100218032610.GB1991@lapse.rw.madduck.net>
	<1266465801.11568.183.camel@localhost.localdomain>
	<20100218044004.GC5136@lapse.rw.madduck.net>
	<20100218161012.704b43a6@notabene.brown>
	<20100218052145.GA7178@lapse.rw.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100218052145.GA7178@lapse.rw.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: martin f krafft <madduck@madduck.net>
Cc: Daniel Reurich <daniel@centurion.net.nz>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 18 Feb 2010 18:21:45 +1300
martin f krafft <madduck@madduck.net> wrote:

> also sprach Neil Brown <neilb@suse.de> [2010.02.18.1810 +1300]:
> > You would put it in /etc/mdadm.conf
> > The format would be something like:
> > 
> >   ARRAY /dev/md/root uuid=xxxx:xxxx:xxxx:xxxx
> > 
> > and any array found with that uuid would be assembled as /dev/md/root
> 
> No, we mean using the UUID of the root filesystem (vol_id, not
> mdadm's UUID) as the homehost identifier, instead of the hostname.
> 

You can set homehost to anything you like, in mdadm.conf or on the command
line..

But it would be rather awkward to store the uuid of the root filesystem in
the metadata for the array that stores the root filesystem (and so is created
before the root filesystem)...

Are you suggesting that when mdadm finds some bits that looks like the form
an array it should test-assemble it, look inside for a filesystem, extra the
uuid of that filesystem and compare against some known uuid before deciding
whether to assemble that array or not?  I hope not.

So I don't think I know what is really being proposed.

??

NeilBrown
