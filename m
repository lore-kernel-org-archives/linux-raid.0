From: Martin Wilck <mwilck@arcor.de>
Subject: Strange / inconsistent behavior with mdadm -I -R
Date: Thu, 14 Mar 2013 21:03:28 +0100
Message-ID: <51422D10.3040000@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hello Neil,

for my DDF/RAID10 work, I have been trying to figure out how mdadm -I -R
is supposed to behave, and I have found strangeness I'd like to clarify,
lest I make a mistake in my DDF/RAID10 code.

My test case is incremental assembly of a clean array running mdadm -I
-R by hand for each array device in turn.

1) native md and containers behave differently for RAID 1

Both native and container RAID 1 are started in auto-read-only mode when
the 1st disk is added. When the 2nd disk is added, the native md
switches to "active" and starts a recovery which finishes immediately.
Container arrays (tested: DDF), on the other hand, do not switch to
"active" until a write attempt is made on the array. The problem is in
the native case: after the switch to "active", no more disks can be
added any more ("can only add $DISK as a spare").

IMO the container behavior makes more sense and matches the man page
better than the native behavior. Do you agree? Would it be hard to fix that?

2) RAID1 skips recovery for clean arrays, RAID10 does not

Native RAID 10 behaves similar to RAID1 as described above. When the
array can be started, it does so, in auto-read-mode. When the next disk
is added after that, recovery starts, and the array switches to
"active", and further disks can't be added the "simple way" any more.
There's one important difference: in the RAID 10 case, the recovery
doesn't finish immediately. Rather, md does a full recovery of the added
disk although it was clean. This is wrong; I have come up with a patch
for this which I will send in a follow-up email.

I tested this behavior with kernels 2.6.32, 3.0, and 3.8, with the same
result, using mdadm from the git tree.

Regards
Martin
