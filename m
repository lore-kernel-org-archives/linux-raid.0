From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: Assertion failure, BUG at journal.c:1732
Date: Sun, 24 Nov 2002 18:42:21 -0500
Sender: ext3-users-admin@redhat.com
Message-ID: <20021124234220.GA17874@think.thunk.org>
References: <Pine.NEB.4.44.0211231926020.11197-100000@iceland.freeshell.org> <Pine.NEB.4.44.0211232017520.8377-200000@iceland.freeshell.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ext3-users-admin@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.NEB.4.44.0211232017520.8377-200000@iceland.freeshell.org>
Errors-To: ext3-users-admin@redhat.com
List-Help: <mailto:ext3-users-request@redhat.com?subject=help>
List-Post: <mailto:ext3-users@redhat.com>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=subscribe>
List-Unsubscribe: <https://listman.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/pipermail/ext3-users/>
To: Jeff Schaller <schaller@freeshell.org>
Cc: sct@redhat.com, akpm@zip.com.au, adilger@clusterfs.com, mingo@redhat.com, neilb@cse.unsw.edu.au, ext3-users@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

These messages tend to indicate that the filesystem is probably
corrupted.  For some reason the kernel is triggering a BUG before
marking the filesystem as containing an error, so fsck isn't being run
on the filesystem.  If you run e2fsck on the filesystem manually,
before it is mounted (or remounted read-write, if it the root
filesystem), it should correct the problem.

I am curious what was the specific form of filesystem corruption which
was triggerring your problem.  If you could save a transcript of the
e2fsck run (say, by running it under the script program, assuming you
have a writeable filesystem available to you when you rune2fsck), I
would be much obliged.

						- Ted

> Nov 20 18:35:39 debian kernel: attempt to access beyond end of device
> Nov 20 18:35:39 debian kernel: 09:00: rw=1, want=39121472, limit=39121408
> Nov 20 18:35:39 debian kernel: attempt to access beyond end of device
> Nov 20 18:35:39 debian kernel: 09:00: rw=1, want=39121476, limit=39121408
> Nov 20 18:35:39 debian kernel: attempt to access beyond end of device
> Nov 20 18:35:39 debian kernel: 09:00: rw=1, want=39121480, limit=39121408
> Nov 20 18:35:39 debian kernel: attempt to access beyond end of device
> Nov 20 18:35:39 debian kernel: 09:00: rw=1, want=39121484, limit=39121408
> Nov 20 18:35:39 debian kernel: attempt to access beyond end of device
> Nov 20 18:35:39 debian kernel: 09:00: rw=1, want=39121488, limit=39121408
> Nov 20 18:35:48 debian kernel: Assertion failure in __journal_remove_journal_head() at journal.c:1732: "buffer_jbd(bh)"
> Nov 20 18:35:48 debian kernel: kernel BUG at journal.c:1732!
> Nov 20 18:35:48 debian kernel: invalid operand: 0000
