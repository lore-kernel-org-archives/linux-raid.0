From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID detection and activation w/o auto detection
Date: Tue, 30 Apr 2002 13:31:22 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15566.4106.971348.1325@notabene.cse.unsw.edu.au>
References: <Pine.GSO.4.21.0204290956010.8825-100000@gecko.roadtoad.net>
	<076401c1efee$885325d0$6501a8c0@bomoon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from bo on Monday April 29
To: bo <bo@sosnetwork.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday April 29, bo@sosnetwork.net wrote:
> Hello,
> 
> How to detect and activate the RAID manually without 
> "auto detection"(0xFD in partition type)?
> 
> I tried with "mdadm -R" or "mdadm -A", but it did not work.

echo '/dev/hd* /dev/sd*' > /etc/mdadm.conf
mdadm -Dsb >> /etc/mdadm.conf

# look at /etc/mdadm.conf and make sure that it looks ok.

# add  "mdadm -As" to an appropriate startup script.

Note that this won't work for assembling the root filesystem.
To do that, you either need an init-ramdisk which runs "mdadm -As", or
use kernel parameters to start the root device.e.g.

  append="root=/dev/md0 md=0,/dev/hda1,/dev/hdc1"

NeilBrown
