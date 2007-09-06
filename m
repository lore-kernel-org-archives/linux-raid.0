From: Andrew Burgess <aab@cichlid.com>
Subject: Grow a degraded raid6?
Date: Thu, 6 Sep 2007 08:23:59 -0700
Message-ID: <200709061523.l86FNxoT010292@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Any chance of being able to grow a degraded raid6 array?
(missing one drive) I tried to add a spare without
it immediately grabbing it and resyncing but couldn't.

Why? I made the array raid6 because eventually it'll have
8-10 drives. Currently you can't change from raid5 to 6 and
preserve your data. Now it has 4 drives and I'm happy with one 
redundant for that small number of drives and the performance 
isn't a problem.

Thanks!
