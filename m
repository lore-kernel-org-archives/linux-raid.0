From: Nebojsa Trpkovic <trx.lists@gmail.com>
Subject: TLER / CCTL timeout handling
Date: Tue, 23 Mar 2010 23:10:07 +0100
Message-ID: <4BA93C3F.2070208@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello.

I've found interesting text about TLER / CCTL
(http://en.wikipedia.org/wiki/Time-Limited_Error_Recovery )

on desktop class drives:
http://forums.storagereview.com/index.php/topic/28333-tler-cctl/

So, the question is:

If I make my drive report back it failed to read the requested sector,
how that report will be handeled?

Will Linux software RAID be aware of that report and start some action
(rebuilding affected stripe or at least whole array, reallocating bad
sectors along the way) ?


Thank you.
Nebojsa Trpkovic


