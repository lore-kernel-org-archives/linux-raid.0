From: David Zampirolo <davidzampirolo@gmail.com>
Subject: migrate from mdadm to HW RAID
Date: Thu, 10 Aug 2017 17:24:12 +0200
Message-ID: <CAG8LN=Nw-VoiWOPj1zOnEegjQ2-AV9eadmtUt6ohnYVBZLYzJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi people,
I'm trying to move data from 2 software raid volumes /dev/md0 (/) and
/dev/md1 (swap)
made by mdadm to a phisical RAID over a server.
md0 and md1 are both raid level 1 composed by 2 partitions over sda and sdb
Anyone have already done that?
The problem is that i need to work only on the disk-image i cannot
stop or modify the original workstation.
any suggestion?

Thanks for your time
David
