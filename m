From: David Rees <drees76@gmail.com>
Subject: Re: Disk IO Slowly Grinds to a (near) Halt
Date: Mon, 9 Feb 2009 15:25:35 -0800
Message-ID: <72dbd3150902091525n516ec5c6i12f3749fd55c47bf@mail.gmail.com>
References: <72dbd3150901152004m2e3d721bwf2cc633361f1fe40@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <72dbd3150901152004m2e3d721bwf2cc633361f1fe40@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jan 15, 2009 at 8:04 PM, David Rees <drees76@gmail.com> wrote:
> I've got a server running Fedora 9 server running kernel
> 2.6.27.9-73.fc9 where inevitably, any sort of IO activity slows down
> significantly.
>
> The machine is a basic Athlon 64 X2 5000+, 3GB RAM and 4 disks
> (2x250GB IDE and 2x1TB SATA) running in two software RAID1 arrays.
>
> One IDE drive is connected to the onboard (Nvidia MCP51 pata_amd), the
> other connected to a Promise (PDC20268 pata_pdc2027x) controller.
>
> Both SATA drivers are connected to the onboard Nvidia MCP51 sata_nv controller.
>
> I suspect that the culprit has something to do with the fact that this
> machine acts as a BackupPC server, and as such, has a filesystem with
> over 7million inodes on it (about 175GB in use on that partition), but
> that's just a hunch.
>
> A simple test to confirm the issue is to drop the caches, and then do
> a directory listing on an empty directory.  Doesn't matter which raid1
> array it's on.  On the normally performing systems I tested this
> typically took 0.15-0.45 seconds.  On this slow system, it takes over
> a second for the same test to run when it's acting up.  After a fresh
> reboot, it takes less than 0.2 seconds.
>
> Any ideas? The only thing that seems to help is rebooting the server.
> Let me know if there is any more information I can provide that would
> be helpful.

Following up to my old message - and CC'ing linux-raid - I found the issue.

The server was suffering again from slow IO today - I also happened to
run a few more tests to try to narrow things down.

I ran some dd raw throughput tests and while write speeds seemed to be
down about 50% slow for one mirror (only ~20MB/s), read speeds of the
individual disks and write speeds of the other mirror were normal.

But any disk IO which required small bursts of activity seemed very slow.

I then realized that I made a mistake in my previous test.  While the
directory listing was slow on both arrays after dropping the caches,
the primary reason it was slow was because of the random IO required
to load the `ls` binary and not the actual directory listing itself.

So this narrowed down the performance issue to the mirror which was
also showing about 1/2 the expected raw write speeds - the /
partition.

I then noticed that there was a raid-check running on the / partition
(which was running about 1/10-1/20th of the expected speed or 1-2MB/s
on a nearly idle system), and then also realized that long smart self
tests were running on those disks, too.  After killing the smart
self-tests the raid check speed jumped to 20MB/s.

So that explains why heavy read/write loads were working OK - they
kept the disks busy enough to keep the raid-check and smart self-tests
from thinking the system was idle and doing their work - and why small
bursts of random IO were slow - a small request would come in and have
to interrupt both the smart self test and the raid recheck.

It seems that the combination of the smart self-test and raid recheck
interact very poorly on this particular mirror though as I don't
recall having similar issues before even though I've used similar
raid-check and smart-test schedules on multiple systems in the past.
At the rate things were going, it'd take the better part of a week to
finish the raid check and longer for the long smart test.  Meanwhile,
the other array had finished both checks in less than 12 hours.

I'm going to try spacing out the start of the raid check and long
smart self-tests more - hopefully ensuring that only one check is
running at a time will avoid the huge slowdowns that are present when
both are running.

I'd be curious to know if anyone else has seen similar very poor
interaction between the two before.  I wonder if there is some sort of
firmware bug on the "slow" array (Seagate ST3250824A) that makes this
worse.

-Dave
