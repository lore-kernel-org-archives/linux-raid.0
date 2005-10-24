From: "Jurriaan Kalkman" <jurriaan@rivierenland.xs4all.nl>
Subject: Re: split RAID1 during backups?
Date: Mon, 24 Oct 2005 13:22:06 +0200 (CEST)
Message-ID: <15835.194.178.120.170.1130152926.squirrel@194.178.120.170>
References: <E1EU01c-0001sZ-00@toko.jab.org>
Reply-To: jurriaan@rivierenland.xs4all.nl
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1EU01c-0001sZ-00@toko.jab.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Breidenbach <jeff@jab.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
> Hi all,
>
> I have a two drive RAID1 serving data for a busy website. The
> partition is 500GB and contains millions of 10KB files. For reference,
> here's /proc/mdstat
>
> Personalities : [raid1]
> md0 : active raid1 sdc1[0] sdd1[1]
>       488383936 blocks [2/2] [UU]
>
> For backups, I set the md0 partition to readonly and then use dd_rescue
> + netcat to copy the parition over a gigabit network. Unfortuantely,
> this process takes almost 10 hours. I'm only able to copy about 18MB/s
> from md0 due to disk contention with the webserver. If I had the full
> attention of a single disk, I could read at nearly 60MB/s.

First of all, if the data is mostly static, rsync might work faster. Don't
feed rsync millions of files in one go - try to split it in separate
processes for say all files starting with a, all files starting with b
etc.

> So - I'm thinking of the following backup scenario.  First, remount
> /dev/md0 readonly just to be safe. Then mount the two component
> paritions (sdc1, sdd1) readonly. Tell the webserver to work from one
> component partition, and tell the backup process to work from the
> other component partition. Once the backup is complete, point the
> webserver back at /dev/md0, unmount the component partitions, then
> switch read-write mode back on.
>
> Am I insane?

It doesn't sound insane. If it's actually fast, is something only you can
test on your hardware.

By the way, it used to be with regular IDE disks that using hdc and hdd
together on a single wire was a sure way to get a slow system. I take it
sdc and sdd using SATA don't influence each other?

Good luck,
Jurriaan

