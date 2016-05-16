From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: MD RAID6 corrupted by Avago 9260-4i controller [SOLVED]
Date: Mon, 16 May 2016 15:14:39 +0200
Message-ID: <20160516131439.GA2850@metamorpher.de>
References: <20160515133740.85EC3100879@atlas.denx.de>
 <20160515153121.GA11365@EIS.leimen.priv>
 <20160515182524.7B12D100A8E@atlas.denx.de>
 <20160515183128.GA12823@EIS.leimen.priv>
 <20160515193516.2C457100879@atlas.denx.de>
 <20160515203446.GA13218@EIS.leimen.priv>
 <20160515231046.E3685100A8E@atlas.denx.de>
 <20160516083903.GA29380@EIS.leimen.priv>
 <20160516120600.5428910035C@atlas.denx.de>
 <20160516125801.20A1A100879@atlas.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160516125801.20A1A100879@atlas.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 16, 2016 at 02:58:01PM +0200, Wolfgang Denk wrote:
> Seems I was lucky - already the second of the 120 possible
> combination turned out to be working: b a c d f e

Find a large enough file (disks * chunksize) and verify it.

Sometimes you can be unlucky, i.e. the LVM is detected, the filesystem 
mounts, but still data is corrupt because the wrong two disks switched 
places (just not the ones that contain filesystem metadata).
 
> But I still have not the slightest idea why the drive order might have
> changed...

Me neither. :)

With GPT partition table, I set PARTLABEL to mdnumber-role so that's 
another place that has metadata in case mdadm loses its own... 
Since GPT lives at beginning and end of the disk it should have a 
good chance of surviving accidents, and you can address them as 
/dev/disk/by-partlabel/mdnumber-* in the correct order...

Anyway, glad you (hopefully, finally?) got your data back.

Regards
Andreas Klauer
