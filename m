From: Ian Young <ian@duffrecords.com>
Subject: I will pay money for the correct RAID recovery instructions
Date: Thu, 16 Oct 2014 12:59:18 -0700
Message-ID: <CANs+QMz3jNpAneHLzN5c=EtK+RAOhQJZy=n3P0oYTRm7yNDzjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've been trying to fix a degraded array for a couple of months now
and it's getting frustrating enough that I'm willing to put a bounty
on the correct solution.  The array can start in a degraded state and
the data is accessible, so I know this is possible to fix.  Any
takers?  I'll bet someone could use some beer money or a contribution
to their web hosting costs.

Here's how the system is set up:  There are (6) 3 TB drives.  Each
drive has a BIOS boot partition.  The rest of the space on each drive
is a large GPT partition that is combined in a RAID 10 array.  On top
of the array there are four LVM volumes: /boot, /root, swap, and /srv.

Here's the problem:  /dev/sdf failed.  I replaced it but as it was
resyncing, read errors on /dev/sde kicked the new sdf out and made it
a spare.  The array is now in a precarious degraded state.  All it
would take for the entire array to fail is for /dev/sde to fail, and
it's already showing signs that it will.  I have tried forcing the
array to assemble using /dev/sd[abcde]2 and then forcing it to add
/dev/sdf2.  That still adds sdf2 as a spare.  I've tried "echo check >
/sys/block/md0/md/sync_action" but that finishes immediately and
changes nothing.

Can anyone solve this?  I'd be happy to pay you for your knowledge.
