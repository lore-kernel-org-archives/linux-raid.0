From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: Script to save array info
Date: Thu, 21 Jun 2012 17:37:00 -0400
Message-ID: <20120621213700.GC10443@animx.eu.org>
References: <20120620232149.GA7767@animx.eu.org>
 <20120621142613.GA28130@calhariz.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120621142613.GA28130@calhariz.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jose Manuel dos Santos Calhariz <jose.spam@netvisao.pt>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jose Manuel dos Santos Calhariz wrote:
> On Wed, Jun 20, 2012 at 07:21:49PM -0400, Wakko Warner wrote:
> > After reading some of the stories about lost metadata, I was wondering if
> > anyone had a script that would output the member info for each device with
> > the device's physical serial number.
> > 
> > For a crude one I did this while in /sys/block:
> > for x in sd*;do
> > 	echo /dev/$x
> > 	/lib/udev/scsi_id --export --page=0x80 --whitelisted /dev/$x
> > 	mdadm -E /dev/$x
> > done
> > 
> > And saved the output.  It works for me because all but 3 of my raid members
> > are full disks.
> 
> I made a script for myself, that collects the information by
> inspecting /sys instead of doing mdadm -E.  The script see all mdraid
> devices and all devices that belong to a mdraid.  I would like to know
> if the script works or not.  It works for me.

I've looked into /sys/block/md*/md before.  I've noticed there is
information not present in the output.

I just checked.  About the only thing important to me would be the "name"
that mdadm -E lists.  I don't know how important UUIDs would be but it could
be.

Looks like your script does essentially this one liner:
find /sys/block/md*/md -type f | xargs grep .

I didn't run it though.  I think yours added the ls -l of the rdX/block/
link.
I looked through everything in the block for some of my devices and none had
the serial number.  I had to use scsi_id from udev to get it.

One thing you might want to do to yours is "exec >> ${FILEMD}" instead of all
the >> ${FILEMD} that you had in your file.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
