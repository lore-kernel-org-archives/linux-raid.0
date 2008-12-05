From: Neil Brown <neilb@suse.de>
Subject: Re: Synchronous vs asynchonous mdadm operations
Date: Fri, 5 Dec 2008 15:45:07 +1100
Message-ID: <18744.45523.151734.277212@notabene.brown>
References: <20081128162703.GA22404@arachsys.com>
	<20081204105953.GL32420@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chris Webb on Thursday December 4
Sender: linux-raid-owner@vger.kernel.org
To: Chris Webb <chris@arachsys.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday December 4, chris@arachsys.com wrote:
> Chris Webb <chris@arachsys.com> writes:
> 
> [Re: mdadm --stop being potentially asynchronous]
> > The reason for the question is that I'm seeing occasional cases of arrays which
> > won't reassemble following such an operation. dmesg alleges there is an invalid
> > superblock for all of the six slots which were originally part of the array.
> 
> I tracked this one down to my scripts, which were failing to adjust the
> available space on the rdevs in a particularly rare case. However, I'm still
> wondering about the best way to do a fail/remove combination, given
> that fail appears to be asynchronous. The shell fragment I give below seems
> way over the top, but I can't see any simpler route....

Yes, --fail is asynchronous and I suspect it will remain that way.  It
is up to the raid array to decide when to let go of the device and it
might never do say: if you fail the last working drive on a raid1, you
still cannot remove it.


> 
> > I notice that some mdadm operations appear to be asynchronous. For instance,
> > 
> >   mdadm --fail /dev/md/shelf.51000 /dev/mapper/slot.51000.1
> >   mdadm --remove /dev/md/shelf.51000 /dev/mapper/slot.51000.1
> > 
> > will always fail at the --remove stage with
> > 
> >   mdadm: hot remove failed for /dev/mapper/slot.51000.1: Device or resource busy
> > 
> > whereas adding a short sleep in between will make it successful.
> > 
> > Is there a 'standard' way to wait for this operation to complete or to
> > perform both steps in one go, other than something horrible like:
> > 
> >   mdadm --fail /dev/md/shelf.51000 /dev/mapper/slot.51000.1
> >   MD=$((`stat -c '%#T' -L /dev/md/shelf.51000`))
> >   MAJOR=$((`stat -c '%#t' -L /dev/mapper/slot.51000.1`))
> >   MINOR=$((`stat -c '%#T' -L /dev/mapper/slot.51000.1`))
> >   for RD in /sys/block/md$MD/md/rd*; do
> >     [ -f $RD/block/dev ] || continue
> >     [ "`<$RD/block/dev`" = "$MAJOR:$MINOR" ] || continue
> >     while [ "< $RD/state" != "faulty ]; do sleep 0.1; done
> >   done
> >   mdadm --remove /dev/md/shelf.51000 /dev/mapper/slot.51000.1

I suspect
  until mdadm --remove /dev/md/shelf.51000 /dev/mapper/slot.51000.1
  do sleep 0.1
  done

might be slightly simpler.

NeilBrown


> 
> Cheers,
> 
> Chris.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
