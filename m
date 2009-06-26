From: Neil Brown <neilb@suse.de>
Subject: Re: resync hangs
Date: Fri, 26 Jun 2009 12:15:04 +1000
Message-ID: <19012.12072.384955.746414@notabene.brown>
References: <h0e9qm$91r$1@ger.gmane.org>
	<h0mjne$mkv$1@ger.gmane.org>
	<e95d1c83e3f5fa745e914e77e90dd8ec.squirrel@neil.brown.name>
	<h1mt5n$b74$1@ger.gmane.org>
	<31c94e366685d963f1a4794853b9339f.squirrel@neil.brown.name>
	<h1ocv7$i4h$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Randall Smith on Monday June 22
Sender: linux-raid-owner@vger.kernel.org
To: Randall Smith <randall@tnr.cc>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday June 22, randall@tnr.cc wrote:
> NeilBrown wrote:
> >>
> >> ~$ grep . /sys/block/md2/md/*
> > ...
> >> /sys/block/md2/md/sync_speed:0
> >> /sys/block/md2/md/sync_speed_max:0 (system)
> >> /sys/block/md2/md/sync_speed_min:0 (system)
> > 
> > This looks like the culprit.  The sync_speed has been limited to
> > 0.  The "(system)" means that it is using the value from
> >   /proc/sys/dev/raid/speed_limit_max
> > 
> > It seem that that value has been set to 0 somehow.
> > The default value is 200000.
> > 
> > Could something be setting that?  Can you set it back?
> >  .../speed_limit_min should be 1000 by default.
> > 
> > NeilBrown
> 
> I'll set it back next time it happens.  Any guess what might set that 
> value to 0 and why? mdadm is the only thing I know of that knows about 
> raid.  It starts up late in the init process with this command:

No, I don't know of anything that would changed these values.  mdadm
certainly does not.  My guess would be some errant script, maybe part
of a cron job.


NeilBrown
