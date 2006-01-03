From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: raid5 read performance
Date: Tue, 3 Jan 2006 15:43:39 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0601031533460.14492-100000@coffee.psychology.mcmaster.ca>
References: <5d96567b0601030616n42d95089pf6422002591b5d78@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b0601030616n42d95089pf6422002591b5d78@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I am checking raid5 performance.

reads or writes?

> I am using asynchronous ios with buffer size as the stripe size.

why do you think async matters?

> In this case i am using a stripe size of 1M with 2+1 disks.

do you mean that md says you have 512k chunks?

> Unlike raid0 , raid5 drops the performance by 50% .

that's slightly unclear: -50% relative to what?  a raw single disk?
is this reads or writes?  strictly bandwidth, and if so, do you have 
multiple outstanding reads?

> Is it because it does parity checkings ?

non-degraded R5 doesn't do parity checks on reads, afaik.

