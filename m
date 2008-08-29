From: "Eric S. Johansson" <esj@harvee.org>
Subject: I/O wait problem with hardware raid
Date: Thu, 28 Aug 2008 21:27:51 -0400
Message-ID: <48B75097.7000509@harvee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm not sure if this mailing lists is just for the Linux kernel raid  so  this
query does not belong, feel free to tell me where to go.

I'm running Ubuntu 8.04 on an HP ProLiant ml350 with an E200i sata raid card.

The problem is the I/O wait percentage increases during data transfer. A simple
rsync transfer will bring the percent I/O wait value up to the mid-20s to 40s
and a little more stress causes the wait percentage to climb to upper 90% range.
 it appears that most of the I/O wait time is from the disk array because a copy
has a similar effect.  However, I cannot eliminate some contribution by the
networking code.

I'm not sure how to debug this. vmstat doesn't show anything extraordinary so
I'm left scratching my head.

what should I be looking for?

Thanks

---eric


