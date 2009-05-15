From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: resync duration ?
Date: Fri, 15 May 2009 00:07:59 -0500
Message-ID: <20090515050801951.MELG9927@cdptpa-omta04.mail.rr.com>
References: <9a9f58b3517ecbc3a076725c671f6cd1.squirrel@neil.brown.name>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9a9f58b3517ecbc3a076725c671f6cd1.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> >> A resync reads all the data and checks the parity.  If it find bad
> >> parity (which is likely to be very rare) then it corrects it.
> >> So resync should run at the full speed of the hardware, just reading.
> >
> > It will?  Maybe I am just mis-remembering, but I thought I saw the same
> > note
> > in the log when the resync occurred (ckarray) as when a recovery was in
> > progress:
> >
> > May 14 22:40:42 Backup kernel: [ 8083.747787] md: recovery of RAID array
> > md0
> > May 14 22:40:42 Backup kernel: [ 8083.747789] md: minimum _guaranteed_
> > speed: 1000 KB/sec/disk.
> > May 14 22:40:42 Backup kernel: [ 8083.747791] md: using maximum
> available
> > idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
> > May 14 22:40:42 Backup kernel: [ 8083.747797] md: using 128k window,
> over
> > a
> > total of 1465138432 blocks.
> >
> > Am I mis-remembering, or am I missing something here?
> 
> It isn't clear to me exactly what you are asking...
> 
> It says it won't use more than 200MB/sec, which is true. But that is
> per-device, and few devices can deliver that yet.

Oh.  I thought it meant for the entire array.  Yeah, 200MBps is pretty far
out there, at least for a sustained rate.  SATA II can burst to that, but
few drives can manage much more than 50 MBps, sustained.

> It says "using maximum available", so it if you want the bandwidth
> for something else, it will back off.
> 
> It prints the same message for resync as for recovery.

Ah, so I'm not going crazy, I just have a comprehension problem.

Hmmm.  I'm not sure which is worse. :-)

> > Oh, while I am thinking of it, ckarray runs every month on the first of
> > the
> > month, but how can one trigger it manually?
> 
>   echo check > /sys/block/mdX/md/sync_action.
> 
> or "echo repair" to get it to fix anything it finds.

Thanks.  Those are pretty easy, but it would be nice if they were in the MAN
page.  Better yet, have you considered adding both as command line options
for mdadm?

