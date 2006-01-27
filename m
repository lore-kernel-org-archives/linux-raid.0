From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Silent Corruption on RAID5
Date: Fri, 27 Jan 2006 13:29:44 +0100
Message-ID: <62b0912f0601270429vc586bdcxb0cbed9474ff8855@mail.gmail.com>
References: <43D3B675.20804@xterminate.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43D3B675.20804@xterminate.me.uk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Michael Barnwell <xterminate@xterminate.me.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Barnwell wrote:
> I'm experiencing silent data corruption
> on my RAID 5 set of four 400GB SATA disks.

I have circa the same hardware:
 * AMD Opteron 250
 * Silicon Image 3114
 * 300 GB Maxtor SATA

Just to add a data point, I've run your test on my RAID 1 (not RAID 5
!) without problems.

localhost ~ # dd bs=1024 count=10000k if=/dev/zero of=./10GB.tst
10240000+0 records in
10240000+0 records out
localhost ~ # od -t x1 ./10GB.tst
0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
*
116100000000
localhost ~ # uname -a
Linux localhost 2.6.12.6-xen #6 SMP Fri Jan 6 06:49:53 CET 2006 x86_64
AMD Opteron(tm) Processor 250 AuthenticAMD GNU/Linux
