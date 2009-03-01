From: Daniel Pittman <daniel@rimspace.net>
Subject: MD software RAID1 vs suspend-to-disk
Date: Sun, 01 Mar 2009 19:52:46 +1100
Message-ID: <87d4d17hgh.fsf@rimspace.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

G'day.

I have a random desktop machine here, running Debian/sid with a 2.6.26
Debian kernel.  It has a two disk software RAID1, and apparently passes
through a suspend/resume cycle correctly, but...

The but is that while booting for resume it warned (in the initrd) that
the RAID array was unclean, and that it would be rebuilt.

After resuming, however, the array was listed as clean, but (damn) it
wasn't; checking the array[1] reported that there were 48800 errors, an=
d
a repair claimed to fix them.

That makes me suspect that something went wrong with shutting down the
array during the suspend process =E2=80=94 given it is the array with /=
 mounted
it could still be busy, and possibly unclean.

Then, resuming detects that, starts to correct it, switches back to the
previous kernel and ... viola, the saved "clean" state is restored,
unaware that the array was out of sync or that anything changed under
it.


I don't know quite enough about the suspend/resume implementation to
know if this is a problem, or just likely to be, or some quirk of this
system.

It does concern me, though, so: should I expect suspend on MD RAID1 to
work, cleanly, in all cases?

Regards,
        Daniel

=46ootnotes:=20
[1]  echo check > /sys/...


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
