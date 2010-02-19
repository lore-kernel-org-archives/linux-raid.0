From: Daniel Reurich <daniel@centurion.net.nz>
Subject: Re: (boot time consequences of) Linux mdadm superblock question.
Date: Fri, 19 Feb 2010 15:51:15 +1300
Message-ID: <1266547875.11568.1552.camel@localhost.localdomain>
References: <20100217183703.GA15446@emergent.ellipticsemi.com>
	 <alpine.DEB.2.00.1002171040350.4721@asgard.lang.hm>
	 <20100218102407.49f73d67@notabene.brown>
	 <20100218025809.GA20358@khazad-dum.debian.net>
	 <20100218032610.GB1991@lapse.rw.madduck.net>
	 <1266465801.11568.183.camel@localhost.localdomain>
	 <20100218044004.GC5136@lapse.rw.madduck.net>
	 <20100218161012.704b43a6@notabene.brown>
	 <20100218052145.GA7178@lapse.rw.madduck.net>
	 <20100218163448.0d3f3107@notabene.brown>
	 <20100219004237.GC25162@lapse.rw.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100219004237.GC25162@lapse.rw.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: martin f krafft <madduck@madduck.net>
Cc: Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>, 567468@bugs.debian.org
List-Id: linux-raid.ids

On Fri, 2010-02-19 at 13:42 +1300, martin f krafft wrote:
> also sprach Neil Brown <neilb@suse.de> [2010.02.18.1834 +1300]:
> > But it would be rather awkward to store the uuid of the root
> > filesystem in the metadata for the array that stores the root
> > filesystem (and so is created before the root filesystem)...
> 
> True. You'd have to update the superblock UUID right after creation
> of the filesystem. That doesn't sound like a robust strategy to
> making mdadm.conf optional.
> 
> > Are you suggesting that when mdadm finds some bits that looks like
> > the form an array it should test-assemble it, look inside for
> > a filesystem, extra the uuid of that filesystem and compare
> > against some known uuid before deciding whether to assemble that
> > array or not?  I hope not.
> 
> Hehe, that would be fun, wouldn't it? ;)
> 
> > So I don't think I know what is really being proposed.
> 
> I really would like to make mdadm.conf optional and still have
> things work incrementally from initrd.
> 
But if a generated 'system uuid' value (I just suggested the root fs
UUID because it would be highly unlikely to be unchanged, and nobody
would be likely to fiddle with it) was copied into a file
called /etc/system_uuid and copied into the initrd, then we could add
put into mdadms hook script in initramfs-tools, to verify and update the
homehost variable in the boot time required raid volumes when ever a new
initrd is installed.  (This generally happens on debian whenever a
kernel is installed and mdadm is installed or upgraded.

As an added protection we could include checks in mdadm shutdown script
a check that warns when mdadm.conf doesn't exist and
the /etc/system_uuid doesn't match the homehost value in the boottime
assembled raid volumes.  If we did use the root filesystem UUID for
this, we could compare that as well.

It would be useful to have a tool similar to /bin/hostname that could be
used to create|read|verify|update the system uuid, which would update
all the relevant locations which store and check against this system
uuid.

One could expect LVM would be another prime candidate for system uuid
usage to bind vg's to the host for boot.

But maybe I'm just getting a bit carried away here.  

 
-- 
Daniel Reurich.

Centurion Computer Technology (2005) Ltd
Mobile 021 797 722



