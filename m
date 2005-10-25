From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Flappy hotswap disks?
Date: Tue, 25 Oct 2005 10:37:26 +0200
Message-ID: <62b0912f0510250137n6ba372c5x312174d908247437@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If
- a disk is part of a MD RAID 1 array, and
- the disk is 'flapping', eg. going online and offline repeatedly in a
hotswap system, and
- a *write* occurs to the MD array at a time when the disk happens to
be offline,

will MD handle this correctly?

Eg. will it increase the event counters on the other disks /even/ when
no reboot or stop-start has been performed, so that when the flappy
disk flaps back online, it will be (perhaps partially) resynced?

Apologies if it's a dumb question.
Hope someone's got a minute to answer it :-).
