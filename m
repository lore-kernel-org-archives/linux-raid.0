From: Phil Turmel <philip@turmel.org>
Subject: Re: mdadm-grow-continue service crashing (similiar to "raid5 reshape
 is stuck" thread from May)
Date: Mon, 13 Jul 2015 09:54:23 -0400
Message-ID: <55A3C30F.404@turmel.org>
References: <CACsGCySTbrEYddSNfi7+9KnxWeddkBGDbxTsBSJkkvGHOaJwKg@mail.gmail.com>
 <55A26F65.5020703@turmel.org>
 <CACsGCyT5vgFkQEc1zgKCGgT_rO5V4cmuFmo9K4vwiqN4JsPLJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACsGCyT5vgFkQEc1zgKCGgT_rO5V4cmuFmo9K4vwiqN4JsPLJA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Edward Kuns <eddie.kuns@gmail.com>
Cc: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hi Eddie,

On 07/12/2015 03:24 PM, Edward Kuns wrote:
> On Sun, Jul 12, 2015 at 8:45 AM, Phil Turmel <philip@turmel.org> wrote:
>> Why were you using --grow for these operations only to reverse it?  This
>> is dangerous if you have a layer or filesystem on your array that
>> doesn't support shrinking.  None of the --grow operations were necessary
>> in this sequence to achieve the end result of replacing disks.
> [snip]
>> At no point should you have changed the number of raid devices.
> [snip]
>> And for the still-running but suspect drive, the --replace operation
>> would have been the right choice, again, after --add of a spare.
> 
> I didn't mention the steps I did to replace the failed drive because
> that went flawlessly.  I did a fail and remove on it to be sure, but
> got complaints that it was already failed/removed.  When I did an add
> for the replacement drive, it came in and synced automatically.  I
> only ran into trouble trying to replace the "not yet dead but suspect"
> drive.  I was following examples on the Internet.  The example I was
> following was a clearly a bad one.  The examples I found didn't
> suggest the --replace option.  This is ultimately my fault for not
> being familiar enough with this.  Now I know better.

Even without the --replace operation, --grow should never have been
used.  On older kernels without support for --replace, the correct
operation is --add spare then --fail, --remove.

> FWIW, I had LVM on top of the raid5, with two partitions (/var and an
> extra storage one) on the LVM.  (I think there is some spare space
> too.)  The goal, of course, is being able to survive any single-drive
> failure, which I did.
> 
> You said this is dangerous.  I went from 4->5 and then immediately
> 5->4 drives.  I didn't expand the LVM on the raid5, and the
> replacement partition was a little bigger than the original.  Next
> time, I'll use --replace, obviously.  I just want to understand why it
> is dangerous.  As long as the replacement partition is as big as the
> one it is replacing, isn't this just extra work, and more chance of
> running into problems like the one I ran into?  But other than that,
> it shouldn't risk the actual data stored on the RAID,should it?

In theory, no.  But the --grow operation has to move virtually every
data block to a new location, and in your case, then back to its
original location.  Lots of unnecessary data movement that has a low but
non-zero error-rate.

Also, the complex operations in --grow have produced somewhat more than
its fair share of mdadm bugs.  Stuck reshapes are usually recoverable,
but typically only with assistance from this list.  Drive failures
during reshapes can be particularly sticky, especially when the failure
is of the device holding a critical section backup.

>> many modern distros delete /tmp on reboot and/or play
>> games with namespaces to isolate different users' /tmp spaces.
> 
> So if the machine crashes during a rebuild, you may lose that backup
> file, depending on the distro.  OK.  Is there a better solution to
> this?  Unfortunately, at the time of the failure to shrink, the
> rebuild that failed to start, stdout and stderr were not going to
> /var/log/messages, so I have no idea what the complaint was at that
> time.  Does this service send so much output to stdout/stderr that
> it's useful to suppress it?  If I'd seen something in
> /var/log/messages, it would have been more clear that there was a
> service with a complaint that was the cause of the rebuild failing to
> start.  I wouldn't have done as much thrashing trying to figure out
> why.

I don't use systemd so can't advise on this.  Without systemd, mdadm
just runs mdmon in the background and it all just works.

>> These are the only operations you should have done in the first place.
>> Although I would have put the --add first, so the --fail operation would
>> have triggered a rebuild onto the spare right away.
> 
> I did the fail/remove/add at the very end, after replacing the dead
> drive, after finally completing the "don't do it this way again"
> grow-to-5-then-shrink-to-4 process to replace the not-yet-dead drive.
> After the shrink finally completed, the new 4th drive showed as a
> spare and removed at the same time.  i.e., this dump from my first

Growing and shrinking didn't do anything to replace your suspect drive.
 It just moved the data blocks around on your other drives, all while
not redundant.

> EMail:
> 
>     Number   Major   Minor   RaidDevice State
>        0       8        2        0    active sync   /dev/sda2
>        1       8       17        1    active sync   /dev/sdb1
>        5       8       33        2    active sync   /dev/sdc1
>        6       0        0        6    removed
> 
>        6       8       49        -    spare   /dev/sdd1

It seems there is a corner case where at completion of shrink where one
device becomes a spare, the new spare doesn't trigger the recovery code
to pull it into service.

Probably never noticed because reshaping a degraded array is *uncommon*.
 :-)

This one is for Neil, I think...

Phil
