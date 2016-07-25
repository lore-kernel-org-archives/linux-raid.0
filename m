From: bobzer <bobzer@gmail.com>
Subject: migration of raid 5 to raid 6 and disk of 2TB to 4TB
Date: Mon, 25 Jul 2016 17:14:19 -0400
Message-ID: <CADzS=aqYQEoqxHbp7keeuYqN2dLur1O=RfctfuFsraggxiWTKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I'm looking for advice to not mess up my migration. because
unfortunately i miss drive
I wanna migrate all my data from a raid 5 of 4x2TB (actually 3 because
i'm degraded right now) to a raid 6 of 4x4TB
so exactly i got :
- raid 5, should be 4 disk of 2T but got problem and so right now it's
just 2x2T and a 2Tb disk image in a 4T disk (the raid crashed and is
not start right now but is clean)
- 2 disk of 4TB
- the raid 5 use lvm2 on top of mdadm

I want a raid 6 so i thought i could create a raid 6 degraded with the
2x4TB and after copy the data to this new raid and after add the third
4TB and finally add the 2  2TB as a raid 0 to get a 4TB
I know it's an ideal solution to get 3x4TB + 2x2TB to do my raid but
it give me time to invest.

So my question is :
- is it a really bad idea ?
- do you have a better idea? solution ?
- maybe i can migrate instead of copy a raid to another ?

thank you very much
Math
