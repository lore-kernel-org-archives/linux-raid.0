From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Configuring combination of RAID-1 RAID-5
Date: Tue, 31 Jan 2006 17:05:12 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0601311658220.17400@lion.drogon.net>
References: <20060131163248.M20133@mail.uadec.mx>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060131163248.M20133@mail.uadec.mx>
Sender: linux-raid-owner@vger.kernel.org
To: Enrique Garcia Briones <egarcia@mail.uadec.mx>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 31 Jan 2006, Enrique Garcia Briones wrote:

> Hi,
>
> Let me introduce myself.
>
> I'm newbie in linux and in RAID over linux, I have configured a RAID-0 in a
> NetBSD 2.0 BOX. so, now let me explain what I'm trying to do,
>
> Antecedents/Equipment:
>
> I have a Sparc 420 with 4 processors and 4 Gb in RAM, two SCSI SEAGATE
> internal hard disk with an array of 12 hard disks (Storedge 1000).
>
> What we want to have:
>
> We installed Debian Linux (I think it is 3.1 with kernel 2.4), and we want
> to have the following configuration:
>
> 1 System Harddisk
> 1 RAID-1 Mirror Hard Drive
> 12 Hard drives in RAID-5, 10 working and 2 as spare disks.
>
> I have read the setting-up for the raid-5 and 1, but I would like to ask you
> if I can set-up a combined RAID configuration as mentioned above, since all
> the examples I found upto now just talk of one RAD configuration, besides
> this, I would like to ask you that if the configuration I want to have is
> STRONG enough for the quantity of disk in the box, or if there must be any
> other considerations to have.

Wow. an A1000. Ancient, but probably still OK. I'm not sure if there are
any management utilities for them that'll run under Linux - I've only ever
seen 2 of these and they seem to be able to run RAID themselves - might be
faster, but the ones I had were slow anyway - maybe you can re-configure
them to just look like 12 disks and let Linux do the RAID on them...

Heres my suggestion:

Install a 2.6 kernel.

Partition both internal disks identically, then then combine all the
partitions with RAID-1. Boot off RAID-1, if you can - I'm not up on the
SLILO/whatever boot loaders for Sparc though.

Configure the 12 external disks using RAID-6. You'll get one disk more
worth of storage that way and still be able to sustain a 2 disk failure.

Gordon

