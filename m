From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: Re: Raid1 doesn't balance under high load [patch]
Date: Thu, 10 Jun 2004 16:42:06 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040610144206.GA16625@cistron.nl>
References: <20040610113019.GA8660@cistron.nl> <000c01c44ef0$195820a0$0201a8c0@windows>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <000c01c44ef0$195820a0$0201a8c0@windows>
To: TJ Harrell <systemloc@earthlink.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

According to TJ Harrell:
> I don't know the details of how writing works in the code. I do know that
> consecutive writes must be issued to both disks, though. This means that
> there is a concievable time when one disk is written to and one is not,
> making the array unclean. I'm assuming that this is the reason that the
> array is marked unclean during a write. If you disable this, I would bet
> that it will create a race condition where you may read from a disk before
> it is written to and get old data. This would probably cause data
> corruption, no?

Not when going through the buffer/page cache, which acts as a syncpoint.
If you write a page to disk, it is first put in the pagecache as
"dirty" page. Once the write is complete (meaning both disks have
written it) the page is marked as clean.

If some other process wants to read the same data from disk, it
will go through the buffer/page cache and get the data from the
(dirty or in the mean time clean) page that is there already.
It won't go behind the buffer/pagecache's back to read the data
straight from disk ...

Think about it - all writes to disk-like devices are queued, so if
this didn't happen you'd have that problem all the time.

So the code in there isn't about preventing that at all. It is
really checking for 'is there a rebuild in progress' but it simply
gets that wrong ..

Mike.
