From: "Dale Dunlea" <ddunlea@gmail.com>
Subject: RAID5 lockup with AMCC440 and async-tx
Date: Mon, 1 Oct 2007 10:16:00 +0100
Message-ID: <8a24fb800710010216m21cd7734p4c19df1aa7dd5564@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a board with an AMCC440 processor, running RAID5 using the
async-tx interface. In general, it works well, but I have found a test
case that consistently causes a hard lockup of the entire system.

What makes this case odd is that I have only been able to generate it
when accessing disks that are on two separate HBAs - in my case
mpt-fusion based SAS HBAs. Once two HBAs are in use, the bug is
trivial to repeat. I simply create a RAID5 using disks from each HBA,
wait for it to resync, and then run

"dd if=/dev/zero of=/dev/md0 bs=512 count=100000".

By disabling CONFIG_DMA_ENGINE in my kernel config, the hang goes
away, but then so does my performance.

Any pointers on how to debug this? It feels like a race condition of
some description, but any serial port printing I enable causes the
problem to go away, and I can't print silently to /var/log/messages as
the system hangs before it can flush.

Regards,
Dale
