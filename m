From: "Kyle" <kyle@southa.com>
Subject: help with raid 5 chunk size and filesystem decision
Date: Tue, 9 Mar 2004 20:28:25 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <027801c405d2$04cc85c0$353ffea9@kyle>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'll need to copy a 2 disk raid-1 into a 6 disk raid-5, most of my files are
small files (there's now around 2,000,000 files, ~50% < 16KB, ~80% < 200KB,
~95% < 400KB). My php script will need to unserialize (read) many small
serialized objects (files) (most of them < 32KB) from disk. My target is,
best PHP performance.

Will 32KB chunk size give me the best performance? Also for my case, will
reiserfs out-perform ext3 a lot? Does reiserfs have any problem with kernel
2.6 raid5? Should I use the unpopular raid4 instead of raid5 for best read
performance?

Wish that someone here can help me

Regards,
Kyle


