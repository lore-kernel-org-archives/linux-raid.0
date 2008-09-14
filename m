From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: Expandable raid
Date: Sun, 14 Sep 2008 12:16:43 +0100
Message-ID: <18636.62107.274386.224236@tree.ty.sabi.co.uk>
References: <48CBDC40.1010505@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48CBDC40.1010505@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> I am setting up a system with five drives. Initially two will
> be for the system and three for other uses. In about 4-6 weeks
> the three will be added to the original two.

What does "added" mean here? Physically? Logically? If logically,
in what way? And what's the starting point?  If you start with 5
drives, why configure them initially as 2 arrays, and then merge
later into 1 array? The exact array shapes involved matter.

> Thoughts on picking a raid config to make this easy? I would
> like to use raid-10, but I don't see a way to grow it.

What's "this"? Do you want to end up with a 5-drive array? If
so, where are you going to put the boot filesystem (most BIOSes
require single drive boot filesystems) unless it is a 5 drive
RAID1? In which case, growing is easy :-).

More generally, my usual story: growing an array is a dangerous
and slow operation. Backup and restore is usually a lot faster,
results in a better physical to logical layout, and safer (and
one should backup anyhow before growing).

BTW I was just looking at his home page for other reasons (NFSv4)
and noticed this:

  http://neil.brown.name/hg

    "LaFS Log Structured File system for Linux - VERY alpha
     Neil Brown 7 weeks ago RSS".
