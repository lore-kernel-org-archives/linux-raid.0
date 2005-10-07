From: Trevor Cordes <trevor@tecnopolis.ca>
Subject: Re: RAID 6 corruption : please help!
Date: Fri, 7 Oct 2005 13:16:53 -0500 (CDT)
Message-ID: <200510071816.j97IGrlV019508@pog.tecnopolis.ca>
References: <43446D1B.1000105@dtbb.net>
Mime-Version: 1.0
Content-Type: TEXT/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43446D1B.1000105@dtbb.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> What was the bug, and is it maybe something that is reversible.. ?

That's what I had thought until I knew the details of the bug.

Mr. Anvin says:

"No, it's "random"."

"The error was: when a write happened to a stripe that needs
read-modify-write, it wouldn't properly schedule the reads, and would
blindly write out whatever crap happened to be in the stripe cache."

">Do you know where in the code the bug was?  If I can only discover
>exactly what it did I could write a program to try to clean it up?"

"No, it's timing-dependent and, in either case, involve writing non-data
to the disks."

On  6 Oct, Molle Bestefich wrote:
> What's stopping you from just pulling out the two new disks, mounting
> the array using the old, almost OK disks, and fsck'ing your way out of
> the couple of files that were corrupted when you were in rw mode?

That's kind of what I thought, but I had written to the disks and for
each write lots of the entire stripe (in many cases) would get wiped out
with random data.

In the end, I ran fsck -y on it and crossed my fingers.  That recovered
nearly 8/10ths of the data before it hit some fsck bug (dies on signal
11).  The rest of the data I had 1 month old backups, so it actually
turned out pretty good.  I'm certainly going to increase my backup
frequency to weekly or twice weekly from now on -- even on a RAID6 setup
that I was *really* trusting to protect my 2TB.

Moral of the story is NEVER mount your RAID array until you update to AT
LEAST the same kernel version you were running prior!

