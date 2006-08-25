From: Wagner Ferenc <wferi@niif.hu>
Subject: RAID6 fallen apart
Date: Sat, 26 Aug 2006 01:38:10 +0200
Message-ID: <87y7tcxu71.fsf@szonett.ki.iif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

after an intermittent network failure, our RAID6 array of AoE devices
can't run anymore.  Looks like the system dropped each of the disks one
after the other, and at the third the array failed as expected.
Trying to assemble the array results in all disks going into spare
status, nothing useful.  The disks really must have been cut
simultaneously, but their superblocks were probably altered since then
by the recovery attempts.

Can anybody suggest a possible way out?  I'm thinking like restoring
all the superblocks into a clean state, starting the array, checking
the filesystem and doing a full copy of it, but don't know how to
restore the superblocks.  Or am I mistaken?
-- 
Thanks,
Feri.
