From: linux@horizon.com
Subject: Does anyone collect bad disks?
Date: 26 Oct 2004 09:17:27 -0000
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <20041026091727.18001.qmail@science.horizon.com>
Return-path: <linux-ide-owner@vger.kernel.org>
To: linux-fsdevel@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have an old PATA drive (IBM-DTLA-307020, 20 GB) that's developing bad
sectors at an alarming rate and is getting replaced.

It's certainly given e2fsck and badblocks a workout.  (Complaint: why
doesn't e2fsck pass the *current* bad block list to badblocks -i,
so it doesn't have to produce all those errors again?)

But, anyway, it's not much use for data storage, but might make a great
test case for error handling.

Does anyone want such a thing for development purposes?
