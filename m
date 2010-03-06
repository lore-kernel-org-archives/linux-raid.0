From: Mark Knecht <markknecht@gmail.com>
Subject: What RAID type and why?
Date: Sat, 6 Mar 2010 14:02:12 -0800
Message-ID: <5bdc1c8b1003061402n1281b64es9fa597b8bc714bd5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

First post. I've never used RAID but am thinking about it and looking
for newbie-level info. Thanks in advance.

I'm thinking about building a machine for long term number crunching
of stock market data. Highest end processor I can get, 16GB and at
least reasonably fast drives. I've not done RAID before and don't know
how to choose one RAID type over another for this sort of workload.
All I know is I want the machine to run 24/7 computing 100% of the
time and be reliable at least in the sense of not losing data if 1
drive or possibly 2 go down.

If a drive does go down I'm not overly worried about down time. I'll
stock a couple of spares when I build the machine and power the box
back up within an hour or two.

What RAID type do I choose and why?

Do I need a 5 physical drive RAID array to meet these requirements?
Assume 1TB+ drives all around.

How critical is it going forward with Linux RAID solutions to be able
to get exactly the same drives in the future? 1TB today is 4TB a year
from now, etc.

With an 8 core processor (high-end Intel Core i7 probably) do I need
to worry much about CPU usage doing RAID? I suspect not and I don't
really want to get into hardware RAID controllers unless critically
necessary which I suspect it isn't.

Anyway, if there's a document around somewhere that helps a newbie
like me I'd sure appreciate finding out about it.

Thanks,
Mark
