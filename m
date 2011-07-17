From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: Software RAID and TRIM
Date: Mon, 18 Jul 2011 00:31:43 +0200
Message-ID: <ivvnnt$ooh$1@dough.gmane.org>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk>	 <BANLkTimswAVra6qnMS4g8WRzs=dhi_f7OQ@mail.gmail.com>	 <alpine.OSX.2.00.1106291133060.257@trogdor.csi.cam.ac.uk>	 <iuf6me$9us$1@dough.gmane.org>	 <alpine.OSX.2.00.1106291348430.257@trogdor.csi.cam.ac.uk>	 <alpine.DEB.2.00.1106300746460.19581@uplift.swm.pp.se>	 <alpine.OSX.2.00.1107041011110.4557@trogdor.csi.cam.ac.uk> <1309796812.2046.13.camel@werner-t410>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1309796812.2046.13.camel@werner-t410>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Werner Fischer wrote:
> 1) regarding Software RAID and TRIM:
> there is a script raid1ext4trim.sh-1.4 from Chris Caputo that does a
> TRIM for Ext4 file systems on a software RAID 1. According to the
> comments in the script it only supports RAID volumes which reside on
> complete disks (e.g. /dev/sdb and /dev/sdc), not on RAID partitions
> (e.g. /dev/sdb1 and /dev/sdc1)
> The script is shipped with hdparm

I wonder why people would use the "hdparm" tool to issue TRIM commands 
on a lower level that you can do much more portable by using ioctl 
BLKDISCARD...

> I would strongly recommend a SSD with integrated power-outage
> protection

Your results seem to indicate differences, but how is that an evidence
for SSDs corrupting filesystems? As long as the SSD actually tells the 
truth about draining its caches when asked to, the journaling of the 
filesystem will keep the meta-data intact - but not necessarily the data 
inside the files, - for very plausible performance reasons, most 
filesystems will _not_ try to sync non-meta data by default!

Nevertheless, sensitivity against power-outage situations has been a 
subject of many SSD updates for different controllers, so there may have 
been real issues, too.

Regards,

Lutz Vieweg

