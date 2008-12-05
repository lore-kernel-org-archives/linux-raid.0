From: Redeeman <redeeman@metanurb.dk>
Subject: time limited error recovery and md raid
Date: Fri, 05 Dec 2008 21:57:26 +0100
Message-ID: <1228510646.16555.73.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello..

Im going to be building a software raid6 setup with probably 8 disks,
and i've been looking at the wd gp disks, which comes in both standard
and raid edition, with the raid edition being much more expensive.

I have searched around, and found that it is indeed possible to activate
tler on the "normal" disks, however, the setting has a parameter, more
specifically, how many seconds it should be limited to. Default is 7.

So i was wondering, what should that be set to, to be optimal for linux
md raid? i havent been able to find any information about this.


Thanks.


mvh.
Kasper Sandberg

