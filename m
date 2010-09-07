From: "George Spelvin" <linux@horizon.com>
Subject: Re: 3-way mirrors
Date: 7 Sep 2010 15:02:55 -0400
Message-ID: <20100907190255.15094.qmail@science.horizon.com>
References: <AANLkTikUt3wrpqxOX+j+3-KRKLhk4YGLvCrKxo3MAeRM@mail.gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikUt3wrpqxOX+j+3-KRKLhk4YGLvCrKxo3MAeRM@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux@horizon.com, Simetrical+list@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> This might be useful reading:
> 
> http://neil.brown.name/blog/20100211050355

An interesting point of view, BUT...

If I am seeing repeated unexplained mismatches (despite being on a good
UPS and having no unclean shutdowns), then some part of my hardware is
failing, and I'd like to know *what part*.

Even if it doesn't halp me get the current data sector back, if I see
that drive #2 keeps having one opinion on the contents of a block while
drives #1 and #3 have a different opinion, then it's a useful piece of
diagnostic information.

It certainly is true that, if my file system doesn't change too fast, I
can pull the mismatching sector out of the logs and do a manual compare
using dd.  But it's a lot nicer to avoid race conditions by placing the
code inside md.

As for an option to read the whole stripe and check it, actually you
only need to read 2 copies.  If they agree, all is well.  If they don't,
recovery is required.


The arguments about blocks magically changing under the file system
don't really hold water as long as RAID-1 distributes reads across the
component drives.  As long as that is the case, a mismatch can result in
a silent change.  A true fix (in the absence of a higher-level checksum
to validate the data) requires multiple reads.


As for unclean shutdowns, I expect that the RAID code holds off barriers
until all copies are written, so I still expect that a majority vote
will produce a consistent file system.

Thank you for the pointer!
