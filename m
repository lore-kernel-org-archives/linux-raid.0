From: Sebastian Kuzminsky <seb.kuzminsky@gmail.com>
Subject: did I just destroy my data?
Date: Tue, 27 Sep 2005 01:02:42 -0600
Message-ID: <7f55de7205092700022e1650aa@mail.gmail.com>
Reply-To: Sebastian Kuzminsky <seb.kuzminsky@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I need your help folks.  :-/

I'm running 2.6.13.1 and mdadm 1.9.0.  I have (had) four SATA drives
in a RAID5 - Maxtor 6B300S0 drives on an Intel D915GEVLK motherboard
(ICH6), with ext3.  Everything was running great for months and
months, until this weekend when three of the four drives developed bad
sectors within a few days of each other.  (I suspect a bad power
supply and fan, with subsequent overheating.  I've replaced the power
supply and added more case fans, about a day late.)

I'll spare you the detailed logs (unless you want them), but basically
what happened was this:

Disk 2 failed ("Medium Error" - "Unrecovered read error - auto
reallocate failed").

Array keeps running in degraded mode with disks 0, 1, and 3.

Fine, I pulled disk 2 and started looking for another just like it to buy.

Then disk 0 failed, same error.  The array went down.

I ran badblocks on the three remaining disks.  Disks 0 and 3 each had
a handful of bad blocks (< 150 each), disk 1 was fine.

I ran "mdadm --assemble --force /dev/md0 /dev/sd{a,b,c}".  It came up
fine.  "fsck -f /dev/md0" also ran fine.  Copied off the most
important stuff, but geez, I just dont have the facilities to back up
a terabyte.

Ok, so far so good right?  Tread lightly, get 3 new disks asap, and
it'll probably be ok.

I should have gone to sleep at this point, but instead I went and
monkeyed with it.  I thought, it's running degraded with two flaky
disks, wouldnt it be better to put disk 2 (the one that failed first
and I pulled it) back in while waiting for the replacement disks to
get here?  Surely three flaky disks are better than two...

So I plugged disk 2 back in and ran badblocks on it, found a bunch,
about like on disks 0 and 3.  Ran "mdadm /dev/md0 --add /dev/sdc" and
it started to resync (is that the proper term?) onto it.

So far so good, but then I had the briliant idea of running "fsck -cf"
on the array, before the resync finished.  It hit the bad blocks on
disk 3 and failed disk 3.  The array now has two active disks (0 and
1), one half-resynced disk (2) and one failed disk (3).  Now, to
really cap my evening off, I ran "mdadm /dev/md0 --add /dev/sdd". 
This added disk 3 back in as a spare.  I should have probably rerun
the "mdadm -A --force".  Sigh.

So now I've got two active disks (0 and 1) and two spares (2 and 3). 
The array is completely unreachable.

Please, cluebat me.  How do I unhork my raid now?  Is it even possible?

--
Sebastian Kuzminsky
