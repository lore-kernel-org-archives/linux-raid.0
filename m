From: NeilBrown <neilb@suse.de>
Subject: Re: race condition in md creation?
Date: Sat, 28 May 2011 07:24:40 +1000
Message-ID: <20110528072440.5bc27c1d@notabene.brown>
References: <20110527152057.47ca7176@pclin250.win.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110527152057.47ca7176@pclin250.win.tue.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Stijn Hoop <stijn@sandcat.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 27 May 2011 15:20:57 +0200 Stijn Hoop <stijn@sandcat.nl> wrote:

> Hello,
> 
> while creating a test suite for internal purposes I ran into a race
> condition where a (very small) raid array that was just created cannot
> be stopped.
> 
> mdadm --create succeeds, but the subsequent mdadm --stop reports
> 'Device or resource busy'.
> 
> Please see the attached script for reproduction purposes, partial output
> from a run on my system (Fedora 14, kernel 2.6.35.13-91.fc14.x86_64,
> mdadm-3.1.3-0.git20100804.2.fc14.x86_64):
> 
> 
> 5+0 records in
> 5+0 records out
> 5242880 bytes (5.2 MB) copied, 0.0166663 s, 315 MB/s
> 5+0 records in
> 5+0 records out
> 5242880 bytes (5.2 MB) copied, 0.0197533 s, 265 MB/s
> mdadm: array /dev/md0 started.
> mdadm: failed to stop array /dev/md0: Device or resource busy
> Perhaps a running process, mounted filesystem or active volume group?
> failed to stop /dev/md0, sleep 1 sec then retrying one more time
> mdadm: stopped /dev/md0

When a new device appears (such as  a new md array), udev springs in to
action and examines it to see if it should do something with it.
While udev (or some tool that it ran) is examining the md array it looks like
it is busy so an attempt to stop it will fail.

My test scripts tend to have
   udevadm settle
before
   mdadm --stop

for exactly this reason.

> 
> 
> I know that this might be an artificial bug, for with real raid arrays
> people will not stop their just-created raid systems, but I figured
> somebody might be interested to find out what was actually going on. As
> I have no kernel expertise (yet! :) and I need to move on, I am only
> posting my results...
> 
> BTW, I'm posting here only because I failed to google a bug tracker for
> linux-raid. If there is one, my apologies, I will gladly create a bug
> instead.
> 

This email list *is* the bug tracker (I'm not a big fan of bug trackers
myself).

Thanks for the report,
NeilBrown



> HTH,
> 
> --Stijn
