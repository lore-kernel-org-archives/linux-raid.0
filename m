From: Justin Maggard <jmaggard10@gmail.com>
Subject: RAID scrubbing
Date: Fri, 9 Apr 2010 18:28:17 -0700
Message-ID: <q2s150c16851004091828t235d2derf36033d19e2f11ad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I've got a system using two RAID5 arrays that share some physical
devices, combined using LVM.  Oddly, when I "echo repair >
/sys/block/md0/md/sync_action", once it finishes, it automatically
starts a repair on md1 also, even though I haven't requested it.
Also, if I try to stop it using "echo idle >
/sys/block/md0/md/sync_action", a repair starts on md1 within a few
seconds.  If I stop that md1 repair immediately, sometimes it will
respawn and start doing the repair again on md1.  What should I be
expecting here?  If I start a repair on one array, is it supposed to
automatically go through and do it on all arrays sharing that
personality?

Thanks!
-Justin
