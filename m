From: Jeff Schaller <schaller@freeshell.org>
Subject: Re: Assertion failure, BUG at journal.c:1732
Date: Mon, 2 Dec 2002 11:15:10 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.NEB.4.44.0212021058460.21200-100000@iceland.freeshell.org>
References: <20021124234220.GA17874@think.thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20021124234220.GA17874@think.thunk.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: sct@redhat.com, akpm@zip.com.au, adilger@clusterfs.com, mingo@redhat.com, neilb@cse.unsw.edu.au, ext3-users@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ted & all,

Here's the typescript; it showed no errors. I did not stop the
raid device before running the fsck; let me know if that would
make a difference.

schaller@debian:~$ sudo e2fsck /dev/hdc
e2fsck 1.27 (8-Mar-2002)
/dev/hdc: clean, 24724/4898816 files, 8018633/9780372 blocks

schaller@debian:~$ sudo e2fsck /dev/hdd
e2fsck 1.27 (8-Mar-2002)
/dev/hdd: clean, 24724/4898816 files, 8018633/9780372 blocks


I then ran "e2fsck -f" on each device:

schaller@debian:~$ sudo e2fsck -f /dev/hdc
e2fsck 1.27 (8-Mar-2002)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/hdc: 24724/4898816 files (21.1% non-contiguous), 8018633/9780372 blocks

schaller@debian:~$ sudo e2fsck -f /dev/hdd
e2fsck 1.27 (8-Mar-2002)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/hdd: 24724/4898816 files (21.1% non-contiguous), 8018633/9780372 blocks

-jeff


On Sun, 24 Nov 2002, Theodore Ts'o wrote:

> These messages tend to indicate that the filesystem is probably
> corrupted.  For some reason the kernel is triggering a BUG
> before marking the filesystem as containing an error, so fsck
> isn't being run on the filesystem.  If you run e2fsck on the
> filesystem manually, before it is mounted (or remounted
> read-write, if it the root filesystem), it should correct the
> problem.
>
> I am curious what was the specific form of filesystem corruption
> which was triggerring your problem.  If you could save a
> transcript of the e2fsck run (say, by running it under the
> script program, assuming you have a writeable filesystem
> available to you when you rune2fsck), I would be much obliged.
>
> 						- Ted
>
> > Nov 20 18:35:39 debian kernel: attempt to access beyond end of device
> > Nov 20 18:35:39 debian kernel: 09:00: rw=1, want=39121472, limit=39121408
> > Nov 20 18:35:39 debian kernel: attempt to access beyond end of device
> > Nov 20 18:35:39 debian kernel: 09:00: rw=1, want=39121476, limit=39121408
> > Nov 20 18:35:39 debian kernel: attempt to access beyond end of device
> > Nov 20 18:35:39 debian kernel: 09:00: rw=1, want=39121480, limit=39121408
> > Nov 20 18:35:39 debian kernel: attempt to access beyond end of device
> > Nov 20 18:35:39 debian kernel: 09:00: rw=1, want=39121484, limit=39121408
> > Nov 20 18:35:39 debian kernel: attempt to access beyond end of device
> > Nov 20 18:35:39 debian kernel: 09:00: rw=1, want=39121488, limit=39121408
> > Nov 20 18:35:48 debian kernel: Assertion failure in __journal_remove_journal_head() at journal.c:1732: "buffer_jbd(bh)"
> > Nov 20 18:35:48 debian kernel: kernel BUG at journal.c:1732!
> > Nov 20 18:35:48 debian kernel: invalid operand: 0000

