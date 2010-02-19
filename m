From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: (boot time consequences of) Linux mdadm superblock question.
Date: Fri, 19 Feb 2010 10:16:19 +0100
Message-ID: <20100219091619.GA2964@lazy.lzy>
References: <alpine.DEB.2.00.1002171040350.4721@asgard.lang.hm>
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
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100219004237.GC25162@lapse.rw.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, Daniel Reurich <daniel@centurion.net.nz>, linux-raid <linux-raid@vger.kernel.org>, 567468@bugs.debian.org
List-Id: linux-raid.ids

Hi,

> True. You'd have to update the superblock UUID right after creation
> of the filesystem. That doesn't sound like a robust strategy to
> making mdadm.conf optional.

it seems that, with "dracut", "mdadm.conf" is optional.

There is the kernel boot paramenter "rd_NO_MDADMCONF",
which forces "dracut" to do not use the "mdadm.conf" in
the initramfs image.

This seems to work also if / is on mdX.

I just tried it, and it was running fine. I did not check
the details, i.e. I've no proof "dracut" was not cheating.

My impression is that it uses the "mdadm -I" functionality.

There are other interesting kernel boot options, like:

rd_MD_UUID=<md uuid>

bye,

-- 

piergiorgio
