From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: raid5 read performance
Date: Tue, 3 Jan 2006 16:16:45 +0200
Message-ID: <5d96567b0601030616n42d95089pf6422002591b5d78@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I am checking raid5 performance.
I am using asynchronous ios with buffer size as the stripe size.
In this case i am using a stripe size of 1M with 2+1 disks.
Unlike raid0 , raid5 drops the performance by 50% .
Why ?
Is it because it does parity checkings ?

thank you
--
Raz
