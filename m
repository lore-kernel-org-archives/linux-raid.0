From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: MD RAID6 corrupted by Avago 9260-4i controller [SOLVED]
Date: Sun, 15 May 2016 20:31:28 +0200
Message-ID: <20160515183128.GA12823@EIS.leimen.priv>
References: <20160515124534.A42D0100879@atlas.denx.de>
 <20160515133740.85EC3100879@atlas.denx.de>
 <20160515153121.GA11365@EIS.leimen.priv>
 <20160515182524.7B12D100A8E@atlas.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160515182524.7B12D100A8E@atlas.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 15, 2016 at 08:25:24PM +0200, Wolfgang Denk wrote:
> After creating the overlys, the system would automatically start the
> (incorrect) RAID arrays.

That should be courtesy of udev, see if you have a 

    /lib/udev/rules.d/64-md-raid-assembly.rules

and if that's the case you can temporarily disable them by

    touch /etc/udev/rules.d/64-md-raid-assembly.rules

and (later) re-enable by rm'ing the /etc/ file.

> Recovering my data was (fortunately) simple:

Congrats!

Regards
Andreas Klauer
