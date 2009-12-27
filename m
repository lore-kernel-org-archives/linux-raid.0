From: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Subject: 99-raid-check (was: raid5: cannot start dirty degraded array)
Date: Sun, 27 Dec 2009 13:57:38 +0100
Message-ID: <13610270181.20091227135738@kaneda.iguw.tuwien.ac.at>
References: <579884013.20091223125023@kaneda.iguw.tuwien.ac.at>
 <512145787.20091223180308@kaneda.iguw.tuwien.ac.at>
 <alpine.DEB.2.00.0912231322060.18793@p34.internal.lan>
 <200912240940.40713.tfjellstrom@shaw.ca>
Reply-To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200912240940.40713.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

addendum:

after backing up data for 30 hours off the degraded array, replacing
sda and after another 50 hours resync the raid5 was healthy again. for
about 8 hours when again it was syncing.

and then I discovered at least a small part of the mystery:

centos 5 runs a script /etc/cron.weekly/99-raid-check (once a week of
course) which (since a few months) triggers a re-sync of the array
(which then runs for another 50 hours at a system load of around 8.0).

I always noticed that it resynced without a drive marked "faulty" in
/proc/mdstat, but I never really took it seriously. And being away so
often I never realized that it always started at sunday 4:20 in the
night.
rebooting during the resync stops it and the system behaves normally
again.

If I interpret the text in /etc/sysconfig/raid-check correctly, I'd
better leave 99-raid-check running (for 50 hours ... :-( ), check
the value of /sys/block/md0/md/mismatch_cnt and if it contains other
than 0, I'd better get worried?

and, catching up with a previous suggestion in this thread: is it safe
to run a smrtctl long selftest on each disk while the raid is mounted
& active? long selftest is supposed to take about 4 hours (per disk).

tnx & cu

