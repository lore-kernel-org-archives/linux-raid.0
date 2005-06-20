From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: when does it become faulty disk
Date: Mon, 20 Jun 2005 09:55:52 +0200
Message-ID: <62b0912f05062000557bd05348@mail.gmail.com>
References: <5d96567b05061804477325d743@mail.gmail.com>
	 <62b0912f05061912103ad3c459@mail.gmail.com>
	 <1119249803.3094.8.camel@raz-laptop>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1119249803.3094.8.camel@raz-laptop>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: raz ben jehuda <razb@bitband.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

raz ben jehuda wrote:
> So, what about write errors ?
> from what you are saying i understand that when a write error occurs
> the disk is faulty.

Yes..  If you are serious about your data redundancy, yes.

A sector _read_ error is a notification from the disk that a sector
has gone bad and that some particular data is lost.

A sector _write_ error is the disk telling you that:
 1. The sector has gone bad.
 2. The disk failed to relocate the sector to the spare area, probably
because it's full.

The above are slight simplifications, since other kinds of read and
write errors may in very rare cases occur.  That's OK though, since
you DO want sick disks with strange internal errors that are causing
read or write errors to get kicked.

In rare cases a disk could get sick in a way where writes to a bad
sector succeeds but subsequent reads fail.  Never seen it happen...
But just in case, you might want to re-read a failed sector after you
have written to it, just to check that the disk actually correctly
relocated it.

Once a disk has been kicked, you may want to instruct the user to
check that the disk's spare sector count has indeed reached 0, by
using smartctl -a /dev/xxx.  That command will also tell of other disk
failures.
