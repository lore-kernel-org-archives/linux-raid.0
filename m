From: Mark Knecht <markknecht@gmail.com>
Subject: mdadm RAID and drives spinning up/down
Date: Sun, 21 Mar 2010 14:40:02 -0700
Message-ID: <5bdc1c8b1003211440n7e0b7848s7c069c3394d487a3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm moving forward on my first machine using RAID. This will be a
fairly lightly used home server storing MythTV recordings and backups
coming from other Linux machine. Due to the light workload I expect
there will be times, sometimes lasting hours or maybe days, when the
drives are unused and might (should?) spin down. Additionally with
everyone trying to save power and be 'green' more and more drives
probably do this by design anyway.

OK, so never having build a RAID array and knowing nothing about this
I'm curious about how mdadm handles this sort of thing. If the drives,
using something like hdparm to set parameters, have times that shut
them down for a while, when the system needs them spinning again are
there ways to buffer write data and delay read data until everything
is ready to roll again? I.e. - it's the middle of the night and Myth
wants to start a recording. Everything is shut down and not it needs
to start.

Is it a problem if one drive spins up more slowly? Could that fool the
RAID software into thinking the drive has died when it's actually just
asleep?

Sorry for such newbish questions.

Thanks,
Mark
