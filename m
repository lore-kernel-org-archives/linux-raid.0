From: Francesc Guasch <frankie@etsetb.upc.es>
Subject: sparc disks on intel and raid
Date: Wed, 24 Mar 2004 12:05:33 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40616B7D.3050703@etsetb.upc.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I got an old box with sparc disk drives and I plugged it
in an Intel Linux box. I made the partitions, built raid
and added it to a LVM group.

After rebooting, some of the old sparc drives changed their
partition tables alone, and I'm unable to start the
RAID nor use the LVM. I noticed the sparc drives do this
the very first time their partitions change. The two that
didn't change this time did it when I rebooted some time
ago, but I didn't recall it happened.

I was using 4 drives for RAID5. Now 2 of the drives changed,
so the raid won't start.

Can I fix it without reformating all the LVM ?

I didn't write data after extending the LVM partition, maybe
I could create the raid again, and fsck the LVM filesystem?

Thank you for your time.
