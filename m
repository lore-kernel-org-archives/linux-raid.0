From: Keld Simonsen <keld@keldix.com>
Subject: Re: very strange raid10,f2 performance
Date: Sat, 1 May 2010 00:46:42 +0200
Message-ID: <20100430224642.GB7127@rap.rap.dk>
References: <k2mcccedfc61004211002p24f1bd21xdead3e501766553f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <k2mcccedfc61004211002p24f1bd21xdead3e501766553f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Apr 21, 2010 at 12:02:46PM -0500, Jon Nelson wrote:
> I was helping somebody else diagnose some issues, and decided to run
> comparitive tests on my own raid (raid10,f2).
> 
> The raid10,f2 (md0) is the only physical device backing a volume
> group, which is then carved into a bunch of (primarily) ext4
> filesystems.
> The kernel is 2.6.31.12 (openSUSE) on a Quad Processor AMD Phenom 9150e system.
> The raid is two Western Digital Caviar Blue drives (WDC WD5000AAKS-00V1A0).
> 
> The problem: really, really bad I/O performance under certain circumstances.
> 
> When using an internal bitmap and *synchronous* I/O, applications like
> dd report 700-800 kB/s.
> When not using a bitmap at all, and synchronous I/O, dd reports 2.5
> MB/s (but dstat shows 14MB/s?)
> Without a bitmap and async I/O (but with fdatasync) I get 65MB/s.
> *With* a bitmap and using async. I/O (but with fdatasync) I get more
> like 65MB/s.
> 
> The system has 3GB of memory and I'm testing with dd if=/dev/zero
> of=somefile bs=4k count=524288.
> 
> I'm trying to understand why the synchronous I/O is so bad, but even
> so I was hoping for more. 65MB/s seems *reasonable* given the
> raid10,f2 configuration and all of the seeking that such a
> configuration involves (when writing).
> 
> The other very strange thing is that the I/O patterns seem very
> strange. I'll see 14MB/s very consistently as reported by dstat
> (14MB/s for each sda, sdb, and md0) for 10-15 seconds and then I'll
> see it drop, sometimes to just 3 or 4 MB/s, for another 10 seconds,
> and then the pattern repeats.  What's going on here? With absolutely
> no other load on the system, I would have expected to see something
> much more consistent.

Hmm, not much response to this.
The only idea I have for now is misalignment between raid and LVM boundaries.

Were your dd's done on the raw devices, or via a file system?

Best regards
keld
