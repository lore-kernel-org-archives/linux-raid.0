From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Ubuntu - RAID Array not "assembling" on boot.
Date: Wed, 22 Nov 2006 16:41:21 +0100
Message-ID: <20061122154121.GI4783@boogie.lpds.sztaki.hu>
References: <1164139592.12278.276853539@webmail.messagingengine.com> <45635DCC.3010500@idgmail.se> <1164147995.26591.276873647@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1164147995.26591.276873647@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Reeves <john.reeves@mailc.net>
Cc: Henrik Holst <henrik.holst@idgmail.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Nov 21, 2006 at 10:26:35PM +0000, John Reeves wrote:

> # mdadm --detail --scan >> /etc/mdadm/mdadm.conf
> 
> And thats when the whole "assemble" on boot problem came from.  I
> presume that the above command (--detail --scan)  is not the correct way
> to make the mdadm.conf file - how should it be made?

It's correct, but as was already said it is not enough. On Debian you
can use the /usr/share/mdadm/mkconf script that spits out a complete
mdadm.conf.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
