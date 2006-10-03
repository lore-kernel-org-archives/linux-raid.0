From: Jochen Oekonomopulos <jochen.oekonomopulos@uni-konstanz.de>
Subject: (unknown)
Date: Tue, 03 Oct 2006 14:24:26 +0200
Message-ID: <1159878266.4522567a81ee4@webmail.uni-konstanz.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: mingo@elte.hu
List-Id: linux-raid.ids


Hello Neil, Ingo and [insert your name here],

I try to understand the raid5 and md code and I have a question
concerning the cache.

There are two ways of calculating the parity: read-modify-write and
reconstruct-write. In my understanding, the code only checks how many
buffers it has to read for each method (rmw or rcw) without considering
the cache. But what if there was relevant data in the cache? How would
the raid code know it so it can build a decision on top of this
knowledge?

I hope You can help me, since I could not find any information on this
in the mailing list archive.

Thanks in advance,
Jochen

