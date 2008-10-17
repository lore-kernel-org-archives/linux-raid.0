From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Distributed spares
Date: Fri, 17 Oct 2008 15:09:51 +0200
Message-ID: <20081017130951.GD9009@boogie.lpds.sztaki.hu>
References: <48F3C2A1.3080607@tmr.com> <18676.28329.93345.30205@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18676.28329.93345.30205@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Bill Davidsen <davidsen@tmr.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Oct 14, 2008 at 09:04:25PM +1100, Neil Brown wrote:

> The tricky bit is encoding the new state.
> We can not longer tell the difference between "optimal" and "degraded"
> based on the number of in-sync devices.  We also need some state flag
> to say that the "distributed spare" has been constructed. 
> Maybe that could be encoded in the "layout".

Or you need to add a "virtual" spare that does not have an actual block
device behind it. Or rather it could be a virtual disk constructed from
the spare chunks on the data disks; maybe device mapper could be used
here? If you could create such a virtual disk then maybe the normal
RAID5 code could just do the rest. Of course the mapping of stripes to
disk locations has to be changed to account for the "black holes" now
belonging to the virtual spare device.

Hmm, if you create DM devices for all the disks that just leave out the
proper holes from the mapping, and you also create a DM device from the
holes, and you create an MD RAID5+spare on top of these DM devices, then
you could have RAID5e right now completely from userspace. The
superblock should be changed so nobody ever tries to build a RAID5 from
the raw disks and there may be some other details...

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
