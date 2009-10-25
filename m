From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Is My Data DESTROYED?!
Date: Sun, 25 Oct 2009 08:06:17 -0500
Message-ID: <20091025130621266.UKNB17264@cdptpa-omta04.mail.rr.com>
References: <200910242326.07365.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200910242326.07365.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Wouldn't you use some 'tar' like format on the tape so there's a file
> index

	Not "tar like".  Tar.  "Tar" stands for "tape archive".  Without the
-f option, tar will write to the location specified by the TAPE environment
variable (or stdout if the variable is not set).  Of course there are other
utilities which can be used, such as cpio and fbackup, and I am sure some
drives may have their own utilities.

> you can search without having to scan the entire tape? Then you can just
> "ffwd" (seek) to the position. _should_ be lots faster than reading all of
> the
> data from the beginning to the files location trying to find it. Or maybe
> there's something I'm missing about tapes?

	Many tape drives cannot seek any faster than they can read.  After
all, a seek *IS* a read.  Even if a particular drive can seek faster than it
can read, however, it will still take a significant amount of time to seek
to the location and read the data.  How quickly depends on the drive, but
under no circumstances will it be milliseconds, or even single-digit
seconds.  High end tape drives of course are much faster than lower cost
tape drives.  In the realm of what is within the budget of a consumer
system, don't hold your breath waiting for the drive to find the data.

