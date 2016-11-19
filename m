From: Wols Lists <antlists@youngman.org.uk>
Subject: linux raid wiki - backup files
Date: Sat, 19 Nov 2016 16:03:28 +0000
Message-ID: <583077D0.5070804@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm updating the mdadm overview at the moment, and I'm giving examples
for changing raid levels etc.

Is a backup file still required? I get the impression with current
kernels and mdadm, any required backup is put in the space left by "data
offset", or if you're adding a disk it stores it in the space on that disk.

Okay, I'll have to document that older versions still need it, but if
that's not needed any more, I'd rather not emphasize it.

I'd also like to confirm my understanding of how a resize works ...

If the number of raid devices is increased, am I right in thinking that
a new stripe one is created from the old stripes one and two, then
written, then the new stripe two is created from the old two and three,
etc etc? In effect, the data slumps down from the old array into the new?

And of course the reverse when a device is removed - it starts with the
highest stripe, which gets pulled upwards so the old array gets pulled
up into the new?

(And during the reshape, you have a marker of the current stripe being
updated, so any stripes above that get read from one array, and below
they get read from the other.)

Cheers,
Wol
