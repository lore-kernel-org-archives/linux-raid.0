From: "Lelsie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Sat, 4 Apr 2009 19:07:26 -0500
Message-ID: <20090405000728.GGPW19140.cdptpa-omta03.mail.rr.com@Leslie>
References: <49D7C19C.2050308@gmail.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49D7C19C.2050308@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> If one of your disks was clearing bad sectors then things get messy
> and when it hits one of these bad sectors that it can successfully
> move you would get a delay almost every time.

Yes, but in that case two things would be true:

1.  Any write of any sort could readily trigger an event.  The system quite
regularly writes more than 5000 sectors / second, but never do any of these
writes trigger an event except in the case where it is a file creation.
Like I said, the drives have no idea whether the sector they are attempting
to write is a new file or not, or part of a directory structure or not.

2.  The kernel would be reporting SMART errors.  It isn't.

Finally, as you said yourself, the situation would result in a delay almost
every time, yet there are signifcant stretches of time when every single
file creation works just fine.  Also, it doesn't take a drive 40 seconds,
let alone 2 minutes, to mark a sector bad.  The array chassis I had
previously had some sort of problem which made the drives think there were
bad sectors, when there weren't.  It cause one drive to be marked with more
than a million bad sectors.  It never paused like this, however.

