From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: linux disk access when idle
Date: Wed, 26 Aug 2009 14:45:21 -0500
Message-ID: <20090826194521.GB27854@sewage>
References: <20090820163522.GA29215@sewage> <4A8D99D9.2090806@sauce.co.nz> <20090821165935.GA18915@sewage> <4A8ED2FC.2070700@redhat.com> <20090822210443.GA12033@sewage>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090822210443.GA12033@sewage>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Aug 22, 2009 at 04:04:43PM -0500, Matt Garman wrote:
> I'm beginning to think that it's not even direct access to the
> drives that cause the heads to unpark, e.g. perhaps even activity
> on my system drive (a compact flash card connected to the PATA
> port) prevents the data drives from parking their heads.

This is correct.  One thing I noticed yesterday, when I was running
blktrace and having block_dump enabled: the heads *never* parked
during this time.  Even though I had zero accesses on the data
drives, the system drive was getting hit pretty heavily (because I
deliberately had syslog write the block_dump stuff).  When I finally
stopped all the heavy logging, I ran "sync" and noticed that a few
seconds later, the heads parked.

Almost exactly five minutes later, the heads un-parked.

I repeated: I ran the "sync" command, the heads unloaded, five
minutes later, they re-loaded.  I repeated this exactly several
times.

So I re-enabled block_dump (i.e. "echo 1 > /proc/sys/vm/block_dump"), 
but disabled syslog (so the system drive wouldn't be thrashed).  I
ran the "sync, then wait five minutes test": pdflush and kjournald
apparently caused the wakeup after five minutes.

I set my system drive to ext2 (instead of ext3) in /etc/fstab and
rebooted.  I was under the impression that using ext2 instead of
ext3 would eliminate the need for kjournald, but this doesn't appear
to be the case.

So, based on what I've seen so far, there's some "five minute thing"
going on that involves pdflush and/or kjournald.

-Matt

