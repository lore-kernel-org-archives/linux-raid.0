From: Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: Re: Set disk faulty / hot disk remove ioctl bug for read-only MD?
Date: Thu, 14 Feb 2013 14:45:30 -0500 (EST)
Message-ID: <alpine.DEB.2.02.1302140918310.11804@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1302121559540.11804@jlaw-desktop.mno.stratus.com> <20130213133820.6496b074@notabene.brown> <511B7CE6.5060806@profitbricks.com> <alpine.DEB.2.02.1302131255510.11804@jlaw-desktop.mno.stratus.com>
 <20130214090113.01bc6788@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130214090113.01bc6788@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Joe Lawrence <Joe.Lawrence@stratus.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 14 Feb 2013, NeilBrown wrote:

> That all looks good.  I could probably argue that removing a device from a
> read-only array should be permitted but I don't know that it is really
> important.
> 
> 
> > 
> > Quick question for Neil -- should the sysfs MD component device state 
> > file interface perform the same transition from auto-read-only to 
> > read-write, or is that route intended for more granular changes?
> > 
> 
> Good question.
> I think they should definitely transition from auto-read-only to read-write.
> Whether they should be denied  for read-only devices I'm less certain of.
> I'll look into that.

For example, if one disk of a read-only RAID1 happens to be removed, what 
should the user do if he wants MD to release its references to that 
device?  For read-write (and auto-read-only after your change), the user 
can issue mdadm --fail then --remove.  However, if the MD is read-only, is 
stopping the MD the only way to close the device?  What happens if the 
disk is re-inserted and added to the MD?

Regards,

-- Joe
