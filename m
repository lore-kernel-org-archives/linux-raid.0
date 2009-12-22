From: "Ciprian Dorin, Craciun" <ciprian.craciun@gmail.com>
Subject: Linux MD RAID 1 read performance tunning
Date: Tue, 22 Dec 2009 18:34:55 +0200
Message-ID: <8e04b5820912220834m595f1aa6sf0071f99b4a5a144@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

    Hello all!

    I've created a 64G RAID 1 matrix from 3 real disks. (I intend to
use this as a target for backups.)
    Now while playing around with this array, I've observed that the
read performance is quite low because it always reads from the disk in
the first slot (which happens to be the slowest...)

    So my questions are:
    * is there any way to tell the MD driver to load-balance the reads
between the three disks?
    * or is there any way to tell the MD driver that I would prefer to
read from a certain device? (maybe use write-mostly?)

    Thanks,
    Ciprian.
