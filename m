From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: Raid1 and mdadm
Date: Tue, 1 Apr 2003 08:43:52 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D72C@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Paul Clements' <Paul.Clements@SteelEye.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, it might be convenient otherwise, but it makes sense that if you want
to boot from the software RAID, that you have to ensure that the md driver
is loaded early enough to recognize that the RAID is configured before it
tries to boot from SCSI alone.

If you aren't booting from the software RAID, md can be a module.  
Also, the other SCSI and RAID components can be modules as long as
CONFIG_BLK_DEV_MD=y.

Andy

-----Original Message-----
From: Paul Clements [mailto:Paul.Clements@SteelEye.com] 
Sent: Tuesday, April 01, 2003 11:08 AM
To: linux-raid@vger.kernel.org
Subject: Re: Raid1 and mdadm


"Cress, Andrew R" wrote:

> However, you MUST link the md driver into the kernel.  It doesn't work
right
> as a module, even in initrd.

BTW, it would be nice if this were fixed, so that md could be compiled
as a module...would the maintainers be willing to accept patches that
would make "autostart" a module option, so that upon insertion of the md
module it would do the autostart stuff, or something similar? From what
I can tell, we basically need to remove some ifndef MODULE stuff and
make the autostart option call autostart_arrays(), as it is when md is
linked into the kernel...

Or is there a better way to do this?

--
Paul
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
