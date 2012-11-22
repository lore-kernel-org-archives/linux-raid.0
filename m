From: "George Spelvin" <linux@horizon.com>
Subject: Re: want-replacement got stuck?
Date: 21 Nov 2012 22:25:04 -0500
Message-ID: <20121122032504.12679.qmail@science.horizon.com>
References: <20121121211910.22223.qmail@science.horizon.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121121211910.22223.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: joystick@shiftmail.org, linux-raid@vger.kernel.org, linux@horizon.com
List-Id: linux-raid.ids

Some more information...

From the "stuck" state, I rebooted the machine.  It came up with 

md5 : active raid10 sde2[2] sdd2[3] sda2[0] sdb2[1]
      725591552 blocks 256K chunks 2 near-copies [4/4] [UUUU]
      bitmap: 172/173 pages [688KB], 2048KB chunk

and e2fsck found severe problems, like multiply-referenced blocks.

I compared sdd2 and sde2 with cmp, and it found tons of
differences.  So I knew what the problem was.  All I havd to do
was pick the right one to fail.

Fortunately, I had the last RAID config on the screen of the
machine I had sshed in from, and decided I truested sdd2 less,
so failed it.

After flushing the device cache (hdparm -f /dev/md5), the errors
went away!  I was left with only what the original e2fsck -p had done
before halting.  (Namely. some updates to i_blocks).

Now I've zeroed sdd2's uperblock and added it back, and things seem
to be working okay.


NeilBrown <neilb@suse.de> wrote:
> Yes.... this is a real worry.  Fortunately I know what is causing it.

Yay!  Tell me when you have a patch to test.

> Meanwhile you have a corrupted filesystem.  Sorry.
> The nature of the corruption is that since the replacement finished
> no writes have gone to slot-3 at all.  So if md ever devices to read
> from slot 3 it will get stale data.

That's sort of what the pattern of errors looked like.

> I suggest you fail the sdd2, reboot, make sure one sda2, sb2, sde2 are
> in the array, run fsck, and then if it seems happy enough, add sdc2
> and/or sdd2 back in so they rebuild completely.

I did this in a sort of bass-ackward way, but I accomplished it in
the end.  And no data loss.  Yippee!

> Thanks for helping to make md better by risking your data :-)
I'm just glad I suffered less damage than my recent ext4 resizing
experiments, which were.... not completely successful.


Anyway, thanks for the help, and all the hard work.
