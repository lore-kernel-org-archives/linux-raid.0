From: Henry Cai <henryplusplus@gmail.com>
Subject: Two Questions about Linux MD
Date: Fri, 18 Jul 2014 22:21:54 +0800
Message-ID: <CANH1pmvFap21btE8oy55_TByC2G0gmjDWowF_Rj1HEO1dbG85Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Here, I got two confusing questions about Linux MD:

I.  Why when initial create RAID5, mdadm marks a physical disk as "spare"?

    Is this for random write with RMW, or for "sync" speed?


II. The write intent bitmap, each disk in RAID with a "write intent
bitmap", or the whole RAID with one "write intent bitmap"?

    If the whole RAID with one "write intent bitmap", how to know
which disk's data need reconstruct, or just use the data disks'

   data to calculate the P data, and write to the P disk? If the only
one "write intent bitmap", how to decide which disk to save

   the "write intent bitmap"?

And is there has any MD design architecture document?

Thanks a lot
