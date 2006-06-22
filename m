From: Neil Brown <neilb@suse.de>
Subject: Re: Can't get drives containing spare devices to spindown
Date: Thu, 22 Jun 2006 15:05:11 +1000
Message-ID: <17562.9479.533427.960138@cse.unsw.edu.au>
References: <446395C0.5060502@debruin.org>
	<449A2152.2040906@debruin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Marc L. de Bruin on Thursday June 22
Sender: linux-raid-owner@vger.kernel.org
To: "Marc L. de Bruin" <marc@debruin.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday June 22, marc@debruin.org wrote:
> Marc L. de Bruin wrote:
> 
> > Situation: /dev/md0, type raid1, containing 2 active devices 
> > (/dev/hda1 and /dev/hdc1) and 2 spare devices (/dev/hde1 and /dev/hdg1).
> >
> > Those two spare 'partitions' are the only partitions on those disks 
> > and therefore I'd like to spin down those disks using hdparm for 
> > obvious reasons (noise, heat). Specifically, 'hdparm -S <value> 
> > <device>' sets the standby (spindown) timeout for a drive; the value 
> > is used by the drive to determine how long to wait (with no disk 
> > activity) before turning off the spindle motor to save power.
> >
> > However, it turns out that md actually sort-of prevents those spare 
> > disks to spindown. I can get them off for about 3 to 4 seconds, after 
> > which they immediately spin up again. Removing the spare devices from 
> > /dev/md0 (mdadm /dev/md0 --remove /dev/hd[eg]1) actually solves this, 
> > but I have no intention actually removing those devices.
> >
> > How can I make sure that I'm actually able to spin down those two 
> > spare drives?

This is fixed in current -mm kernels and the fix should be in 2.6.18.

NeilBrown
