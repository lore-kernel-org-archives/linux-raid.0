From: Nix <nix@esperi.org.uk>
Subject: insane md check latencies with multiple devices on one disk
Date: Tue, 02 Jan 2018 11:05:03 +0000
Message-ID: <87r2r8ed28.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So I have a triplet of RAID arrays (md0 and md6) on 6x modern rotating
storage (read speeds for contiguous reads nearly 200MiB/s: much much
slower when seeking, naturally). There are three arrays on one set of
disks, md0 at the start and two md6 later on (one of them is backing a
bcache, the other is not). Most non-archival data is on the bcached
array.

A routine every-N-months RAID check of the md6 arrays has just kicked
in, and I'm being murdered by latencies: even writing this email is
painful due to massive blocking (latencytop shows routine 20s latencies,
which is just appalling).

The md device that's syncing right now is for archival storage: the one
for the OS and $HOME and the like is not syncing, and the sync speed
is sitting at the max for the disk, not dropping when user-requested I/O
takes place.

The problem, I think, is that while md realizes that all three devices
are on one disk for the purpose of serializing checks, it doesn't
realize that md devices sharing disks also implies that I/O to every
such device should reduce the sync speed of every md device syncing on
that disk, not just the one to which the I/O is directed. Not knowing
anything about that part of the code, I'm wondering how hard that would
be to add... I'll have a look. (This is obviously not urgent since I
can't improve performance for this check, since it would require a
reboot to do so :) I'll just knock down sync_speed_max for now and live
with that).
