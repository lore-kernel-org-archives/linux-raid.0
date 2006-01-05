From: Andrew Burgess <aab@cichlid.com>
Subject: Re: Fwd: Linux MD raid5 and reiser4... Any experience ?
Date: Thu, 5 Jan 2006 09:32:24 -0800
Message-ID: <200601051732.k05HWOYT000687@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>Furthermore, I would prefer not to use LVM nor any middle layer
>between MD and the fs... Is this middle layer *very* usefull when I'm
>sure my partitions layout will not evolve (e.g. only one enormous fs)
>?

Another feature of LVM is moving physical devices (PV). This makes it
easier to grow your enormous fs because it allows you to remove disks.

An example:

Today 1 500GB RAID6 PV #1
A year from now, add another 1TB PV #2, no LVM advantage yet.
A year later, you want to add another 1TB PV #3 but then you want to
remove the first 500GB. With LVM you can copy PV #1 to PV#3 without
affecting the filesystem and then remove PV #1.

I haven't ever done this, just read about it. Also, maybe when md
allows growing raid5/6 this will be handled by md.

HTH

