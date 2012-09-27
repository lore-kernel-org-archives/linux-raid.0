From: Jake Thomas <thomasj10@georgefox.edu>
Subject: Re: Device Unusable At Startup
Date: Thu, 27 Sep 2012 19:47:56 -0400
Message-ID: <CACO8vipp6mWQCY-cWhSbty=XNKFoxc_q_ntv-0C+dKsRD8DEWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry for the lateness of this note, but I've been rather busy at
school (and still am).

Although in my previous post, I did say I got the array working (not
as /usr, but rather at a non-system-critical mount point),
and also working whilst mounted at /usr,

I cannot unmount it if it is mounted as /usr (and thus couldn't stop
it), because /usr is in use (duh). Not even if I put it late in a
shutdown script.
Therefore, due to the bug, it gets corrupted on shutdown.

When it wasn't at /usr, I could stop the device before shutdown,
keeping it from being corrupted.

When it was mounted at /usr, there was nothing I could do to stop it
from being corrupted at shutdown, though I did get it
working before I shutdown.

To get into it again, I specify the break=premount kernel parameter
and forcably reassemble the array and fsck the
filesystem on it from the premount commandline.

Then I exit the premount commandline, and it boots on its merry way.



To automate this, I made a custom hook:

"P.P.S. Sorry it took so long for this note. I've been (and still am)
rather busy at school. Due to the current mdadm bug, I found it
nessecary to make a custom hook that assembles and fs checks the raid
array, premount.
The problem is that the array gets broken on shutdown due to a bug in
mdadm. Therefore /usr can't get mounted on startup, unless you boot
into a Live environment or something and fix the raid array in there
(or just specify the break=premount kernel parameter and fix from the
premount commandline).
This wouldn't happen if the array is stopped before shutdown (and
/sbin/mdadm is moved to /sbin/mdadm.moved), but since /usr is in use
till the very end, it can't be stopped. So it gets broke every
shutdown.

Fortunately, a custom hook (which you add to mkinitcpio.conf, and then
re-make the initial ramdisk with) can automate the forced assembly and
fs checking of the array, all premount. So it breaks on shutdown, and
fixes itself on startup.

I followed the Arch Wiki's howto for making custom hooks. But here's
the quick-and-clean solution:

I put this in a file named "mdusr_fixer" in the
/usr/lib/initcpio/install folder:

[code]
#!/bin/bash

build()
{
	#mdadm binary already added by other stuff
	add_runscript
}

help ()
{
	cat <<HELPOF
Fixes borked md array holding /usr. On shutdown, the
md array holding my /usr filesystem gets broke, due
to a bug in mdadm. If the array was stopped before
shutdown, it wouldn't get broke. But it can't be
stopped. So I'm fixinig it on startup, premount.
HELPOF
}
[/code]

And this into a file named "mdusr_fixer" in the /usr/lib/initcpio/hooks folder:

[code]
#! /usr/bin/ash

run_hook ()
{
	msg -n ":: About to fix broke md array holding /usr"

	msg -n ":: Stopping all md devices. Sorry, it must be done."

	msg -n ":: It's the only way I can stop the broke md array, which I
have to do to fix it."

	msg -n ":: You'll have to manually start any non-/usr md devices, or
script them elsewhere."

	mdadm --stop /dev/md*

	mdadm --assemble --run /dev/md0 /dev/disk/by-id/ata-ST31500341AS_9VS51LLD-part2

	fsck -f /dev/md0

	msg -n ":: Done fixing /usr md device."
}
[/code]

Before we can re-assemble the broken array, we must stop it.

Note that all md devices must be stopped using a wildcard: "/dev/md*"
because we technically don't know
for sure what the name of the md device is that holds /usr. It could
be /dev/md127, /dev/md126, /dev/md125
or whatever. We simply don't know. If it's the only md device present,
it will, with almost 100% certainty, be /dev/md127,
but what if someone plugs in USB drives that have mdraid before you
turn the computer on? Now we really don't know.
Or, more likely, if you have more than one md raid array amongst your
internal hard drives, we wouldn't know the name of the one we must
stop to reassemble.

Unfortunately, /dev/disk/by-uuid is not populated for this md device,
because it is currently broke. So we can't specify it by uuid
or anything. A system-wide stopping of all md devices (/dev/md*) must
be done to stop it.

Now to assemble it, we must specify the partition that holds half the
raid1 array. How? Not simply by saying /dev/sda2.
That can change from boot-to-boot. So the next best thing is to
specify by uuid (/dev/disk/by-uuid/[blah blah blah]).
But unfortunately, /dev/disk/by-uuid is not populated for
linux_raid_member formatted partitions, (the partition itself, not the
filesystem it contains).

So we have to resort to /dev/disk/by-id/[hardware-based name of hard
drive, hyphen, "part", partition number].
And that works great!

Now run fsck on the md device you just reassembled. This can be
refered to as /dev/md0, rather than by some jumble-proof reference,
because we just explicitly named it /dev/md0.

And, of course, I added mdusr_fixer to the HOOKS line in
mkinitcpio.conf, and re-made the the initial ramdisk with mkinitcpio."

From: http://bbs.archbang.org/viewtopic.php?pid=17316#p17316 .

Cheers,
Jake
