From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: >16TB RAID0
Date: Fri, 17 Jul 2009 17:39:12 -0500
Message-ID: <20090717223912025.ZZHZ5000@cdptpa-omta04.mail.rr.com>
References: <88b4380a1bcd5fd15556fd1d4454565a.squirrel@neil.brown.name>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <88b4380a1bcd5fd15556fd1d4454565a.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I'm not 100% sure, but a quick look at the code suggests that
> 16TB is the upper limit for normal read/write operations on
> a block device like /dev/md0 on a 32bit host.  This is because it uses
> the page cache, and that uses 4K pages with a 32bit index, hence
> 16TB.

	Uh-oh!  I hope this doesn't apply to a 64 bit host running
2.6.26-2-amd64, or is it a limitation of md?  In fairly short order (a year,
maybe), I'm going to need to go beyond 16T employing RAID6 on some number
more than eight 3T drives.  I know a lot can happen in a year, but when it
comes to upgrading code, sometimes a lot doesn't happen, either.

> A filesystem using a 16TB device would not be limited in the same way
> as it caches individual files, not the whole device (individual files
> would still be limited to 16TB).
> I think if you access the block device with O_DIRECT you might be
> able to bypass the 16TB barrier.  Try hacking the program
> to add O_DIRECT to the open mode.

	I'm running XFS, but perhaps I could get the developers to put in a
switch for this, if need be.

