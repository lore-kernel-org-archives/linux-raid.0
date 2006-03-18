From: "Ewan Grantham" <ewan.grantham@gmail.com>
Subject: ex2fsck showing MANY errors on degraded RAID - out of luck?
Date: Sat, 18 Mar 2006 09:41:21 -0600
Message-ID: <6d5bedd80603180741s6b19ed53x929093fdac803d99@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

OK, managed to use assemble force to get the five remaining drives of
the array up in degraded mode. But running ex2fsck (I had an ext3 fs
on the RAID) is revealing a number of bad dtimes and invalid blocks.
Trying to run ex2fsck with the -p option doesn't work for long, and
having to hit enter after each line is testing my patience.

So, am I likely to have any good data by the time I finish anyway, or
am I wasting my time? Any quicker way to cleanup the filesystem to
find out?

TIA,
Ewan
