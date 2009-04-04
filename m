From: "Lelsie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Sat, 4 Apr 2009 10:15:55 -0500
Message-ID: <20090404151557.VWAG19140.cdptpa-omta03.mail.rr.com@Leslie>
References: <1238857457.16200.64.camel@cichlid.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1238857457.16200.64.camel@cichlid.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Oprofile is supposed to be good for user and kernel profiling but I
> don't know if it can find non-cpu bound stuff. There are also a bunch of
> latency analysis tools in the kernel that were used for realtime tuning,
> they might show where something is getting stuck. Andrew Morton did alot
> of work in this area.

Do you know if he subscribes to this list?  If not, how may I reach him?

> If the cpu was spinning somewhere it would show as system time so it
> must be waiting for a timer or some other event (wild guessing). It's as
> if the i/o completion never arrives but some timer eventually goes off
> and maybe the i/o is retried and everything gets back on track? But that
> should cause utilization to go up and you'd think some sort of
> message...

It's also puzzling why the issue is so much worse when the array diagnostic
is running.  Almost every file creation triggers a halt, and the halt time
extends to 2 minutes.  This is one thing which makes me tend to think it is
an interaction between the file system and the RAID system, rather than
either one alone.

 
> Perhaps the ide list would know of some diagnostic knobs to tweak.


> One last thing, the cpu goes toward 100% idle not wait?

Neither one.  If the drive access is tied to a local CPU intensive user
application, for example ffmpeg, then of course CPU utilization dips, but if
all the drive accesses are via network utilities (ftp, SAMBA, etc), I
haven't noticed any change in CPU utilization.  Simultaneous reads and
writes to other local drives or network drives continue without a hiccough. 

