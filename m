From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: New setup: partitions or raw devices
Date: Wed, 29 Nov 2017 18:42:23 +0100
Message-ID: <CAJH6TXirSV0X4jXa2de6wFFET+_gGUB9iod61kwHFvEWcoruVw@mail.gmail.com>
References: <CAJH6TXj4wp-k2QQ0O8W2PDQEg9QHcWwPkOEOSzMgvtbV6b21Cw@mail.gmail.com>
 <7f6abcbc-7dfa-0252-e9df-984e7e637936@thelounge.net> <1cf640fc-c6ee-25e8-8aee-9cf8025f9f4d@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1cf640fc-c6ee-25e8-8aee-9cf8025f9f4d@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Reindl Harald <h.reindl@thelounge.net>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2017-11-29 17:52 GMT+01:00 Phil Turmel <philip@turmel.org>:
> These are good reasons.  I have also seen reports of NAS devices/distros
> unconditionally partitioning devices that don't have one.  Although I
> have in the past used raw devices with mdadm, I don't plan to do so with
> any future systems.

I always used partitioning.
But last time i've tried to configure mdadm to automatically replace a
disk when replaced:
https://linux.die.net/man/5/mdadm.conf
"POLICY" section, tried all but the best candidate seems to be "spare-same-slot"

I was never able to make that working. I've tried everything: insert a
brand new disk, insert an already partitioned disks and so on.
I always though that the main issue was due to disk partitioning,
mdadm won't be able to re-add a brand new disks if raid is made
with paritions (the new disks doesn't have any partition)

Any idea ?
