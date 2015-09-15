From: Alex <mysqlstudent@gmail.com>
Subject: Recommendations for RAID setup needed
Date: Tue, 15 Sep 2015 13:39:50 -0400
Message-ID: <CAB1R3sjKb-aXJV+4E5t6OsWid4QB+r6aCteZt+F+57=cWLhHWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
I have a fedora22 system and would like to build a backup server. I
have four 3TB SATA disks and would like to build a RAID5 array. I
understand rebuild times can be extensive, possibility creating a
scenario where another disk fails during that rebuild time, but I'm
not sure I want to lose the extra space with creating a RAID6 array. I
believe RAID5 also has faster write speeds?

Is a 9TB RAID5 partition too risky in terms of rebuild time?

What's the preferred filesystem for a backup server these days? Should
I use XFS or ext4?

Thanks,
Alex
