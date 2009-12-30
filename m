From: Matt Garman <matthew.garman@gmail.com>
Subject: raid0/jbod/lvm, sorta?
Date: Tue, 29 Dec 2009 18:03:57 -0600
Message-ID: <20091230000357.GA23485@septictank.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Is there a way, with Linux md (or maybe lvm) to create a single mass
storage device from many physical drives, but with the property that
if one drive fails, all data isn't lost, AND no redundancy?

I.e., similar to RAID-0, but if one drive dies, all data (but that
on the failed drive) is still readily available?

Motivation:

I currently have a four-disc RAID5 device for media storage.  The
typical usage pattern is few writes, many reads, lots of idle time.
I got to thinking, with proper backups, RAID really only buys me
availability or performance, neither of which are a priority.
Modern single-disc speed is more than enough, and high-availability
isn't a requirement for a home media server.

So I have four discs constantly running, using a fair amount of
power.  And I need more space, so the power consumption only goes
up.

I experimented a while with letting the drives spindown (hdparm -S),
but (1) it was obnoxious waiting for all four discs to spinup when I
wanted the data (they spunup in series---good for the power supply,
bad for latency); and (2) I felt that having all four discs spinup
was too much wear and tear on the drives, when, in principle, only
one drive needed to spin up.

I got to thinking, I could just have a bunch of individual drives,
let them all spindown, and when data is needed, only spinup the one
drive that has the data I want.  Less wear and tear overall, lower
overall power consumption, and lower access latency (compared to the
whole RAID spinup).

I know I could do this manually with symlinks.  E.g., have a
directory like /bigstore that contains symlinks into /mnt/drive1,
/mnt/drive2, /mnt/drive3, etc.  And then if one drive dies, the
whole store isn't trashed.  This seems fairly simple, so I wonder if
there's not some automatic way to do it.  Hence, this email.  :)

Thanks for any thoughts or suggestions!
Matt

