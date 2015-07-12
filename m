From: Edward Kuns <eddie.kuns@gmail.com>
Subject: Re: mdadm-grow-continue service crashing (similiar to "raid5 reshape
 is stuck" thread from May)
Date: Sun, 12 Jul 2015 14:24:50 -0500
Message-ID: <CACsGCyT5vgFkQEc1zgKCGgT_rO5V4cmuFmo9K4vwiqN4JsPLJA@mail.gmail.com>
References: <CACsGCySTbrEYddSNfi7+9KnxWeddkBGDbxTsBSJkkvGHOaJwKg@mail.gmail.com>
	<55A26F65.5020703@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55A26F65.5020703@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jul 12, 2015 at 8:45 AM, Phil Turmel <philip@turmel.org> wrote:
> Why were you using --grow for these operations only to reverse it?  This
> is dangerous if you have a layer or filesystem on your array that
> doesn't support shrinking.  None of the --grow operations were necessary
> in this sequence to achieve the end result of replacing disks.
[snip]
> At no point should you have changed the number of raid devices.
[snip]
> And for the still-running but suspect drive, the --replace operation
> would have been the right choice, again, after --add of a spare.

I didn't mention the steps I did to replace the failed drive because
that went flawlessly.  I did a fail and remove on it to be sure, but
got complaints that it was already failed/removed.  When I did an add
for the replacement drive, it came in and synced automatically.  I
only ran into trouble trying to replace the "not yet dead but suspect"
drive.  I was following examples on the Internet.  The example I was
following was a clearly a bad one.  The examples I found didn't
suggest the --replace option.  This is ultimately my fault for not
being familiar enough with this.  Now I know better.

FWIW, I had LVM on top of the raid5, with two partitions (/var and an
extra storage one) on the LVM.  (I think there is some spare space
too.)  The goal, of course, is being able to survive any single-drive
failure, which I did.

You said this is dangerous.  I went from 4->5 and then immediately
5->4 drives.  I didn't expand the LVM on the raid5, and the
replacement partition was a little bigger than the original.  Next
time, I'll use --replace, obviously.  I just want to understand why it
is dangerous.  As long as the replacement partition is as big as the
one it is replacing, isn't this just extra work, and more chance of
running into problems like the one I ran into?  But other than that,
it shouldn't risk the actual data stored on the RAID,should it?

> many modern distros delete /tmp on reboot and/or play
> games with namespaces to isolate different users' /tmp spaces.

So if the machine crashes during a rebuild, you may lose that backup
file, depending on the distro.  OK.  Is there a better solution to
this?  Unfortunately, at the time of the failure to shrink, the
rebuild that failed to start, stdout and stderr were not going to
/var/log/messages, so I have no idea what the complaint was at that
time.  Does this service send so much output to stdout/stderr that
it's useful to suppress it?  If I'd seen something in
/var/log/messages, it would have been more clear that there was a
service with a complaint that was the cause of the rebuild failing to
start.  I wouldn't have done as much thrashing trying to figure out
why.

> These are the only operations you should have done in the first place.
> Although I would have put the --add first, so the --fail operation would
> have triggered a rebuild onto the spare right away.

I did the fail/remove/add at the very end, after replacing the dead
drive, after finally completing the "don't do it this way again"
grow-to-5-then-shrink-to-4 process to replace the not-yet-dead drive.
After the shrink finally completed, the new 4th drive showed as a
spare and removed at the same time.  i.e., this dump from my first
EMail:

    Number   Major   Minor   RaidDevice State
       0       8        2        0    active sync   /dev/sda2
       1       8       17        1    active sync   /dev/sdb1
       5       8       33        2    active sync   /dev/sdc1
       6       0        0        6    removed

       6       8       49        -    spare   /dev/sdd1

Doing a fail, then remove, then add on that 4th partition (sdd1)
brought it back and it very quickly synced.  I did a forced fsck on
both partitions to be sure, and both were clean.

       Thanks

              Eddie
