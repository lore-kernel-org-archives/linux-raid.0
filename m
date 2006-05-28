From: Steve Haehnichen <steve@trix.com>
Subject: "Readonly" entry in your TODO list
Date: Sat, 27 May 2006 17:44:36 -0700
Message-ID: <E1Fk9OW-0005ra-00@spoon.trix.com>
Reply-To: steve@trix.com
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just a quick note, first to say THANKS for raid/md and mdadm.. it's
fantastic, especially the monitor mode, --examine and --detail.

I recently had an unfortunately RAID-5 failure.. the machine crashed,
and on reboot found one RAID member (out of 10) to be not-so-fresh.
So it was kicked out of the RAID and rebuild began as planned.  I had
two spare drives.  So far, so good.

Halfway through rebuilding, it found a read error on one drive!  This
isn't shouldn't have been surprising, since some of the data is two
years old had not been read in some time.

You can guess what happened next -- it failed the drive, and could no
longer assemble the raid with one drive unfresh and another one
faulty.

This is where the READONLY assembly would have been useful.  I wanted
to 'freeze' the machine and change nothing on it until I had copied
some critical data out of the raid.  I'd like to do:

  mdadm --assemble --force --readonly /dev/md1

But... it won't assemble until it can update the event count in the
unfresh drive, even with --force.  This requires that I allow a write
to the device, as well as kick off a rebuild.

I had to start the raid without --readonly, and then quickly change it
to --manage --readonly to stop the rebuilding before it potentially
finds another bad sector and really makes trouble.


Also, I like to take full images of problem drives, using something
like dd or dd_rescue to make a raw file dump, and them mount them as
loopback devices.  Works great for recovery!

mango / # losetup -a
/dev/loop/0: [fd00]:1095813 (WD-WMACK1166390.p1)
/dev/loop/1: [fd00]:1095812 (WD-WMACK1182728.p1)
/dev/loop/2: [fd00]:1095820 (WD-WMAEH2610524.p1)
/dev/loop/3: [fd00]:43 (WD-WMAEP1040801.p1)
/dev/loop/4: [fd00]:46 (Y41MRR0E.p1)
/dev/loop/5: [fd00]:1095816 (Y44N8PKE.p1)
/dev/loop/6: [fd00]:85317 (Y4580H9E.p1)
/dev/loop/7: [fd00]:1095811 (Y458CJRE.p1)

mango / # cat /proc/mdstat 
md1 : active (read-only) raid5 hdc1[0] loop0[8] loop1[7] loop7[6] loop5[5] loop3[4] loop4[3] loop6[2] hdd1[1]
      1406594304 blocks level 5, 128k chunk, algorithm 2 [10/9] [UUUUUUUUU_]

Anyway, just a vote here for readonly assembly.  The second one on
your todo list: "don't kick drives on read errors" would have probably
been useful as well.


The lesson I learned is that it's good hygiene to simply read all data
on the drives now and then to 'prompt' any drive failures before there
exists more than one at a time.  I intend to 'dd' read all of /dev/md0
once a week or so in the background, in addition to the smartctl tests
which did not detect this.

Thanks again for sharing the md/raid code.  I would have never guessed
something like this was possible, let alone free.

-Steve

