From: Wolfgang Denk <wd@denx.de>
Subject: Re: MD RAID6 corrupted by Avago 9260-4i controller [SOLVED]
Date: Sun, 15 May 2016 21:35:16 +0200
Message-ID: <20160515193516.2C457100879@atlas.denx.de>
References: <20160515124534.A42D0100879@atlas.denx.de> <20160515133740.85EC3100879@atlas.denx.de> <20160515153121.GA11365@EIS.leimen.priv> <20160515182524.7B12D100A8E@atlas.denx.de> <20160515183128.GA12823@EIS.leimen.priv>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20160515183128.GA12823@EIS.leimen.priv>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Andreas,

In message <20160515183128.GA12823@EIS.leimen.priv> you wrote:
> On Sun, May 15, 2016 at 08:25:24PM +0200, Wolfgang Denk wrote:
> > After creating the overlys, the system would automatically start the
> > (incorrect) RAID arrays.
> 
> That should be courtesy of udev, see if you have a 
> 
>     /lib/udev/rules.d/64-md-raid-assembly.rules
> 
> and if that's the case you can temporarily disable them by
> 
>     touch /etc/udev/rules.d/64-md-raid-assembly.rules
> 
> and (later) re-enable by rm'ing the /etc/ file.

Thanks.

> > Recovering my data was (fortunately) simple:

Unfortunately my luck did not last very long.  While copying the first
file system from the recovered array, the system crashed - can't tell
why, when I got to the console it was all black :-(

So I tried to repeat the same procedure, but it does not work any
more:  after erasing the superblocks my attempts to assemble the array
now give only:

	#  mdadm --assemble  /dev/md2 --metadata=1.2  $overlays
	mdadm: no RAID superblock on /dev/mapper/sda
	mdadm: /dev/mapper/sda has no superblock - assembly aborted

[which is what I had initially expected; I have no idea why it worked
once, but not a second time.]

OK, I can recreate the array, but LVM does not recognize it.

You mentioned I had to play around with the offsets - do you have any
idea which values would be reasonable to try out?

Thanks in advance - once more...

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
You can't depend on your eyes when your imagination is out of  focus.
- Mark Twain
