From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Growing a RAID array
Date: Sat, 14 May 2011 11:44:53 -0500
Message-ID: <CB.37.28813.081BECD4@cdptpa-omtalb.mail.rr.com>
References: <8F.2D.17273.3159ECD4@cdptpa-omtalb.mail.rr.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8F.2D.17273.3159ECD4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'NeilBrown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Leslie Rhorer
> Sent: Saturday, May 14, 2011 9:44 AM
> To: 'NeilBrown'
> Cc: linux-raid@vger.kernel.org
> Subject: RE: Growing a RAID array
> 
> > 10Meg devices with a 1Meg chunk size means just 10 stripes.
> >
> > To grow from 4 to 5 data disks it calculates that it needs to back up
> the
> > first 20 stripes (I think).  It sees this is more than half the device
> and
> > gets confused and assumes something is wrong.
> >
> > Try with 4k chunks, or 100Meg devices.
> 
> 	Silly machine.  :-)
> 
> 	'Works like a champ, thanks.  No errors, and the process completes
> in the blink of an eye.  Now if growing an array with 3T spindles were
> only
> that fast...

	Well, this is interesting.  I was playing around a bit more, and I
tried to start a resync.  It failed:

RAID-Server:/RAID# echo repair > /sys/block/md6/md/sync_action
bash: echo: write error: Device or resource busy

	The device was unmounted at the time, so I mounted it and tried
again.  This time it worked.  Is this normal behaviour?



