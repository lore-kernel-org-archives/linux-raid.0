From: "Donald J. Barry" <don@isc.astro.cornell.edu>
Subject: A (novel?) variant of the Raid5 reassembly problem: help requested
Date: Thu, 20 Nov 2008 15:36:34 -0500
Message-ID: <1227213394.21302.89.camel@vodka.astro.cornell.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Linux-Raid mailing list:

This is a variant of the usual "My RAID5 array has fallen and it can't
get
up" frequently asked question.   I am hoping for some advice!

I had added an additional drive to a 3-drive md RAID5 and was running
a grow resync when hardware errors hit.  The drives are SATA connected
via a Silicon Image port multiplier (something I've cursed numerous
times) to a SiI 3124 (sata_sil24) controller.  I'm running the Debian
2.6.26-1-686-bigmen (2.6.26-8) kernel.

During the resync, as I would later discover, drive 3 (only a few
months old, and having passed a surface scan a few weeks previously)
was acting up -- it shows now some long seek times and occasional
failures
and some bad blocks -- it repeatably fails SMART short and long tests.

Whether from that alone or in combination with the port multiplier, the
SATA link 
got hard reset twice, each time with a series of "atax.yy: failed to
read SCR 1
(Emask=0x40)" messages and followed by iterated hard resets of the
multiplied links.

The first time, Drive 2 got knocked offline and thus out of the Raid.  A
few minutes 
later,  the same occurred and Drive 1 got knocked offline.  At that
point, 
obviously the Raid5 resync could not continue and the raid itself 
became effectively nonfunctional.

I've mirrored all four drives before trying some reassembly.  The
prime issue is that the Event counts are not quite in sync:

Drive 1: 72510  (dropped offline 2nd)
Drive 2: 63150  (dropped offline 1st)
Drive 3: 72520  (drive with newly flaky performance, but stayed in
array)
Drive 4: 72520  (new drive added before the grow resync)
Note the slight 

Reshape positions are at least consistent across 1, 3, and 4:

Drive 1:  Reshape pos'n : 153092352 (146.00 GiB 156.77 GB)  (dropped
2nd)
Drive 2:  Reshape pos'n : 110905152 (105.77 GiB 113.57 GB)  (dropped
1st)
Drive 3:  Reshape pos'n : 153092352 (146.00 GiB 156.77 GB)
Drive 4:  Reshape pos'n : 153092352 (146.00 GiB 156.77 GB)

Because of the event count differences, I can't do a simple
reassembly.  If I force the array together ab initio, I presumably lose
information on the ongoing resync.

All I know of (as an experiment) is to play with the test-stripe tool
to try to back out drive 4 somehow, and then force reassembly of the
first 3 disks and reload the dump from test-stripe.

Is this a valid approach?  Is there an easier way?

Like I've said, I have mirrors of all the drives, so I can try several
approaches (modulo a several day period to recopy them).  I also have
all the images on a large (hardware) raid system and they can be
played with there via loop devices.  I have all the kernel logs from
the initial failure if it would be of use to people trying to harden
the RAID (or PMP parts of sata) subsystems.  I managed to get a pretty
complete (minus only 12k of bad sectors) copy of Drive 3 with
ddrescue, so I would guess, with the redundancy, that there are
several good avenues to reconstruction.  But I don't know enough to
fully enumerate or rank these choices!

To this list, I offer my gratitude to whoever may be able to offer
some additional advice before I start iterating through some certain
blind ends.


One last note: the mailing list link on vger.kernel.org has a link to
a FAQ which at one time was apparently at http://www.linuxdoc.org/FAQ.
It is there no more.  Someone with the privilege to edit this should
probably fix it.


Very kind regards in advance,
Don Barry


