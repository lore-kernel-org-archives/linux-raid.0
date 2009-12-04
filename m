From: =?UTF-8?Q?Lucian_=C8=98andor?= <lucisandor@gmail.com>
Subject: RAID5 demise or coma? after re-creating with a spare
Date: Fri, 4 Dec 2009 14:46:39 -0500
Message-ID: <c775b4470912041146rcff477bj97e86eca5bdb2dfa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,
There is a problem with my Linux installation, and the drives get
renamed and reordered all the time. Now, it just happened that the two
degraded RAID5s won't return to life. The system would not boot, so I
panicked and deleted: fstab, mdadm.conf, and some of the superblocks.
Now Linux boots, but RAIDs are, of course, dead. I tried to re-create
the arrays, but I cannot recall the correct order and my attempts
failed. I believe that the partitions are OK, because I don't recall
re-creating without "missing", but surely the superblocks are damaged
and certanily most of them are zero now.
Is there a short way to recover the degraded RAIDs without knowing the
order of drives? I have 6 drives in one (including "missing"), that
gives 720 permutations. Also, clearing the superblocks is recoverable,
isn't it?
Thank you,
Lucian
