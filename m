From: Jeff Breidenbach <jeff@jab.org>
Subject: Re: split RAID1 during backups?
Date: Mon, 24 Oct 2005 22:01:10 -0700
Message-ID: <E1EUGvu-0006Sr-00@toko.jab.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 10/24/05, Thomas Garner <tlg1466@neo.tamu.edu> wrote:
> Should there be any consideration for the utilization of the gigabit
> interface that is passing all of this backup traffic, as well as the
> speed of the drive that is doing all of the writing during this
> transaction?  Is the 18MB/s how fast the data is being copied over the
> network, or is it some metric within the host system?

The switched gigabit network is plenty fast. The bottleneck is
reading from the RAID1 while it is under contention.

Here are measurements from transferring a chunk of data from
/dev/zero, a single unmounted drive, and RAID1. Measurements are
reported by dd_rescue and reflect how fast data is moving over the
network. I was careful to use smart command line options with
dd_rescue, avoid contaminating Linux's disk cache, and make sure
results were repeatable.

MB/s   Operation
====   ============================
72.0   dd-rescue /dev/zero - | netcat
61.8   dd-rescue [unmounted single drive]  - | netcat
18.8   dd-rescue md0 - | netcat

dd_rescue v1.11 options:
 -B 4096 -q  -l -d -s 11G -m 200M -S 0
