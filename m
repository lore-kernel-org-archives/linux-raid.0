From: "Andrei E. Warkentin" <andrey.warkentin@gmail.com>
Subject: Clarification behind md 1.0 superblock resync_offset and recovery_offset?
Date: Thu, 6 Oct 2011 14:48:28 -0400
Message-ID: <CANz0V+7gGjK8BfatVdLXJdJ-6Okcmx6P_32jjzxgihmV_JqsoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

Hi group,

This is my first time posting on this mailing list. I've tried looking
in the archives, but didn't find what I was looking for. I am trying
to understand how the synchronization code in MD driver works, and I
am unsure about the exact relation between resync_offset
and recovery_offset for the 1.X SB format.

sb->resync_offset sets mddev->recovery_cp, which is the last sector
synchronized/recovered when md_do_sync exits, and isn't
used for recovery if a bitmap is used.

sb->recovery_offset sets rdev->recovery_offset, which seemingly is a
per-member-device recovery_cp, but updated at a finer granularity,
right?

I think my confusion might be stemming from a misunderstandig behind
what RECOVERY and SYNC implies. I thought that RECOVERY
means metadata cleanup, while RESYNC is actual syncing of data to
spares (or re-added previously faulty disks), but then why is there a
recovery offset? Why isn't a resync offset sufficient?

I'd be willing to submit a few documentation patches just to others
have an easier time of reading MD code :-).

Thank you,
-- 
A
