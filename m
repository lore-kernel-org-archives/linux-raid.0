From: Mario Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Questions regarding readonly/readwrite semantics
Date: Tue, 22 Mar 2005 22:07:59 +0100
Message-ID: <d1q1b3$5j0$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

in the beginning I had just one simple question :) ...
Is there any way to start RAIDs in readonly mode while autodetection
on system boot?

I was thinking about some 2-stage boot mimic that first enables all
RAIDs readonly (while autodetection for example) and then in a second
stage sets them to readwrite (in a early init script for example).
Such a mimic could provide a chance to system administrators for
intervention before automatic resync or such things would take place
(by booting up in emergency mode for example).

Since I found no solution to tell the autodetection to start up RAIDs
in readonly mode, I was thinking about kicking autodetection at all
and starting up RAIDs via mdadm or something like that. However, when
looking at man mdadm it seems to me that it is impossible there too,
to start RAIDs in readonly mode (since --readonly and --readwrite are
defined in Misc mode only, while I would need them in Assemble mode,
wouldn't I?). So my second question came up :) ...
Is there any way to start RAIDs in readonly mode at all?

And then while looking at --readonly and --readwrite semantics, some
more questions came up :) ...

I was trying in emergency mode with two RAID1: md0 and md4.
md0: initially readwrite mounted / ro
md4: initially readwrite not mounted
I'm running 2.4.27 built from Debian's kernel-source-2.4.27.
I'm booting with ro in kernel commandline, so root device is mounted
readonly initially.

# mdadm --readonly /dev/md0
failed to set readonly: EBUSY

This is somehow understandable. However, it would be nice to have a
way to force it. Furthermore, since the device is (should be?) opened
readonly, it should be possible to set it readonly, too.

# mdadm --readwrite /dev/md0
failed to set writable: EBUSY

Huh, why does that fail? It *is* writable already!

# mdadm --readonly /dev/md4

Works. Of course.

# mount -o ro /dev/md4 /usr
# mdadm --readwrite /dev/md4

Works. Why does it work? If setting an already readwrite device to
readwrite fails, *this* one should fail more than ever!

# mdadm --readonly /dev/md4
failed to set readonly: EBUSY

Expected. However, since this device *must* be opened readonly (since
it *was* readonly at mount time), it should definitely be possible to
set it back to readonly.

Well, the whole readonly/readwrite semantics seem somehow inconsistent
to me. Setting a mounted and already readwrite device to readwrite
fails, while setting a mounted but readonly device to readwrite works.

And a last question came up then, too:

blockdev --setro /dev/md0
md: blockdev(pid 3446) used obsolete MD ioctl, upgrade your software to use new ictls.
BLKROSET: Invalid argument

Is there any objective, why md does not support the standard block
device readonly/readwrite ioctls?


regards
   Mario
-- 
Independence Day: Fortunately, the alien computer operating system works just
fine with the laptop. This proves an important point which Apple enthusiasts
have known for years. While the evil empire of Microsoft may dominate the
computers of Earth people, more advanced life forms clearly prefer Mac's.

